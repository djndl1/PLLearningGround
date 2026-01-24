Attribute VB_Name = "AssertThat"
Option Explicit

Public Enum AssertCode
    FailureCode = vbObjectError + 151000
    SuccessCode
    IgnoreCode
End Enum

Public Sub IsTrue(cond As Boolean, message As String, Optional source As String)
   If Not cond Then
      Err.Raise FailureCode, source, message
   End If
End Sub

Public Sub IsFalse(cond As Boolean, message As String, Optional source As String)
   If cond Then
      Err.Raise SuccessCode, source, message
   End If
End Sub

Public Sub Fail(message As String, Optional source As String)
      Err.Raise FailureCode, source, message
End Sub