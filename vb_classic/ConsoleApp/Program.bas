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
   AggregateTypesTest.Run
   ArrayTest.Run
   CollectionTest.Run
   DotnetInteropTest.Run
   StringFunctionTest.Run
   DateTimeTest.Run
   ClassTest.Run
   FileTest.Run
   ADOTest.Run

   GoTo CleanUp
FailedTest:
   Dim printOut As String
   printOut = "Failed test: " & CStr(Err.Number) & " " _
            & Err.Description & " at " & Err.Source ' line continuation
   Console.WriteLine printOut
CleanUp:
   Call Console.Dispose
End Sub
