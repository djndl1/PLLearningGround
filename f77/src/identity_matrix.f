      program identity_matrix
         implicit none

         integer i, j, V(10, 10)

         do i = 1, 10
            do j = 1, 10
               V(i, j) = (i/j)*(j/i)
            end do
         end do

         stop
      end
