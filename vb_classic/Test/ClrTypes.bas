Attribute VB_Name = "ClrTypes"
Option Explicit

Public Sub testArrayList()
    Dim clrArray As mscorlib.ArrayList
    
    Set clrArray = CreateObject("System.Collections.ArrayList")
    
    clrArray.Add "Hello"
    clrArray.Add "World"
    clrArray.Add "!"
    
    Debug.Print clrArray.Count, clrArray.Capacity, clrArray.ToString
    Debug.Print "Contains !: ", clrArray.Contains("Hello")
    
    Dim i As Long
    For i = 0 To 2
        Debug.Print clrArray.Item(i)
    Next
    
    clrArray.Sort
    
    For i = 0 To 2
        Debug.Print clrArray.Item(i)
    Next
    
    clrArray.Reverse
    For i = 0 To 2
        Debug.Print clrArray.Item(i)
    Next
    
    Dim clrArr As Variant
    clrArr = clrArray.toArray
    
    Debug.Print "I'm from a CLR array"
    For i = 0 To 2
        Debug.Print clrArr(i)
    Next
    
    clrArray.RemoveAt (2)
    Debug.Print clrArray.Count
    
    clrArray.Add "1"
    clrArray.Add "2"
    Debug.Print clrArray.Count
    
    clrArray.Remove "2"
    Debug.Print clrArray.Count
    
    Debug.Print clrArray.LastIndexOf("1")
    
    Dim o As Variant
    o = "1"
    
    ' one way to avoid this overloading
    Dim ilst As mscorlib.IList
    Set ilst = clrArray
    Debug.Print ilst.IndexOf(o)
    
    ' another way
    Debug.Print clrArray.IndexOf_3(o)
    
    clrArray.Insert 2, "3"
    Debug.Print clrArray.Count
    
    'IEnumerator works as a COM Enumerator
    Dim elm As Variant
    For Each elm In clrArray
        Debug.Print elm, "+"
    Next
    
End Sub

Public Sub HashTableTest()
    Dim tbl As New Hashtable
    
    tbl.Add 1, 2
    tbl.Add 2, 3
    
    Debug.Print tbl.Item(1)
    
    Dim keys As Object
    Set keys = tbl.keys
    
    Debug.Print keys.Count
    
    tbl.Item(4) = 3
    Debug.Print "key 4 => ", tbl.Item(4)
    
    Debug.Print "Contains key 4: " & tbl.containskey(4)
    

End Sub

Public Sub randomTest()
    Dim rnd As New Random
    
    Dim i As Long
    i = rnd.Next
    
    Debug.Print i
End Sub

Public Sub stringbuildertest()
    Dim sb As New StringBuilder
    
    sb.append_3 "1"
    
    Debug.Print sb.ToString
End Sub

Public Sub datetimetest()
   Dim a As Date
   Debug.Print Now
End Sub

