VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AlwaysTruePredicate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements IPredicate

Private Function IPredicate_Test(ByVal value As Variant) As Boolean
    IPredicate_Test = True
End Function
