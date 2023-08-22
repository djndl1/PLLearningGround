Attribute VB_Name = "ADOTest"
Option Explicit

Public Sub Run()
   InitialConnectionTest
End Sub

Private Sub InitialConnectionTest()
   Dim conn As New ADODB.Connection
   Dim rs As New ADODB.Recordset

   On Error GoTo Cleanup

   conn.Open "Driver={Oracle in oracle_instant_client};" _
       & "DBQ=10.88.0.30:1521/pdbmgyard.cisdi.com.cn;Uid=djn;Pwd=freebird;"

   Console.WriteLine "State: " & CStr(conn.State)  & " Mode: " & CStr(conn.Mode)

Cleanup:
   conn.Close
End Sub