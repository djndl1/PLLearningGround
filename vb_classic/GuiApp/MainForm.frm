VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   660
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   2805
   LinkTopic       =   "Form1"
   ScaleHeight     =   660
   ScaleWidth      =   2805
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox AutoExitCheckBox 
      Caption         =   "AutoExit"
      Height          =   375
      Left            =   1680
      TabIndex        =   1
      Top             =   120
      Value           =   1  'Checked
      Width           =   975
   End
   Begin VB.CommandButton RunMain 
      Caption         =   "Run"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Type SYSTEMTIME
        wYear As Integer
        wMonth As Integer
        wDayOfWeek As Integer
        wDay As Integer
        wHour As Integer
        wMinute As Integer
        wSecond As Integer
        wMilliseconds As Integer
End Type

Private OutputFile As Scripting.TextStream

Private Declare Sub GetSystemTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME)

Private Declare Sub GetLocalTime Lib "kernel32.dll" (ByRef lpSystemTime As SYSTEMTIME)

Private Function DateTimeAsISO8601(ByRef d As Date) As String
   DateTimeAsISO8601 = Format(d, "yyyy-mm-ddThh:nn:ss")
End Function

Private Function SYSTEMTIMEAsISO8601(ByRef sysTime As SYSTEMTIME) As String
        Dim yearString As String
        yearString = Format(sysTime.wYear, "0000")
        Dim monthString As String
        monthString = Format(sysTime.wMonth, "00")
        Dim dayString As String
        dayString = Format(sysTime.wDay, "00")
        Dim hourString As String
        hourString = Format(sysTime.wHour, "00")
        Dim minuteString As String
        minuteString = Format(sysTime.wMinute, "00")
        Dim secondString As String
        secondString = Format(sysTime.wSecond, "00")
        Dim milliString As String
        milliString = Format(sysTime.wMilliseconds, "000")

        SYSTEMTIMEAsISO8601 = yearString & "-" & monthString & "-" & dayString & "T" _
               & hourString & ":" & minuteString & ":" & secondString & "." & milliString
End Function



Private Function LocalSystemTimeNow() As SYSTEMTIME
        Dim s As SYSTEMTIME
        GetLocalTime s
        LocalSystemTimeNow = s
End Function

Private Function UtcSystemTimeNow() As SYSTEMTIME
        Dim s As SYSTEMTIME
        GetSystemTime s
        UtcSystemTimeNow = s
End Function

Private Sub Main()
    Debug.Print "当前目录" & CurDir$
    Debug.Print "Enter Main() at " & DateTimeAsISO8601(Now())
    Debug.Print "Enter Main() at " & SYSTEMTIMEAsISO8601(LocalSystemTimeNow())
    OutputFile.WriteLine "当前目录" & CurDir$
    OutputFile.WriteLine "Enter Main() at " & SYSTEMTIMEAsISO8601(LocalSystemTimeNow())

        If AutoExitCheckBox.Value Then
                Unload Me
        End If
End Sub

Private Sub OpenOutput()
        Dim FSO As Scripting.FileSystemObject
        Set FSO = New Scripting.FileSystemObject
        Set OutputFile = FSO.OpenTextFile("output.txt", ForAppending, True, TristateTrue)
End Sub

Private Sub Form_Load()
        Call OpenOutput
    Call Main

Cleanup:
    OutputFile.Close
    Set OutputFile = Nothing
End Sub

Private Sub RunMain_Click()
        Call Main
End Sub
