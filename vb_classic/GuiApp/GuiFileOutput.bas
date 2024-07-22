Attribute VB_Name = "GuiFileOutput"
Option Explicit

Public Stream As Scripting.TextStream

Public Sub OpenStream()
        Dim FSO As Scripting.FileSystemObject
        Set FSO = New Scripting.FileSystemObject
        Set Stream = FSO.OpenTextFile("output.txt", ForAppending, True, TristateTrue)
End Sub

Public Sub CloseStream()
    	Stream.Close
    	Set Stream = Nothing
End Sub
