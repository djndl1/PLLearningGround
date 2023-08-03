Option Explicit

Public Sub Run()
   ShowCurrentDirectoryTest
   CopyDeleteTest
   MoveDeleteTest
   ShowAttributesTest
End Sub

Private Sub ShowCurrentDirectoryTest()
   Console.WriteLine CurDir$()
End Sub

Private Sub MoveDeleteTest()
   If FileExists("build/ConsoleAppMoved.exe") Then
      Kill "build/ConsoleAppMoved.exe"
   End If
   Name "build/ConsoleApp.exe" As "build/ConsoleAppMoved.exe"

   AssertThat.IsTrue FileExists("build/ConsoleAppMoved.exe") = True, "Should be there a ConsoleAppMoved.exe"

   Kill "build/ConsoleAppMoved.exe"
End Sub

Private Sub ShowAttributesTest()
   Dim a As long
   a = GetAttr("build\ConsoleApp.exe.config")

   Dim siz As long
   siz = FileLen("build\ConsoleApp.exe.config")

   Dim d As Date
   d = FileDateTime("build\ConsoleApp.exe.config")

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

Private Function FileExists(ByRef s As String) As Boolean
   Dim fso As New FileSystemObject

   FileExists = fso.FileExists(s)
End Function
