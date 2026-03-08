VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TestOverflowConsumer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements IConsumer

Private m_Test As NaiveCounterTest

Public Sub Init(ByRef test As NaiveCounterTest)
    Set m_Test = test
End Sub

Private Sub IConsumer_Accept(ByVal t As Variant)
    ' Not used in this test consumer
End Sub
