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
Private m_factory As FileTimeDateTimeFactory


Private Sub Main()
    Set m_asserter = New Asserter
    Dim handler As IErrorHandler
    Set handler = New TextOutputErrorHandler
    Set m_factory = New FileTimeDateTimeFactory
    m_asserter.Init handler

    Dim curDirText As String
    curDirText = ChrW(24403) & ChrW(21069) & ChrW(30446) & ChrW(24405)
        Dim utc As FileTimeDateTime, localT As FileTimeDateTime, manual As FileTimeDateTime
        
        Set utc = m_factory.GetUtcNow()
        Set localT = m_factory.GetLocalNow()
        Set manual = m_factory.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, UtcKind)

        Call GuiFileOutput.WriteLine(utc.ToISOFormat())
        Call GuiFileOutput.WriteLine(localT.ToISOFormat())
        Call GuiFileOutput.WriteLine(manual.ToISOFormat() & ": (H: " & manual.highDateTime & ", L: " & manual.lowDateTime & ")" & " Ticks: " & manual.TicksAsDecimal)

        Dim manualFromTicks As FileTimeDateTime
        Set manualFromTicks = m_factory.FromTicks(manual.TicksAsDecimal)
        Call GuiFileOutput.WriteLine(manualFromTicks.ToISOFormat())

        Call GuiFileOutput.WriteLine(m_factory.GetToday().AddDays(10).ToISOFormat())
        Call GuiFileOutput.WriteLine("")

        'Call DecimalsTest.RunTest(m_asserter)
        'Call ArraysTest.Run(m_asserter)
        'Call CSliceTest.Run(m_asserter)
        'Call FileTimeDateTimeTest.Run(m_asserter)
        'Call NumericsTest.Run(m_asserter)
        'Call NativeConverterTest.Run(m_asserter)
        'Call BitReinterpretTest.Run(m_asserter)
        'Call BigEndianConverterTest.Run(m_asserter)
        'Call LittleEndianConverterTest.Run(m_asserter)
        'Call BitAccessorTest.Run(m_asserter)
        'Call BitPaddingTest.Run(m_asserter)
        'Call NaiveCounterTest.Run(m_asserter)
        Call CTimeSpanTest.Run(m_asserter)
        Call CStopwatchTest.Run(m_asserter)
        Call OleDatesTest.Run(m_asserter)

        If AutoExitCheckBox.value Then
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
