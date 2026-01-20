      program circle
      implicit none
      real r, area
      integer i, sum

!  My Comment
      read (*, *) r
      area = 3.14159 * r * r
      write (*, *) 'Area = ', area

      i = 0
      sum = 0
      write(*, *) sum

      if (sum > 0) then
            sum = 0
      else if (sum < 0) then
            sum = 0
      else
            sum = 0
      endif

      stop
      end
