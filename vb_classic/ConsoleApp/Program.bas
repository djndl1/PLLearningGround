Attribute VB_Name = "Program"
Option Explicit

' LINK /EDIT /SUBSYSTEM:CONSOLE ConsoleApp.exe
' debugging using the IDE is not possible here
' as it requires linking to the console subsystem.
' Be careful
Sub Main()
   Console.Init

   On Error GoTo FailedTest

   VariantTest.Run

FailedTest:
   Dim printOut As String
   printOut = "Failed test: " & CStr(Err.Number) & " " _
            & Err.Description & " at " & Err.Source ' line continuation

   Call Console.Dispose
End Sub
