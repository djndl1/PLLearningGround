Option Explicit

Public Sub Run()
   ShowDateTest
End Sub

Private Sub ShowDateTest()
   Dim d As Date
   d = #2023-07-22 23:49:41# ' build with literal
   AssertThat.IsTrue DateTimeAsISO8601(d) = "2023-07-22T23:49:41", "ISO8601 Format"

   Dim combined As Date
   combined = DateSerial(2023, 7, 22) + TimeSerial(23, 49, 41) 'build with functions
   AssertThat.IsTrue DateTimeAsISO8601(combined) = "2023-07-22T23:49:41", "ISO8601 Format"
   Console.WriteLine DateTimeAsISO8601(combined)

   Dim valueDate As Date
   valueDate = DateValue("2023-07-22 23:49:41") ' date only
   AssertThat.IsTrue DateTimeAsISO8601(valueDate) = "2023-07-22T00:00:00", "ISO8601 Format"

   Dim dvalue As Double
   dvalue = valueDate
   Console.WriteLine CStr(dvalue / 365.25) & " years since the Lotus 1-2-3 epoch"

   Dim tseconds As Single
   tseconds = Timer
   Dim tTime As Date
   tTime = Time
   AssertThat.IsTrue DateAsISO8601(tTime) = "1899-12-30", ""
End Sub

Public Function DateTimeAsISO8601(ByRef d As Date) As String
   DateTimeAsISO8601 = Format(d, "yyyy-mm-ddThh:nn:ss")
End Function

Public Function DateAsISO8601(ByRef d As Date) As String
   DateAsISO8601 = Format(d, "yyyy-mm-dd")
End Function