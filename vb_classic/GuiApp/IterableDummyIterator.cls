VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "IterableDummyIterator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements IIterable
Implements IIterator

Private m_items(0 To 2) As Variant
Private m_index As Long
Private m_exhausted As Boolean

Private Sub Class_Initialize()
    m_items(0) = "alpha"
    m_items(1) = "bravo"
    m_items(2) = "charlie"
    m_index = 0
    m_exhausted = False
End Sub

Private Function IIterator_NextItem() As Variant
    If m_exhausted Then
        IIterator_NextItem = CVErr(StopIterationCode.StopIteration)
        Exit Function
    End If
    If m_index > 2 Then
        m_exhausted = True
        IIterator_NextItem = CVErr(StopIterationCode.StopIteration)
        Exit Function
    End If
    IIterator_NextItem = m_items(m_index)
    m_index = m_index + 1
End Function

Private Function IIterator_Iter() As IIterator
    Set IIterator_Iter = Me
End Function

Private Function IIterable_Iter() As IIterator
    Set IIterable_Iter = Me
End Function
