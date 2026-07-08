VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SequenceDummy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements ISequence
Implements ILength

Private m_items(0 To 2) As Variant

Private Sub Class_Initialize()
    m_items(0) = 10
    m_items(1) = 20
    m_items(2) = 30
End Sub

' ISequence
Private Function ISequence_GetItem(ByVal index As Long) As Variant
    ISequence_GetItem = m_items(index)
End Function

Private Function ISequence_Length() As Long
    ISequence_Length = 3
End Function

Private Function ISequence_Count(ByVal value As Variant) As Long
    Dim i As Long
    For i = 0 To 2
        If m_items(i) = value Then ISequence_Count = ISequence_Count + 1
    Next i
End Function

Private Function ISequence_Index(ByVal value As Variant, Optional ByVal start As Variant, Optional ByVal stopValue As Variant) As Long
    Dim startIdx As Long: startIdx = 0
    Dim stopIdx As Long: stopIdx = 3
    If Not IsMissing(start) Then startIdx = CLng(start)
    If Not IsMissing(stopValue) Then stopIdx = CLng(stopValue)
    Dim i As Long
    For i = startIdx To stopIdx - 1
        If m_items(i) = value Then
            ISequence_Index = i
            Exit Function
        End If
    Next i
    Err.Raise 5, "SequenceDummy.Index", "value not in sequence"
End Function

' ILength — delegated to ISequence.Length
Private Function ILength_Length() As Long
    ILength_Length = 3
End Function
