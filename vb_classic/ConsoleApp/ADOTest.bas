Attribute VB_Name = "ADOTest"
Option Explicit

Private Const TestDBConnectionString As String = "Driver={Oracle in oracle_instant_client};" _
       & "DBQ=10.88.0.30:1521/pdbmgyard.cisdi.com.cn;Uid=djn;Pwd=freebird;"

Public Sub Run()
   InitialConnectionTest
End Sub

Private Sub InitialConnectionTest()
   Dim conn As New ADODB.Connection
   Dim rs As New ADODB.Recordset

   On Error GoTo Cleanup

   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Console.WriteLine "State: " & CStr(conn.State)  & " Mode: " & CStr(conn.Mode)


   Console.WriteLine "Connected to test Database: " _
          &  CStr(conn.Properties("DBMS Name")) & " " & _
          CStr(conn.Properties("DBMS Version")) & " " & _
          CStr(conn.Properties("Data Source Name"))
   Console.WriteLine "Provider: " & CStr(conn.Properties("Provider Name")) _
          & " " & CStr(conn.Properties("Provider Friendly Name"))  _
          & " " & CStr(conn.Properties("Provider Version"))

Cleanup:
   conn.Close

End Sub

