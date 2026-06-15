VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DynamicCount"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_count As Long

Private Sub Class_Initialize()
    m_count = 42
End Sub

Public Property Get Count() As Long
    Count = m_count
End Property

Public Property Let Count(ByVal value As Long)
    m_count = value
End Property
