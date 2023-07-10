Option Explicit

Public Enum AssertCode
    FailureCode = vbObjectError + 151000
    SuccessCode
    IgnoreCode
End Enum

Public Sub IsTrue(cond As Boolean, message As String)
   If Not cond Then
      Console.WriteLine "IsTrue test failed: " & message
   End If
End Sub

Public Sub IsFalse(cond As Boolean, message As String)
   If cond Then
      Console.WriteLine "IsFalse test failed: " & message
   End If
End Sub