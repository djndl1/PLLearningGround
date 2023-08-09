a = [1 2 3 4]

b = [1 3 5; 2 4 6; 7 8 10]

b * inv(b)

z = zeros(5, 1)

## elementwise
b .* b

b .^ 3

# horizontal concatenation
[b, b]
[b b]
# vertical concatenation
[b; b]


# complex
1 + 1j
sqrt(-1)

pkg load strings

# string
s = "ABFD my string 中文"
q = """quoted"""
q + 5 + ""

A = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]
A(8) # one-based
A(4, 2)
A(1:3, 2) # 1-3 row, the 2nd column
A(1:3, 2:3)
A(3, :)

whos
whos A

save wk.mat # save workspace variables
clear # clear the workspace
load wk.mat

A = [1 3 5]
max(A)
B = [3 6 9]
union(A, B)
[a, b] = bounds(A)

disp("Hello world") # finally

clc # clear the screen

# draw some graphs
x = linspace(0, 2 * pi);
y = sin(x);
plot(x, y)
xlabel("x")
ylabel("sin(x)")
title("Plot of the Sine Function")
plot(x, y, "r--");

hold on

y2 = cos(x)
plot(x, y2, ":");

legend("sin", "cos");

hold off

# 3D
x = linspace(-2,2,20);
y = x';
z = x .* exp(-x.^2 - y.^2);

surf(x, y, z)

t = tiledlayout(2,2);
title(t,"Trigonometric Functions")
x = linspace(0,30);
