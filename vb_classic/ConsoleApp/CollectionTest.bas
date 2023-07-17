Option Explicit

Public Sub Run()
   OneBasedTest
   DenseIndexedTest
   ReplaceTest
End Sub

Private Sub DenseIndexedTest()
   Dim c As New Collection

   Dim idx As Long
   For idx = 1 To 100
      c.Add idx, CStr(idx)
   Next

   AssertThat.IsTrue c(3) = 3, "Before: c(3) = 3"
   AssertThat.IsTrue c("3") = 3, "Before: c(3) = 3"
   AssertThat.IsTrue c.Count = 100, "Before: Count 100"
   c.Remove 3
   AssertThat.IsTrue c(3) = 4, "After: c(3) = 4"
   AssertThat.IsTrue c("4") = 4, "After: c(3) = 4"
   AssertThat.IsTrue c.Count = 99, "Before: Count 99"
End Sub

Private Sub ReplaceTest()
   Dim c As New Collection

   Dim idx As Long
   For idx = 1 To 100
      c.Add idx, CStr(idx)
   Next

   c.Remove 1
   c.Add 5,, 1

   AssertThat.IsTrue c(1) = 5, "Should be replaced"
End Sub

Private Sub OneBasedTest()
   Dim c As New Collection

   Dim idx As Long
   For idx = 1 To 100
      c.Add idx, CStr(idx)
   Next

   On Error GoTo OutOfRange
   AssertThat.IsTrue c(0) = 0, "Should Error"

   AssertThat.Fail "Not reachable", "CollectionTest.OneBasedTest"
OutOfRange:
   Exit Sub
End Sub