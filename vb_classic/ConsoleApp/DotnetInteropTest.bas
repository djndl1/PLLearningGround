Attribute VB_Name = "DotnetInteropTest"
Option Explicit

Public Sub Run()
   CreateDotnetObjectTest
   StringBuilderTest
   MethodOverloadingTest
   ArrayListTest
   QueueTest
   StackTest
   HashTableTest
   CalendarTest
End Sub

Private Sub CreateDotnetObjectTest()
   Dim o As New mscorlib.Object

   AssertThat.IsFalse o Is Nothing, "there should be an object"
   AssertThat.IsTrue o.ToString = "System.Object", "Should be System.Object"
   AssertThat.IsTrue o.Equals(o), "Should be equal to itself"

   Dim typ As mscorlib.[_Type] ' System.Type is by default exposed as _Type   ' and has no generated class interface
   Set typ = o.GetType()    ' and thus it has be acccessed through a certain interface
   Console.WriteLine typ.AssemblyQualifiedName

End Sub

Private Sub CalendarTest()
   Dim o As New mscorlib.GregorianCalendar

   Dim d As Variant
   d = Date

   AssertThat.IsTrue o.GetYear(d) = Year(Date()), "Should be year 2026"
End Sub

Private Sub StringBuilderTest()
   Dim o As Object
   Set o = CreateObject("System.Text.StringBuilder")

   o.Append_3 "A" ' Append(String) is the third in the source code

   AssertThat.IsTrue o.ToString = "A", "Should be A"
End Sub

Private Sub MethodOverloadingTest()
   Dim d As New mscorlib.Random
   Dim l As Long
   l = d.Next_2(1, 10)

   AssertThat.IsTrue l >= 1 And l <= 10, "Should be inbetween"

   l = d.Next()

   l = d.Next_3(10)
   AssertThat.IsTrue l <= 10, "Should be less"
End Sub

Private Sub StackTest()
   Dim q As New mscorlib.Stack

   q.Push 1
   q.Push 2

   AssertThat.IsTrue q.Count = 2, "Should have two elements"
   AssertThat.IsTrue q.Peek() = 2, "Should be two"

   Dim popped As Variant
   popped = q.Pop
   AssertThat.IsTrue popped = 2, "Should be the upper one popped"
End Sub

Private Sub HashTableTest()
   Dim dict As New mscorlib.Hashtable

   dict.Add 1, 1
   dict.Add 2, 2

   AssertThat.IsTrue dict.ContainsKey(1), "Should contains Key"
   AssertThat.IsTrue dict.ContainsValue(1), "Should contains value"

   AssertThat.IsTrue dict(1) = 1, "Should be one"

   ' a lot of QueryInterface under the hood
   Dim dictEO As mscorlib.IDictionaryEnumerator
   Set dictEO = dict.GetEnumerator() ' IDictionaryEnumerator is not an IEnumerator
   Dim dictE As mscorlib.IEnumerator ' cast IDictionaryEnumerator so that IEnumerator's method can be used
   Set dictE = dictEO                ' because inheritance does not exists in COM
   While dictE.MoveNext
      Dim c As Variant, kv As mscorlib.DictionaryEntry
      c = dictE.Current ' IEnumerator marshaled as IEnumVARIANT and thus returns a Variant
      kv = c            ' cast to DictionaryEntry

      Dim k As Variant, ki As Integer, vi As Integer
      Set k = kv.[_key] ' this Variant holds to an IUnknown pointer, a not-quite-supported interface in VBA
      Console.WriteLine VarType(k) & " " & TypeName(k) ' 13 vbDataObject (VT_UNKNOWN) and Int16

      Dim ik As IUnknown
      Set ik = k

      Dim ko As Object ' It just happens that System.Int16's class interface is IDispatch by default
      Set ko = ik       ' so it can be assigned to a VBA Object (IDispatch)'
      Set ko = kv.[_key] ' the assignment wouldn't work otherwise

      Dim kconv As mscorlib.IConvertible ' cast to IConvertible so that it can be converted to an integer
      Set kconv = ko
      ki = kconv.ToInt16(Nothing)

      Set ko = kv.[_value]
      vi = CInt(ko.ToString) ' or we parse its string form

      AssertThat.IsTrue ki = vi, "key = value"
   Wend

   Dim dictumerable As mscorlib.IEnumerable ' otherwise IDictionaryEnumerator
   Set dictumerable = dict
   Dim dictEntryVar As Variant ' IEnumVARIANT returns VARIANT
   For Each dictEntryVar In dictumerable
      Dim dictEntry As mscorlib.DictionaryEntry ' but actually a DictionaryEntry
      dictEntry = dictEntryVar

      Set ko = dictEntry.[_key]
      ki = CInt(ko) ' seems that the default ToString is evaluated before passing to CInt
      Set ko = dictEntry.[_value]
      vi = CInt(ko)

      AssertThat.IsTrue ki = vi, "key = value"
   Next
End Sub

Private Sub QueueTest()
   Dim q As New mscorlib.Queue

   q.Enqueue 1
   q.Enqueue 2

   AssertThat.IsTrue q.Count = 2, "Should have two elements"
   AssertThat.IsTrue q.Peek() = 1, "Should be one"

   Dim l As Variant
   For Each l In q
      AssertThat.IsTrue l = 1 Or l = 2, "Should be elements"
   Next

   AssertThat.IsTrue q.Contains(2), "Should contain 2"

   l = q.Dequeue
   AssertThat.IsTrue l = 1, "Should be one"

   Dim arr As Variant
   arr = q.ToArray()
   AssertThat.IsTrue arr(0) = 2, "Should be 2 left"
End Sub

Private Sub ArrayListTest()
   Dim arrLst As New mscorlib.ArrayList

   arrLst.Add 1
   arrLst.Add 2

   AssertThat.IsTrue arrLst.Count = 2, "Should have two elements"
   arrLst.Reverse
   AssertThat.IsTrue arrLst(1) = 1, "Should be reversed"

   Dim l As Variant
   For Each l In arrLst
      AssertThat.IsTrue l = 1 Or l = 2, "Should be elements"
   Next

   AssertThat.IsTrue arrLst.Contains(2), "Should contain 2"
End Sub