VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OverflowEventCatcher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements IConsumer

Private m_LastValue As Long
Private m_OverflowValue As Long
Private m_Fired As Boolean

Public Property Get LastValue() As Long
    LastValue = m_LastValue
End Property

Public Property Get OverflowValue() As Long
    OverflowValue = m_OverflowValue
End Property

Public Property Get Fired() As Boolean
    Fired = m_Fired
End Property

Public Sub Reset()
    m_LastValue = 0
    m_OverflowValue = 0
    m_Fired = False
End Sub

Private Sub IConsumer_Accept(ByVal t As Variant)
    ' Accept a CounterOverflowEventArgs type
    Dim args As CounterOverflowEventArgs
    args = t

    m_LastValue = args.LastValue
    m_OverflowValue = args.OverflowValue
    m_Fired = True
End Sub