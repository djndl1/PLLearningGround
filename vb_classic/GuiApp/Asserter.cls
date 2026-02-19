VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Asserter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Private Const AssertionError As Long = 8192

Private m_handler As Variant

Private Property Get handler() As IErrorHandler
        If IsEmpty(m_handler) Then
                Set m_handler = New TextOutputErrorHandler
        End If

        Set handler = m_handler
End Property

Public Sub Init(ByVal handler As IErrorHandler)
        If IsEmpty(m_handler) Then
                Set m_handler = handler
        End If
End Sub

Public Sub IsTrue(ByVal booleanExpression As Boolean, _
                        Optional site As String = "", _
                        Optional message As String = "")
        If booleanExpression Then
                Call m_handler.Handle(0, site, message)
        Else
                Call m_handler.Handle(AssertionError, site, message)
        End If
End Sub

Public Sub AreEqual(ByVal l As Variant, ByVal r As Variant, _
                        Optional site As String = "", _
                        Optional message As String = "")
    IsTrue l = r, site, message
End Sub
