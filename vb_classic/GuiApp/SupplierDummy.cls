VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "SupplierDummy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Implements ISupplier

Private m_counter As Long

Private Sub Class_Initialize()
    m_counter = 1
End Sub

Private Function ISupplier_GetResult() As Variant
    ISupplier_GetResult = m_counter
    m_counter = m_counter + 1
End Function
