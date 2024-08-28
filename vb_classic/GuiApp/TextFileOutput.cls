VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextFileOutput"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Stream As Scripting.TextStream

Public OutputPath As String

Public Sub OpenStream()
        Dim FSO As Scripting.FileSystemObject
        Set FSO = New Scripting.FileSystemObject
        Set Stream = FSO.OpenTextFile(OutputPath, ForAppending, True, TristateTrue)
End Sub

Public Sub CloseStream()
        Stream.Close
        Set Stream = Nothing
End Sub

Private Sub Class_Terminate()
        If Not Stream Is Nothing Then
                Call Me.CloseStream
        End If
End Sub

Public Function Read(ByVal characters As Long) As String
        Read = Stream.Read(characters)
End Function

Public Function ReadLine() As String
        ReadLine = Stream.ReadLine()
End Function

Public Function ReadAll() As String
        ReadAll = Stream.ReadAll()
End Function

Public Sub WriteText(Text As Variant)
        Stream.Write CStr(Text)
End Sub

Public Sub WriteLine(Optional Text As Variant = "")
        Stream.WriteLine CStr(Text)
End Sub


Public Sub Skip(ByVal characters As Long)
        Stream.Skip (characters)
End Sub

Public Sub SkipLine()
        Stream.SkipLine
End Sub
