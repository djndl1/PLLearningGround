Attribute VB_Name = "Console"
Option Explicit

Private Sout As Scripting.TextStream
Private Sin As Scripting.TextStream

Property Get Out() As Scripting.ITextStream
	Set Out = Sout
End Property

Public Sub Init()
    Dim FSO As New Scripting.FileSystemObject
    Set Sin = FSO.GetStandardStream(StdIn)
    Set Sout = FSO.GetStandardStream(StdOut)
End Sub

Public Sub WriteText(Optional text As String)
   Out.Write text
End Sub

Public Sub WriteLine(Optional text As String)
   Out.WriteLine text
End Sub

Public Sub Dispose()
   Call Sout.Close
   Set Sout = Nothing

   Call Sin.Close
   Set Sin = Nothing
End Sub
