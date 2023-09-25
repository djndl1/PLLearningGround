Attribute VB_Name = "ADOTest"
Option Explicit

Private Const TestDBConnectionString As String = "Driver={Oracle in oracle_instant_client};" _
       & "DBQ=10.10.0.3:1521/pdbmgyard.cisdi.com.cn;Uid=djn;Pwd=freebird;"

Public Sub Run()
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
   hndler.Unsubscribe
End Sub

Private Sub DisplayRecordSetFeaturesTest()
   Console.WriteLine "Dynamic Cursor"
   DisplayRecordSetFeatures adOpenDynamic

   Console.WriteLine "KeySet Cursor"
   DisplayRecordSetFeatures adOpenKeySet

   Console.WriteLine "Static Cursor"
   DisplayRecordSetFeatures adOpenStatic

   Console.WriteLine "Forward-Only Cursor"
   DisplayRecordSetFeatures adOpenForwardOnly
End Sub

Private Sub DisplayRecordSetFeatures(cursorTyp As CursorTypeEnum)
   On Error GoTo CleanUp

   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim rs As New ADODB.Recordset
   With rs
      Set .ActiveConnection = conn
      .Source = "SELECT * FROM SQLALCHEMY.USER_ACCOUNT"
      .CursorType = cursorTyp
      .Open LockType := adLockOptimistic
   End With

   Dim b As Boolean
   b = rs.Supports(adAddNew)
   Console.WriteLine "Supports adAddNew: " & CStr(b)

   b = rs.Supports(adApproxPosition)
   Console.WriteLine "Supports adApproxPosition: " & CStr(b)

   b = rs.Supports(adBookmark)
   Console.WriteLine "Supports adBookmark: " & CStr(b)

   b = rs.Supports(adDelete)
   Console.WriteLine "Supports adDelete: " & CStr(b)

   b = rs.Supports(adFind)
   Console.WriteLine "Supports adFind: " & CStr(b)

   b = rs.Supports(adHoldRecords)
   Console.WriteLine "Supports adHoldRecords: " & CStr(b)

   b = rs.Supports(adMovePrevious)
   Console.WriteLine "Supports adMovePrevious: " & CStr(b)

   b = rs.Supports(adNotify)
   Console.WriteLine "Supports adNotify: " & CStr(b)

   b = rs.Supports(adUpdate)
   Console.WriteLine "Supports adUpdate: " & CStr(b)

   b = rs.Supports(adUpdateBatch)
   Console.WriteLine "Supports adUpdateBatch: " & CStr(b)

CleanUp:
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
      .Source = "SELECT ROWID, ua.* FROM SQLALCHEMY.USER_ACCOUNT ua"
      .CursorType = adOpenDynamic
      .Open LockType := adLockOptimistic
   End With

   rs.MoveFirst
   ' update failed probably due to ODBC provider, better use an explicit command to avoid locking
   Do While Not rs.EOF
      'rs("FULL_NAME").Value = "SELECT"
      'rs.Update "NAME", "SELECT"
      rs.MoveNext
   Loop

End Sub

Private Sub SimpleCommandTest()
   Dim conn As New ADODB.Connection
   conn.ConnectionString = TestDBConnectionString
   conn.Open

   Dim cmd As New ADODB.Command
   cmd.CommandText = "UPDATE SQLALCHEMY.USER_ACCOUNT SET name = ? WHERE id = ?" ' only positional parameters are supported

   Dim p As ADODB.Parameter
   ' length is required for variable length
   Set p = cmd.CreateParameter("Name", DataTypeEnum.adVarChar, ParameterDirectionEnum.adParamInput, 30, Left(TestDBConnectionString, 30))
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
      colsString = Join(col, vbCrlf)
      Console.WriteLine "V$INSTANCE COLUMNS: " & colsString
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

      Console.WriteLine "Oracle Instance: " & rs("INSTANCE_NAME")
   End If

Cleanup:
   rs.Close
   rs2.Close
   If conn.State & adStateOpen Then
      conn.Close
   End If
End Sub
