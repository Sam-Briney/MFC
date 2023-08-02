!>
!! @file m_boundary_conditions.fpp
!! @brief Contains module m_boundary_conditions

!> @brief The purpose of the module is to apply noncharacteristic and processor
!! boundary condiitons 
module m_boundary_conditions

    ! Dependencies =============================================================
    use m_derived_types        !< Definitions of the derived types

    use m_global_parameters    !< Definitions of the global parameters

    use m_mpi_proxy

    use m_constants
    ! ==========================================================================

    implicit none

    private; public :: s_populate_conservative_variables_buffers

    contains

    !>  The purpose of this procedure is to populate the buffers
    !!      of the conservative variables, depending on the selected
    !!      boundary conditions.
    subroutine s_populate_conservative_variables_buffers(q_cons_vf, pb, mv)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_loc, bc_dir

        ! Population of Buffers in x-direction =============================

        select case(bc_x%beg)
            case(-13:-3) ! Ghost-cell extrap. BC at beginning
                call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 1, -1)
            case(-2)     ! Symmetry BC at beginning
                call s_symmetry(q_cons_vf, pb, mv, 1, -1)
            case(-1)     ! Periodic BC at beginning
                call s_periodic(q_cons_vf, pb, mv, 1, -1)
            case(-14)    ! Slip wall BC at beginning
                call s_slip_wall(q_cons_vf, pb, mv, 1, -1)
            case(-15)    ! No-slip wall BC at beginning
                call s_no_slip_wall(q_cons_vf, pb, mv, 1, -1)
            case(-16)    ! Specified velocity BC at beginning
                call s_specified_velocity(q_cons_Vf, pb, mv, 1, -1)
            case default ! Processor BC at beginning
                call s_mpi_sendrecv_conservative_variables_buffers( &
                    q_cons_vf, pb, mv, 1, -1)
        end select

        select case(bc_x%end)
            case(-13:-3) ! Ghost-cell extrap. BC at end   
                call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 1, 1)
            case(-2)     ! Symmetry BC at end
                call s_symmetry(q_cons_vf, pb, mv, 1, 1)
            case(-1)     ! Periodic BC at end
                call s_periodic(q_cons_vf, pb, mv, 1, 1)
            case(-14)    ! Slip wall BC at end
                call s_slip_wall(q_cons_vf, pb, mv, 1, 1)
            case(-15)    ! No-slip wall bc at end
                call s_no_slip_wall(q_cons_vf, pb, mv, 1, 1)
            case(-16)    ! Specified velocity bc at end
                call s_specified_velocity(q_cons_Vf, pb, mv, 1, 1)
            case default ! Processor BC at end
                call s_mpi_sendrecv_conservative_variables_buffers( &
                    q_cons_vf, pb, mv,  1, 1)
        end select

        ! END: Population of Buffers in x-direction ========================

        ! Population of Buffers in y-direction =============================

        if (n == 0) return
        
        select case(bc_y%beg)
            case(-12:-3) ! Ghost-cell extrap. BC at beginning
                call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 2, -1)
            case(-13)    ! Axis BC at beginning
                call s_axis(q_cons_vf, pb, mv, 2, -1)
            case(-2)     ! Symmetry BC at beginning
                call s_symmetry(q_cons_vf, pb, mv, 2, -1)
            case(-1)     ! Periodic BC at beginning
                call s_periodic(q_cons_vf, pb, mv, 2, -1)
            case(-14)    ! Slip wall BC at beginning
                call s_slip_wall(q_cons_vf, pb, mv, 2, -1)
            case(-15)    ! No-slip wall BC at beginning
                call s_no_slip_wall(q_cons_vf, pb, mv, 2, -1)
            case default ! Processor BC at beginning
                call s_mpi_sendrecv_conservative_variables_buffers( &
                    q_cons_vf, pb, mv,  2, -1)
        end select


        select case(bc_y%end)
        case(-13:-3) ! Ghost-cell extrap. BC at end        
            call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 2, 1)
        case(-2)     ! Symmetry BC at end
            call s_symmetry(q_cons_vf, pb, mv, 2, 1)
        case(-1)     ! Periodic BC at end            
            call s_periodic(q_cons_vf, pb, mv, 2, 1)
        case(-14)    ! Slip wall BC at end
            call s_slip_wall(q_cons_vf, pb, mv, 2, 1)
        case(-15)    ! No-slip wall BC at end
            call s_no_slip_wall(q_cons_vf, pb, mv, 2, 1)
        case default ! Processor BC at end
            call s_mpi_sendrecv_conservative_variables_buffers( &
                q_cons_vf, pb, mv,  2, 1)
        end select

        ! END: Population of Buffers in y-direction ========================

        ! Population of Buffers in z-direction =============================

        if (p == 0) return

        select case(bc_z%beg)
            case(-13:-3) ! Ghost-cell extrap. BC at beginning
                call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 3, -1)
            case(-2)     ! Symmetry BC at beginning
                call s_symmetry(q_cons_vf, pb, mv, 3, -1)
            case(-1)     ! Periodic BC at beginning
                call s_periodic(q_cons_vf, pb, mv, 3, -1)
            case(-14)    ! Slip wall BC at beginning
                call s_slip_wall(q_cons_vf, pb, mv, 3, -1)
            case(-15)    ! No-slip wall BC at beginning
                call s_no_slip_wall(q_cons_vf, pb, mv, 3, -1)
            case default ! Processor BC at beginning
                call s_mpi_sendrecv_conservative_variables_buffers( &
                    q_cons_vf, pb, mv,  3, -1)
        end select

        select case(bc_z%end)
            case(-13:-3) ! Ghost-cell extrap. BC at end
                call s_ghost_cell_extrapolation(q_cons_vf, pb, mv, 3, 1)
            case(-2)     ! Symmetry BC at end
                call s_symmetry(q_cons_vf, pb, mv, 3, 1)
            case(-1)     ! Periodic BC at end
                call s_periodic(q_cons_vf, pb, mv, 3, 1)
            case(-14)    ! Slip wall BC at end
                call s_slip_wall(q_cons_vf, pb, mv, 3, 1)
            case(-15)    ! No-slip wall BC at end
                call s_no_slip_wall(q_cons_vf, pb, mv, 3, 1)
            case default ! Processor BC at end
                call s_mpi_sendrecv_conservative_variables_buffers( &
                    q_cons_vf, pb, mv,  3, 1)
        end select

        ! END: Population of Buffers in z-direction ========================

    end subroutine s_populate_conservative_variables_buffers

    subroutine s_ghost_cell_extrapolation(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !< x-direction =========================================================
        if (bc_dir == 1) then !< x-direction

            if (bc_loc == -1) then !bc_x%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                q_cons_vf(i)%sf(-j, k, l) = &
                                    q_cons_vf(i)%sf(0, k, l)
                            end do
                        end do
                    end do
                end do
    
                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(4) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                           pb(0, k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                           mv(0, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                q_cons_vf(i)%sf(m + j, k, l) = &
                                    q_cons_vf(i)%sf(m, k, l)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(m, k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(m, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then !< y-direction

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(l, -j, k) = &
                                    q_cons_vf(i)%sf(l, 0, k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, 0, k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, 0, k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(l, n + j, k) = &
                                    q_cons_vf(i)%sf(l, n, k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, n , k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, n , k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if   

            end if

        !< z-direction =========================================================
        elseif (bc_dir == 3) then !< z-direction

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(k, l, -j) = &
                                    q_cons_vf(i)%sf(k, l, 0)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, 0, q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, 0, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_z%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(k, l, p + j) = &
                                    q_cons_vf(i)%sf(k, l, p)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p+j, q, i) = &
                                            pb(k, l, p, q, i)
                                        mv(k, l, p+j, q, i) = &
                                            mv(k, l, p, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if  

            end if

        end if
        !< =====================================================================

    end subroutine s_ghost_cell_extrapolation

    subroutine s_symmetry(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !< x-direction =========================================================
        if (bc_dir == 1) then

            if (bc_loc == -1) then !< bc_x%beg

                !$acc parallel loop collapse(3) gang vector default(present)
                do l = 0, p
                    do k = 0, n
                        do j = 1, buff_size
                            !$acc loop seq
                            do i = 1, contxe
                                q_cons_vf(i)%sf(-j, k, l) = &
                                    q_cons_vf(i)%sf(j - 1, k, l)
                            end do

                            q_cons_vf(momxb)%sf(-j, k, l) = &
                                - q_cons_vf(momxb)%sf(j - 1, k, l)

                            !$acc loop seq
                            do i = momxb + 1, sys_size
                                q_cons_vf(i)%sf(-j, k, l) = &
                                    q_cons_vf(i)%sf(j - 1, k, l)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                            pb(j - 1, k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                            mv(j - 1, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(3) default(present)
                do l = 0, p
                    do k = 0, n
                        do j = 1, buff_size
    
                            !$acc loop seq
                            do i = 1, contxe
                                q_cons_vf(i)%sf(m + j, k, l) = &
                                    q_cons_vf(i)%sf(m - (j - 1), k, l)
                            end do
    
                            q_cons_vf(momxb)%sf(m + j, k, l) = &
                                -q_cons_vf(momxb)%sf(m - (j - 1), k, l)
    
                            !$acc loop seq
                            do i = momxb + 1, sys_size
                                q_cons_vf(i)%sf(m + j, k, l) = &
                                    q_cons_vf(i)%sf(m - (j - 1), k, l)
                            end do
    
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(m - (j - 1), k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(m - (j - 1), k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(3) gang vector default(present)
                do k = 0, p
                    do j = 1, buff_size
                        do l = -buff_size, m + buff_size
                            !$acc loop seq
                            do i = 1, momxb
                                q_cons_vf(i)%sf(l, -j, k) = &
                                    q_cons_vf(i)%sf(l, j - 1, k)
                            end do

                            q_cons_vf(momxb + 1)%sf(l, -j, k) = &
                                - q_cons_vf(momxb + 1)%sf(l, j - 1, k)

                            !$acc loop seq
                            do i = momxb + 2, sys_size
                                q_cons_vf(i)%sf(l, -j, k) = &
                                    q_cons_vf(i)%sf(l, j - 1, k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, j - 1, k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, j - 1, k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(3) gang vector default(present)
                do k = 0, p
                    do j = 1, buff_size
                        do l = -buff_size, m + buff_size
                            !$acc loop seq
                            do i = 1, momxb
                                q_cons_vf(i)%sf(l, n + j, k) = &
                                    q_cons_vf(i)%sf(l, n - (j - 1), k)
                            end do

                            q_cons_vf(momxb + 1)%sf(l, n + j, k) = &
                                -q_cons_vf(momxb + 1)%sf(l, n - (j - 1), k)

                            !$acc loop seq
                            do i = momxb + 2, sys_size
                                q_cons_vf(i)%sf(l, n + j, k) = &
                                    q_cons_vf(i)%sf(l, n - (j - 1), k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, n - (j-1), k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, n - (j-1), k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if
        
        !< z-direction =========================================================
        elseif (bc_dir == 3) then

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(3) gang vector default(present)
                do j = 1, buff_size
                    do l = -buff_size, n + buff_size
                        do k = -buff_size, m + buff_size
                            !$acc loop seq
                            do i = 1, momxb + 1
                                q_cons_vf(i)%sf(k, l, -j) = &
                                    q_cons_vf(i)%sf(k, l, j - 1)
                            end do

                            q_cons_vf(momxe)%sf(k, l, -j) = &
                                -q_cons_vf(momxe)%sf(k, l, j - 1)

                            !$acc loop seq
                            do i = E_idx, sys_size
                                q_cons_vf(i)%sf(k, l, -j) = &
                                    q_cons_vf(i)%sf(k, l, j - 1)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, j-1, q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, j-1, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if    

            else !< bc_z%end

                !$acc parallel loop collapse(3) gang vector default(present)
                do j = 1, buff_size
                    do l = -buff_size, n + buff_size
                        do k = -buff_size, m + buff_size
                            !$acc loop seq
                            do i = 1, momxb + 1
                                q_cons_vf(i)%sf(k, l, p + j) = &
                                    q_cons_vf(i)%sf(k, l, p - (j - 1))
                            end do

                            q_cons_vf(momxe)%sf(k, l, p + j) = &
                                -q_cons_vf(momxe)%sf(k, l, p - (j - 1))

                            !$acc loop seq
                            do i = E_idx, sys_size
                                q_cons_vf(i)%sf(k, l, p + j) = &
                                    q_cons_vf(i)%sf(k, l, p - (j - 1))
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p + j, q, i) = &
                                            pb(k, l, p - (j-1), q, i)
                                        mv(k, l, p + j, q, i) = &   
                                            mv(k, l, p - (j-1), q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if 

            end if

        end if
        !< =====================================================================

    end subroutine s_symmetry

    subroutine s_periodic(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !< x-direction =========================================================
        if (bc_dir == 1) then

            if (bc_loc == -1) then !< bc_x%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                q_cons_vf(i)%sf(-j, k, l) = &
                                    q_cons_vf(i)%sf(m - (j - 1), k, l)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                            pb(m - (j - 1), k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                            mv(m - (j - 1), k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                q_cons_vf(i)%sf(m + j, k, l) = &
                                    q_cons_vf(i)%sf(j - 1, k, l)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(j - 1, k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(j - 1, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(l, -j, k) = &
                                    q_cons_vf(i)%sf(l, n - (j - 1), k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(4) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, n - (j-1), k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, n - (j-1), k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(l, n + j, k) = &
                                    q_cons_vf(i)%sf(l, j - 1, k)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, (j-1), k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, (j-1), k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if
        
        !< z-direction =========================================================
        elseif (bc_dir == 3) then

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(k, l, -j) = &
                                    q_cons_vf(i)%sf(k, l, p - (j - 1))
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, p - (j-1), q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, p - (j-1), q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_z%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                q_cons_vf(i)%sf(k, l, p + j) = &
                                    q_cons_vf(i)%sf(k, l, j - 1)
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p + j, q, i) = &
                                            pb(k, l, j-1, q, i)
                                        mv(k, l, p + j, q, i) = &
                                            mv(k, l, j-1, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if 

            end if

        end if
        !< =====================================================================

    end subroutine s_periodic

    subroutine s_axis(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !$acc parallel loop collapse(3) gang vector default(present)
        do k = 0, p
            do j = 1, buff_size
                do l = -buff_size, m + buff_size
                    if (z_cc(k) < pi) then
                        !$acc loop seq
                        do i = 1, momxb
                            q_cons_vf(i)%sf(l, -j, k) = &
                                q_cons_vf(i)%sf(l, j - 1, k + ((p + 1)/2))
                        end do

                        q_cons_vf(momxb + 1)%sf(l, -j, k) = &
                            -q_cons_vf(momxb + 1)%sf(l, j - 1, k + ((p + 1)/2))

                        q_cons_vf(momxe)%sf(l, -j, k) = &
                            -q_cons_vf(momxe)%sf(l, j - 1, k + ((p + 1)/2))

                        !$acc loop seq
                        do i = E_idx, sys_size
                            q_cons_vf(i)%sf(l, -j, k) = &
                                q_cons_vf(i)%sf(l, j - 1, k + ((p + 1)/2))
                        end do
                    else
                        !$acc loop seq
                        do i = 1, momxb
                            q_cons_vf(i)%sf(l, -j, k) = &
                                q_cons_vf(i)%sf(l, j - 1, k - ((p + 1)/2))
                        end do

                        q_cons_vf(momxb + 1)%sf(l, -j, k) = &
                            -q_cons_vf(momxb + 1)%sf(l, j - 1, k - ((p + 1)/2))

                        q_cons_vf(momxe)%sf(l, -j, k) = &
                            -q_cons_vf(momxe)%sf(l, j - 1, k - ((p + 1)/2))

                        !$acc loop seq
                        do i = E_idx, sys_size
                            q_cons_vf(i)%sf(l, -j, k) = &
                                q_cons_vf(i)%sf(l, j - 1, k - ((p + 1)/2))
                        end do
                    end if
                end do
            end do
        end do

        if(qbmm .and. .not. polytropic) then
            !$acc parallel loop collapse(5) gang vector default(present)
            do i = 1, nb
                do k = 0, p
                    do j = 1, buff_size
                        do l = -buff_size, m + buff_size
                            do q = 1, nnode
                                pb(l, -j, k, q, i) = &
                                    pb(l, j-1, k - ((p+1)/2), q, i)
                                mv(l, -j, k, q, i) = &
                                    mv(l, j-1, k - ((p+1)/2), q, i)
                            end do
                        end do
                    end do
                end do
            end do
        end if

    end subroutine s_axis

    subroutine s_slip_wall(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !< x-direction =========================================================
        if (bc_dir == 1) then

            if (bc_loc == -1) then !< bc_x%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i == momxb) then
                                    q_cons_vf(i)%sf(-j,k,l) = 0d0
                                else
                                    q_cons_vf(i)%sf(-j, k, l) = &
                                        q_cons_vf(i)%sf(0, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(4) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                           pb(0, k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                           mv(0, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i == momxb) then
                                    q_cons_vf(i)%sf(m+j,k,l) = 0d0
                                else
                                    q_cons_vf(i)%sf(m+j, k, l) = &
                                        q_cons_vf(i)%sf(m, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(m, k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(m, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i == momxb + 1) then
                                    q_cons_vf(i)%sf(l, -j, k) = 0d0
                                else
                                    q_cons_vf(i)%sf(l, -j, k) = &
                                        q_cons_vf(i)%sf(l, 0, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, 0, k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, 0, k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i == momxb + 1) then
                                    q_cons_vf(i)%sf(l, n + j, k) = 0d0
                                else
                                    q_cons_vf(i)%sf(l, n + j, k) = &
                                        q_cons_vf(i)%sf(l, n, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, n , k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, n , k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if
        
        !< z-direction =========================================================
        elseif (bc_dir == 3) then

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i == momxe) then
                                    q_cons_vf(i)%sf(k, l, -j) = 0d0
                                else
                                    q_cons_vf(i)%sf(k, l, -j) = &
                                        q_cons_vf(i)%sf(k, l, 0)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, 0, q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, 0, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_z%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i == momxe) then
                                    q_cons_vf(i)%sf(k, l, p+j) = 0d0
                                else
                                    q_cons_vf(i)%sf(k, l, p+j) = &
                                        q_cons_vf(i)%sf(k, l, p)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p+j, q, i) = &
                                            pb(k, l, p, q, i)
                                        mv(k, l, p+j, q, i) = &
                                            mv(k, l, p, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if 

            end if

        end if
        !< =====================================================================

    end subroutine s_slip_wall

    subroutine s_no_slip_wall(q_cons_vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i

        !< x-direction =========================================================
        if (bc_dir == 1) then

            if (bc_loc == -1) then !< bc_x%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(-j,k,l) = &
                                        - q_cons_vf(i)%sf(j - 1, k, l)
                                else
                                    q_cons_vf(i)%sf(-j, k, l) = &
                                        q_cons_vf(i)%sf(0, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(4) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                           pb(0, k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                           mv(0, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(m+j,k,l) = &
                                        - q_cons_vf(i)%sf(m - (j - 1), k, l)
                                else
                                    q_cons_vf(i)%sf(m+j, k, l) = &
                                        q_cons_vf(i)%sf(m, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(m, k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(m, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(l, -j, k) = &
                                        - q_cons_vf(i)%sf(l, (j - 1), k)
                                else
                                    q_cons_vf(i)%sf(l, -j, k) = &
                                        q_cons_vf(i)%sf(l, 0, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, 0, k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, 0, k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i == momxb + 1) then
                                    q_cons_vf(i)%sf(l, n + j, k) = &
                                        - q_cons_vf(i)%sf(l, n - (j - 1), k)
                                else
                                    q_cons_vf(i)%sf(l, n + j, k) = &
                                        q_cons_vf(i)%sf(l, n, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, n , k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, n , k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if
        
        !< z-direction =========================================================
        elseif (bc_dir == 3) then

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(k, l, -j) = &
                                        - q_cons_vf(i)%sf(k, l, j - 1)
                                else
                                    q_cons_vf(i)%sf(k, l, -j) = &
                                        q_cons_vf(i)%sf(k, l, 0)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, 0, q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, 0, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_z%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(k, l, p+j) = &
                                        -q_cons_vf(i)%sf(k, l, p - (j - 1))
                                else
                                    q_cons_vf(i)%sf(k, l, p+j) = &
                                        q_cons_vf(i)%sf(k, l, p)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p+j, q, i) = &
                                            pb(k, l, p, q, i)
                                        mv(k, l, p+j, q, i) = &
                                            mv(k, l, p, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if 

            end if

        end if
        !< =====================================================================

    end subroutine s_no_slip_wall

    subroutine s_specified_velocity(q_cons_Vf, pb, mv, bc_dir, bc_loc)

        type(scalar_field), dimension(sys_size) :: q_cons_vf
        real(kind(0d0)), dimension(startx:, starty:, startz:, 1:, 1:), intent (INOUT) :: pb, mv
        integer :: bc_dir, bc_loc
        integer :: j, k, l, q, i
        real(kind(0d0)) :: vel_mag_buff, e_internal_int, rhoL

        !< x-direction =========================================================
        if (bc_dir == 1) then

            if (bc_loc == -1) then !< bc_x%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i == momxb .and. bc_x%vel1b .ne. dflt_real) then
                                    call s_compute_mixture_density(q_cons_vf, rhoL, 0, k, l)
                                    q_cons_vf(i)%sf(-j,k,l) = rhoL*bc_x%vel1b
                                elseif (i == momxb + 1 .and. bc_x%vel2b .ne. dflt_real) then
                                    call s_compute_mixture_density(q_cons_vf, rhoL, 0, k, l)
                                    q_cons_vf(i)%sf(-j,k,l) = rhoL*bc_x%vel2b
                                elseif (i == momxb + 2 .and. bc_x%vel3b .ne. dflt_real) then
                                    call s_compute_mixture_density(q_cons_vf, rhoL, 0, k, l)
                                    q_cons_vf(i)%sf(-j,k,l) = rhoL*bc_x%vel3b
                                else if (i == E_idx) then
                                    ! Compute necessary values
                                    call s_compute_specific_velocity_internal_results(q_cons_vf, &
                                        e_internal_int, rhoL, 0, k, l)
                                    call s_compute_specific_velocity_buffer_results(q_cons_vf, &
                                        vel_mag_buff, rhoL, -j, k, l)
                                    ! Assign value
                                    q_cons_vf(i)%sf(-j, k, l) = rhoL*(e_internal_int + &
                                        5d-1*vel_mag_buff)
                                else
                                    q_cons_vf(i)%sf(-j, k, l) = &
                                        q_cons_vf(i)%sf(0, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(4) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(-j, k, l, q, i) = &
                                           pb(0, k, l, q, i)
                                        mv(-j, k, l, q, i) = &
                                           mv(0, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_x%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do l = 0, p
                        do k = 0, n
                            do j = 1, buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(m+j,k,l) = 0d0
                                else
                                    q_cons_vf(i)%sf(m+j, k, l) = &
                                        q_cons_vf(i)%sf(m, k, l)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do l = 0, p
                            do k = 0, n
                                do j = 1, buff_size
                                    do q = 1, nnode
                                        pb(m + j, k, l, q, i) = &
                                            pb(m, k, l, q, i)
                                        mv(m + j, k, l, q, i) = &
                                            mv(m, k, l, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if

        !< y-direction =========================================================
        elseif (bc_dir == 2) then

            if (bc_loc == -1) then !< bc_y%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(l, -j, k) = 0d0
                                else
                                    q_cons_vf(i)%sf(l, -j, k) = &
                                        q_cons_vf(i)%sf(l, 0, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, -j, k, q, i) = &
                                            pb(l, 0, k, q, i)
                                        mv(l, -j, k, q, i) = &
                                            mv(l, 0, k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_y%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do k = 0, p
                        do j = 1, buff_size
                            do l = -buff_size, m + buff_size
                                if (i == momxb + 1) then
                                    q_cons_vf(i)%sf(l, n + j, k) = 0d0
                                else
                                    q_cons_vf(i)%sf(l, n + j, k) = &
                                        q_cons_vf(i)%sf(l, n, k)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do k = 0, p
                            do j = 1, buff_size
                                do l = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(l, n + j, k, q, i) = &
                                            pb(l, n , k, q, i)
                                        mv(l, n + j, k, q, i) = &
                                            mv(l, n , k, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            end if
        
        !< z-direction =========================================================
        elseif (bc_dir == 3) then

            if (bc_loc == -1) then !< bc_z%beg

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(k, l, -j) = 0d0
                                else
                                    q_cons_vf(i)%sf(k, l, -j) = &
                                        q_cons_vf(i)%sf(k, l, 0)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, -j, q, i) = &
                                            pb(k, l, 0, q, i)
                                        mv(k, l, -j, q, i) = &
                                            mv(k, l, 0, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if

            else !< bc_z%end

                !$acc parallel loop collapse(4) gang vector default(present)
                do i = 1, sys_size
                    do j = 1, buff_size
                        do l = -buff_size, n + buff_size
                            do k = -buff_size, m + buff_size
                                if (i >= momxb .and. i <= momxe) then
                                    q_cons_vf(i)%sf(k, l, p+j) = 0d0
                                else
                                    q_cons_vf(i)%sf(k, l, p+j) = &
                                        q_cons_vf(i)%sf(k, l, p)
                                end if
                            end do
                        end do
                    end do
                end do

                if(qbmm .and. .not. polytropic) then
                    !$acc parallel loop collapse(5) gang vector default(present)
                    do i = 1, nb
                        do j = 1, buff_size
                            do l = -buff_size, n + buff_size
                                do k = -buff_size, m + buff_size
                                    do q = 1, nnode
                                        pb(k, l, p+j, q, i) = &
                                            pb(k, l, p, q, i)
                                        mv(k, l, p+j, q, i) = &
                                            mv(k, l, p, q, i)
                                    end do
                                end do
                            end do
                        end do
                    end do
                end if 

            end if

        end if
        !< =====================================================================

    end subroutine s_specified_velocity

    subroutine s_compute_specific_velocity_internal_results(q_cons_vf, &
        e_internal_int, rhoL, j, k, l)

        type(scalar_field), dimension(1:sys_size) :: q_cons_vf
        real(kind(0d0)) :: e_internal_int, rhoL
        integer :: j, k, l, i

        real(kind(0d0)) :: vel_mag_int

        !$acc routine seq

        ! Compute square of velocity magnitude in interior and buffer
        vel_mag_int = 0d0
        do i = 1, num_dims
            vel_mag_int = vel_mag_int + (q_cons_vf(momxb + i - 1)%sf(j, k, l)/max(small_alf,rhoL))**2d0
        end do

        call s_compute_mixture_density(q_cons_vf, rhoL, j, k, l)

        e_internal_int = q_cons_vf(E_idx)%sf(j, k, l)/max(small_alf, rhoL) - 5d-1*vel_mag_int

    end subroutine s_compute_specific_velocity_internal_results

    subroutine s_compute_specific_velocity_buffer_results(q_cons_vf, vel_mag_buff, rhoL, j, k, l)

        type(scalar_field), dimension(1:sys_size) :: q_cons_vf
        real(kind(0d0)) :: vel_mag_buff, rhoL
        integer :: j, k, l, i

        vel_mag_buff = 0d0
        do i = 1, num_dims
            vel_mag_buff = vel_mag_buff + (q_cons_vf(momxb + i - 1)%sf(j, k, l)/max(small_alf, rhoL))**2d0
        end do

    end subroutine s_compute_specific_velocity_buffer_results

    subroutine s_compute_mixture_density(q_cons_vf, rhoL, j, k, l)

        type(scalar_field), dimension(1:sys_size) :: q_cons_vf
        real(kind(0d0)) :: rhoL
        integer :: j, k, l, i

        !$acc routine seq
        rhoL = 0d0
        do i = 1, num_fluids
            rhoL = rhoL + q_cons_vf(contxb + i - 1)%sf(j, k, l)
        end do

    end subroutine

end module m_boundary_conditions