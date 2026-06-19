VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BuiltinTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestArrayLen
    TestStringLen
    TestCollectionLen
    TestDictionaryLen
    TestArrayNonZeroLBound
    TestArrayListLen
    TestHashtableLen
    TestCSliceLen
    TestDynamicCount
    TestDynamicLength
    TestILengthLen
    TestNonIntegerError
    TestPyBin
    TestPyHex
    TestPyOct
End Sub

Private Sub TestArrayLen()
    Dim arr(0 To 4) As Long
    m_asserter.AreEqual 5, Builtin.PyLen(arr), "BuiltinTest.TestArrayLen", "zero-based: 0 To 4"

    Dim arr1(1 To 5) As Long
    m_asserter.AreEqual 5, Builtin.PyLen(arr1), "BuiltinTest.TestArrayLen", "one-based: 1 To 5"

    Dim arr0(0 To 0) As Long
    m_asserter.AreEqual 1, Builtin.PyLen(arr0), "BuiltinTest.TestArrayLen", "single element"
End Sub

Private Sub TestStringLen()
    m_asserter.AreEqual 0, Builtin.PyLen(""), "BuiltinTest.TestStringLen", "empty string"
    m_asserter.AreEqual 1, Builtin.PyLen("a"), "BuiltinTest.TestStringLen", "single char"
    m_asserter.AreEqual 5, Builtin.PyLen("hello"), "BuiltinTest.TestStringLen", "hello"
End Sub

Private Sub TestCollectionLen()
    Dim col As New Collection
    m_asserter.AreEqual 0, Builtin.PyLen(col), "BuiltinTest.TestCollectionLen", "empty collection"

    col.Add "a"
    col.Add "b"
    col.Add "c"
    m_asserter.AreEqual 3, Builtin.PyLen(col), "BuiltinTest.TestCollectionLen", "3 items"
End Sub

Private Sub TestDictionaryLen()
    Dim dict As Object
    Set dict = CreateObject("Scripting.Dictionary")
    m_asserter.AreEqual 0, Builtin.PyLen(dict), "BuiltinTest.TestDictionaryLen", "empty dictionary"

    dict.Add "a", 1
    dict.Add "b", 2
    m_asserter.AreEqual 2, Builtin.PyLen(dict), "BuiltinTest.TestDictionaryLen", "dictionary with 2 items"
End Sub

Private Sub TestArrayNonZeroLBound()
    Dim arr(3 To 7) As Long
    m_asserter.AreEqual 5, Builtin.PyLen(arr), "BuiltinTest.TestArrayNonZeroLBound", "3 To 7 = 5 elements"
End Sub

Private Sub TestArrayListLen()
    Dim list As Object
    Set list = CreateObject("System.Collections.ArrayList")
    m_asserter.AreEqual 0, Builtin.PyLen(list), "BuiltinTest.TestArrayListLen", "empty ArrayList"
    
    list.Add "a"
    list.Add "b"
    list.Add "c"
    m_asserter.AreEqual 3, Builtin.PyLen(list), "BuiltinTest.TestArrayListLen", "ArrayList with 3 items"
End Sub

Private Sub TestHashtableLen()
    Dim ht As Object
    Set ht = CreateObject("System.Collections.Hashtable")
    m_asserter.AreEqual 0, Builtin.PyLen(ht), "BuiltinTest.TestHashtableLen", "empty Hashtable"
    
    ht.Add "a", 1
    ht.Add "b", 2
    m_asserter.AreEqual 2, Builtin.PyLen(ht), "BuiltinTest.TestHashtableLen", "Hashtable with 2 items"
End Sub

Private Sub TestCSliceLen()
    Dim factory As New CSliceFactory
    Dim arr(5) As Long
    Dim slice As CSlice
    Set slice = factory.Of(arr)
    m_asserter.AreEqual slice.Length, Builtin.PyLen(slice), "BuiltinTest.TestCSliceLen", "CSlice from arr(5) — TypeName match to .Length"
End Sub

Private Sub TestDynamicCount()
    Dim obj As New DynamicCount
    m_asserter.AreEqual 42, Builtin.PyLen(obj), "BuiltinTest.TestDynamicCount", "DynamicCount default Count=42 — PyLenByName dynamic fallback"

    obj.Count = 7
    m_asserter.AreEqual 7, Builtin.PyLen(obj), "BuiltinTest.TestDynamicCount", "DynamicCount Count=7"
End Sub

Private Sub TestDynamicLength()
    Dim obj As New DynamicLength
    m_asserter.AreEqual 99, Builtin.PyLen(obj), "BuiltinTest.TestDynamicLength", "DynamicLength default Length=99 — PyLenByName dynamic fallback (no Count)"

    obj.Length = 15
    m_asserter.AreEqual 15, Builtin.PyLen(obj), "BuiltinTest.TestDynamicLength", "DynamicLength Length=15"
End Sub

Private Sub TestILengthLen()
    Dim container As New LenContainer
    m_asserter.AreEqual 0, Builtin.PyLen(container), "BuiltinTest.TestILengthLen", "LenContainer default Length=0"
    
    container.SetLength 42
    m_asserter.AreEqual 42, Builtin.PyLen(container), "BuiltinTest.TestILengthLen", "LenContainer Length=42"
End Sub

Private Sub TestNonIntegerError()
    Dim errorRaised As Boolean
    Dim result As Long

    ' Integer has no len
    errorRaised = False
    On Error GoTo IntegerError
    result = Builtin.PyLen(42)
    GoTo IntegerDone
IntegerError:
    errorRaised = True
    Resume IntegerDone
IntegerDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestNonIntegerError", "PyLen(Integer) should raise error"

    ' Double has no len
    errorRaised = False
    On Error GoTo DoubleError
    result = Builtin.PyLen(3.14)
    GoTo DoubleDone
DoubleError:
    errorRaised = True
    Resume DoubleDone
DoubleDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestNonIntegerError", "PyLen(Double) should raise error"

    ' Boolean has no len
    errorRaised = False
    On Error GoTo BoolError
    result = Builtin.PyLen(True)
    GoTo BoolDone
BoolError:
    errorRaised = True
    Resume BoolDone
BoolDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestNonIntegerError", "PyLen(Boolean) should raise error"

    ' Object without ILength has no len
    errorRaised = False
    On Error GoTo ObjectError
    Dim nonLenObj As Object
    Set nonLenObj = New Asserter
    result = Builtin.PyLen(nonLenObj)
    GoTo ObjectDone
ObjectError:
    errorRaised = True
    Resume ObjectDone
ObjectDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestNonIntegerError", "PyLen(non-ILength Object) should raise error"
End Sub

Private Sub TestPyBin()
    ' Zero
    m_asserter.AreEqual "0b0", Builtin.PyBin(0), "BuiltinTest.TestPyBin", "PyBin(0)"

    ' Positive: small values
    m_asserter.AreEqual "0b1", Builtin.PyBin(1), "BuiltinTest.TestPyBin", "PyBin(1)"
    m_asserter.AreEqual "0b111", Builtin.PyBin(7), "BuiltinTest.TestPyBin", "PyBin(7)"
    m_asserter.AreEqual "0b1000", Builtin.PyBin(8), "BuiltinTest.TestPyBin", "PyBin(8)"
    m_asserter.AreEqual "0b1010", Builtin.PyBin(10), "BuiltinTest.TestPyBin", "PyBin(10)"

    ' Positive: boundary values (powers of 2 minus 1, powers of 2)
    m_asserter.AreEqual "0b1111", Builtin.PyBin(15), "BuiltinTest.TestPyBin", "PyBin(15)"
    m_asserter.AreEqual "0b10000", Builtin.PyBin(16), "BuiltinTest.TestPyBin", "PyBin(16)"
    m_asserter.AreEqual "0b111111", Builtin.PyBin(63), "BuiltinTest.TestPyBin", "PyBin(63)"
    m_asserter.AreEqual "0b1000000", Builtin.PyBin(64), "BuiltinTest.TestPyBin", "PyBin(64)"

    ' Positive: byte boundaries
    m_asserter.AreEqual "0b11111111", Builtin.PyBin(255), "BuiltinTest.TestPyBin", "PyBin(255)"
    m_asserter.AreEqual "0b100000000", Builtin.PyBin(256), "BuiltinTest.TestPyBin", "PyBin(256)"

    ' Positive: larger values
    m_asserter.AreEqual "0b1111101000", Builtin.PyBin(1000), "BuiltinTest.TestPyBin", "PyBin(1000)"
    m_asserter.AreEqual "0b1111111111111111", Builtin.PyBin(65535), "BuiltinTest.TestPyBin", "PyBin(65535)"
    m_asserter.AreEqual "0b11000011010100000", Builtin.PyBin(100000), "BuiltinTest.TestPyBin", "PyBin(100000)"

    ' Positive: Long boundary values
    m_asserter.AreEqual "0b1000000000000000000000000000000", Builtin.PyBin(1073741824), "BuiltinTest.TestPyBin", "PyBin(1073741824)"
    m_asserter.AreEqual "0b1111111111111111111111111111111", Builtin.PyBin(2147483647), "BuiltinTest.TestPyBin", "PyBin(2147483647)"

    ' Negative: small values
    m_asserter.AreEqual "-0b1", Builtin.PyBin(-1), "BuiltinTest.TestPyBin", "PyBin(-1)"
    m_asserter.AreEqual "-0b111", Builtin.PyBin(-7), "BuiltinTest.TestPyBin", "PyBin(-7)"
    m_asserter.AreEqual "-0b1000", Builtin.PyBin(-8), "BuiltinTest.TestPyBin", "PyBin(-8)"
    m_asserter.AreEqual "-0b1010", Builtin.PyBin(-10), "BuiltinTest.TestPyBin", "PyBin(-10)"

    ' Negative: boundary values
    m_asserter.AreEqual "-0b1111", Builtin.PyBin(-15), "BuiltinTest.TestPyBin", "PyBin(-15)"
    m_asserter.AreEqual "-0b10000", Builtin.PyBin(-16), "BuiltinTest.TestPyBin", "PyBin(-16)"
    m_asserter.AreEqual "-0b111111", Builtin.PyBin(-63), "BuiltinTest.TestPyBin", "PyBin(-63)"
    m_asserter.AreEqual "-0b1000000", Builtin.PyBin(-64), "BuiltinTest.TestPyBin", "PyBin(-64)"

    ' Negative: byte boundaries
    m_asserter.AreEqual "-0b11111111", Builtin.PyBin(-255), "BuiltinTest.TestPyBin", "PyBin(-255)"
    m_asserter.AreEqual "-0b100000000", Builtin.PyBin(-256), "BuiltinTest.TestPyBin", "PyBin(-256)"

    ' Negative: larger values
    m_asserter.AreEqual "-0b1111101000", Builtin.PyBin(-1000), "BuiltinTest.TestPyBin", "PyBin(-1000)"
    m_asserter.AreEqual "-0b1111111111111111", Builtin.PyBin(-65535), "BuiltinTest.TestPyBin", "PyBin(-65535)"
    m_asserter.AreEqual "-0b11000011010100000", Builtin.PyBin(-100000), "BuiltinTest.TestPyBin", "PyBin(-100000)"

    ' Negative: Long boundary values
    m_asserter.AreEqual "-0b1000000000000000000000000000000", Builtin.PyBin(-1073741824), "BuiltinTest.TestPyBin", "PyBin(-1073741824)"
    m_asserter.AreEqual "-0b1111111111111111111111111111111", Builtin.PyBin(-2147483647), "BuiltinTest.TestPyBin", "PyBin(-2147483647)"

    ' Long.MinValue special case (&H80000000 = -2147483648)
    m_asserter.AreEqual "-0b10000000000000000000000000000000", Builtin.PyBin(&H80000000), _
        "BuiltinTest.TestPyBin", "PyBin(&H80000000) — Long.MinValue"

    ' Negative: non-integer argument raises error
    Dim errorRaised As Boolean
    Dim result As String
    errorRaised = False
    On Error GoTo PyBinDoubleErr
    result = Builtin.PyBin(3.14)
    GoTo PyBinDoubleDone
PyBinDoubleErr:
    errorRaised = True
    Resume PyBinDoubleDone
PyBinDoubleDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyBin", "PyBin(Double) should raise error"

    errorRaised = False
    On Error GoTo PyBinStringErr
    result = Builtin.PyBin("hello")
    GoTo PyBinStringDone
PyBinStringErr:
    errorRaised = True
    Resume PyBinStringDone
PyBinStringDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyBin", "PyBin(String) should raise error"
End Sub

Private Sub TestPyOct()
    Dim errorRaised As Boolean
    Dim result As String
    
    ' Zero
    m_asserter.AreEqual "0o0", Builtin.PyOct(0), "BuiltinTest.TestPyOct", "PyOct(0)"

    ' Positive: small values
    m_asserter.AreEqual "0o1", Builtin.PyOct(1), "BuiltinTest.TestPyOct", "PyOct(1)"
    m_asserter.AreEqual "0o7", Builtin.PyOct(7), "BuiltinTest.TestPyOct", "PyOct(7)"
    m_asserter.AreEqual "0o10", Builtin.PyOct(8), "BuiltinTest.TestPyOct", "PyOct(8)"
    m_asserter.AreEqual "0o12", Builtin.PyOct(10), "BuiltinTest.TestPyOct", "PyOct(10)"

    ' Positive: boundary values (powers of 8 minus 1, powers of 8)
    m_asserter.AreEqual "0o17", Builtin.PyOct(15), "BuiltinTest.TestPyOct", "PyOct(15)"
    m_asserter.AreEqual "0o20", Builtin.PyOct(16), "BuiltinTest.TestPyOct", "PyOct(16)"
    m_asserter.AreEqual "0o77", Builtin.PyOct(63), "BuiltinTest.TestPyOct", "PyOct(63)"
    m_asserter.AreEqual "0o100", Builtin.PyOct(64), "BuiltinTest.TestPyOct", "PyOct(64)"

    ' Positive: byte boundaries
    m_asserter.AreEqual "0o377", Builtin.PyOct(255), "BuiltinTest.TestPyOct", "PyOct(255)"
    m_asserter.AreEqual "0o400", Builtin.PyOct(256), "BuiltinTest.TestPyOct", "PyOct(256)"

    ' Positive: larger values
    m_asserter.AreEqual "0o1750", Builtin.PyOct(1000), "BuiltinTest.TestPyOct", "PyOct(1000)"
    m_asserter.AreEqual "0o177777", Builtin.PyOct(65535), "BuiltinTest.TestPyOct", "PyOct(65535)"
    m_asserter.AreEqual "0o303240", Builtin.PyOct(100000), "BuiltinTest.TestPyOct", "PyOct(100000)"

    ' Positive: Long boundary values
    m_asserter.AreEqual "0o10000000000", Builtin.PyOct(1073741824), "BuiltinTest.TestPyOct", "PyOct(1073741824)"
    m_asserter.AreEqual "0o17777777777", Builtin.PyOct(2147483647), "BuiltinTest.TestPyOct", "PyOct(2147483647)"

    ' Negative: small values
    m_asserter.AreEqual "-0o1", Builtin.PyOct(-1), "BuiltinTest.TestPyOct", "PyOct(-1)"
    m_asserter.AreEqual "-0o7", Builtin.PyOct(-7), "BuiltinTest.TestPyOct", "PyOct(-7)"
    m_asserter.AreEqual "-0o10", Builtin.PyOct(-8), "BuiltinTest.TestPyOct", "PyOct(-8)"
    m_asserter.AreEqual "-0o12", Builtin.PyOct(-10), "BuiltinTest.TestPyOct", "PyOct(-10)"

    ' Negative: boundary values
    m_asserter.AreEqual "-0o17", Builtin.PyOct(-15), "BuiltinTest.TestPyOct", "PyOct(-15)"
    m_asserter.AreEqual "-0o20", Builtin.PyOct(-16), "BuiltinTest.TestPyOct", "PyOct(-16)"
    m_asserter.AreEqual "-0o77", Builtin.PyOct(-63), "BuiltinTest.TestPyOct", "PyOct(-63)"
    m_asserter.AreEqual "-0o100", Builtin.PyOct(-64), "BuiltinTest.TestPyOct", "PyOct(-64)"

    ' Negative: byte boundaries
    m_asserter.AreEqual "-0o377", Builtin.PyOct(-255), "BuiltinTest.TestPyOct", "PyOct(-255)"
    m_asserter.AreEqual "-0o400", Builtin.PyOct(-256), "BuiltinTest.TestPyOct", "PyOct(-256)"

    ' Negative: larger values
    m_asserter.AreEqual "-0o1750", Builtin.PyOct(-1000), "BuiltinTest.TestPyOct", "PyOct(-1000)"
    m_asserter.AreEqual "-0o177777", Builtin.PyOct(-65535), "BuiltinTest.TestPyOct", "PyOct(-65535)"
    m_asserter.AreEqual "-0o303240", Builtin.PyOct(-100000), "BuiltinTest.TestPyOct", "PyOct(-100000)"

    ' Negative: Long boundary values
    m_asserter.AreEqual "-0o10000000000", Builtin.PyOct(-1073741824), "BuiltinTest.TestPyOct", "PyOct(-1073741824)"
    m_asserter.AreEqual "-0o17777777777", Builtin.PyOct(-2147483647), "BuiltinTest.TestPyOct", "PyOct(-2147483647)"

    ' Long.MinValue special case (&H80000000 = -2147483648)
    m_asserter.AreEqual "-0o20000000000", Builtin.PyOct(&H80000000), _
        "BuiltinTest.TestPyOct", "PyOct(&H80000000) — Long.MinValue"

    ' Negative: non-integer argument raises error
    errorRaised = False
    On Error GoTo PyOctDoubleErr
    result = Builtin.PyOct(3.14)
    GoTo PyOctDoubleDone
PyOctDoubleErr:
    errorRaised = True
    Resume PyOctDoubleDone
PyOctDoubleDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyOct", "PyOct(Double) should raise error"

    errorRaised = False
    On Error GoTo PyOctStringErr
    result = Builtin.PyOct("hello")
    GoTo PyOctStringDone
PyOctStringErr:
    errorRaised = True
    Resume PyOctStringDone
PyOctStringDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyOct", "PyOct(String) should raise error"
End Sub

Private Sub TestPyHex()
    ' Zero
    m_asserter.AreEqual "0x0", Builtin.PyHex(0), "BuiltinTest.TestPyHex", "PyHex(0)"

    ' Positive: small values
    m_asserter.AreEqual "0x1", Builtin.PyHex(1), "BuiltinTest.TestPyHex", "PyHex(1)"
    m_asserter.AreEqual "0xa", Builtin.PyHex(10), "BuiltinTest.TestPyHex", "PyHex(10)"
    m_asserter.AreEqual "0xf", Builtin.PyHex(15), "BuiltinTest.TestPyHex", "PyHex(15)"
    m_asserter.AreEqual "0x10", Builtin.PyHex(16), "BuiltinTest.TestPyHex", "PyHex(16)"
    m_asserter.AreEqual "0x2a", Builtin.PyHex(42), "BuiltinTest.TestPyHex", "PyHex(42)"

    ' Positive: byte boundaries
    m_asserter.AreEqual "0xff", Builtin.PyHex(255), "BuiltinTest.TestPyHex", "PyHex(255)"
    m_asserter.AreEqual "0x100", Builtin.PyHex(256), "BuiltinTest.TestPyHex", "PyHex(256)"

    ' Positive: larger values
    m_asserter.AreEqual "0x3e8", Builtin.PyHex(1000), "BuiltinTest.TestPyHex", "PyHex(1000)"
    m_asserter.AreEqual "0xffff", Builtin.PyHex(65535), "BuiltinTest.TestPyHex", "PyHex(65535)"
    m_asserter.AreEqual "0x186a0", Builtin.PyHex(100000), "BuiltinTest.TestPyHex", "PyHex(100000)"

    ' Positive: Long boundary values
    m_asserter.AreEqual "0x40000000", Builtin.PyHex(1073741824), "BuiltinTest.TestPyHex", "PyHex(1073741824)"
    m_asserter.AreEqual "0x7fffffff", Builtin.PyHex(2147483647), "BuiltinTest.TestPyHex", "PyHex(2147483647)"

    ' Negative: small values
    m_asserter.AreEqual "-0x1", Builtin.PyHex(-1), "BuiltinTest.TestPyHex", "PyHex(-1)"
    m_asserter.AreEqual "-0xa", Builtin.PyHex(-10), "BuiltinTest.TestPyHex", "PyHex(-10)"
    m_asserter.AreEqual "-0xf", Builtin.PyHex(-15), "BuiltinTest.TestPyHex", "PyHex(-15)"
    m_asserter.AreEqual "-0x10", Builtin.PyHex(-16), "BuiltinTest.TestPyHex", "PyHex(-16)"
    m_asserter.AreEqual "-0x2a", Builtin.PyHex(-42), "BuiltinTest.TestPyHex", "PyHex(-42)"

    ' Negative: byte boundaries
    m_asserter.AreEqual "-0xff", Builtin.PyHex(-255), "BuiltinTest.TestPyHex", "PyHex(-255)"
    m_asserter.AreEqual "-0x100", Builtin.PyHex(-256), "BuiltinTest.TestPyHex", "PyHex(-256)"

    ' Negative: larger values
    m_asserter.AreEqual "-0x3e8", Builtin.PyHex(-1000), "BuiltinTest.TestPyHex", "PyHex(-1000)"
    m_asserter.AreEqual "-0xffff", Builtin.PyHex(-65535), "BuiltinTest.TestPyHex", "PyHex(-65535)"
    m_asserter.AreEqual "-0x186a0", Builtin.PyHex(-100000), "BuiltinTest.TestPyHex", "PyHex(-100000)"

    ' Negative: Long boundary values
    m_asserter.AreEqual "-0x40000000", Builtin.PyHex(-1073741824), "BuiltinTest.TestPyHex", "PyHex(-1073741824)"
    m_asserter.AreEqual "-0x7fffffff", Builtin.PyHex(-2147483647), "BuiltinTest.TestPyHex", "PyHex(-2147483647)"

    ' Long.MinValue special case (&H80000000 = -2147483648)
    m_asserter.AreEqual "-0x80000000", Builtin.PyHex(&H80000000), _
        "BuiltinTest.TestPyHex", "PyHex(&H80000000) — Long.MinValue"

    ' Non-integer argument raises error
    Dim errorRaised As Boolean
    Dim result As String

    errorRaised = False
    On Error GoTo PyHexDoubleErr
    result = Builtin.PyHex(3.14)
    GoTo PyHexDoubleDone
PyHexDoubleErr:
    errorRaised = True
    Resume PyHexDoubleDone
PyHexDoubleDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyHex", "PyHex(Double) should raise error"

    errorRaised = False
    On Error GoTo PyHexStringErr
    result = Builtin.PyHex("hello")
    GoTo PyHexStringDone
PyHexStringErr:
    errorRaised = True
    Resume PyHexStringDone
PyHexStringDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyHex", "PyHex(String) should raise error"
End Sub
