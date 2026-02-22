VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NumericsTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestEuclideanDivisionLong
    TestEuclideanDivisionInteger
    TestCeilingDivisionLong
    TestCeilingDivisionInteger
    TestFloorDivisionLong
    TestFloorDivisionInteger
    TestMathematicalModuloLong
    TestMathematicalModuloInteger
    TestDivisionByZeroErrors
    TestClampFunctions
    TestClampErrorHandling
End Sub

Private Sub TestEuclideanDivisionLong()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.EuclideanDivisionLong(7, 3)
    m_asserter.AreEqual result.First, 2, "NumericsTest.TestEuclideanDivisionLong", "7/3 quotient should be 2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestEuclideanDivisionLong", "7/3 remainder should be 1 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.EuclideanDivisionLong(-7, 3)
    m_asserter.AreEqual result.First, -3, "NumericsTest.TestEuclideanDivisionLong", "-7/3 quotient should be -3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestEuclideanDivisionLong", "-7/3 remainder should be 2 but got " & result.Second

    ' Test positive dividend, negative divisor
    result = Numerics.EuclideanDivisionLong(7, -3)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestEuclideanDivisionLong", "7/-3 quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestEuclideanDivisionLong", "7/-3 remainder should be 1 but got " & result.Second

    ' Test negative dividend, negative divisor
    result = Numerics.EuclideanDivisionLong(-7, -3)
    m_asserter.AreEqual result.First, 3, "NumericsTest.TestEuclideanDivisionLong", "-7/-3 quotient should be 3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestEuclideanDivisionLong", "-7/-3 remainder should be 2 but got " & result.Second

    ' Test zero dividend
    result = Numerics.EuclideanDivisionLong(0, 5)
    m_asserter.AreEqual result.First, 0, "NumericsTest.TestEuclideanDivisionLong", "0/5 quotient should be 0 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestEuclideanDivisionLong", "0/5 remainder should be 0 but got " & result.Second

    ' Test boundary values
    result = Numerics.EuclideanDivisionLong(32767, 32767)
    m_asserter.AreEqual result.First, 1, "NumericsTest.TestEuclideanDivisionLong", "32767/32767 quotient should be 1 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestEuclideanDivisionLong", "32767/32767 remainder should be 0 but got " & result.Second

    result = Numerics.EuclideanDivisionLong(-32768, 32767)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestEuclideanDivisionLong", "-32768/32767 Euclidean quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, 32766, "NumericsTest.TestEuclideanDivisionLong", "-32768/32767 Euclidean remainder should be 32766 but got " & result.Second
End Sub

Private Sub TestEuclideanDivisionInteger()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.EuclideanDivisionInteger(7, 3)
    m_asserter.AreEqual result.First, 2, "NumericsTest.TestEuclideanDivisionInteger", "7/3 quotient should be 2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestEuclideanDivisionInteger", "7/3 remainder should be 1 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.EuclideanDivisionInteger(-7, 3)
    m_asserter.AreEqual result.First, -3, "NumericsTest.TestEuclideanDivisionInteger", "-7/3 quotient should be -3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestEuclideanDivisionInteger", "-7/3 remainder should be 2 but got " & result.Second

    ' Test boundary values for Integer type
    result = Numerics.EuclideanDivisionInteger(32767, 32767)
    m_asserter.AreEqual result.First, 1, "NumericsTest.TestEuclideanDivisionInteger", "32767/32767 quotient should be 1 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestEuclideanDivisionInteger", "32767/32767 remainder should be 0 but got " & result.Second

    result = Numerics.EuclideanDivisionInteger(-32768, 32767)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestEuclideanDivisionInteger", "-32768/32767 Euclidean quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, 32766, "NumericsTest.TestEuclideanDivisionInteger", "-32768/32767 Euclidean remainder should be 32766 but got " & result.Second
End Sub

Private Sub TestCeilingDivisionLong()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.CeilingDivisionLong(7, 3)
    m_asserter.AreEqual result.First, 3, "NumericsTest.TestCeilingDivisionLong", "7/3 ceiling quotient should be 3 but got " & result.First
    m_asserter.AreEqual result.Second, -2, "NumericsTest.TestCeilingDivisionLong", "7/3 ceiling remainder should be -2 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.CeilingDivisionLong(-7, 3)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestCeilingDivisionLong", "-7/3 ceiling quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, -1, "NumericsTest.TestCeilingDivisionLong", "-7/3 ceiling remainder should be -1 but got " & result.Second

    ' Test positive dividend, negative divisor
    result = Numerics.CeilingDivisionLong(7, -3)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestCeilingDivisionLong", "7/-3 ceiling quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestCeilingDivisionLong", "7/-3 ceiling remainder should be 1 but got " & result.Second

    ' Test negative dividend, negative divisor
    result = Numerics.CeilingDivisionLong(-7, -3)
    m_asserter.AreEqual result.First, 3, "NumericsTest.TestCeilingDivisionLong", "-7/-3 ceiling quotient should be 3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestCeilingDivisionLong", "-7/-3 ceiling remainder should be 2 but got " & result.Second

    ' Test zero dividend
    result = Numerics.CeilingDivisionLong(0, 5)
    m_asserter.AreEqual result.First, 0, "NumericsTest.TestCeilingDivisionLong", "0/5 ceiling quotient should be 0 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestCeilingDivisionLong", "0/5 ceiling remainder should be 0 but got " & result.Second
End Sub

Private Sub TestCeilingDivisionInteger()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.CeilingDivisionInteger(7, 3)
    m_asserter.AreEqual result.First, 3, "NumericsTest.TestCeilingDivisionInteger", "7/3 ceiling quotient should be 3 but got " & result.First
    m_asserter.AreEqual result.Second, -2, "NumericsTest.TestCeilingDivisionInteger", "7/3 ceiling remainder should be -2 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.CeilingDivisionInteger(-7, 3)
    m_asserter.AreEqual result.First, -2, "NumericsTest.TestCeilingDivisionInteger", "-7/3 ceiling quotient should be -2 but got " & result.First
    m_asserter.AreEqual result.Second, -1, "NumericsTest.TestCeilingDivisionInteger", "-7/3 ceiling remainder should be -1 but got " & result.Second

    ' Test boundary values for Integer type
    result = Numerics.CeilingDivisionInteger(32767, 32767)
    m_asserter.AreEqual result.First, 1, "NumericsTest.TestCeilingDivisionInteger", "32767/32767 ceiling quotient should be 1 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestCeilingDivisionInteger", "32767/32767 ceiling remainder should be 0 but got " & result.Second
End Sub

Private Sub TestFloorDivisionLong()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.FloorDivisionLong(7, 3)
    m_asserter.AreEqual result.First, 2, "NumericsTest.TestFloorDivisionLong", "7/3 floor quotient should be 2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestFloorDivisionLong", "7/3 floor remainder should be 1 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.FloorDivisionLong(-7, 3)
    m_asserter.AreEqual result.First, -3, "NumericsTest.TestFloorDivisionLong", "-7/3 floor quotient should be -3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestFloorDivisionLong", "-7/3 floor remainder should be 2 but got " & result.Second

    ' Test positive dividend, negative divisor
    result = Numerics.FloorDivisionLong(7, -3)
    m_asserter.AreEqual result.First, -3, "NumericsTest.TestFloorDivisionLong", "7/-3 floor quotient should be -3 but got " & result.First
    m_asserter.AreEqual result.Second, -2, "NumericsTest.TestFloorDivisionLong", "7/-3 floor remainder should be -2 but got " & result.Second

    ' Test negative dividend, negative divisor
    result = Numerics.FloorDivisionLong(-7, -3)
    m_asserter.AreEqual result.First, 2, "NumericsTest.TestFloorDivisionLong", "-7/-3 floor quotient should be 2 but got " & result.First
    m_asserter.AreEqual result.Second, -1, "NumericsTest.TestFloorDivisionLong", "-7/-3 floor remainder should be -1 but got " & result.Second

    ' Test zero dividend
    result = Numerics.FloorDivisionLong(0, 5)
    m_asserter.AreEqual result.First, 0, "NumericsTest.TestFloorDivisionLong", "0/5 floor quotient should be 0 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestFloorDivisionLong", "0/5 floor remainder should be 0 but got " & result.Second
End Sub

Private Sub TestFloorDivisionInteger()
    Dim result As VariantPair

    ' Test positive dividend, positive divisor
    result = Numerics.FloorDivisionInteger(7, 3)
    m_asserter.AreEqual result.First, 2, "NumericsTest.TestFloorDivisionInteger", "7/3 floor quotient should be 2 but got " & result.First
    m_asserter.AreEqual result.Second, 1, "NumericsTest.TestFloorDivisionInteger", "7/3 floor remainder should be 1 but got " & result.Second

    ' Test negative dividend, positive divisor
    result = Numerics.FloorDivisionInteger(-7, 3)
    m_asserter.AreEqual result.First, -3, "NumericsTest.TestFloorDivisionInteger", "-7/3 floor quotient should be -3 but got " & result.First
    m_asserter.AreEqual result.Second, 2, "NumericsTest.TestFloorDivisionInteger", "-7/3 floor remainder should be 2 but got " & result.Second

    ' Test boundary values for Integer type
    result = Numerics.FloorDivisionInteger(32767, 32767)
    m_asserter.AreEqual result.First, 1, "NumericsTest.TestFloorDivisionInteger", "32767/32767 floor quotient should be 1 but got " & result.First
    m_asserter.AreEqual result.Second, 0, "NumericsTest.TestFloorDivisionInteger", "32767/32767 floor remainder should be 0 but got " & result.Second
End Sub

Private Sub TestMathematicalModuloLong()
    Dim result As Long

    ' Test positive dividend, positive divisor (same as EuclideanDivisionLong remainder)
    result = Numerics.MathematicalModuloLong(7, 3)
    m_asserter.AreEqual result, 1, "NumericsTest.TestMathematicalModuloLong", "7 mod 3 should be 1 (same as Euclidean remainder) but got " & result

    ' Test negative dividend, positive divisor (same as EuclideanDivisionLong remainder)
    result = Numerics.MathematicalModuloLong(-7, 3)
    m_asserter.AreEqual result, 2, "NumericsTest.TestMathematicalModuloLong", "-7 mod 3 should be 2 (same as Euclidean remainder) but got " & result

    ' Test positive dividend, negative divisor (same as EuclideanDivisionLong remainder)
    result = Numerics.MathematicalModuloLong(7, -3)
    m_asserter.AreEqual result, 1, "NumericsTest.TestMathematicalModuloLong", "7 mod -3 should be 1 (same as Euclidean remainder) but got " & result

    ' Test negative dividend, negative divisor (same as EuclideanDivisionLong remainder)
    result = Numerics.MathematicalModuloLong(-7, -3)
    m_asserter.AreEqual result, 2, "NumericsTest.TestMathematicalModuloLong", "-7 mod -3 should be 2 (same as Euclidean remainder) but got " & result

    ' Test zero dividend
    result = Numerics.MathematicalModuloLong(0, 5)
    m_asserter.AreEqual result, 0, "NumericsTest.TestMathematicalModuloLong", "0 mod 5 should be 0 but got " & result

    ' Test boundary values (same as EuclideanDivisionLong remainder)
    result = Numerics.MathematicalModuloLong(32767, 32767)
    m_asserter.AreEqual result, 0, "NumericsTest.TestMathematicalModuloLong", "32767 mod 32767 should be 0 (same as Euclidean remainder) but got " & result

    result = Numerics.MathematicalModuloLong(-32768, 32767)
    m_asserter.AreEqual result, 32766, "NumericsTest.TestMathematicalModuloLong", "-32768 mod 32767 should be 32766 (same as Euclidean remainder) but got " & result
End Sub

Private Sub TestMathematicalModuloInteger()
    Dim result As Integer

    ' Test positive dividend, positive divisor (same as EuclideanDivisionInteger remainder)
    result = Numerics.MathematicalModuloInteger(7, 3)
    m_asserter.AreEqual result, 1, "NumericsTest.TestMathematicalModuloInteger", "7 mod 3 should be 1 (same as Euclidean remainder) but got " & result

    ' Test negative dividend, positive divisor (same as EuclideanDivisionInteger remainder)
    result = Numerics.MathematicalModuloInteger(-7, 3)
    m_asserter.AreEqual result, 2, "NumericsTest.TestMathematicalModuloInteger", "-7 mod 3 should be 2 (same as Euclidean remainder) but got " & result

    ' Test boundary values for Integer type (same as EuclideanDivisionInteger remainder)
    result = Numerics.MathematicalModuloInteger(0, 5)
    m_asserter.AreEqual result, 0, "NumericsTest.TestMathematicalModuloInteger", "0 mod 5 should be 0 but got " & result

    result = Numerics.MathematicalModuloInteger(32767, 32767)
    m_asserter.AreEqual result, 0, "NumericsTest.TestMathematicalModuloInteger", "32767 mod 32767 should be 0 (same as Euclidean remainder) but got " & result

    result = Numerics.MathematicalModuloInteger(-32768, 32767)
    m_asserter.AreEqual result, 32766, "NumericsTest.TestMathematicalModuloInteger", "-32768 mod 32767 should be 32766 (same as Euclidean remainder) but got " & result
End Sub

Private Sub TestDivisionByZeroErrors()
    Dim errorRaised As Boolean
    Dim result As VariantPair

    ' Test EuclideanDivisionLong with zero divisor
    errorRaised = False
    On Error GoTo EuclideanLongError
    result = Numerics.EuclideanDivisionLong(5, 0)
    GoTo EuclideanLongSuccess
EuclideanLongError:
    errorRaised = True
    Resume EuclideanLongSuccess
EuclideanLongSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "EuclideanDivisionLong should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test EuclideanDivisionInteger with zero divisor
    errorRaised = False
    On Error GoTo EuclideanIntegerError
    result = Numerics.EuclideanDivisionInteger(5, 0)
    GoTo EuclideanIntegerSuccess
EuclideanIntegerError:
    errorRaised = True
    Resume EuclideanIntegerSuccess
EuclideanIntegerSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "EuclideanDivisionInteger should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test CeilingDivisionLong with zero divisor
    errorRaised = False
    On Error GoTo CeilingLongError
    result = Numerics.CeilingDivisionLong(5, 0)
    GoTo CeilingLongSuccess
CeilingLongError:
    errorRaised = True
    Resume CeilingLongSuccess
CeilingLongSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "CeilingDivisionLong should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test CeilingDivisionInteger with zero divisor
    errorRaised = False
    On Error GoTo CeilingIntegerError
    result = Numerics.CeilingDivisionInteger(5, 0)
    GoTo CeilingIntegerSuccess
CeilingIntegerError:
    errorRaised = True
    Resume CeilingIntegerSuccess
CeilingIntegerSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "CeilingDivisionInteger should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test FloorDivisionLong with zero divisor
    errorRaised = False
    On Error GoTo FloorLongError
    result = Numerics.FloorDivisionLong(5, 0)
    GoTo FloorLongSuccess
FloorLongError:
    errorRaised = True
    Resume FloorLongSuccess
FloorLongSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "FloorDivisionLong should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test FloorDivisionInteger with zero divisor
    errorRaised = False
    On Error GoTo FloorIntegerError
    result = Numerics.FloorDivisionInteger(5, 0)
    GoTo FloorIntegerSuccess
FloorIntegerError:
    errorRaised = True
    Resume FloorIntegerSuccess
FloorIntegerSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "FloorDivisionInteger should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test MathematicalModuloLong with zero divisor
    errorRaised = False
    On Error GoTo ModuloLongError
    Dim moduloResult As Long
    moduloResult = Numerics.MathematicalModuloLong(5, 0)
    GoTo ModuloLongSuccess
ModuloLongError:
    errorRaised = True
    Resume ModuloLongSuccess
ModuloLongSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "MathematicalModuloLong should raise error for zero divisor but errorRaised = " & errorRaised

    ' Test MathematicalModuloInteger with zero divisor
    errorRaised = False
    On Error GoTo ModuloIntegerError
    Dim moduloResultInt As Integer
    moduloResultInt = Numerics.MathematicalModuloInteger(5, 0)
    GoTo ModuloIntegerSuccess
ModuloIntegerError:
    errorRaised = True
    Resume ModuloIntegerSuccess
ModuloIntegerSuccess:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "NumericsTest.TestDivisionByZeroErrors", "MathematicalModuloInteger should raise error for zero divisor but errorRaised = " & errorRaised
End Sub

Private Sub TestClampFunctions()
    ' Test ClampInbetween
    ' byte
    m_asserter.AreEqual Numerics.ClampByte(5, 1, 6), 5, "NumericsTest.TestClampFunctions", "ClampByte(5, 1, 6) should be 5 but got " & Numerics.ClampByte(5, 1, 6)

    ' short (using ClampInteger in VB6)
    m_asserter.AreEqual Numerics.ClampInteger(5, 1, 6), 5, "NumericsTest.TestClampFunctions", "ClampInteger(5, 1, 6) should be 5 but got " & Numerics.ClampInteger(5, 1, 6)

    ' int (using ClampInteger in VB6)
    m_asserter.AreEqual Numerics.ClampInteger(5, 1, 6), 5, "NumericsTest.TestClampFunctions", "ClampInteger(5, 1, 6) should be 5 but got " & Numerics.ClampInteger(5, 1, 6)

    ' long
    m_asserter.AreEqual Numerics.ClampLong(5, 1, 6), 5, "NumericsTest.TestClampFunctions", "ClampLong(5, 1, 6) should be 5 but got " & Numerics.ClampLong(5, 1, 6)

    ' float
    m_asserter.AreEqual Numerics.ClampSingle(5#, 1#, 6#), 5#, "NumericsTest.TestClampFunctions", "ClampSingle(5.0, 1.0, 6.0) should be 5.0 but got " & Numerics.ClampSingle(5#, 1#, 6#)

    ' double
    m_asserter.AreEqual Numerics.ClampDouble(5#, 1#, 6#), 5#, "NumericsTest.TestClampFunctions", "ClampDouble(5.0, 1.0, 6.0) should be 5.0 but got " & Numerics.ClampDouble(5#, 1#, 6#)

    ' decimal
    m_asserter.AreEqual Numerics.Clamp(5#, 1#, 6#), 5#, "NumericsTest.TestClampFunctions", "Clamp(5.0, 1.0, 6.0) should be 5.0 but got " & Numerics.Clamp(5#, 1#, 6#)

    ' Test ClampLessThan
    ' byte
    m_asserter.AreEqual Numerics.ClampByte(0, 1, 6), 1, "NumericsTest.TestClampFunctions", "ClampByte(0, 1, 6) should be 1 but got " & Numerics.ClampByte(0, 1, 6)

    ' short
    m_asserter.AreEqual Numerics.ClampInteger(-11, -10, 6), -10, "NumericsTest.TestClampFunctions", "ClampInteger(-11, -10, 6) should be -10 but got " & Numerics.ClampInteger(-11, -10, 6)

    ' int
    m_asserter.AreEqual Numerics.ClampInteger(-11, -10, 6), -10, "NumericsTest.TestClampFunctions", "ClampInteger(-11, -10, 6) should be -10 but got " & Numerics.ClampInteger(-11, -10, 6)

    ' long
    m_asserter.AreEqual Numerics.ClampLong(-11, -10, 6), -10, "NumericsTest.TestClampFunctions", "ClampLong(-11, -10, 6) should be -10 but got " & Numerics.ClampLong(-11, -10, 6)

    ' float
    m_asserter.AreEqual Numerics.ClampSingle(-110#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "ClampSingle(-110.0, -10.0, 6.0) should be -10.0 but got " & Numerics.ClampSingle(-110#, -10#, 6#)

    ' double
    m_asserter.AreEqual Numerics.ClampDouble(-55#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "ClampDouble(-55.0, -10.0, 6.0) should be -10.0 but got " & Numerics.ClampDouble(-55#, -10#, 6#)

    ' decimal
    m_asserter.AreEqual Numerics.Clamp(-15#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "Clamp(-15.0, -10.0, 6.0) should be -10.0 but got " & Numerics.Clamp(-15#, -10#, 6#)

    ' Test ClampGreaterThan
    ' byte
    m_asserter.AreEqual Numerics.ClampByte(7, 1, 6), 6, "NumericsTest.TestClampFunctions", "ClampByte(7, 1, 6) should be 6 but got " & Numerics.ClampByte(7, 1, 6)

    ' short
    m_asserter.AreEqual Numerics.ClampInteger(7, -10, 6), 6, "NumericsTest.TestClampFunctions", "ClampInteger(7, -10, 6) should be 6 but got " & Numerics.ClampInteger(7, -10, 6)

    ' int
    m_asserter.AreEqual Numerics.ClampInteger(8, -10, 6), 6, "NumericsTest.TestClampFunctions", "ClampInteger(8, -10, 6) should be 6 but got " & Numerics.ClampInteger(8, -10, 6)

    ' long
    m_asserter.AreEqual Numerics.ClampLong(11, -10, 6), 6, "NumericsTest.TestClampFunctions", "ClampLong(11, -10, 6) should be 6 but got " & Numerics.ClampLong(11, -10, 6)

    ' float
    m_asserter.AreEqual Numerics.ClampSingle(110#, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "ClampSingle(110.0, -10.0, 6.0) should be 6.0 but got " & Numerics.ClampSingle(110#, -10#, 6#)

    ' double
    m_asserter.AreEqual Numerics.ClampDouble(8.3, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "ClampDouble(8.3, -10.0, 6.0) should be 6.0 but got " & Numerics.ClampDouble(8.3, -10#, 6#)

    ' decimal
    m_asserter.AreEqual Numerics.Clamp(15#, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "Clamp(15.0, -10.0, 6.0) should be 6.0 but got " & Numerics.Clamp(15#, -10#, 6#)

    ' Test ClampAtLowerBoundaries
    ' byte
    m_asserter.AreEqual Numerics.ClampByte(1, 1, 6), 1, "NumericsTest.TestClampFunctions", "ClampByte(1, 1, 6) should be 1 but got " & Numerics.ClampByte(1, 1, 6)

    ' short
    m_asserter.AreEqual Numerics.ClampInteger(-10, -10, 6), -10, "NumericsTest.TestClampFunctions", "ClampInteger(-10, -10, 6) should be -10 but got " & Numerics.ClampInteger(-10, -10, 6)

    ' int
    m_asserter.AreEqual Numerics.ClampInteger(0, 0, 6), 0, "NumericsTest.TestClampFunctions", "ClampInteger(0, 0, 6) should be 0 but got " & Numerics.ClampInteger(0, 0, 6)

    ' long
    m_asserter.AreEqual Numerics.ClampLong(-10, -10, 6), -10, "NumericsTest.TestClampFunctions", "ClampLong(-10, -10, 6) should be -10 but got " & Numerics.ClampLong(-10, -10, 6)

    ' float
    m_asserter.AreEqual Numerics.ClampSingle(-10#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "ClampSingle(-10.0, -10.0, 6.0) should be -10.0 but got " & Numerics.ClampSingle(-10#, -10#, 6#)

    ' double
    m_asserter.AreEqual Numerics.ClampDouble(-10#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "ClampDouble(-10.0, -10.0, 6.0) should be -10.0 but got " & Numerics.ClampDouble(-10#, -10#, 6#)

    ' decimal
    m_asserter.AreEqual Numerics.Clamp(-10#, -10#, 6#), -10#, "NumericsTest.TestClampFunctions", "Clamp(-10.0, -10.0, 6.0) should be -10.0 but got " & Numerics.Clamp(-10#, -10#, 6#)

    ' Test ClampAtUpperBoundaries
    ' byte
    m_asserter.AreEqual Numerics.ClampByte(6, 1, 6), 6, "NumericsTest.TestClampFunctions", "ClampByte(6, 1, 6) should be 6 but got " & Numerics.ClampByte(6, 1, 6)

    ' short
    m_asserter.AreEqual Numerics.ClampInteger(6, -10, 6), 6, "NumericsTest.TestClampFunctions", "ClampInteger(6, -10, 6) should be 6 but got " & Numerics.ClampInteger(6, -10, 6)

    ' int
    m_asserter.AreEqual Numerics.ClampInteger(6, 0, 6), 6, "NumericsTest.TestClampFunctions", "ClampInteger(6, 0, 6) should be 6 but got " & Numerics.ClampInteger(6, 0, 6)

    ' long
    m_asserter.AreEqual Numerics.ClampLong(6, -10, 6), 6, "NumericsTest.TestClampFunctions", "ClampLong(6, -10, 6) should be 6 but got " & Numerics.ClampLong(6, -10, 6)

    ' float
    m_asserter.AreEqual Numerics.ClampSingle(6#, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "ClampSingle(6.0, -10.0, 6.0) should be 6.0 but got " & Numerics.ClampSingle(6#, -10#, 6#)

    ' double
    m_asserter.AreEqual Numerics.ClampDouble(6#, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "ClampDouble(6.0, -10.0, 6.0) should be 6.0 but got " & Numerics.ClampDouble(6#, -10#, 6#)

    ' decimal
    m_asserter.AreEqual Numerics.Clamp(6#, -10#, 6#), 6#, "NumericsTest.TestClampFunctions", "Clamp(6.0, -10.0, 6.0) should be 6.0 but got " & Numerics.Clamp(6#, -10#, 6#)
End Sub

Private Sub TestClampErrorHandling()
    Dim errorRaised As Boolean

    ' Test ClampMinMaxInverted - all clamp types should throw ArgumentException when min > max
    ' byte
    errorRaised = False
    On Error GoTo ClampByteError
    Dim resultByte As Byte
    resultByte = Numerics.ClampByte(6, 6, 1)
    GoTo ClampByteSuccess
ClampByteError:
    errorRaised = True
    Resume ClampByteSuccess
ClampByteSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampByte should raise error when min > max but errorRaised = " & errorRaised

    ' short (using ClampInteger in VB6)
    errorRaised = False
    On Error GoTo ClampShortError
    Dim resultShort As Integer
    resultShort = Numerics.ClampInteger(-10, 6, -10)
    GoTo ClampShortSuccess
ClampShortError:
    errorRaised = True
    Resume ClampShortSuccess
ClampShortSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampInteger should raise error when min > max but errorRaised = " & errorRaised

    ' int (using ClampInteger in VB6)
    errorRaised = False
    On Error GoTo ClampIntError
    Dim resultInt As Integer
    resultInt = Numerics.ClampInteger(-10, 6, -10)
    GoTo ClampIntSuccess
ClampIntError:
    errorRaised = True
    Resume ClampIntSuccess
ClampIntSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampInteger should raise error when min > max but errorRaised = " & errorRaised

    ' long
    errorRaised = False
    On Error GoTo ClampLongError
    Dim resultLong As Long
    resultLong = Numerics.ClampLong(-10, 6, -10)
    GoTo ClampLongSuccess
ClampLongError:
    errorRaised = True
    Resume ClampLongSuccess
ClampLongSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampLong should raise error when min > max but errorRaised = " & errorRaised

    ' float
    errorRaised = False
    On Error GoTo ClampFloatError
    Dim resultFloat As Single
    resultFloat = Numerics.ClampSingle(-10#, 6#, -10#)
    GoTo ClampFloatSuccess
ClampFloatError:
    errorRaised = True
    Resume ClampFloatSuccess
ClampFloatSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampSingle should raise error when min > max but errorRaised = " & errorRaised

    ' double
    errorRaised = False
    On Error GoTo ClampDoubleError
    Dim resultDouble As Double
    resultDouble = Numerics.ClampDouble(-10#, 6#, -10#)
    GoTo ClampDoubleSuccess
ClampDoubleError:
    errorRaised = True
    Resume ClampDoubleSuccess
ClampDoubleSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampDouble should raise error when min > max but errorRaised = " & errorRaised

    ' decimal
    errorRaised = False
    On Error GoTo ClampDecimalError
    Dim resultDecimal As Variant
    resultDecimal = Numerics.Clamp(-10#, 6#, -10#)
    GoTo ClampDecimalSuccess
ClampDecimalError:
    errorRaised = True
    Resume ClampDecimalSuccess
ClampDecimalSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "Clamp should raise error when min > max but errorRaised = " & errorRaised

    ' Test NaN handling for Single - should raise error now
    errorRaised = False
    On Error Resume Next
    Dim nanResult As Single
    nanResult = 0# / 0#    ' Create NaN by 0/0 in VB6
    On Error GoTo 0
    On Error GoTo ClampSingleNaNError
    nanResult = Numerics.ClampSingle(nanResult, 0#, 5#)    ' Pass the NaN to ClampSingle - should raise error
    GoTo ClampSingleNaNSuccess
ClampSingleNaNError:
    errorRaised = True
    Resume ClampSingleNaNSuccess
ClampSingleNaNSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampSingle should raise error for NaN input but errorRaised = " & errorRaised

    ' Test NaN handling for Double - should raise error now
    errorRaised = False
    Dim nanResultDbl As Double
    On Error Resume Next
    nanResultDbl = 0# / 0#    ' Create NaN by 0/0 in VB6
    On Error GoTo 0
    On Error GoTo ClampDoubleNaNError
    nanResultDbl = Numerics.ClampDouble(nanResultDbl, 0#, 5#)    ' Pass the NaN to ClampDouble - should raise error
    GoTo ClampDoubleNaNSuccess
ClampDoubleNaNError:
    errorRaised = True
    Resume ClampDoubleNaNSuccess
ClampDoubleNaNSuccess:
    On Error GoTo 0
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "NumericsTest.TestClampErrorHandling", "ClampDouble should raise error for NaN input but errorRaised = " & errorRaised
End Sub
