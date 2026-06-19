VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "IterTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestIIterable
    TestIIteratorIsIterable
    TestArrayIter
    TestCollectionIter
    TestISequenceIter
    TestIterTwoArg
    TestExhaustion
    TestNonIterableError
    TestEmptyCollection
    TestIterationLoop
    TestPyNext
    TestPyAllWithIterable
    TestPyAnyWithIterable
    TestPyAllWithIterator
    TestPyAnyWithIterator
    TestPyBool
    TestStringIter
    TestStringIterEmpty
    TestPyAllWithString
    TestPyAnyWithString
End Sub

' ─── Test 1: Pure IIterable protocol (fast path) ───

Private Sub TestIIterable()
    Dim iterable As IIterable
    Set iterable = New IterableDummy
    Dim iter As IIterator
    Set iter = PyIter(iterable)
    m_asserter.AreEqual "alpha", iter.NextItem(), "IterTest.TestIIterable", "item 0"
    m_asserter.AreEqual "bravo", iter.NextItem(), "IterTest.TestIIterable", "item 1"
    m_asserter.AreEqual "charlie", iter.NextItem(), "IterTest.TestIIterable", "item 2"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestIIterable", "exhausted"
End Sub

' ─── Test 2: An iterator is also iterable (Iter returns self) ───

Private Sub TestIIteratorIsIterable()
    Dim inner As IIterable
    Set inner = New IterableDummy
    
    ' PyIter(iterable) returns IIterator
    Dim iter As IIterator
    Set iter = PyIter(inner)
    
    ' IIterator is IIterable → PyIter(iter) returns iter itself
    Dim iterAgain As IIterator
    Set iterAgain = PyIter(iter)
    
    ' Walking iterAgain should give the same items
    m_asserter.AreEqual "alpha", iterAgain.NextItem(), "IterTest.TestIIteratorIsIterable", "item 0 from iter of iter"
    m_asserter.AreEqual "bravo", iterAgain.NextItem(), "IterTest.TestIIteratorIsIterable", "item 1"
    m_asserter.AreEqual "charlie", iterAgain.NextItem(), "IterTest.TestIIteratorIsIterable", "item 2"
    m_asserter.IsTrue IsError(iterAgain.NextItem()), "IterTest.TestIIteratorIsIterable", "exhausted"
End Sub

' ─── Test 3: Array fallback (ArrayIterator) ───

Private Sub TestArrayIter()
    Dim arr(0 To 2) As Long
    arr(0) = 10
    arr(1) = 20
    arr(2) = 30
    
    Dim iter As IIterator
    Set iter = PyIter(arr)
    
    m_asserter.AreEqual 10, iter.NextItem(), "IterTest.TestArrayIter", "element 0"
    m_asserter.AreEqual 20, iter.NextItem(), "IterTest.TestArrayIter", "element 1"
    m_asserter.AreEqual 30, iter.NextItem(), "IterTest.TestArrayIter", "element 2"
    
    Dim e As Boolean
    Dim v As Variant
    v = iter.NextItem()
    e = IsError(v)
    m_asserter.IsTrue e, "IterTest.TestArrayIter", "exhausted"
End Sub

' ─── Test 4: Collection fallback (EnumVARIANTIterator) ───

Private Sub TestCollectionIter()
    Dim col As New Collection
    col.Add "one"
    col.Add "two"
    col.Add "three"
    
    Dim iter As IIterator
    Set iter = PyIter(col)
    
    m_asserter.AreEqual "one", iter.NextItem(), "IterTest.TestCollectionIter", "item 0"
    m_asserter.AreEqual "two", iter.NextItem(), "IterTest.TestCollectionIter", "item 1"
    m_asserter.AreEqual "three", iter.NextItem(), "IterTest.TestCollectionIter", "item 2"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestCollectionIter", "exhausted"
End Sub

' ─── Test 5: ISequence fallback (SequenceIterator) ───

Private Sub TestISequenceIter()
    Dim seq As New SequenceDummy
    
    Dim iter As IIterator
    Set iter = PyIter(seq)
    
    m_asserter.AreEqual 10, iter.NextItem(), "IterTest.TestISequenceIter", "element 0"
    m_asserter.AreEqual 20, iter.NextItem(), "IterTest.TestISequenceIter", "element 1"
    m_asserter.AreEqual 30, iter.NextItem(), "IterTest.TestISequenceIter", "element 2"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestISequenceIter", "exhausted"
End Sub

' ─── Test 6: Two-arg form — iter(callable, sentinel) ───

Private Sub TestIterTwoArg()
    Dim sup As New SupplierDummy    ' returns 1, 2, 3, 4, 5, 6, ...
    
    Dim iter As IIterator
    Set iter = PyIter(sup, 5)   ' sentinel = 5
    
    ' Values 1-4 are yielded; 5 matches sentinel so it is NOT yielded
    m_asserter.AreEqual 1, iter.NextItem(), "IterTest.TestIterTwoArg", "value 1"
    m_asserter.AreEqual 2, iter.NextItem(), "IterTest.TestIterTwoArg", "value 2"
    m_asserter.AreEqual 3, iter.NextItem(), "IterTest.TestIterTwoArg", "value 3"
    m_asserter.AreEqual 4, iter.NextItem(), "IterTest.TestIterTwoArg", "value 4"
    
    ' Fifth call: SupplierDummy returns 5 which matches sentinel → exhausted
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestIterTwoArg", "sentinel reached, exhausted"
End Sub

' ─── Test 7: Exhaustion is idempotent ───

Private Sub TestExhaustion()
    Dim arr(0 To 0) As Long
    arr(0) = 99
    
    Dim iter As IIterator
    Set iter = PyIter(arr)
    
    ' Consume the only element
    m_asserter.AreEqual 99, iter.NextItem(), "IterTest.TestExhaustion", "only element"
    
    ' First exhausted call
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestExhaustion", "first exhausted call"
    
    ' Every subsequent call must also return the error sentinel
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestExhaustion", "second exhausted call"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestExhaustion", "third exhausted call"
End Sub

' ─── Test 8: Non-iterable arguments raise error ───

Private Sub TestNonIterableError()
    Dim errorRaised As Boolean
    Dim iter As IIterator
    
    ' Integer is not iterable
    errorRaised = False
    On Error GoTo IntErr
    Set iter = PyIter(42)
    GoTo IntDone
IntErr:
    errorRaised = True
    Resume IntDone
IntDone:
    On Error GoTo -1
    m_asserter.IsTrue errorRaised, "IterTest.TestNonIterableError", "PyIter(Integer) should raise error"
    
    ' Object without IIterable is not iterable
    errorRaised = False
    On Error GoTo ObjErr
    Dim nonIter As Object
    Set nonIter = New WinHttpRequest
    Set iter = PyIter(nonIter)
    GoTo ObjDone
ObjErr:
    errorRaised = True
    Resume ObjDone
ObjDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "IterTest.TestNonIterableError", "PyIter(non-iterable Object) should raise error"
    
    ' ISupplier alone (without sentinel) is not iterable by single-arg form
    errorRaised = False
    On Error GoTo SupplierErr
    Dim sup As New SupplierDummy
    Set iter = PyIter(sup)
    GoTo SupplierDone
SupplierErr:
    errorRaised = True
    Resume SupplierDone
SupplierDone:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "IterTest.TestNonIterableError", "PyIter(ISupplier without sentinel) should raise error"
End Sub

' ─── Test 9: Empty Collection yields immediate StopIteration ───

Private Sub TestEmptyCollection()
    Dim col As New Collection
    
    Dim iter As IIterator
    Set iter = PyIter(col)
    
    ' Empty collection — first NextItem should be exhausted
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestEmptyCollection", "empty collection exhausted"
    
    ' Still exhausted on subsequent calls
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestEmptyCollection", "still exhausted"
End Sub

' ─── Test 10: Demonstration of the PyTryNext loop pattern ───
' Shows the recommended way to iterate:
'   Do While PyTryNext(iter, item)
'       ' process item
'   Loop
Private Sub TestIterationLoop()
    Dim col As New Collection
    col.Add "red"
    col.Add "green"
    col.Add "blue"
    
    Dim iter As IIterator
    Set iter = PyIter(col)
    
    Dim item As Variant
    Dim Count As Long
    Count = 0
    
    Do While PyTryNext(iter, item)
        Count = Count + 1
    Loop
    
    m_asserter.AreEqual 3, Count, "IterTest.TestIterationLoop", _
        "all items consumed via PyTryNext"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestIterationLoop", _
        "iterator exhausted after loop"
End Sub

' ─── Test 11: PyNext — Pythonic next(it) / next(it, default) ───
Private Sub TestPyNext()
    ' --- Two-arg form: next(it, default) ---
    Dim arr2(0 To 1) As Long
    arr2(0) = 10
    arr2(1) = 20
    
    Dim iter As IIterator
    Set iter = PyIter(arr2)
    
    ' Normal items
    m_asserter.AreEqual 10, PyNext(iter, -1), _
        "IterTest.TestPyNext", "two-arg: item 0"
    m_asserter.AreEqual 20, PyNext(iter, -1), _
        "IterTest.TestPyNext", "two-arg: item 1"
    ' Exhausted → returns default
    m_asserter.AreEqual -1, PyNext(iter, -1), _
        "IterTest.TestPyNext", "two-arg: exhausted returns default"
    
    ' --- One-arg form: next(it) raises on exhaustion ---
    Set iter = PyIter(arr2)
    
    m_asserter.AreEqual 10, PyNext(iter), _
        "IterTest.TestPyNext", "one-arg: item 0"
    m_asserter.AreEqual 20, PyNext(iter), _
        "IterTest.TestPyNext", "one-arg: item 1"
    
    ' Third call — iterator exhausted → error raised
    Dim errorRaised As Boolean
    errorRaised = False
    On Error GoTo PyNextErr
    Dim unused As Variant
    unused = PyNext(iter)
    GoTo AfterPyNextErr
PyNextErr:
    errorRaised = True
    Resume AfterPyNextErr
AfterPyNextErr:
    On Error GoTo 0
    m_asserter.IsTrue errorRaised, "IterTest.TestPyNext", _
        "one-arg: exhausted raises StopIteration"
End Sub

' ─── Test 12: PyAll with IIterable protocol ───
Private Sub TestPyAllWithIterable()
    Dim dummy As New IterableDummy
    
    ' All items are truthy strings → PyAll should return True
    m_asserter.IsTrue PyAll(dummy), "IterTest.TestPyAllWithIterable", _
        "PyAll(IIterable) all truthy"
    
    ' PyAll with AlwaysTrue — predicate always passes
    m_asserter.IsTrue PyAll(dummy, New AlwaysTruePredicate), _
        "IterTest.TestPyAllWithIterable", _
        "PyAll(IIterable, AlwaysTrue) all truthy"
    
    ' PyAll with AlwaysFalse — predicate always fails
    m_asserter.IsFalse PyAll(dummy, New AlwaysFalsePredicate), _
        "IterTest.TestPyAllWithIterable", _
        "PyAll(IIterable, AlwaysFalse) none truthy"
End Sub

' ─── Test 13: PyAny with IIterable protocol ───
Private Sub TestPyAnyWithIterable()
    Dim dummy As New IterableDummy
    
    ' Any truthy string → PyAny should return True
    m_asserter.IsTrue PyAny(dummy), "IterTest.TestPyAnyWithIterable", _
        "PyAny(IIterable) any truthy"
    
    ' PyAny with AlwaysTrue — predicate always passes
    m_asserter.IsTrue PyAny(dummy, New AlwaysTruePredicate), _
        "IterTest.TestPyAnyWithIterable", _
        "PyAny(IIterable, AlwaysTrue) any truthy"
    
    ' PyAny with AlwaysFalse — predicate always fails
    m_asserter.IsFalse PyAny(dummy, New AlwaysFalsePredicate), _
        "IterTest.TestPyAnyWithIterable", _
        "PyAny(IIterable, AlwaysFalse) none truthy"
End Sub

' ─── Test 14: PyAll with an IIterator (since IIterator Is IIterable) ───
Private Sub TestPyAllWithIterator()
    ' Create an iterator directly to test the IIterator → IIterable path
    Dim iter As New IterableDummyIterator
    
    ' Passing the iterator directly — TypeOf iter Is IIterable is True
    m_asserter.IsTrue PyAll(iter), "IterTest.TestPyAllWithIterator", _
        "PyAll(IIterator) all truthy"
End Sub

' ─── Test 15: PyAny with an IIterator ───
Private Sub TestPyAnyWithIterator()
    ' Create an iterator directly to test the IIterator → IIterable path
    Dim iter As New IterableDummyIterator
    
    ' Passing the iterator directly
    m_asserter.IsTrue PyAny(iter), "IterTest.TestPyAnyWithIterator", _
        "PyAny(IIterator) any truthy"
End Sub

' ─── Test 16: PyBool — truth value testing ───
Private Sub TestPyBool()
    ' No argument → False
    m_asserter.IsFalse PyBool(), "IterTest.TestPyBool", _
        "PyBool() no arg is False"
    
    ' Empty / Null → False
    m_asserter.IsFalse PyBool(Empty), "IterTest.TestPyBool", _
        "PyBool(Empty) is False"
    m_asserter.IsFalse PyBool(Null), "IterTest.TestPyBool", _
        "PyBool(Null) is False"
    
    ' Strings: non-empty → True, empty → False
    m_asserter.IsTrue PyBool("alpha"), "IterTest.TestPyBool", _
        "PyBool(non-empty string) is True"
    m_asserter.IsFalse PyBool(""), "IterTest.TestPyBool", _
        "PyBool(empty string) is False"
    
    ' Numerics: zero → False, non-zero → True
    m_asserter.IsFalse PyBool(0), "IterTest.TestPyBool", _
        "PyBool(0) is False"
    m_asserter.IsTrue PyBool(42), "IterTest.TestPyBool", _
        "PyBool(42) is True"
    
    ' Arrays: non-empty → True
    Dim arr(0 To 2) As Long
    m_asserter.IsTrue PyBool(arr), "IterTest.TestPyBool", _
        "PyBool(non-empty array) is True"
    
    ' Empty array via undimensioned variable → False
    Dim emptyArr() As Variant
    m_asserter.IsFalse PyBool(emptyArr), "IterTest.TestPyBool", _
        "PyBool(empty array) is False"
    
    ' Nothing → False
    Dim obj As Object: Set obj = Nothing
    m_asserter.IsFalse PyBool(obj), "IterTest.TestPyBool", _
        "PyBool(Nothing) is False"
    
    ' ILength object (SequenceDummy: Length=3) → True
    Dim seq As New SequenceDummy
    m_asserter.IsTrue PyBool(seq), "IterTest.TestPyBool", _
        "PyBool(ILength with Length=3) is True"
    
    ' Collection: non-empty → True
    Dim col As New Collection
    col.Add "item"
    m_asserter.IsTrue PyBool(col), "IterTest.TestPyBool", _
        "PyBool(non-empty Collection) is True"
    col.Remove 1
    m_asserter.IsFalse PyBool(col), "IterTest.TestPyBool", _
        "PyBool(empty Collection) is False"
End Sub

' ─── Test 17: String character iterator via PyIter ───
Private Sub TestStringIter()
    Dim iter As IIterator
    Set iter = PyIter("hello")
    
    m_asserter.AreEqual "h", iter.NextItem(), "IterTest.TestStringIter", "char 0"
    m_asserter.AreEqual "e", iter.NextItem(), "IterTest.TestStringIter", "char 1"
    m_asserter.AreEqual "l", iter.NextItem(), "IterTest.TestStringIter", "char 2"
    m_asserter.AreEqual "l", iter.NextItem(), "IterTest.TestStringIter", "char 3"
    m_asserter.AreEqual "o", iter.NextItem(), "IterTest.TestStringIter", "char 4"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestStringIter", "exhausted"
End Sub

' ─── Test 18: Empty string iterator ───
Private Sub TestStringIterEmpty()
    Dim iter As IIterator
    Set iter = PyIter("")
    
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestStringIterEmpty", _
        "empty string exhausted immediately"
    m_asserter.IsTrue IsError(iter.NextItem()), "IterTest.TestStringIterEmpty", _
        "still exhausted"
End Sub

' ─── Test 19: PyAll with string ───
Private Sub TestPyAllWithString()
    m_asserter.IsTrue PyAll("hello"), "IterTest.TestPyAllWithString", _
        "PyAll(non-empty string) all chars truthy"
    m_asserter.IsTrue PyAll(""), "IterTest.TestPyAllWithString", _
        "PyAll(empty string) vacuous truth"
End Sub

' ─── Test 20: PyAny with string ───
Private Sub TestPyAnyWithString()
    m_asserter.IsTrue PyAny("hello"), "IterTest.TestPyAnyWithString", _
        "PyAny(non-empty string) some char truthy"
    m_asserter.IsFalse PyAny(""), "IterTest.TestPyAnyWithString", _
        "PyAny(empty string) no truthy chars"
End Sub
