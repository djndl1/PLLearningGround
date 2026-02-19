VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FileTimeDateTimeTest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_asserter As Asserter
Private m_factory As FileTimeDateTimeFactory

Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    Set m_factory = New FileTimeDateTimeFactory

    TestFactoryMethods
    TestInstanceProperties
    TestTimeArithmetic
    ''TestAddMonths
End Sub

Private Sub TestFactoryMethods()
    Dim ft As FileTimeDateTime

    ' Test GetUtcNow
    Set ft = m_factory.GetUtcNow()
    m_asserter.IsTrue Not ft Is Nothing, "FileTimeDateTimeTest.TestFactoryMethods", "GetUtcNow should return valid object"
    m_asserter.IsTrue ft.Kind = UtcKind, "FileTimeDateTimeTest.TestFactoryMethods", "GetUtcNow should return UTC kind"

    ' Test GetLocalNow
    Set ft = m_factory.GetLocalNow()
    m_asserter.IsTrue Not ft Is Nothing, "FileTimeDateTimeTest.TestFactoryMethods", "GetLocalNow should return valid object"
    m_asserter.IsTrue ft.Kind = LocalKind, "FileTimeDateTimeTest.TestFactoryMethods", "GetLocalNow should return Local kind"

    ' Test GetToday
    Set ft = m_factory.GetToday()
    m_asserter.IsTrue Not ft Is Nothing, "FileTimeDateTimeTest.TestFactoryMethods", "GetToday should return valid object"
    m_asserter.IsTrue ft.HourPart = 0, "FileTimeDateTimeTest.TestFactoryMethods", "GetToday should return midnight"
    m_asserter.IsTrue ft.MinutePart = 0, "FileTimeDateTimeTest.TestFactoryMethods", "GetToday should return midnight"
    m_asserter.IsTrue ft.SecondPart = 0, "FileTimeDateTimeTest.TestFactoryMethods", "GetToday should return midnight"

    ' Test FromDateTime
    Set ft = m_factory.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, UtcKind)
    m_asserter.IsTrue Not ft Is Nothing, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime should return valid object"
    m_asserter.AreEqual ft.YearPart, 2023, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime year should match"
    m_asserter.AreEqual ft.MonthPart, 2, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime month should match"
    m_asserter.AreEqual ft.DayPart, 1, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime day should match"
    m_asserter.AreEqual ft.HourPart, 2, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime hour should match"
    m_asserter.AreEqual ft.MinutePart, 2, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime minute should match"
    m_asserter.AreEqual ft.SecondPart, 4, "FileTimeDateTimeTest.TestFactoryMethods", "FromDateTime second should match"

    ' Test FromTicks
    Dim originalTicks As Variant
    originalTicks = ft.TicksAsDecimal
    Set ft = m_factory.FromTicks(originalTicks)
    m_asserter.IsTrue Not ft Is Nothing, "FileTimeDateTimeTest.TestFactoryMethods", "FromTicks should return valid object"
    m_asserter.AreEqual ft.TicksAsDecimal, originalTicks, "FileTimeDateTimeTest.TestFactoryMethods", "FromTicks ticks should match"
End Sub

Private Sub TestInstanceProperties()
    Dim ft As FileTimeDateTime
    Set ft = m_factory.FromDateTime(2023, 2, 1, 2, 2, 4, 123, 452, UtcKind)
    
    m_asserter.AreEqual ft.YearPart, 2023, "FileTimeDateTimeTest.TestInstanceProperties", "YearPart should match"
    m_asserter.AreEqual ft.MonthPart, 2, "FileTimeDateTimeTest.TestInstanceProperties", "MonthPart should match"
    m_asserter.AreEqual ft.DayPart, 1, "FileTimeDateTimeTest.TestInstanceProperties", "DayPart should match"
    m_asserter.AreEqual ft.HourPart, 2, "FileTimeDateTimeTest.TestInstanceProperties", "HourPart should match"
    m_asserter.AreEqual ft.MinutePart, 2, "FileTimeDateTimeTest.TestInstanceProperties", "MinutePart should match"
    m_asserter.AreEqual ft.SecondPart, 4, "FileTimeDateTimeTest.TestInstanceProperties", "SecondPart should match"
    m_asserter.AreEqual ft.MillisecondPart, 123, "FileTimeDateTimeTest.TestInstanceProperties", "MillisecondPart should match"
    m_asserter.AreEqual ft.Kind, UtcKind, "FileTimeDateTimeTest.TestInstanceProperties", "Kind should match"

    ' Test that LowDateTime and HighDateTime are valid
    m_asserter.IsTrue ft.lowDateTime <> 0, "FileTimeDateTimeTest.TestInstanceProperties", "LowDateTime should not be zero"
    m_asserter.IsTrue ft.highDateTime <> 0, "FileTimeDateTimeTest.TestInstanceProperties", "HighDateTime should not be zero"

    ' Test TicksAsDecimal is valid
    m_asserter.IsTrue ft.TicksAsDecimal > 0, "FileTimeDateTimeTest.TestInstanceProperties", "TicksAsDecimal should be positive"

    ' Test DatePart returns only date components
    Dim datePart As FileTimeDateTime
    Set datePart = ft.datePart
    m_asserter.AreEqual datePart.YearPart, 2023, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart year should match"
    m_asserter.AreEqual datePart.MonthPart, 2, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart month should match"
    m_asserter.AreEqual datePart.DayPart, 1, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart day should match"
    m_asserter.AreEqual datePart.HourPart, 0, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart hour should be zero"
    m_asserter.AreEqual datePart.MinutePart, 0, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart minute should be zero"
    m_asserter.AreEqual datePart.SecondPart, 0, "FileTimeDateTimeTest.TestInstanceProperties", "DatePart second should be zero"
End Sub

Private Sub TestTimeArithmetic()
    Dim baseTime As FileTimeDateTime
    Set baseTime = m_factory.FromDateTime(2023, 2, 1, 10, 30, 0, 0, 0, UtcKind)

    ' Test AddDays
    Dim afterDays As FileTimeDateTime
    Set afterDays = baseTime.AddDays(5)
    m_asserter.AreEqual afterDays.DayPart, 6, "FileTimeDateTimeTest.TestTimeArithmetic", "AddDays should add days correctly"

    ' Test AddHours
    Dim afterHours As FileTimeDateTime
    Set afterHours = baseTime.AddHours(2)
    m_asserter.AreEqual afterHours.HourPart, 12, "FileTimeDateTimeTest.TestTimeArithmetic", "AddHours should add hours correctly"

    ' Test AddMinutes
    Dim afterMinutes As FileTimeDateTime
    Set afterMinutes = baseTime.AddMinutes(15)
    m_asserter.AreEqual afterMinutes.MinutePart, 45, "FileTimeDateTimeTest.TestTimeArithmetic", "AddMinutes should add minutes correctly"

    ' Test AddSeconds
    Dim afterSeconds As FileTimeDateTime
    Set afterSeconds = baseTime.AddSeconds(30)
    m_asserter.AreEqual afterSeconds.SecondPart, 30, "FileTimeDateTimeTest.TestTimeArithmetic", "AddSeconds should add seconds correctly"

    ' Test negative arithmetic
    Set afterDays = baseTime.AddDays(-1)
    m_asserter.AreEqual afterDays.DayPart, 31, "FileTimeDateTimeTest.TestTimeArithmetic", "AddDays with negative should subtract days"
    m_asserter.AreEqual afterDays.MonthPart, 1, "FileTimeDateTimeTest.TestTimeArithmetic", "AddDays with negative should handle month boundary"
End Sub

Private Sub TestAddMonths()
    Dim baseTime As FileTimeDateTime

    ' Test simple month addition
    Set baseTime = m_factory.FromDateTime(2023, 2, 15, 0, 0, 0, 0, 0, UtcKind)
    Dim afterMonths As FileTimeDateTime
    Set afterMonths = baseTime.AddMonths(1)
    m_asserter.AreEqual afterMonths.MonthPart, 3, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(1) should increment month"
    m_asserter.AreEqual afterMonths.YearPart, 2023, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(1) should keep same year"

    ' Test year rollover
    Set baseTime = m_factory.FromDateTime(2023, 11, 15, 0, 0, 0, 0, 0, UtcKind)
    Set afterMonths = baseTime.AddMonths(3)
    m_asserter.AreEqual afterMonths.MonthPart, 2, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(3) from Nov should go to Feb next year"
    m_asserter.AreEqual afterMonths.YearPart, 2024, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(3) from Nov should increment year"

    ' Test negative months
    Set baseTime = m_factory.FromDateTime(2023, 3, 15, 0, 0, 0, 0, 0, UtcKind)
    Set afterMonths = baseTime.AddMonths(-2)
    m_asserter.AreEqual afterMonths.MonthPart, 1, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(-2) should decrecent month"
    m_asserter.AreEqual afterMonths.YearPart, 2023, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(-2) should keep same year"

    ' Test year rollover with negative
    Set baseTime = m_factory.FromDateTime(2023, 1, 15, 0, 0, 0, 0, 0, UtcKind)
    Set afterMonths = baseTime.AddMonths(-3)
    m_asserter.AreEqual afterMonths.MonthPart, 10, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(-3) from Jan should go to Oct previous year"
    m_asserter.AreEqual afterMonths.YearPart, 2022, "FileTimeDateTimeTest.TestAddMonths", "AddMonths(-3) from Jan should decrement year"

    ' Test that time components are preserved
    Set baseTime = m_factory.FromDateTime(2023, 2, 15, 10, 30, 45, 123, 456, UtcKind)
    Set afterMonths = baseTime.AddMonths(1)
    m_asserter.AreEqual afterMonths.HourPart, 10, "FileTimeDateTimeTest.TestAddMonths", "AddMonths should preserve hour"
    m_asserter.AreEqual afterMonths.MinutePart, 30, "FileTimeDateTimeTest.TestAddMonths", "AddMonths should preserve minute"
    m_asserter.AreEqual afterMonths.SecondPart, 45, "FileTimeDateTimeTest.TestAddMonths", "AddMonths should preserve second"
    m_asserter.AreEqual afterMonths.MillisecondPart, 123, "FileTimeDateTimeTest.TestAddMonths", "AddMonths should preserve millisecond"
End Sub
