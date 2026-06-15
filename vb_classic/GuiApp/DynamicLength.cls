VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DynamicLength"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_length As Long

Private Sub Class_Initialize()
    m_length = 99
End Sub

Public Property Get Length() As Long
    Length = m_length
End Property

Public Property Let Length(ByVal value As Long)
    m_length = value
End Property
