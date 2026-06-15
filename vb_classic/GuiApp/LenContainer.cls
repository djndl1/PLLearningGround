VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "LenContainer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements ILength

Private m_length As Long

Public Sub SetLength(ByVal value As Long)
    m_length = value
End Sub

Private Function ILength_Length() As Long
    ILength_Length = m_length
End Function
