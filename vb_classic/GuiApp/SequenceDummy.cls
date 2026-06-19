VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
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

' ILength — delegated to ISequence.Length
Private Function ILength_Length() As Long
    ILength_Length = 3
End Function
