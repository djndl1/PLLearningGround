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
