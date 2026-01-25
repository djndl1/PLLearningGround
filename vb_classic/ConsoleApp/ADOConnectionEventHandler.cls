VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ADOConnectionEventHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Option Explicit

Private WithEvents source As ADODB.Connection

Public Sub Subscribe(src As ADODB.Connection)
   Set source = src
End Sub

Public Sub Unsubscribe()
   Set source = Nothing
End Sub



Private Sub source_ConnectComplete(ByVal pError As ADODB.Error, _
                                   adStatus As ADODB.EventStatusEnum, _
                                   ByVal conn As ADODB.Connection)
   Console.WriteLine "Connected to test Database: " _
          &  conn.Properties("DBMS Name") & " " & _
          conn.Properties("DBMS Version") & " " & _
          conn.Properties("Data Source Name")

   Console.WriteLine "State: " & conn.State  & " Mode: " & conn.Mode

   Console.WriteLine "Provider: " & conn.Properties("Provider Name") _
          & " " & conn.Properties("Provider Friendly Name")  _
          & " " & conn.Properties("Provider Version")
   Console.WriteLine "Conncted through ODBC " & conn.Properties("Driver ODBC Version")  _
             & " " & conn.Properties("Driver Name")  _
             & " " & conn.Properties("SQL Grammar Support")
End Sub


Private Sub source_Disconnect(adStatus As ADODB.EventStatusEnum, _
                              ByVal conn As ADODB.Connection)
   Console.WriteLine "Disconnected: " + adStatus
   Console.WriteLine "State: " & conn.State  & " Mode: " & conn.Mode
End Sub