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
        m_output.OutputPath = GenerateUniqueFileName()
        Call m_output.OpenStream
End Sub

Private Function GenerateUniqueFileName() As String
        Dim nowTime As FileTimeDateTime
        Set nowTime = FileTimeDateTimes.GetLocalNow()
        
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(nowTime)
        
        ' Format: asserter_YYYYMMDD_HHMMSSmmm.log
        Dim timestamp As String
        timestamp = Format(sysTime.wYear, "0000") & _
                   Format(sysTime.wMonth, "00") & _
                   Format(sysTime.wDay, "00") & "_" & _
                   Format(sysTime.wHour, "00") & _
                   Format(sysTime.wMinute, "00") & _
                   Format(sysTime.wSecond, "00") & _
                   Format(sysTime.wMilliseconds, "000")
        
        GenerateUniqueFileName = "asserter_" & timestamp & ".log"
End Function

Public Sub IErrorHandler_Handle(errCode As Long, Optional source As String, Optional description As String)
        Dim s As String
        s = FileTimeDateTimes.GetLocalNow().ToISOFormat()

        Dim errResultString As String
        errResultString = IIF(errCode = 0, ChrW$(&H2713), ChrW$(&H2717))
        Call m_output.WriteLine( _
                "|" & s & "|" & source & "|" & errCode & "|" &  errResultString & "|" & description)
End Sub