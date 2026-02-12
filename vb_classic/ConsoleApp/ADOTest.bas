Attribute VB_Name = "ADOTest"
Option Explicit

Private Const TestDBConnectionString As String = "Driver={SQL Server Native Client 10.0};" _
       & "Server=127.0.0.1;Database=VB6Learn;Uid=djn;Pwd=djn123;"

Public Sub Run()
    Console.WriteLine ""
    Console.WriteLine vbTab & "Connecting to Local MSSQL: "
    InitialConnectionTest
    SimpleReadTest
    SimpleCommandTest
    DisplayRecordSetFeaturesTest
    ImmediateRecordsetUpdateTest
End Sub

Private Sub InitialConnectionTest()
   Dim conn As New ADODB.Connection

   Dim hndler As New ADOConnectionEventHandler
   hndler.Subscribe conn

   On Error GoTo Cleanup

   conn.ConnectionString = TestDBConnectionString
   conn.Open

Cleanup:
   conn.Close
   Set hndler = Nothing
End Sub

Private Sub DisplayRecordSetFeaturesTest()
   Console.WriteLine "Dynamic Cursor"
   DisplayRecordSetFeatures adOpenDynamic

   Console.WriteLine "KeySet Cursor"
   DisplayRecordSetFeatures adOpenKeyset

   Console.WriteLine "Static Cursor"
   DisplayRecordSetFeatures adOpenStatic

   Console.WriteLine "Forward-Only Cursor"
   DisplayRecordSetFeatures adOpenForwardOnly
End Sub

Private Sub DisplayRecordSetFeatures(cursorTyp As CursorTypeEnum)
   On Error GoTo Cleanup

   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim rs As New ADODB.Recordset
   With rs
      Set .ActiveConnection = conn
      .source = "SELECT * FROM INFORMATION_SCHEMA.TABLES"
      .CursorType = cursorTyp
      .Open LockType:=adLockOptimistic
   End With

   Dim b As Boolean
   b = rs.Supports(adAddNew)
   Console.WriteLine vbTab & "Supports adAddNew: " & b

   b = rs.Supports(adApproxPosition)
   Console.WriteLine vbTab & "Supports adApproxPosition: " & b

   b = rs.Supports(adBookmark)
   Console.WriteLine vbTab & "Supports adBookmark: " & b

   b = rs.Supports(adDelete)
   Console.WriteLine vbTab & "Supports adDelete: " & b

   b = rs.Supports(adFind)
   Console.WriteLine vbTab & "Supports adFind: " & b

   b = rs.Supports(adHoldRecords)
   Console.WriteLine vbTab & "Supports adHoldRecords: " & b

   b = rs.Supports(adMovePrevious)
   Console.WriteLine vbTab & "Supports adMovePrevious: " & b

   b = rs.Supports(adNotify)
   Console.WriteLine vbTab & "Supports adNotify: " & b

   b = rs.Supports(adUpdate)
   Console.WriteLine vbTab & "Supports adUpdate: " & b

   b = rs.Supports(adUpdateBatch)
   Console.WriteLine vbTab & "Supports adUpdateBatch: " & b

Cleanup:
   rs.Close
   If conn.State = adStateOpen Then
      conn.Close
   End If
End Sub

Private Sub ImmediateRecordsetUpdateTest()
   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim rs As New ADODB.Recordset
   With rs
      Set .ActiveConnection = conn
      .source = "SELECT ua.* FROM USER_ACCOUNT ua"
      .CursorType = adOpenDynamic
      .Open LockType:=adLockOptimistic
   End With

   rs.MoveFirst
   ' update failed sometimes due to provider issues,
   ' SQL Server works but oracle does not
   Do While Not rs.EOF
      rs("FULLNAME").Value = "SELECT"
      rs.Update "NAME", "SELECT"
      rs.MoveNext
   Loop

End Sub

Private Sub SimpleCommandTest()
   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim cmd As New ADODB.Command
   cmd.CommandText = "UPDATE USER_ACCOUNT SET name = ? WHERE id = ?" ' only positional parameters are supported

   Dim p As ADODB.Parameter
   ' length is required for variable length
   Set p = cmd.CreateParameter("Name", DataTypeEnum.adVarChar, ParameterDirectionEnum.adParamInput, 30, Left(TestDBConnectionString, 30))
   cmd.Parameters.Append p
   Set p = cmd.CreateParameter("Id", DataTypeEnum.adInteger, ParameterDirectionEnum.adParamInput, , 4)
   cmd.Parameters.Append p

   Set cmd.ActiveConnection = conn
   cmd.Execute

Cleanup:
   If conn.State = adStateOpen Then
      conn.Close
   End If
End Sub

Private Sub SimpleReadTest()
   Dim conn As New ADODB.Connection
   Dim rs As New ADODB.Recordset

   conn.ConnectionString = TestDBConnectionString
   conn.Open

   With rs
      Set .ActiveConnection = conn
      .source = "SELECT * FROM information_schema.TABLES"
      .CursorLocation = adUseClient
      .Open
   End With

   Console.WriteLine ": " & rs.RecordCount
   If rs.RecordCount > 0 Then
      rs.MoveFirst

      Dim col() As String
      ReDim col(rs.Fields.Count)
      Dim idx As Integer
      Dim fi As Object
      For idx = 0 To rs.Fields.Count - 1
         Set fi = rs.Fields(idx)
         Dim vs As String
         Dim vt As String
         If IsNull(fi.Value) Then
            vs = ""
            vt = "Null"
         Else
            vs = CStr(fi.Value)
            vt = TypeName(fi.Value)
         End If
         col(idx) = fi.Name & vbTab & vs & vbTab & fi.Type & vbTab & vt
      Next

      Dim colsString As String
      colsString = Join(col, vbCrLf)
      Console.WriteLine "information_schema.tables columns: " & colsString
   End If


   Dim cmd As New ADODB.Command
   cmd.CommandText = "SELECT * FROM information_schema.TABLES"
   cmd.CommandType = adCmdText
   Set cmd.ActiveConnection = conn
   Dim rs2 As ADODB.Recordset
   Set rs2 = cmd.Execute

   Console.WriteLine "TABLES ROW: " & rs.RecordCount
   If rs.RecordCount > 0 Then
      rs.MoveFirst

      Console.WriteLine "SQL Server tables: " & rs("TABLE_NAME")
   End If

Cleanup:
   rs.Close
   rs2.Close
   If conn.State & adStateOpen Then
      conn.Close
   End If
End Sub