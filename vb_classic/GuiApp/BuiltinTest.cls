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
    TestPyRange
    TestPyInt
    TestPyIn
    TestSequenceMethods
    TestPyTuple
    TestVBArray
    TestLetSetString
    TestLetSetLong
    TestLetSetBoolean
    TestLetSetEmpty
    TestLetSetNull
    TestLetSetNothing
    TestLetSetObject
    TestLetSetArray
    TestLetSetFunctionResult
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

Private Sub TestPyRange()
    Dim r As RangeIterator
    Dim seq As ISequence
    
    ' ─── Single-arg: PyRange(stop) → range(0, stop, 1) ───
    Set r = PyRange(10)
    m_asserter.AreEqual 0, r.Start, "BuiltinTest.TestPyRange", "range(10).Start=0"
    m_asserter.AreEqual 10, r.[Stop], "BuiltinTest.TestPyRange", "range(10).Stop=10"
    m_asserter.AreEqual 1, r.Step, "BuiltinTest.TestPyRange", "range(10).Step=1"
    m_asserter.AreEqual 10, PyLen(r), "BuiltinTest.TestPyRange", "len(range(10))=10"
    Set seq = r
    m_asserter.AreEqual 0, seq.GetItem(0), "BuiltinTest.TestPyRange", "range(10)[0]=0"
    m_asserter.AreEqual 9, seq.GetItem(9), "BuiltinTest.TestPyRange", "range(10)[9]=9"
    
    ' ─── Two-arg: PyRange(start, stop) → range(start, stop, 1) ───
    Set r = PyRange(1, 11)
    m_asserter.AreEqual 10, PyLen(r), "BuiltinTest.TestPyRange", "len(range(1,11))=10"
    Set seq = r
    m_asserter.AreEqual 1, seq.GetItem(0), "BuiltinTest.TestPyRange", "range(1,11)[0]=1"
    m_asserter.AreEqual 10, seq.GetItem(9), "BuiltinTest.TestPyRange", "range(1,11)[9]=10"
    
    ' ─── Three-arg positive step ───
    ' range(0, 30, 5) → [0, 5, 10, 15, 20, 25]
    Set r = PyRange(0, 30, 5)
    m_asserter.AreEqual 6, PyLen(r), "BuiltinTest.TestPyRange", "len(range(0,30,5))=6"
    Set seq = r
    m_asserter.AreEqual 0, seq.GetItem(0), "BuiltinTest.TestPyRange", "[0]"
    m_asserter.AreEqual 25, seq.GetItem(5), "BuiltinTest.TestPyRange", "[5]"
    
    ' range(0, 10, 3) → [0, 3, 6, 9]
    Set r = PyRange(0, 10, 3)
    m_asserter.AreEqual 4, PyLen(r), "BuiltinTest.TestPyRange", "len(range(0,10,3))=4"
    Set seq = r
    m_asserter.AreEqual 0, seq.GetItem(0), "BuiltinTest.TestPyRange", "[0]"
    m_asserter.AreEqual 3, seq.GetItem(1), "BuiltinTest.TestPyRange", "[1]"
    m_asserter.AreEqual 9, seq.GetItem(3), "BuiltinTest.TestPyRange", "[3]"
    
    ' ─── Three-arg negative step ───
    ' range(0, -10, -1) → [0, -1, -2, ..., -9]
    Set r = PyRange(0, -10, -1)
    m_asserter.AreEqual 10, PyLen(r), "BuiltinTest.TestPyRange", "len(range(0,-10,-1))=10"
    Set seq = r
    m_asserter.AreEqual 0, seq.GetItem(0), "BuiltinTest.TestPyRange", "[0]"
    m_asserter.AreEqual -5, seq.GetItem(5), "BuiltinTest.TestPyRange", "[5]"
    m_asserter.AreEqual -9, seq.GetItem(9), "BuiltinTest.TestPyRange", "[9]"
    
    ' ─── Empty ranges ───
    Set r = PyRange(0)
    m_asserter.AreEqual 0, PyLen(r), "BuiltinTest.TestPyRange", "len(range(0))=0"
    Set r = PyRange(1, 0)
    m_asserter.AreEqual 0, PyLen(r), "BuiltinTest.TestPyRange", "len(range(1,0))=0"
    
    ' ─── Negative indices ───
    Set r = PyRange(0, 20, 2)
    Set seq = r
    m_asserter.AreEqual 18, seq.GetItem(-1), "BuiltinTest.TestPyRange", "range(0,20,2)[-1]=18"
    m_asserter.AreEqual 16, seq.GetItem(-2), "BuiltinTest.TestPyRange", "range(0,20,2)[-2]=16"
    
    ' ─── Containment test (constant-time) ───
    m_asserter.IsFalse r.Contains(11), "BuiltinTest.TestPyRange", "11 not in range(0,20,2)"
    m_asserter.IsTrue r.Contains(10), "BuiltinTest.TestPyRange", "10 in range(0,20,2)"
    m_asserter.IsFalse r.Contains(-2), "BuiltinTest.TestPyRange", "-2 not in range(0,20,2)"
    
    ' Negative step containment
    Set r = PyRange(0, -10, -1)
    m_asserter.IsTrue r.Contains(-5), "BuiltinTest.TestPyRange", "-5 in range(0,-10,-1)"
    m_asserter.IsFalse r.Contains(5), "BuiltinTest.TestPyRange", "5 not in range(0,-10,-1)"
    m_asserter.IsFalse r.Contains(-10), "BuiltinTest.TestPyRange", "-10 not in range(0,-10,-1)"
    
    ' ─── Index lookup ───
    Set r = PyRange(0, 20, 2)
    m_asserter.AreEqual 5, r.Index(10), "BuiltinTest.TestPyRange", "range(0,20,2).index(10)=5"
    m_asserter.AreEqual 0, r.Index(0), "BuiltinTest.TestPyRange", "range(0,20,2).index(0)=0"
    
    ' ─── Step = 0 raises error ───
    Dim errorRaised As Boolean
    Set r = New RangeIterator
    errorRaised = False
    On Error GoTo StepZeroErr
    r.Init 0, 10, 0
    GoTo StepZeroDone
StepZeroErr:
    errorRaised = True
    Resume StepZeroDone
StepZeroDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyRange", "range(0,10,0) step zero raises error"
End Sub

Private Sub TestPyInt()
    ' ─── No arg → 0 ───
    m_asserter.AreEqual 0, PyInt(), "BuiltinTest.TestPyInt", "PyInt()=0"
    
    ' ─── Integer types pass through ───
    m_asserter.AreEqual 0, PyInt(0), "BuiltinTest.TestPyInt", "PyInt(0)=0"
    m_asserter.AreEqual 42, PyInt(42), "BuiltinTest.TestPyInt", "PyInt(42)=42"
    m_asserter.AreEqual -7, PyInt(-7), "BuiltinTest.TestPyInt", "PyInt(-7)=-7"
    
    ' ─── Float truncation towards zero ───
    m_asserter.AreEqual 123, PyInt(123.45), "BuiltinTest.TestPyInt", "PyInt(123.45)=123"
    m_asserter.AreEqual -3, PyInt(-3.14), "BuiltinTest.TestPyInt", "PyInt(-3.14)=-3"
    m_asserter.AreEqual 0, PyInt(0.99), "BuiltinTest.TestPyInt", "PyInt(0.99)=0"
    m_asserter.AreEqual 0, PyInt(-0.5), "BuiltinTest.TestPyInt", "PyInt(-0.5)=0"
    
    ' ─── String parsing (decimal) ───
    m_asserter.AreEqual 123, PyInt("123"), "BuiltinTest.TestPyInt", "PyInt(\"123\")=123"
    m_asserter.AreEqual -12345, PyInt("  -12345"), "BuiltinTest.TestPyInt", _
        "PyInt(\"  -12345\")=-12345"
    m_asserter.AreEqual 0, PyInt("0"), "BuiltinTest.TestPyInt", "PyInt(\"0\")=0"
    m_asserter.AreEqual 10, PyInt("+10"), "BuiltinTest.TestPyInt", "PyInt(\"+10\")=10"
    
    ' ─── String parsing with explicit base ───
    m_asserter.AreEqual 64206, PyInt("FACE", 16), "BuiltinTest.TestPyInt", _
        "PyInt(\"FACE\", 16)=64206"
    m_asserter.AreEqual 115, PyInt("01110011", 2), "BuiltinTest.TestPyInt", _
        "PyInt(\"01110011\", 2)=115"
    m_asserter.AreEqual 511, PyInt("777", 8), "BuiltinTest.TestPyInt", _
        "PyInt(\"777\", 8)=511"
    m_asserter.AreEqual 255, PyInt("FF", 16), "BuiltinTest.TestPyInt", _
        "PyInt(\"FF\", 16)=255"
    m_asserter.AreEqual 35, PyInt("z", 36), "BuiltinTest.TestPyInt", _
        "PyInt(\"z\", 36)=35"
    
    ' ─── String parsing with prefix (base=0 auto-detect) ───
    m_asserter.AreEqual 255, PyInt("0xFF", 0), "BuiltinTest.TestPyInt", _
        "PyInt(\"0xFF\", 0)=255"
    m_asserter.AreEqual 255, PyInt("0xFF", 16), "BuiltinTest.TestPyInt", _
        "PyInt(\"0xFF\", 16)=255"
    m_asserter.AreEqual 10, PyInt("0b1010", 0), "BuiltinTest.TestPyInt", _
        "PyInt(\"0b1010\", 0)=10"
    m_asserter.AreEqual 63, PyInt("0o77", 0), "BuiltinTest.TestPyInt", _
        "PyInt(\"0o77\", 0)=63"
    
    ' ─── Edge cases ───
    ' Negative hex
    m_asserter.AreEqual -255, PyInt("-0xFF", 0), "BuiltinTest.TestPyInt", _
        "PyInt(\"-0xFF\", 0)=-255"
    ' Zero with sign
    m_asserter.AreEqual 0, PyInt("-0"), "BuiltinTest.TestPyInt", "PyInt(\"-0\")=0"
    
    ' ─── Error: non-integer types ───
    Dim errorRaised As Boolean
    
    errorRaised = False
    On Error GoTo PyIntBoolErr
    PyInt True
    GoTo PyIntBoolDone
PyIntBoolErr:
    errorRaised = True
    Resume PyIntBoolDone
PyIntBoolDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyInt", "PyInt(Boolean) should raise error"
    
    ' ─── Error: invalid digit for base ───
    errorRaised = False
    On Error GoTo PyIntDigitErr
    PyInt "FF", 10
    GoTo PyIntDigitDone
PyIntDigitErr:
    errorRaised = True
    Resume PyIntDigitDone
PyIntDigitDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyInt", "PyInt(\"FF\", 10) should raise error"
    
    ' ─── Error: empty string ───
    errorRaised = False
    On Error GoTo PyIntEmptyErr
    PyInt ""
    GoTo PyIntEmptyDone
PyIntEmptyErr:
    errorRaised = True
    Resume PyIntEmptyDone
PyIntEmptyDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyInt", "PyInt(\"\") should raise error"
    
    ' ─── Base 0 with no prefix → default base 10 ───
    m_asserter.AreEqual 10, PyInt("10", 0), "BuiltinTest.TestPyInt", _
        "PyInt(\"10\", 0)=10 (no prefix → base 10 default)"
End Sub

Private Sub TestPyIn()
    Dim r As RangeIterator
    
    ' ─── IContains fast path (RangeIterator) ───
    Set r = PyRange(0, 20, 2)
    m_asserter.IsTrue PyIn(10, r), "BuiltinTest.TestPyIn", "10 in range(0,20,2)"
    m_asserter.IsFalse PyIn(11, r), "BuiltinTest.TestPyIn", "11 not in range(0,20,2)"
    m_asserter.IsFalse PyIn(-2, r), "BuiltinTest.TestPyIn", "-2 not in range(0,20,2)"
    
    ' Negative step
    Set r = PyRange(0, -10, -1)
    m_asserter.IsTrue PyIn(-5, r), "BuiltinTest.TestPyIn", "-5 in range(0,-10,-1)"
    m_asserter.IsFalse PyIn(5, r), "BuiltinTest.TestPyIn", "5 not in range(0,-10,-1)"
    
    ' ─── Iteration fallback (array) ───
    Dim arr(0 To 3) As Long
    arr(0) = 10: arr(1) = 20: arr(2) = 30: arr(3) = 40
    m_asserter.IsTrue PyIn(20, arr), "BuiltinTest.TestPyIn", "20 in array"
    m_asserter.IsFalse PyIn(99, arr), "BuiltinTest.TestPyIn", "99 not in array"
    
    ' ─── String → substring matching (not character iteration) ───
    m_asserter.IsTrue PyIn("e", "hello"), "BuiltinTest.TestPyIn", "'e' in 'hello'"
    m_asserter.IsTrue PyIn("ell", "hello"), "BuiltinTest.TestPyIn", "'ell' in 'hello'"
    m_asserter.IsFalse PyIn("z", "hello"), "BuiltinTest.TestPyIn", "'z' not in 'hello'"
    m_asserter.IsTrue PyIn("", "abc"), "BuiltinTest.TestPyIn", _
        "'' in 'abc' (empty string is always a substring)"
    m_asserter.IsTrue PyIn("", ""), "BuiltinTest.TestPyIn", "'' in ''"
    
    ' Non-string item in string → raises error
    Dim errorRaised As Boolean
    errorRaised = False
    On Error GoTo PyInStrItemErr
    PyIn 123, "abc"
    GoTo PyInStrItemDone
PyInStrItemErr:
    errorRaised = True
    Resume PyInStrItemDone
PyInStrItemDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyIn", _
        "PyIn(123, 'abc') should raise TypeError"
    
    ' ─── Iteration fallback (Collection) ───
    Dim col As New Collection
    col.Add "alpha"
    col.Add "bravo"
    m_asserter.IsTrue PyIn("alpha", col), "BuiltinTest.TestPyIn", "'alpha' in Collection"
    m_asserter.IsFalse PyIn("zulu", col), "BuiltinTest.TestPyIn", "'zulu' not in Collection"
    
    ' ─── TypeName fast path: Scripting.Dictionary (PyInByTypeName → .Exists) ───
    Dim dict As New Scripting.Dictionary
    dict.Add "key1", 42
    dict.Add "key2", 99
    m_asserter.IsTrue PyIn("key1", dict), "BuiltinTest.TestPyIn", "'key1' in Dictionary"
    m_asserter.IsFalse PyIn("nonexistent", dict), "BuiltinTest.TestPyIn", _
        "'nonexistent' not in Dictionary"
    
    ' Dictionary lookup values (PyIn checks keys, not values, matching Python's `in`)
    dict.Add "answer", 42
    m_asserter.IsFalse PyIn(42, dict), "BuiltinTest.TestPyIn", _
        "42 not in Dictionary (PyIn checks keys, not values)"
    
    ' ─── Empty container ───
    Set r = PyRange(0)
    m_asserter.IsFalse PyIn(0, r), "BuiltinTest.TestPyIn", "0 not in empty range"
End Sub

Private Sub TestSequenceMethods()
    Dim seq As ISequence
    Dim r As RangeIterator
    
    ' ─── Count on RangeIterator ───
    Set r = PyRange(0, 20, 2)
    Set seq = r
    m_asserter.AreEqual 1, seq.Count(10), "BuiltinTest.TestSequenceMethods", "range(0,20,2).count(10)=1"
    m_asserter.AreEqual 0, seq.Count(11), "BuiltinTest.TestSequenceMethods", "range(0,20,2).count(11)=0"
    m_asserter.AreEqual 1, seq.Count(0), "BuiltinTest.TestSequenceMethods", "range(0,20,2).count(0)=1"
    
    ' ─── Index on RangeIterator (unbounded) ───
    m_asserter.AreEqual 5, seq.Index(10), "BuiltinTest.TestSequenceMethods", "range(0,20,2).index(10)=5"
    m_asserter.AreEqual 0, seq.Index(0), "BuiltinTest.TestSequenceMethods", "range(0,20,2).index(0)=0"
    
    ' ─── Index with start bound ───
    m_asserter.AreEqual 5, seq.Index(10, 0), "BuiltinTest.TestSequenceMethods", "range(0,20,2).index(10, 0)=5"
    m_asserter.AreEqual 5, seq.Index(10, 5), "BuiltinTest.TestSequenceMethods", "range(0,20,2).index(10, 5)=5"
    
    ' ─── Index with start AND stop bound ───
    m_asserter.AreEqual 2, seq.Index(4, 0, 3), "BuiltinTest.TestSequenceMethods", "range(0,20,2).index(4, 0, 3)=2"
    
    ' ─── Index error: value not in range ───
    Dim errorRaised As Boolean
    errorRaised = False
    On Error GoTo IndexNotFoundErr
    seq.Index 99
    GoTo IndexNotFoundDone
IndexNotFoundErr:
    errorRaised = True
    Resume IndexNotFoundDone
IndexNotFoundDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestSequenceMethods", "range.index(99) should raise"
    
    ' ─── Index error: value outside start/stop bounds ───
    errorRaised = False
    On Error GoTo IndexBoundedErr
    seq.Index 10, 6, 10
    GoTo IndexBoundedDone
IndexBoundedErr:
    errorRaised = True
    Resume IndexBoundedDone
IndexBoundedDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestSequenceMethods", "range.index(10,6,10) should raise"
End Sub

Private Sub TestPyTuple()
    Dim t As Tuple
    Dim t2 As Tuple
    Dim seq As ISequence
    Dim errorRaised As Boolean
    
    ' ─── PyTuple() → empty tuple ───
    Set t = PyTuple()
    m_asserter.AreEqual 0, t.Length, "BuiltinTest.TestPyTuple", "PyTuple().Length=0"
    m_asserter.AreEqual 0, PyLen(t), "BuiltinTest.TestPyTuple", "len(PyTuple())=0"
    
    ' ─── PyTuple(Array(1, 2, 3, 4)) ───
    Dim arr(0 To 3) As Long
    arr(0) = 10: arr(1) = 20: arr(2) = 30: arr(3) = 40
    Set t = PyTuple(arr)
    m_asserter.AreEqual 4, t.Length, "BuiltinTest.TestPyTuple", "tuple from array: Length=4"
    m_asserter.AreEqual 10, t.GetItem(0), "BuiltinTest.TestPyTuple", "tuple[0]=10"
    m_asserter.AreEqual 20, t.GetItem(1), "BuiltinTest.TestPyTuple", "tuple[1]=20"
    m_asserter.AreEqual 40, t.GetItem(3), "BuiltinTest.TestPyTuple", "tuple[3]=40"
    
    ' ─── PyTuple(array) → ISequence ───
    Set seq = t
    m_asserter.AreEqual 4, seq.Length, "BuiltinTest.TestPyTuple", "ISequence length=4"
    m_asserter.AreEqual 10, seq.GetItem(0), "BuiltinTest.TestPyTuple", "ISequence[0]=10"
    m_asserter.AreEqual 30, seq.GetItem(2), "BuiltinTest.TestPyTuple", "ISequence[2]=30"
    
    ' ─── Default Item property via seq index ───
    m_asserter.AreEqual 10, t.Item(0), "BuiltinTest.TestPyTuple", "t.Item(0)=10"
    m_asserter.AreEqual 20, t.Item(1), "BuiltinTest.TestPyTuple", "t.Item(1)=20"
    
    ' ─── Negative indexing ───
    m_asserter.AreEqual 40, t.Item(-1), "BuiltinTest.TestPyTuple", "t.Item(-1)=40 (last)"
    m_asserter.AreEqual 30, t.Item(-2), "BuiltinTest.TestPyTuple", "t.Item(-2)=30"
    m_asserter.AreEqual 10, t.Item(-4), "BuiltinTest.TestPyTuple", "t.Item(-4)=10 (first)"
    
    ' ─── Index out of range raises ───
    errorRaised = False
    On Error GoTo TupOobErr
    t.Item 100
    GoTo TupOobDone
TupOobErr:
    errorRaised = True
    Resume TupOobDone
TupOobDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyTuple", "t.Item(100) should raise"
    
    ' Negative index too far
    errorRaised = False
    On Error GoTo TupNegErr
    t.Item -10
    GoTo TupNegDone
TupNegErr:
    errorRaised = True
    Resume TupNegDone
TupNegDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyTuple", "t.Item(-10) should raise"
    
    ' ─── PyTuple(tuple) → same object ───
    Set t2 = t      ' same object by reference
    Set t2 = PyTuple(t)
    m_asserter.IsTrue (t2 Is t), "BuiltinTest.TestPyTuple", "PyTuple(tuple) returns same object"
    
    ' ─── Immutability: tuple not affected by source changes ───
    Dim mutArr(0 To 2) As Long
    mutArr(0) = 1: mutArr(1) = 2: mutArr(2) = 3
    Set t = PyTuple(mutArr)
    mutArr(0) = 99                      ' modify source
    m_asserter.AreEqual 1, t.Item(0), "BuiltinTest.TestPyTuple", "tuple[0]=1 after source mutation (immutable)"
    
    ' ─── PyTuple("abc") → ('a', 'b', 'c') ───
    Set t = PyTuple("abc")
    m_asserter.AreEqual 3, t.Length, "BuiltinTest.TestPyTuple", "tuple('abc').Length=3"
    m_asserter.AreEqual "a", t.GetItem(0), "BuiltinTest.TestPyTuple", "tuple('abc')[0]='a'"
    m_asserter.AreEqual "b", t.GetItem(1), "BuiltinTest.TestPyTuple", "tuple('abc')[1]='b'"
    m_asserter.AreEqual "c", t.GetItem(2), "BuiltinTest.TestPyTuple", "tuple('abc')[2]='c'"
    
    ' ─── PyTuple("") → empty tuple ───
    Set t = PyTuple("")
    m_asserter.AreEqual 0, t.Length, "BuiltinTest.TestPyTuple", "tuple('').Length=0"
    
    ' ─── PyTuple(range) → collect iterable items ───
    Dim r As RangeIterator
    Set r = PyRange(5)
    Set t = PyTuple(r)
    m_asserter.AreEqual 5, t.Length, "BuiltinTest.TestPyTuple", "tuple(range(5)).Length=5"
    m_asserter.AreEqual 0, t.Item(0), "BuiltinTest.TestPyTuple", "tuple(range(5))[0]=0"
    m_asserter.AreEqual 4, t.Item(4), "BuiltinTest.TestPyTuple", "tuple(range(5))[4]=4"
    
    ' ─── Count(value) ───
    Set t = PyTuple(Array(1, 2, 2, 3, 2, 4))
    m_asserter.AreEqual 2, t.Count(2), "BuiltinTest.TestPyTuple", "tuple.count(2)=2"
    m_asserter.AreEqual 1, t.Count(1), "BuiltinTest.TestPyTuple", "tuple.count(1)=1"
    m_asserter.AreEqual 0, t.Count(99), "BuiltinTest.TestPyTuple", "tuple.count(99)=0"
    
    ' ─── IndexOf(value) ───
    m_asserter.AreEqual 0, t.Index(1), "BuiltinTest.TestPyTuple", "tuple.index(1)=0"
    m_asserter.AreEqual 1, t.Index(2), "BuiltinTest.TestPyTuple", "tuple.index(2)=1 (first occurrence)"
    m_asserter.AreEqual 5, t.Index(4), "BuiltinTest.TestPyTuple", "tuple.index(4)=5"
    
    ' IndexOf not found raises
    errorRaised = False
    On Error GoTo TupIdxErr
    t.Index 99
    GoTo TupIdxDone
TupIdxErr:
    errorRaised = True
    Resume TupIdxDone
TupIdxDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestPyTuple", "tuple.index(99) should raise"
    
    ' ─── IndexOf with start and stop bounds ───
    m_asserter.AreEqual 3, t.Index(2, 2), "BuiltinTest.TestPyTuple", "tuple.index(2, 2)=3 (skip first 2)"
    m_asserter.AreEqual 1, t.Index(2, 0, 3), "BuiltinTest.TestPyTuple", "tuple.index(2, 0, 3)=1"
    
    ' ─── Contains via IContains (PyIn) ───
    Dim evens(0 To 4) As Long
    evens(0) = 0: evens(1) = 2: evens(2) = 4: evens(3) = 6: evens(4) = 8
    Set t = PyTuple(evens)
    m_asserter.IsTrue PyIn(4, t), "BuiltinTest.TestPyTuple", "4 in tuple"
    m_asserter.IsFalse PyIn(5, t), "BuiltinTest.TestPyTuple", "5 not in tuple"
    m_asserter.IsTrue PyIn(0, t), "BuiltinTest.TestPyTuple", "0 in tuple"
    
    ' ─── Len via ILength ───
    m_asserter.AreEqual 5, PyLen(t), "BuiltinTest.TestPyTuple", "len(tuple)=5"
    
    ' ─── Iteration via PyAll / PyAny ───
    Dim zeros(0 To 3) As Long
    zeros(0) = 0: zeros(1) = 0: zeros(2) = 0: zeros(3) = 0
    Set t = PyTuple(zeros)
    m_asserter.IsFalse PyAll(t), "BuiltinTest.TestPyTuple", "all(tuple of zeros)=False"
    m_asserter.IsFalse PyAny(t), "BuiltinTest.TestPyTuple", "any(tuple of zeros)=False"
    
    Set t = PyTuple(Array(0, 1, 0))
    m_asserter.IsFalse PyAll(t), "BuiltinTest.TestPyTuple", "all(tuple(0,1,0))=False"
    m_asserter.IsTrue PyAny(t), "BuiltinTest.TestPyTuple", "any(tuple(0,1,0))=True"
    
    ' ─── Tuple from Collection ───
    Dim col As New Collection
    col.Add "x": col.Add "y": col.Add "z"
    Set t = PyTuple(col)
    m_asserter.AreEqual 3, t.Length, "BuiltinTest.TestPyTuple", "tuple from collection: Length=3"
    m_asserter.AreEqual "x", t.Item(0), "BuiltinTest.TestPyTuple", "tuple[0]='x'"
    m_asserter.AreEqual "z", t.Item(2), "BuiltinTest.TestPyTuple", "tuple[2]='z'"
End Sub

Private Sub TestVBArray()
    Dim v As VBArray
    Dim v2 As VBArray
    Dim v3 As VBArray
    Dim seq As ISequence
    Dim arr(0 To 3) As Long
    Dim errorRaised As Boolean
    
    ' ─── VBArray() → empty ───
    Set v = PyVBArray()
    m_asserter.AreEqual 0, v.Length, "BuiltinTest.TestVBArray", "VBArray().Length=0"
    m_asserter.AreEqual 0, PyLen(v), "BuiltinTest.TestVBArray", "len(VBArray())=0"
    
    ' ─── VBArray(Array(10, 20, 30, 40)) ───
    arr(0) = 10: arr(1) = 20: arr(2) = 30: arr(3) = 40
    Set v = PyVBArray(arr)
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "VBArray from array: Length=4"
    m_asserter.AreEqual 10, v.Item(0), "BuiltinTest.TestVBArray", "v[0]=10"
    m_asserter.AreEqual 40, v.Item(3), "BuiltinTest.TestVBArray", "v[3]=40"
    
    ' ─── ISequence interface ───
    Set seq = v
    m_asserter.AreEqual 4, seq.Length, "BuiltinTest.TestVBArray", "ISequence length=4"
    m_asserter.AreEqual 20, seq.GetItem(1), "BuiltinTest.TestVBArray", "ISequence[1]=20"
    
    ' ─── Default Item property ───
    m_asserter.AreEqual 10, v.Item(0), "BuiltinTest.TestVBArray", "v.Item(0)=10"
    
    ' ─── Negative indexing ───
    m_asserter.AreEqual 40, v.Item(-1), "BuiltinTest.TestVBArray", "v.Item(-1)=40 (last)"
    m_asserter.AreEqual 30, v.Item(-2), "BuiltinTest.TestVBArray", "v.Item(-2)=30"
    m_asserter.AreEqual 10, v.Item(-4), "BuiltinTest.TestVBArray", "v.Item(-4)=10 (first)"
    
    ' ─── Set Item (mutation) ───
    v.Item(1) = 99
    m_asserter.AreEqual 99, v.Item(1), "BuiltinTest.TestVBArray", "v[1]=99 after set"
    
    ' ─── Index out of range raises ───
    errorRaised = False
    On Error GoTo VBOobErr
    v.Item 100
    GoTo VBOobDone
VBOobErr:
    errorRaised = True
    Resume VBOobDone
VBOobDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestVBArray", "v.Item(100) should raise"
    
    ' ─── Append ───
    Set v = PyVBArray(Array(1, 2))
    v.Append 3
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "append: Length=3"
    m_asserter.AreEqual 3, v.Item(2), "BuiltinTest.TestVBArray", "append: v[2]=3"
    
    v.Append 4
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "append: Length=4"
    m_asserter.AreEqual 4, v.Item(3), "BuiltinTest.TestVBArray", "append: v[3]=4"
    
    ' ─── Clear ───
    v.Clear
    m_asserter.AreEqual 0, v.Length, "BuiltinTest.TestVBArray", "clear: Length=0"
    
    ' ─── Copy ───
    Set v = PyVBArray(Array(1, 2, 3))
    Set v2 = v.Copy()
    m_asserter.AreEqual 3, v2.Length, "BuiltinTest.TestVBArray", "copy: Length=3"
    m_asserter.AreEqual 1, v2.Item(0), "BuiltinTest.TestVBArray", "copy: [0]=1"
    m_asserter.AreEqual 3, v2.Item(2), "BuiltinTest.TestVBArray", "copy: [2]=3"
    
    ' Copy is independent
    v2.Item(0) = 99
    m_asserter.AreEqual 1, v.Item(0), "BuiltinTest.TestVBArray", "copy isolation: original[0]=1 unchanged"
    
    ' ─── VBArray(VBArray) creates copy ───
    Set v3 = PyVBArray(v)
    m_asserter.AreEqual 3, v3.Length, "BuiltinTest.TestVBArray", "VBArray(VBArray): Length=3"
    m_asserter.AreEqual 2, v3.Item(1), "BuiltinTest.TestVBArray", "VBArray(VBArray): [1]=2"
    ' Mutate v3 — v unchanged
    v3.Item(1) = 77
    m_asserter.AreEqual 2, v.Item(1), "BuiltinTest.TestVBArray", "VBArray(VBArray): source[1]=2 unchanged"
    
    ' ─── Extend from array ───
    Set v = PyVBArray(Array(1, 2))
    v.Extend Array(3, 4)
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "extend array: Length=4"
    m_asserter.AreEqual 3, v.Item(2), "BuiltinTest.TestVBArray", "extend array: [2]=3"
    m_asserter.AreEqual 4, v.Item(3), "BuiltinTest.TestVBArray", "extend array: [3]=4"
    
    ' ─── Extend from string ───
    Set v = PyVBArray(Array("a"))
    v.Extend "bcd"
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "extend string: Length=4"
    m_asserter.AreEqual "b", v.Item(1), "BuiltinTest.TestVBArray", "extend string: [1]='b'"
    m_asserter.AreEqual "d", v.Item(3), "BuiltinTest.TestVBArray", "extend string: [3]='d'"
    
    ' ─── Extend from range ───
    Set v = PyVBArray(Array(0))
    v.Extend PyRange(1, 4)
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "extend range: Length=4"
    m_asserter.AreEqual 1, v.Item(1), "BuiltinTest.TestVBArray", "extend range: [1]=1"
    m_asserter.AreEqual 3, v.Item(3), "BuiltinTest.TestVBArray", "extend range: [3]=3"
    
    ' ─── Insert at beginning ───
    Set v = PyVBArray(Array(2, 3))
    v.Insert 0, 1
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "insert 0: Length=3"
    m_asserter.AreEqual 1, v.Item(0), "BuiltinTest.TestVBArray", "insert 0: [0]=1"
    m_asserter.AreEqual 2, v.Item(1), "BuiltinTest.TestVBArray", "insert 0: [1]=2"
    m_asserter.AreEqual 3, v.Item(2), "BuiltinTest.TestVBArray", "insert 0: [2]=3"
    
    ' ─── Insert at end ───
    Set v = PyVBArray(Array(1, 2))
    v.Insert 2, 3
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "insert end: Length=3"
    m_asserter.AreEqual 3, v.Item(2), "BuiltinTest.TestVBArray", "insert end: [2]=3"
    
    ' ─── Insert in middle ───
    Set v = PyVBArray(Array(1, 3))
    v.Insert 1, 2
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "insert mid: Length=3"
    m_asserter.AreEqual 2, v.Item(1), "BuiltinTest.TestVBArray", "insert mid: [1]=2"
    m_asserter.AreEqual 3, v.Item(2), "BuiltinTest.TestVBArray", "insert mid: [2]=3"
    
    ' ─── Insert with negative index ───
    Set v = PyVBArray(Array(1, 3))
    v.Insert -1, 2        ' insert before last → position 1
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "insert -1: Length=3"
    m_asserter.AreEqual 2, v.Item(1), "BuiltinTest.TestVBArray", "insert -1: [1]=2"
    
    ' ─── Pop default (last) ───
    Set v = PyVBArray(Array(1, 2, 3))
    m_asserter.AreEqual 3, v.Pop(), "BuiltinTest.TestVBArray", "pop default: returns 3"
    m_asserter.AreEqual 2, v.Length, "BuiltinTest.TestVBArray", "pop default: Length=2"
    
    ' ─── Pop at index ───
    Set v = PyVBArray(Array(10, 20, 30, 40))
    m_asserter.AreEqual 20, v.Pop(1), "BuiltinTest.TestVBArray", "pop(1): returns 20"
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "pop(1): Length=3"
    m_asserter.AreEqual 30, v.Item(1), "BuiltinTest.TestVBArray", "pop(1): new[1]=30 (shifted)"
    
    ' ─── Pop negative index ───
    Set v = PyVBArray(Array(1, 2, 3))
    m_asserter.AreEqual 2, v.Pop(-2), "BuiltinTest.TestVBArray", "pop(-2): returns 2"
    
    ' ─── Pop from empty raises ───
    errorRaised = False
    On Error GoTo VBEmptyPopErr
    Set v = PyVBArray()
    v.Pop
    GoTo VBEmptyPopDone
VBEmptyPopErr:
    errorRaised = True
    Resume VBEmptyPopDone
VBEmptyPopDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestVBArray", "pop from empty should raise"
    
    ' ─── Remove ───
    Set v = PyVBArray(Array(1, 2, 3, 2, 4))
    v.Remove 2
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "remove: Length=4"
    m_asserter.AreEqual 1, v.Item(0), "BuiltinTest.TestVBArray", "remove: [0]=1"
    m_asserter.AreEqual 3, v.Item(1), "BuiltinTest.TestVBArray", "remove: [1]=3 (second became first)"
    m_asserter.AreEqual 2, v.Item(2), "BuiltinTest.TestVBArray", "remove: [2]=2 (remaining)"
    m_asserter.AreEqual 4, v.Item(3), "BuiltinTest.TestVBArray", "remove: [3]=4"
    
    ' ─── Remove not found raises ───
    errorRaised = False
    On Error GoTo VBRemoveErr
    v.Remove 99
    GoTo VBRemoveDone
VBRemoveErr:
    errorRaised = True
    Resume VBRemoveDone
VBRemoveDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "BuiltinTest.TestVBArray", "remove(99) should raise"
    
    ' ─── Reverse ───
    Set v = PyVBArray(Array(1, 2, 3, 4))
    v.Reverse
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "reverse: Length=4"
    m_asserter.AreEqual 4, v.Item(0), "BuiltinTest.TestVBArray", "reverse: [0]=4"
    m_asserter.AreEqual 3, v.Item(1), "BuiltinTest.TestVBArray", "reverse: [1]=3"
    m_asserter.AreEqual 2, v.Item(2), "BuiltinTest.TestVBArray", "reverse: [2]=2"
    m_asserter.AreEqual 1, v.Item(3), "BuiltinTest.TestVBArray", "reverse: [3]=1"
    
    ' ─── Reverse empty ───
    Set v = PyVBArray()
    v.Reverse      ' should not raise
    m_asserter.AreEqual 0, v.Length, "BuiltinTest.TestVBArray", "reverse empty: Length=0"
    
    ' ─── Len via ILength ───
    Set v = PyVBArray(Array(1, 2, 3, 4, 5))
    m_asserter.AreEqual 5, PyLen(v), "BuiltinTest.TestVBArray", "len(VBArray)=5"
    
    ' ─── Contains via IContains (PyIn) ───
    Set v = PyVBArray(Array(0, 2, 4, 6, 8))
    m_asserter.IsTrue PyIn(4, v), "BuiltinTest.TestVBArray", "4 in VBArray"
    m_asserter.IsFalse PyIn(5, v), "BuiltinTest.TestVBArray", "5 not in VBArray"
    
    ' ─── Iteration via PyAll / PyAny ───
    Set v = PyVBArray(Array(0, 0, 0))
    m_asserter.IsFalse PyAll(v), "BuiltinTest.TestVBArray", "all(zeros)=False"
    m_asserter.IsFalse PyAny(v), "BuiltinTest.TestVBArray", "any(zeros)=False"
    
    Set v = PyVBArray(Array(0, 1, 0))
    m_asserter.IsFalse PyAll(v), "BuiltinTest.TestVBArray", "all(0,1,0)=False"
    m_asserter.IsTrue PyAny(v), "BuiltinTest.TestVBArray", "any(0,1,0)=True"
    
    ' ─── ISequence Count and Index ───
    Set v = PyVBArray(Array(1, 2, 2, 3, 2))
    Set seq = v
    m_asserter.AreEqual 3, seq.Count(2), "BuiltinTest.TestVBArray", "count(2)=3"
    m_asserter.AreEqual 0, seq.Count(99), "BuiltinTest.TestVBArray", "count(99)=0"
    m_asserter.AreEqual 1, seq.Index(2), "BuiltinTest.TestVBArray", "index(2)=1"
    m_asserter.AreEqual 3, seq.Index(2, 2), "BuiltinTest.TestVBArray", "index(2, 2)=3"
    
    ' ─── VBArray("abc") → ['a', 'b', 'c'] ───
    Set v = PyVBArray("abc")
    m_asserter.AreEqual 3, v.Length, "BuiltinTest.TestVBArray", "VBArray('abc'): Length=3"
    m_asserter.AreEqual "a", v.Item(0), "BuiltinTest.TestVBArray", "VBArray('abc'): [0]='a'"
    m_asserter.AreEqual "c", v.Item(2), "BuiltinTest.TestVBArray", "VBArray('abc'): [2]='c'"
    
    ' ─── VBArray from range ───
    Set v = PyVBArray(PyRange(4))
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "VBArray(range(4)): Length=4"
    m_asserter.AreEqual 3, v.Item(3), "BuiltinTest.TestVBArray", "VBArray(range(4)): [3]=3"
    
    ' ─── Immutability of original array ───
    Dim src(0 To 2) As Long
    src(0) = 1: src(1) = 2: src(2) = 3
    Set v = PyVBArray(src)
    src(0) = 99
    m_asserter.AreEqual 1, v.Item(0), "BuiltinTest.TestVBArray", "source mutation: [0]=1 unchanged"
    
    ' ─── IMutableSequence interface methods ───
    Dim ms As IMutableSequence
    Set v = PyVBArray(Array(1, 2, 3))
    Set ms = v
    ms.Append 4
    m_asserter.AreEqual 4, v.Length, "BuiltinTest.TestVBArray", "IMutableSequence.Append: Length=4"
    ms.Reverse
    m_asserter.AreEqual 4, v.Item(0), "BuiltinTest.TestVBArray", "IMutableSequence.Reverse: [0]=4"
    
    ' Copy via IMutableSequence
    Dim copyVar As Variant
    Set copyVar = ms.Copy()
    Dim copyVB As VBArray
    Set copyVB = copyVar
    m_asserter.AreEqual 4, copyVB.Length, "BuiltinTest.TestVBArray", "IMutableSequence.Copy: Length=4"
End Sub

Private Sub TestLetSetString()
    Dim dest As Variant
    Builtin.LetSet dest, "hello"
    m_asserter.AreEqual "hello", dest, "BuiltinTest.TestLetSetString", "string: LetSet dest, ""hello"""
    
    Dim src As Variant
    src = "world"
    Builtin.LetSet dest, src
    m_asserter.AreEqual "world", dest, "BuiltinTest.TestLetSetString", "string: LetSet dest, src"
End Sub

Private Sub TestLetSetLong()
    Dim dest As Variant
    Builtin.LetSet dest, 42
    m_asserter.AreEqual 42, dest, "BuiltinTest.TestLetSetLong", "long: 42"
    
    Builtin.LetSet dest, 0
    m_asserter.AreEqual 0, dest, "BuiltinTest.TestLetSetLong", "long: 0"
    
    Builtin.LetSet dest, -1
    m_asserter.AreEqual -1, dest, "BuiltinTest.TestLetSetLong", "long: -1"
End Sub

Private Sub TestLetSetBoolean()
    Dim dest As Variant
    Builtin.LetSet dest, True
    m_asserter.AreEqual True, dest, "BuiltinTest.TestLetSetBoolean", "bool: True"
    
    Builtin.LetSet dest, False
    m_asserter.AreEqual False, dest, "BuiltinTest.TestLetSetBoolean", "bool: False"
End Sub

Private Sub TestLetSetEmpty()
    Dim dest As Variant
    dest = "should be cleared"
    Builtin.LetSet dest, Empty
    m_asserter.IsTrue IsEmpty(dest), "BuiltinTest.TestLetSetEmpty", "Empty"
End Sub

Private Sub TestLetSetNull()
    Dim dest As Variant
    Builtin.LetSet dest, Null
    m_asserter.IsTrue IsNull(dest), "BuiltinTest.TestLetSetNull", "Null"
End Sub

Private Sub TestLetSetNothing()
    Dim dest As Variant
    Builtin.LetSet dest, Nothing
    m_asserter.IsTrue IsObject(dest), "BuiltinTest.TestLetSetNothing", "Nothing: IsObject"
    m_asserter.IsTrue (dest Is Nothing), "BuiltinTest.TestLetSetNothing", "Nothing: dest Is Nothing"
End Sub

Private Sub TestLetSetObject()
    Dim ref As Builtin
    Set ref = Builtin
    Dim dest As Variant
    Builtin.LetSet dest, ref
    m_asserter.IsTrue IsObject(dest), "BuiltinTest.TestLetSetObject", "object: IsObject"
    m_asserter.IsTrue (dest Is Builtin), "BuiltinTest.TestLetSetObject", "object: same reference"
End Sub

Private Sub TestLetSetArray()
    Dim src(0 To 2) As Long
    src(0) = 10
    src(1) = 20
    src(2) = 30
    Dim dest As Variant
    Builtin.LetSet dest, src
    m_asserter.IsTrue IsArray(dest), "BuiltinTest.TestLetSetArray", "array: IsArray"
    m_asserter.AreEqual 10, dest(0), "BuiltinTest.TestLetSetArray", "array: element 0"
    m_asserter.AreEqual 20, dest(1), "BuiltinTest.TestLetSetArray", "array: element 1"
    m_asserter.AreEqual 30, dest(2), "BuiltinTest.TestLetSetArray", "array: element 2"
End Sub

Private Sub TestLetSetFunctionResult()
    Dim dest As Variant
    
    ' String
    Builtin.LetSet dest, GetHello()
    m_asserter.AreEqual "hello", dest, "BuiltinTest.TestLetSetFunctionResult", "function return: string"
    
    ' Long
    Builtin.LetSet dest, GetAnswer()
    m_asserter.AreEqual 42, dest, "BuiltinTest.TestLetSetFunctionResult", "function return: long"
    
    ' Boolean
    Builtin.LetSet dest, GetTrueResult()
    m_asserter.AreEqual True, dest, "BuiltinTest.TestLetSetFunctionResult", "function return: True"
    Builtin.LetSet dest, GetFalseResult()
    m_asserter.AreEqual False, dest, "BuiltinTest.TestLetSetFunctionResult", "function return: False"
    
    ' Empty
    dest = "should be cleared"
    Builtin.LetSet dest, GetEmptyResult()
    m_asserter.IsTrue IsEmpty(dest), "BuiltinTest.TestLetSetFunctionResult", "function return: Empty"
    
    ' Null
    Builtin.LetSet dest, GetNullResult()
    m_asserter.IsTrue IsNull(dest), "BuiltinTest.TestLetSetFunctionResult", "function return: Null"
    
    ' Nothing
    Builtin.LetSet dest, GetNothingResult()
    m_asserter.IsTrue IsObject(dest), "BuiltinTest.TestLetSetFunctionResult", "function return: Nothing: IsObject"
    m_asserter.IsTrue (dest Is Nothing), "BuiltinTest.TestLetSetFunctionResult", "function return: Nothing: Is Nothing"
    
    ' Object
    Builtin.LetSet dest, GetObjectResult()
    m_asserter.IsTrue IsObject(dest), "BuiltinTest.TestLetSetFunctionResult", "function return: object: IsObject"
    m_asserter.IsTrue (dest Is Builtin), "BuiltinTest.TestLetSetFunctionResult", "function return: object: same reference"
    
    ' Array
    Builtin.LetSet dest, GetArrayResult()
    m_asserter.IsTrue IsArray(dest), "BuiltinTest.TestLetSetFunctionResult", "function return: array: IsArray"
    m_asserter.AreEqual 10, dest(0), "BuiltinTest.TestLetSetFunctionResult", "function return: array: element 0"
    m_asserter.AreEqual 20, dest(1), "BuiltinTest.TestLetSetFunctionResult", "function return: array: element 1"
    m_asserter.AreEqual 30, dest(2), "BuiltinTest.TestLetSetFunctionResult", "function return: array: element 2"
End Sub

' Helper: returns a string
Private Function GetHello() As Variant
    GetHello = "hello"
End Function

' Helper: returns a long
Private Function GetAnswer() As Variant
    GetAnswer = 42
End Function

' Helper: returns True
Private Function GetTrueResult() As Variant
    GetTrueResult = True
End Function

' Helper: returns False
Private Function GetFalseResult() As Variant
    GetFalseResult = False
End Function

' Helper: returns Empty (uninitialized Variant)
Private Function GetEmptyResult() As Variant
    ' Not initialized — returns Empty
End Function

' Helper: returns Null
Private Function GetNullResult() As Variant
    GetNullResult = Null
End Function

' Helper: returns Nothing via Variant
Private Function GetNothingResult() As Variant
    Dim obj As Object
    Set obj = Nothing
    Set GetNothingResult = obj
End Function

' Helper: returns an object reference (Builtin default instance)
Private Function GetObjectResult() As Variant
    Set GetObjectResult = Builtin
End Function

' Helper: returns an array
Private Function GetArrayResult() As Variant
    GetArrayResult = Array(10, 20, 30)
End Function
