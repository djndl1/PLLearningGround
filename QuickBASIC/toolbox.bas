' 四舍五入
Function RoundCent (m)
	RoundCent = Sgn(m) * INT(100 * ABS(m) + 0.5) / 100 ' add 0.5 to enforce rounding
End Function

' 两种证明：
' bit flipping = (2^N-1) - Unsigned
' 1. (2^N) - 1 - Unsigned + 1 = SignedNeg => Unsigned = (2^N)-1 - SignedNeg + 1
' 2. 证明 inv(Y-1) = Y + 1 按奇偶分情况讨论，
' 奇数情况易证，偶数情况下，从低位起第一个1之前inv(Y-1)和inv(Y)相同，
' 后面部分正好inv(Y)低位比inv(Y-1)低位少1，最后得到inv(Y-1) = inv(Y)+1
Function OptimAbsI(a%)
	Dim mask%: mask% = -a% > 0
	OptimAbsI = (a% xor mask%) - mask%
End Function

Function OptimAbsL(a&)
	Dim mask&: mask& = -a& > 0
	OptimAbsL = (a& xor mask&) - mask&
End Function

Function OptimAbsF(a!)
	OptimAbsF = a! * (a! < 0) - a! * (a! >= 0)
End Function

Function OptimAbsD(a#)
	OptimAbsD = a# * (a# < 0) - a# * (a# >= 0)
End Function

Function Max(a, b)
	MAx = a * ABS(a <= b) + b * ABS(a > b)
End Function

print OptimAbsI(-5%)
print OptimAbsI(0%)
print OptimAbsI(5%)
print OptimAbsL(5&)
print OptimAbsL(0&)
print OptimAbsL(-5&)

end
