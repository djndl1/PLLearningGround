Attribute VB_Name = "GuiDataBinder"
Option Explicit

Public Type TextBoxBinder
    Control As TextBox
    dataItem As Variant
End Type


Public Type ListBoxBinder
    Control As ListBox
    DataItems() As Variant
End Type

Public Type ComboBoxBinder
    Control As ComboBox
    DataItems() As Variant
End Type

Public Sub SetTextBoxDataItem(ByRef txtBoxBinder As TextBoxBinder, _
                              ByVal dataText As String, _
                              ByVal dataItem As Variant)
    If IsObject(dataItem) Then
        Set txtBoxBinder.dataItem = dataItem
    Else
        txtBoxBinder.dataItem = dataItem
    End If
    txtBoxBinder.Control.Text = dataText
End Sub

Public Sub SetListBoxItems(ByRef lstBoxBinder As ListBoxBinder, _
                           ByRef items() As Variant, _
                           ByRef itemTexts() As String)
    lstBoxBinder.DataItems = items
    lstBoxBinder.Control.Clear

    Dim i As Integer
    For i = LBound(items) To UBound(items)
        lstBoxBinder.Control.AddItem itemTexts(i)
        lstBoxBinder.Control.ItemData(lstBoxBinder.Control.NewIndex) = i
    Next
End Sub

Public Function GetCurrentListBoxItem(ByRef lstBoxBinder As ListBoxBinder) As Variant
    If lstBoxBinder.Control Is Nothing Then
        GetCurrentListBoxItem = vbEmpty
        Exit Function
    End If
    If lstBoxBinder.Control.Index = -1 Then
        GetCurrentListBoxItem = vbEmpty
        Exit Function
    End If

    Dim key As Integer
    key = lstBoxBinder.Control.ItemData(lstBoxBinder.Control.Index)
    If key < LBound(lstBoxBinder.DataItems) Or _
       key > UBound(lstBoxBinder.DataItems) Then
        GetCurrentListBoxItem = vbEmpty
        Exit Function
    End If

    If IsObject(lstBoxBinder.DataItems(key)) Then
        Set GetCurrentListBoxItem = lstBoxBinder.DataItems(key)
    Else
        GetCurrentListBoxItem = lstBoxBinder.DataItems(key)
    End If
End Function

Public Sub SetComboBoxItems(ByRef cmbBoxBinder As ComboBoxBinder, _
                           ByRef items() As Variant, _
                           ByRef itemTexts() As String)
    cmbBoxBinder.DataItems = items
    cmbBoxBinder.Control.Clear

    Dim i As Integer
    For i = LBound(items) To UBound(items)
        cmbBoxBinder.Control.AddItem itemTexts(i)
        cmbBoxBinder.Control.ItemData(cmbBoxBinder.Control.NewIndex) = i
    Next
End Sub

Public Function GetCurrentComboBoxItem(ByRef cmbBoxBinder As ComboBoxBinder) As Variant
    If cmbBoxBinder.Control Is Nothing Then
        GetCurrentComboBoxItem = vbEmpty
        Exit Function
    End If
    If cmbBoxBinder.Control.Index = -1 Then
        GetCurrentComboBoxItem = vbEmpty
        Exit Function
    End If

    Dim key As Integer
    key = cmbBoxBinder.Control.ItemData(cmbBoxBinder.Control.Index)
    If key < LBound(cmbBoxBinder.DataItems) Or _
       key > UBound(cmbBoxBinder.DataItems) Then
        GetCurrentComboBoxItem = vbEmpty
        Exit Function
    End If

    If IsObject(cmbBoxBinder.DataItems(key)) Then
        Set GetCurrentComboBoxItem = cmbBoxBinder.DataItems(key)
    Else
        GetCurrentComboBoxItem = cmbBoxBinder.DataItems(key)
    End If
End Function
