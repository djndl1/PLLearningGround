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
Option Explicit

Private GuiFileOutput As TextFileOutput
Private m_asserter As Asserter

Private Sub Main()
    Set m_asserter = New Asserter
    Dim handler As IErrorHandler
    Set handler = New TextOutputErrorHandler
    m_asserter.Init handler

    Dim curDirText As String
    curDirText = ChrW(24403) & ChrW(21069) & ChrW(30446) & ChrW(24405)
        Dim utc As FileTimeDateTime, localT As FileTimeDateTime, manual As FileTimeDateTime
        Set utc = FileTimeDateTimes.GetUtcNow()
        Set localT = FileTimeDateTimes.GetLocalNow()
        Set manual = FileTimeDateTimes.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, dtKind:=DateTimeKind.UtcKind)

        Call GuiFileOutput.WriteLine(utc.ToISOFormat())
        Call GuiFileOutput.WriteLine(localT.ToISOFormat())
        Call GuiFileOutput.WriteLine(manual.ToISOFormat() & ": (H: " & manual.HighDateTime & ", L: " & manual.LowDateTime & ")" & " Ticks: " & manual.TicksAsDecimal)

        Dim manualFromTicks As FileTimeDateTime
        Set manualFromTicks = New FileTimeDateTime
        Call manualFromTicks.InitFromTicks(manual.TicksAsDecimal)
        Call GuiFileOutput.WriteLine(manualFromTicks.ToISOFormat())

        Call GuiFileOutput.WriteLine(FileTimeDateTimes.GetToday().AddDays(10).ToISOFormat())
        Call GuiFileOutput.WriteLine("")

        Call DecimalsTest.RunTest(m_asserter)
        Call ArraysTest.Run(m_asserter)

        If AutoExitCheckBox.Value Then
                Unload Me
        End If
End Sub

Private Sub Form_Load()
        Set GuiFileOutput = New TextFileOutput
        GuiFileOutput.OutputPath = "./output"
        Call GuiFileOutput.OpenStream
        Call Main
End Sub

Private Sub Form_Unload(Cancel As Integer)
        Call GuiFileOutput.CloseStream
End Sub

Private Sub RunMain_Click()
        Call Main
End Sub