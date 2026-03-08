VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NaiveCounter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True

Option Explicit

' CounterOverflowEventArgs - Event arguments for counter overflow event
' Public type defined within the class module
Public Type CounterOverflowEventArgs
    LastValue As Long
    OverflowValue As Long
End Type

Private m_Name As String
Private m_Current As Long
Private m_Max As Long
Private m_JustOverflowed As Boolean
Private m_Handlers As Collection

Public Property Get Name() As String
    Name = m_Name
End Property

Public Property Get Current() As Long
    Current = m_Current
End Property

Public Property Let Current(ByVal value As Long)
    m_Current = value
End Property

Public Property Get Max() As Long
    Max = m_Max
End Property

Public Property Get JustOverflowed() As Boolean
    JustOverflowed = m_JustOverflowed
End Property

Public Sub Init(ByVal name As String, ByVal max As Long)
    m_Name = name
    m_Max = max
    m_Current = 0
    m_JustOverflowed = False
    Set m_Handlers = New Collection
End Sub

Public Sub Subscribe(ByVal handler As IConsumer)
    m_Handlers.Add handler
End Sub

Public Sub Unsubscribe(ByVal handler As IConsumer)
    Dim i As Long
    For i = 1 To m_Handlers.Count
        If m_Handlers(i) Is handler Then
            m_Handlers.Remove i
            Exit For
        End If
    Next i
End Sub

Public Sub Increment()
    Add 1
End Sub

Public Sub Reset()
    m_Current = 0
    m_JustOverflowed = False
End Sub

Public Sub Add(ByVal increment As Long)
    Dim oldValue As Long
    oldValue = m_Current

    If increment < 1 Then
        m_Current = m_Current + 1
    Else
        m_Current = m_Current + increment
    End If

    m_JustOverflowed = False

    If m_Current > m_Max Then
        Dim overflowValue As Long
        overflowValue = m_Current

        Reset
        m_JustOverflowed = True

        If m_Handlers.Count > 0 Then
            Dim args As CounterOverflowEventArgs
            args.LastValue = oldValue
            args.OverflowValue = overflowValue

            Dim handler As IConsumer
            For Each handler In m_Handlers
                handler.Accept args
            Next handler
        End If
    End If
End Sub