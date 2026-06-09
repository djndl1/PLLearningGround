VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OleDatesTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestEpoch
    TestNtEpoch
    TestUnixEpoch
    TestFormatAsISO8601
    TestToFromFileTimeDecimal
    TestRoundTripFileTimeDecimal
    TestLocalUtcRoundTrip
    TestTimezoneOffset
End Sub

Private Sub TestEpoch()
    Dim e As Date
    e = OleDates.OleEpoch
    m_asserter.AreEqual e, 0#, "OleDatesTest.TestEpoch", "Epoch is 0#"
End Sub

Private Sub TestNtEpoch()
    ' 1601-01-01 00:00:00 UTC is OLE Date -109205 (1899-12-30 minus 109,205 days)
    m_asserter.AreEqual OleDates.NtEpoch, -109205#, "OleDatesTest.TestNtEpoch", "NtEpoch is 1601-01-01 UTC"
    ' Spot check: FormatAsISO8601 of the NT epoch should produce a 1601 date
    Dim s As String
    s = OleDates.FormatAsISO8601(OleDates.NtEpoch)
    m_asserter.IsTrue InStr(s, "1601") > 0, "OleDatesTest.TestNtEpoch", "FormatAsISO8601 of NtEpoch contains 1601"
    ' Sanity: NT epoch < Unix epoch (1601 is before 1970)
    m_asserter.IsTrue OleDates.NtEpoch < OleDates.UnixEpoch, "OleDatesTest.TestNtEpoch", "NtEpoch < UnixEpoch"
End Sub

Private Sub TestUnixEpoch()
    ' 1970-01-01 00:00:00 UTC is OLE Date 25569
    m_asserter.AreEqual OleDates.UnixEpoch, 25569#, "OleDatesTest.TestUnixEpoch", "UnixEpoch is 1970-01-01 UTC"
    Dim s As String
    s = OleDates.FormatAsISO8601(OleDates.UnixEpoch)
    m_asserter.IsTrue InStr(s, "1970") > 0, "OleDatesTest.TestUnixEpoch", "FormatAsISO8601 of UnixEpoch contains 1970"
    ' Sanity: Unix epoch > OLE epoch (1970 is after 1899-12-30)
    m_asserter.IsTrue OleDates.UnixEpoch > OleDates.OleEpoch, "OleDatesTest.TestUnixEpoch", "UnixEpoch > OleEpoch"
    ' Sanity: gap between Unix and OLE epochs is exactly 25569 days
    m_asserter.AreEqual OleDates.UnixEpoch - OleDates.OleEpoch, 25569#, "OleDatesTest.TestUnixEpoch", "UnixEpoch - OleEpoch = 25569 days"
End Sub

Private Sub TestFormatAsISO8601()
    Dim s As String
    s = OleDates.FormatAsISO8601(OleDates.OleEpoch)
    m_asserter.IsTrue Len(s) > 0, "OleDatesTest.TestFormatAsISO8601", "Format returns non-empty"
    ' Should contain a year (1899 or 1900 for OLE 0#)
    m_asserter.IsTrue InStr(s, "1899") > 0 Or InStr(s, "1900") > 0, "OleDatesTest.TestFormatAsISO8601", "Contains year 1899 or 1900"
End Sub

Private Sub TestToFromFileTimeDecimal()
    Dim knownDate As Date
    knownDate = DateSerial(2023, 6, 15) + TimeSerial(12, 30, 45)
    Dim ticks As Variant
    ticks = OleDates.ToFileTimeDecimal(knownDate)
    m_asserter.IsTrue CDec(ticks) > CDec(0), "OleDatesTest.TestToFromFileTimeDecimal", "Ticks should be positive for 2023"
End Sub

Private Sub TestRoundTripFileTimeDecimal()
    Dim knownDate As Date
    knownDate = DateSerial(2023, 6, 15) + TimeSerial(12, 30, 45)
    Dim ticks As Variant
    ticks = OleDates.ToFileTimeDecimal(knownDate)
    Dim back As Date
    back = OleDates.FromFileTimeDecimal(ticks)
    ' OLE Date precision is ~1ms in 1900-2100. Allow 1s tolerance.
    Dim diff As Double
    diff = CDbl(back) - CDbl(knownDate)
    If diff < 0 Then diff = -diff
    m_asserter.IsTrue diff < 1 / 86400, "OleDatesTest.TestRoundTripFileTimeDecimal", "Round-trip within 1 second"
End Sub

Private Sub TestLocalUtcRoundTrip()
    Dim factory As New FileTimeDateTimeFactory
    ' Use a real moment to compute the local/UTC offset
    Dim utcNow As FileTimeDateTime
    Set utcNow = factory.GetUtcNow()
    Dim localNow As FileTimeDateTime
    Set localNow = factory.GetLocalNow()

    Dim utcOle As Date
    utcOle = utcNow.ToOleDate()
    Dim localFromUtc As Date
    localFromUtc = OleDates.ToLocalFromUtc(utcOle)
    Dim backToUtc As Date
    backToUtc = OleDates.ToUtcFromLocal(localFromUtc)

    ' The local we got should be close to localNow's OLE Date
    Dim localOle As Date
    localOle = localNow.ToOleDate()
    Dim diff As Double
    diff = CDbl(localFromUtc) - CDbl(localOle)
    If diff < 0 Then diff = -diff
    m_asserter.IsTrue diff < 1 / 86400, "OleDatesTest.TestLocalUtcRoundTrip", "ToLocalFromUtc matches localNow within 1s"

    ' backToUtc should be close to utcOle
    Dim backDiff As Double
    backDiff = CDbl(backToUtc) - CDbl(utcOle)
    If backDiff < 0 Then backDiff = -backDiff
    m_asserter.IsTrue backDiff < 1 / 86400, "OleDatesTest.TestLocalUtcRoundTrip", "ToUtcFromLocal round-trips back within 1s"
End Sub

Private Sub TestTimezoneOffset()
    ' The TZ offset should be a multiple of 15 minutes (or some fixed offset in the test env)
    ' Verify: ToLocalFromUtc(utcOle) - utcOle = expected offset (in days)
    Dim factory As New FileTimeDateTimeFactory
    Dim utcNow As FileTimeDateTime
    Set utcNow = factory.GetUtcNow()
    Dim utcOle As Date
    utcOle = utcNow.ToOleDate()

    Dim localFromUtc As Date
    localFromUtc = OleDates.ToLocalFromUtc(utcOle)

    ' Offset in days
    Dim offsetDays As Double
    offsetDays = CDbl(localFromUtc) - CDbl(utcOle)
    ' Offset in minutes
    Dim offsetMinutes As Double
    offsetMinutes = offsetDays * 1440

    ' Must be a multiple of 15 minutes (or close to one of the common ones: 0, 60, -300, -360, -420, -480 etc.)
    ' Most lenient: |offset| <= 14*60 (i.e. somewhere between UTC-14 and UTC+14)
    m_asserter.IsTrue offsetMinutes >= -14 * 60 And offsetMinutes <= 14 * 60, "OleDatesTest.TestTimezoneOffset", "Offset in valid range"
    ' And a multiple of 15 min
    Dim modMin As Double
    modMin = offsetMinutes - (Int(offsetMinutes / 15) * 15)
    If modMin < 0 Then modMin = -modMin
    m_asserter.IsTrue modMin < 0.5, "OleDatesTest.TestTimezoneOffset", "Offset is a multiple of 15 min"
End Sub
