ans # show previous result

clc # clear the screen

diary # log the command

format long # show numbers in the long fomrat

A = [1 2 3; ... # line continuation
     3 4 5; ...
     7 8 9];

exist sin # is a name bound and how
iskeyword if
iskeyword # show keywords

isvarname 5a # is it a valid variabe name

if 1 == true
  disp("true is one")
end

if -1
  disp("-1 is true")
end

if true + true == 2
  disp("true is numerically 1")
else
  disp("true is real boolean")
end

if -1 == true
  disp("-1 == true")
elseif -1
  disp("-1 is true but not equal to true")
else
  disp("-1 is not true")
end

switch -1
       case true
         disp("-1 == true");
       case -1
         disp("-1 == -1");
       otherwise
         disp("you can't be serious");
end;
