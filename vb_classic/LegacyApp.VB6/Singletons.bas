Attribute VB_Name = "Singletons"
Option Explicit

Private m_Arrays As CArrays
Private m_Decimals As CDecimals

' Returns the singleton instance of the Arrays class
' This provides backward compatibility with the previous module-based approach
Public Property Get Arrays() As CArrays
    If m_Arrays Is Nothing Then
        Set m_Arrays = New CArrays
    End If
    Set Arrays = m_Arrays
End Property

' Returns the singleton instance of the Decimals class
' This provides backward compatibility with the previous module-based approach
Public Property Get Decimals() As CDecimals
    If m_Decimals Is Nothing Then
        Set m_Decimals = New CDecimals
    End If
    Set Decimals = m_Decimals
End Property
