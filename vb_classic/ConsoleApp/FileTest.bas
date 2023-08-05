Option Explicit

Public Sub Run()
   ShowCurrentDirectoryTest
   CopyDeleteTest
   ShowAttributesTest
End Sub

Private Sub ShowCurrentDirectoryTest()
   Console.WriteLine CurDir$()
End Sub

Private Sub ShowAttributesTest()
   Dim a As long
   a = GetAttr("build/ConsoleApp.exe.config")

   Dim siz As long
   siz = FileLen("build/ConsoleApp.exe.config")

   Dim d As Date
   d = FileDateTime("build/ConsoleApp.exe.config")

   Dim s As String
   s = "build\ConsoleApp.exe.config has an attribute value of " & CStr(Hex(a)) _
     & " file length of " & CStr(siz) _
     & " and file date of " & DateTimeTest.DateTimeAsISO8601(d)


   Console.WriteLine s
End Sub

Private Sub CopyDeleteTest()

   If FileExists("build/ConsoleAppCopy.exe") Then
      Kill "build/ConsoleAppCopy.exe"
   End If
   FileCopy "build/ConsoleApp.exe", "build/ConsoleAppCopy.exe"

   AssertThat.IsTrue FileExists("build/ConsoleAppCopy.exe") = True, "Should be there a ConsoleAppCopy.exe"

   Kill "build/ConsoleAppCopy.exe"
End Sub

Function FileExists(filename As String) As Boolean
    On Error Resume Next
    FileExists = (Dir$(filename) <> "")
End Function