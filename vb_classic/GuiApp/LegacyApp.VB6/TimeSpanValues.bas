Attribute VB_Name = "TimeSpanValues"
Option Explicit

' TimeSpanValues holds the value-type building blocks for the CTimeSpan
' module hierarchy:
'   1. The `TimeSpan` UDT (a single Variant Ticks field) - the value
'      representation used by the procedural API in CTimeSpans.cls.
'   2. The Int64 tick bounds (MAX_TICKS_STR / MIN_TICKS_STR) - parsed
'      via CDec into the Decimal Variant form used internally.
'
' These declarations live in a .bas module because VB6 forbids Public
' Type and Public Const in class modules (object modules). The values
' are public to the project but not COM-exposed.

' Maximum Int64 tick count, expressed as a string to keep it readable in
' source. CDec parses it into the Decimal Variant form used internally.
Public Const MAX_TICKS_STR As String = "9223372036854775807"

' Minimum Int64 tick count. The asymmetric magnitude is intrinsic to two's
' complement: |MinValue| > |MaxValue|, so negating MinValue overflows.
Public Const MIN_TICKS_STR As String = "-9223372036854775808"