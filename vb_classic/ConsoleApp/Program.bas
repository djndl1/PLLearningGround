Attribute VB_Name = "Program"
Option Explicit

' LINK /EDIT /SUBSYSTEM:CONSOLE ConsoleApp.exe
' debugging using the IDE is not possible here
' as it requires linking to the console subsystem.
' Be careful
Sub Main()
   Console.Init

   Dim s As String
   s = "123"
   Dim i As Long
   i = s

   Console.WriteLine CStr(i)

   Call Console.Dispose
End Sub
