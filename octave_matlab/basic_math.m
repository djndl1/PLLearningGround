A = [2 0; ...
     0 2]
b = [2; ...
     1]

A \ b # solve the linear equation system

coeff = [1 0 -5]
# polynomial evaluation
polyval(coeff, x)

# compute polynomial zeros
roots(coeff)
