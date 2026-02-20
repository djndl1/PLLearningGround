VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "FileTimeDateTime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_ftimestamp As FILETIME

Private m_dtKind As DateTimeKind

Public Property Get lowDateTime() As Long
        lowDateTime = m_ftimestamp.dwLowDateTime
End Property

Public Property Get highDateTime() As Long
        highDateTime = m_ftimestamp.dwHighDateTime
End Property

Public Property Get TicksAsDecimal() As Variant
        TicksAsDecimal = FileTimeDateTimes.ConvertFileTimeToDecimal(m_ftimestamp)
End Property

Public Property Get Kind() As DateTimeKind
        Kind = m_dtKind
End Property

Public Property Get datePart() As FileTimeDateTime
        Dim y As Integer, m As Integer, d As Integer
        Call GetDatePart(y, m, d)

        Set datePart = FileTimeDateTimes.FromDateTime(y, m, d, dtKind:=Me.Kind)
End Property

Private Sub GetDatePart(ByRef y As Integer, ByRef m As Integer, ByRef d As Integer)
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)
        y = sysTime.wYear
        m = sysTime.wMonth
        d = sysTime.wDay
End Sub

Public Property Get YearPart() As Integer
        Dim y As Integer, m As Integer, d As Integer
        Call GetDatePart(y, m, d)

        YearPart = y
End Property

Public Property Get MonthPart() As Integer
        Dim y As Integer, m As Integer, d As Integer
        Call GetDatePart(y, m, d)

        MonthPart = m
End Property

Public Property Get DayPart() As Integer
        Dim y As Integer, m As Integer, d As Integer
        Call GetDatePart(y, m, d)

        DayPart = d
End Property

Public Property Get HourPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        HourPart = sysTime.wHour
End Property

Public Property Get MinutePart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        MinutePart = sysTime.wMinute
End Property

Public Property Get SecondPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        SecondPart = sysTime.wSecond
End Property

Public Property Get MillisecondPart() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        MillisecondPart = sysTime.wMilliseconds
End Property

Private Function GetSubmillisecondTicks() As Integer
        Dim sysTime As SYSTEMTIME
        sysTime = FileTimeDateTimes.ToSystemTime(Me)

        Dim convertedBack As FileTimeDateTime
        Set convertedBack = FileTimeDateTimes.FromSystemTime(sysTime)

        GetSubmillisecondTicks = CInt(m_ftimestamp.dwLowDateTime - convertedBack.lowDateTime)
End Function

Public Property Get MicrosecondPart() As Integer
        MicrosecondPart = GetSubmillisecondTicks() \ 10
End Property

Public Property Get NanosecondPart() As Integer
        NanosecondPart = (GetSubmillisecondTicks() Mod 10) * 100
End Property

Sub Class_Initialize()
        m_dtKind = UtcKind
End Sub

Public Sub InitFromFileTime(ByVal lowPart As Long, ByVal highPart As Long, Optional ByVal dtKind As DateTimeKind = UnspecifiedKind)
        m_ftimestamp.dwLowDateTime = lowPart
        m_ftimestamp.dwHighDateTime = highPart
        m_dtKind = dtKind
End Sub

Public Sub InitFromTicks(ByVal ticks As Variant, Optional ByVal dtKind As DateTimeKind = UnspecifiedKind)
        m_ftimestamp = FileTimeDateTimes.ConvertDecimalToFileTime(ticks)
        m_dtKind = dtKind
End Sub

Public Function AddTicks(ByVal diffTicks As Variant) As FileTimeDateTime
        Dim sumTicks As Variant
        sumTicks = diffTicks + Me.TicksAsDecimal

        Dim result As New FileTimeDateTime
        Call result.InitFromTicks(sumTicks, m_dtKind)

        Set AddTicks = result
End Function

Public Function AddMicroseconds(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerMicrosecond

        Set AddMicroseconds = AddTicks(diffTicks)
End Function

Public Function AddMilliseconds(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerMillisecond

        Set AddMilliseconds = AddTicks(diffTicks)
End Function

Public Function AddSeconds(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerSecond

        Set AddSeconds = AddTicks(diffTicks)
End Function

Public Function AddMinutes(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerMinute

        Set AddMinutes = AddTicks(diffTicks)
End Function

Public Function AddHours(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerHour

        Set AddHours = AddTicks(diffTicks)
End Function

Public Function AddDays(ByVal d As Double) As FileTimeDateTime
        Dim diffTicks As Variant
        diffTicks = CDec(d) * FileTimeDateTimes.TicksPerDay

        Set AddDays = AddTicks(diffTicks)
End Function

Public Function Clone() As FileTimeDateTime
        ' Create a new FileTimeDateTime with the same time components and DateTimeKind
        Set Clone = FileTimeDateTimes.FromDateTime(Me.YearPart, Me.MonthPart, Me.DayPart, _
                                                   Me.HourPart, Me.MinutePart, Me.SecondPart, _
                                                   Me.MillisecondPart, Me.MicrosecondPart, Me.Kind)
End Function

Public Function AddMonths(ByVal months As Long) As FileTimeDateTime
        ' Step 1: Check if months is zero
        If months = 0 Then
            ' Step 2: If parameter is zero, create new FileTimeDateTime with same time
            Set AddMonths = Me.Clone()
            Exit Function
        End If

        Dim y As Integer, m As Integer, d As Integer
        Call GetDatePart(y, m, d)

        Dim divisionResult As VariantPair
        If months > 0 Then
            ' Step 3: Positive months
            Dim remainingMonths As Integer
            remainingMonths = 12 - m ' Months remaining in current year

            If months <= remainingMonths Then
                ' Within current year
                m = m + months
            Else
                ' Move to next year(s)
                Dim monthsOfFutureYears As Integer
                monthsOfFutureYears = months - remainingMonths

                divisionResult = Numerics.CeilingDivisionLong(monthsOfFutureYears, 12)
                ' until 13, the added year is 1, the remainder is the negative of the lacking months
                y = y + divisionResult.first
                m = 12 + divisionResult.second
            End If
        Else
            ' Step 4: Negative months
            Dim elapsedMonths As Integer
            elapsedMonths = m - 1 ' Months elapsed in current year (0-based)

            Dim monthsToMoveBack As Integer
            monthsToMoveBack = Abs(months) - elapsedMonths

            If monthsToMoveBack <= 0 Then
                ' Within current year
                m = m + months
            Else
                ' Move to previous year(s)
                divisionResult = Numerics.CeilingDivisionLong(monthsToMoveBack, 12)
                y = y - divisionResult.first
                m = 1 - divisionResult.second
            End If
        End If

        ' Step 4: Handle invalid day in resulting month
        ' Use the last valid day of the resulting month if needed
        Dim maxDaysInMonth As Integer
        maxDaysInMonth = DaysInMonth(m, y)

        If d > maxDaysInMonth Then
            d = maxDaysInMonth
        End If

        ' Create new FileTimeDateTime using FileTimeDateTimes.FromDateTime
        Set AddMonths = FileTimeDateTimes.FromDateTime(y, m, d, _
                                                       Me.HourPart, Me.MinutePart, Me.SecondPart, _
                                                       Me.MillisecondPart, Me.MicrosecondPart, Me.Kind)
End Function

Private Function DaysInMonth(ByVal month As Integer, ByVal year As Integer) As Integer
    Select Case month
        Case 1, 3, 5, 7, 8, 10, 12
            DaysInMonth = 31
        Case 4, 6, 9, 11
            DaysInMonth = 30
        Case 2
            If IsLeapYear(year) Then
                DaysInMonth = 29
            Else
                DaysInMonth = 28
            End If
    End Select
End Function

Private Function IsLeapYear(ByVal y As Integer) As Boolean
        IsLeapYear = (y Mod 4 = 0) And (y Mod 100 <> 0 Or y Mod 400 = 0)
End Function

Public Function ToSystemTime() As SYSTEMTIME
        ToSystemTime = FileTimeDateTimes.ToSystemTime(Me)
End Function

Public Function ToISOFormat() As String
        Dim yearString As String
        yearString = Format(YearPart, "0000")
        Dim monthString As String
        monthString = Format(MonthPart, "00")
        Dim dayString As String
        dayString = Format(DayPart, "00")
        Dim hourString As String
        hourString = Format(HourPart, "00")
        Dim minuteString As String
        minuteString = Format(MinutePart, "00")
        Dim secondString As String
        secondString = Format(SecondPart, "00")
        Dim milliString As String
        milliString = Format(MillisecondPart, "000")
        Dim microString As String
        microString = Format(MicrosecondPart, "000")
        Dim nanoString As String
        nanoString = Format(NanosecondPart, "000")

        Dim s As String
         s = yearString & "-" & monthString & "-" & dayString & "T" _
               & hourString & ":" & minuteString & ":" & secondString & "." & milliString & microString & nanoString
        If Me.Kind = UtcKind Then
                s = s & "Z"
        End If

        ToISOFormat = s
End Function
