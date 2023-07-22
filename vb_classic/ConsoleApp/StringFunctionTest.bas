Option Explicit

Public Sub Run()
   SubStringTest
   TrimTest
End Sub

Private Sub SubStringTest()
   'this is very ugly just for some Unicode string literal
   Dim cnStr As String
   cnStr = chrW(19968) & ChrW(20108) & ChrW(19977) & ChrW(22235) & ChrW(20116) & ChrW(20845)
   Dim s As String
   s = "123456" & cnStr

   AssertThat.IsTrue Len(s) = 12, ""
   AssertThat.IsTrue Left$(s, 6) = "123456", "Should be 123456"
   AssertThat.IsTrue Right$(s, 6) = cnStr, "Should be 一二三四五六"
   AssertThat.IsTrue Mid$(s, 7) = cnStr, "Should be 一二三四五六"

   ' a reference
   Mid$(s, 1, 6) = "ABCDEF"

   AssertThat.IsTrue Left$(s, 6) = "ABCDEF", "Should be ABCDEF"
End Sub

' Does not seem to work with tab and other white spaces
Private Sub TrimTest()
   Dim s As String
   s = "  fd  "

   Dim l As String
   l = LTrim$(s)

   AssertThat.IsTrue l = "fd  ", "left trim"

   Dim r As String
   r = RTrim$(s)
   AssertThat.IsTrue r = "  fd", "right trim"

   Dim lr As String
   lr = Trim$(s)
   AssertThat.IsTrue lr = "fd", "full trim"
End Sub