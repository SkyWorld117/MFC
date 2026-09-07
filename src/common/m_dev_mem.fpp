!! @brief Raw device-memory helpers that bypass NVHPC's present-table
!! machinery for nested allocatable components.
!!
!! On NVHPC 25.7 the `acc update device` for a two-level-nested allocatable
!! component (q_cons_ts(1)%vf(i)%sf — the MFC field model) resolves to a
!! DIFFERENT device buffer than the compute regions' descriptor-based
!! access (dev-MFC hit the same class: "ACC present-table entries are
!! corrupted by the pointer attaches on sibling rows").  The startup IC
!! push therefore goes through an explicit cudaMemcpy with the device
!! address taken from host_data use_device — the same pattern MFC's MPI
!! halo exchange already uses.
module m_dev_mem
    use m_precision_select, only: stp
    use, intrinsic :: iso_c_binding, only: c_ptr, c_size_t, c_int, c_loc
    implicit none
    private
    public :: s_memcpy_h2d, s_push_field_to_device, s_dev_copy_in

    interface
        function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
            import :: c_ptr
            type(c_ptr) :: acc_deviceptr_
            type(c_ptr), value :: hostptr
        end function
        function cudaMemcpy_(dst, src, cnt, kind) bind(C, name='cudaMemcpy')
            import :: c_ptr, c_size_t, c_int
            integer(c_int) :: cudaMemcpy_
            type(c_ptr), value :: dst, src
            integer(c_size_t), value :: cnt
            integer(c_int), value :: kind
        end function
    end interface

contains

    !> Copy nbytes from the host address to the DEVICE address (the caller
    !! obtains dev inside !$acc host_data use_device via c_loc).
    subroutine s_memcpy_h2d(dev, host, nbytes)
        type(c_ptr), value :: dev, host
        integer(c_size_t), value :: nbytes
        integer(c_int) :: ierr
        ierr = cudaMemcpy_(dev, host, nbytes, 1_c_int)   ! cudaMemcpyHostToDevice
        if (ierr /= 0_c_int) then
            print *, 'm_dev_mem: cudaMemcpy H2D failed, code=', ierr
            error stop 1
        end if
    end subroutine s_memcpy_h2d

    !> Push a contiguous array to its declare-created device copy, by
    !! address: acc_deviceptr maps the host address of the mapped array to
    !! its device copy; the copy is a plain cudaMemcpy H2D.  This bypasses
    !! the `acc update device` present-table resolution that mis-delivers
    !! for two-level-nested allocatable components on NVHPC 25.7.
    subroutine s_push_field_to_device(host_addr, nbytes, what)
        use, intrinsic :: iso_c_binding, only: c_null_ptr
        type(c_ptr), value :: host_addr
        integer(c_size_t), value :: nbytes
        character(*), intent(in) :: what
        type(c_ptr) :: dptr
        integer(c_int) :: ierr
        dptr = acc_deviceptr_(host_addr)
        if (dptr == c_null_ptr) then
            print *, 'm_dev_mem: ', what, ' has no device copy (acc_deviceptr=NULL)'
            error stop 1
        end if
        ierr = cudaMemcpy_(dptr, host_addr, nbytes, 1_c_int)
        if (ierr /= 0_c_int) then
            print *, 'm_dev_mem: cudaMemcpy H2D failed for ', what, ', code=', ierr
            error stop 1
        end if
    end subroutine s_push_field_to_device

    !> Copy nbytes from a HOST address into the array passed as dev_arr.
    !! The caller invokes this inside !$acc host_data use_device(dev_arr):
    !! nvfortran then passes the component's DEVICE address as the actual
    !! (the same argument-rewriting the CUF kernel launches in dev-MFC rely
    !! on), and c_loc inside this helper returns that device address.
    subroutine s_dev_copy_in(dev_arr, host_addr, nbytes, what)
        real(stp), target, intent(in) :: dev_arr(*)
        type(c_ptr), value :: host_addr
        integer(c_size_t), value :: nbytes
        character(*), intent(in) :: what
        type(c_ptr) :: dptr
        integer(c_int) :: ierr
        dptr = c_loc(dev_arr)
        ierr = cudaMemcpy_(dptr, host_addr, nbytes, 1_c_int)
        if (ierr /= 0_c_int) then
            print *, 'm_dev_mem: dev_copy_in failed for ', what, ', code=', ierr
            error stop 1
        end if
    end subroutine s_dev_copy_in

end module m_dev_mem
