Option Explicit

Private Type TestUserUDT
   I As Integer ' padded
   L As Long   ' 4 bytes
   S As String ' itself a pointer
End Type

Public Sub Run()
   UDTCopyAssignment
   UDTLenTest
End Sub

Private Sub UDTLenTest()
   Dim u As TestUserUDT
   AssertThat.IsTrue LenB(u) = 12, "UDTLenTest"
End Sub

Private Sub UDTCopyAssignment()
   Dim u As TestUserUDT, v As TestUserUDT
   With u
      .I = 1
      .L = &1
      .S = "ABC"
   End With

   v = u

   AssertThat.IsTrue v.I = u.I, "v.I = u.I"
   AssertThat.IsTrue v.L = u.L, "v.L = u.L"
   AssertThat.IsTrue v.S = u.S, "v.S = u.S"
End Sub