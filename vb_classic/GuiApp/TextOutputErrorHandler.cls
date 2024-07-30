VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TextOutputErrorHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Private m_output As TextFileOutput

Implements IErrorHandler

Private Sub Class_Initialize()
        Set m_output = New TextFileOutput
        m_output.OutputPath = "asserter.log"
        Call m_output.OpenStream
End Sub

Public Sub IErrorHandler_Handle(errCode As Long, Optional source As String, Optional description As String)
        Dim s As String
        s = FileTimeDateTimes.GetLocalNow().ToISOFormat()

        Dim errResultString As String
        errResultString = IIF(errCode = 0, ChrW$(&H2713), ChrW$(&H2717))
        Call m_output.WriteLine( _
                "|" & s & "|" & source & "|" & CStr(errCode) & "|" &  errResultString & "|" & description)
End Sub
