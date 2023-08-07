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
