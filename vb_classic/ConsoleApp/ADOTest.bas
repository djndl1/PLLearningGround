Attribute VB_Name = "ADOTest"
Option Explicit

Private Const TestDBConnectionString As String = "Driver={Oracle in oracle_instant_client};" _
       & "DBQ=10.10.0.3:1521/pdbmgyard.cisdi.com.cn;Uid=djn;Pwd=freebird;"

Public Sub Run()
   InitialConnectionTest
   SimpleReadTest
   SimpleCommandTest
End Sub

Private Sub InitialConnectionTest()
   Dim conn As New ADODB.Connection

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
   Console.WriteLine "Conncted through ODBC " & CStr(conn.Properties("Driver ODBC Version"))  _
             & " " & CStr(conn.Properties("Driver Name"))  _
             & " " & CStr(conn.Properties("SQL Grammar Support"))

Cleanup:
   conn.Close
End Sub

Private Sub SimpleCommandTest()
   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim cmd As New ADODB.Command
   cmd.CommandText = "UPDATE SQLALCHEMY.USER_ACCOUNT SET name = ? WHERE id = ?" ' only positional parameters are supported

   Dim p As ADODB.Parameter
   ' length is required for variable length
   Set p = cmd.CreateParameter("Name", DataTypeEnum.adBSTR, ParameterDirectionEnum.adParamInput, 30, Left(TestDBConnectionString, 30))
   cmd.Parameters.Append p
   Set p = cmd.CreateParameter("Id", DataTypeEnum.adInteger, ParameterDirectionEnum.adParamInput, , 4)
   cmd.Parameters.Append p

   Set cmd.ActiveConnection = conn
   cmd.Execute

CleanUp:
   If conn.State = adStateOpen Then
      conn.Close
   End If
End Sub

Private Sub SimpleReadTest()
   Dim conn As New ADODB.Connection
   Dim  rs As New ADODB.Recordset

   conn.ConnectionString = TestDBConnectionString
   conn.Open

   With rs
      Set .ActiveConnection = conn
      .Source = "SELECT * FROM V$INSTANCE"
      .CursorLocation = adUseClient
      .Open
   End With

   Console.WriteLine "V$INSTANCE ROW: " & CStr(rs.RecordCount)
   If rs.RecordCount > 0 Then
      rs.MoveFirst
      Dim instanceName As String
      instanceName = rs("INSTANCE_NAME")

      Console.WriteLine "Oracle Instance: " & instanceName
   End If


   Dim cmd As New ADODB.Command
   cmd.CommandText = "SELECT * FROM V$INSTANCE"
   cmd.CommandType = adCmdText
   Set cmd.ActiveConnection = conn
   Dim rs2 As ADODB.RecordSet
   Set rs2 = cmd.Execute

   Console.WriteLine "V$INSTANCE ROW: " & CStr(rs.RecordCount)
   If rs.RecordCount > 0 Then
      rs.MoveFirst
      instanceName = rs("INSTANCE_NAME")

      Console.WriteLine "Oracle Instance: " & instanceName
   End If

Cleanup:
   rs.Close
   rs2.Close
   If conn.State & adStateOpen Then
      conn.Close
   End If
End Sub
