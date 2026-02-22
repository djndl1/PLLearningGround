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
        Dim factory As New FileTimeDateTimeFactory
        Set utc = factory.GetUtcNow()
        Set localT = factory.GetLocalNow()
        Set manual = factory.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, dtKind:=UtcKind)

        Call GuiFileOutput.WriteLine(utc.ToISOFormat())
        Call GuiFileOutput.WriteLine(localT.ToISOFormat())
        Call GuiFileOutput.WriteLine(manual.ToISOFormat() & ": (H: " & manual.highDateTime & ", L: " & manual.lowDateTime & ")" & " Ticks: " & manual.TicksAsDecimal)

        Dim manualFromTicks As FileTimeDateTime
        Set manualFromTicks = New FileTimeDateTime
        Call manualFromTicks.InitFromTicks(manual.TicksAsDecimal)
        Call GuiFileOutput.WriteLine(manualFromTicks.ToISOFormat())

        Call GuiFileOutput.WriteLine(factory.GetToday().AddDays(10).ToISOFormat())
        Call GuiFileOutput.WriteLine("")

        Call DecimalsTest.RunTest(m_asserter)
        Call ArraysTest.Run(m_asserter)
        Call CSliceTest.Run(m_asserter)
        Call FileTimeDateTimeTest.Run(m_asserter)
        Call NumericsTest.Run(m_asserter)

        Call TestFileTimeDateTime

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

Private Sub TestFileTimeDateTime()
    Call GuiFileOutput.WriteLine("")
    Call GuiFileOutput.WriteLine("=== FileTimeDateTime Test ===")

    Dim factory As New FileTimeDateTimeFactory

    Dim ftUtc As FileTimeDateTime
    Set ftUtc = factory.GetUtcNow()
    Call GuiFileOutput.WriteLine("FileTimeDateTime UTC Now: " & ftUtc.ToISOFormat())

    Dim ftLocal As FileTimeDateTime
    Set ftLocal = factory.GetLocalNow()
    Call GuiFileOutput.WriteLine("FileTimeDateTime Local Now: " & ftLocal.ToISOFormat())

    Dim ftToday As FileTimeDateTime
    Set ftToday = factory.GetToday()
    Call GuiFileOutput.WriteLine("FileTimeDateTime Today: " & ftToday.ToISOFormat())

    Dim ftManual As FileTimeDateTime
    Set ftManual = factory.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, UtcKind)
    Call GuiFileOutput.WriteLine("FileTimeDateTime Manual: " & ftManual.ToISOFormat())

    Dim ftFromTicks As FileTimeDateTime
    Set ftFromTicks = factory.FromTicks(ftManual.TicksAsDecimal)
    Call GuiFileOutput.WriteLine("FileTimeDateTime From Ticks: " & ftFromTicks.ToISOFormat())

    Dim ftFuture As FileTimeDateTime
    Set ftFuture = ftToday.AddDays(10)
    Call GuiFileOutput.WriteLine("FileTimeDateTime Today + 10 days: " & ftFuture.ToISOFormat())

    Call GuiFileOutput.WriteLine("FileTimeDateTime Year: " & CStr(ftManual.YearPart))
    Call GuiFileOutput.WriteLine("FileTimeDateTime Month: " & CStr(ftManual.MonthPart))
    Call GuiFileOutput.WriteLine("FileTimeDateTime Day: " & CStr(ftManual.DayPart))
    Call GuiFileOutput.WriteLine("FileTimeDateTime Hour: " & CStr(ftManual.HourPart))
    Call GuiFileOutput.WriteLine("FileTimeDateTime Minute: " & CStr(ftManual.MinutePart))
    Call GuiFileOutput.WriteLine("FileTimeDateTime Second: " & CStr(ftManual.SecondPart))

    Call GuiFileOutput.WriteLine("=== FileTimeDateTime Test Complete ===")
    Call GuiFileOutput.WriteLine("")
End Sub

Private Sub Form_Unload(Cancel As Integer)
        Call GuiFileOutput.CloseStream
End Sub

Private Sub RunMain_Click()
        Call Main
End Sub
