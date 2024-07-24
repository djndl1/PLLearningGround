VERSION 5.00
Begin VB.Form MainForm 
   Caption         =   "MainForm"
   ClientHeight    =   660
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   2805
   LinkTopic       =   "MainForm"
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
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Main()
    Dim curDirText As String
    curDirText = ChrW(24403) & ChrW(21069) & ChrW(30446) & ChrW(24405)
    Debug.Print curDirText & " 当前目录" & CurDir$
    Debug.Print "Enter Main() at " & SystemTimeDateTime.DateTimeAsISO8601(Now())
    Debug.Print "Enter Main() at " & SystemTimeDateTime.SYSTEMTIMEAsISO8601(SystemTimeDateTime.LocalSystemTimeNow())
    GuiFileOutput.Stream.WriteLine "当前目录" & CurDir$
    GuiFileOutput.Stream.WriteLine "Enter Main() at " & SystemTimeDateTime.SYSTEMTIMEAsISO8601(SystemTimeDateTime.LocalSystemTimeNow())

	Dim utc As FileTimeDateTime, localT As FileTimeDateTime
	Set utc = FileTimeDateTimes.GetUtcNow()
	Set localT = FileTimeDateTimes.GetLocalNow()

        If AutoExitCheckBox.Value Then
                Unload Me
        End If
End Sub

Private Sub Form_Load()
        Call GuiFileOutput.OpenStream
        Call Main
End Sub

Private Sub Form_Unload(Cancel As Integer)
        Call GuiFileOutput.CloseStream
End Sub

Private Sub RunMain_Click()
        Call Main
End Sub
