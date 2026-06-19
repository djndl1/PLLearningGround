VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "IterableDummy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Implements IIterable

Private Function IIterable_Iter() As IIterator
    Set IIterable_Iter = New IterableDummyIterator
End Function
