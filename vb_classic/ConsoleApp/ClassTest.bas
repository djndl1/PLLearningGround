Option Explicit

Public Sub Run()
   CreateMyObject
End Sub

Private Sub CreateMyObject()
   Dim o As TestClass

   Set o = New TestClass
   o.AValue = 5

   AssertThat.IsTrue o.AValue = 5, "o.AValue"
End Sub