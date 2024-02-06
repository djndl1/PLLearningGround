VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command6 
      Caption         =   "ConnectToOracle"
      Height          =   495
      Left            =   480
      TabIndex        =   6
      Top             =   2280
      Width           =   2535
   End
   Begin VB.CommandButton Command5 
      Caption         =   "datetime"
      Height          =   375
      Left            =   2280
      TabIndex        =   5
      Top             =   1680
      Width           =   1575
   End
   Begin VB.CommandButton Command4 
      Caption         =   "StringBuilder"
      Height          =   255
      Left            =   360
      TabIndex        =   4
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton Command3 
      Caption         =   "randomTest"
      Height          =   375
      Left            =   1920
      TabIndex        =   3
      Top             =   1080
      Width           =   2295
   End
   Begin VB.CommandButton Command2 
      Caption         =   "HashTable"
      Height          =   255
      Left            =   360
      TabIndex        =   2
      Top             =   960
      Width           =   975
   End
   Begin VB.CommandButton ArrayListButton 
      Caption         =   "ArrayList"
      Height          =   255
      Left            =   2520
      TabIndex        =   1
      Top             =   360
      Width           =   1695
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   495
      Left            =   480
      TabIndex        =   0
      Top             =   240
      Width           =   1335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub ArrayListButton_Click()
    ClrTypes.testArrayList
End Sub

Private Sub Command1_Click()
    Dim httpclient As New HttpClientRequest
    httpclient.init

    httpclient.httpRequest.Open "GET", "https://gorest.co.in/public/v2/users.xml"
    httpclient.httpRequest.SetRequestHeader "Accept", "application/json"
    httpclient.httpRequest.Send

    'Debug.Print httpclient.httpRequest.ResponseText

    If httpclient.httpRequest.Status = 200 Then
        Debug.Print httpclient.httpRequest.StatusText, Len(httpclient.httpRequest.ResponseText)
    End If
End Sub

Private Sub Command2_Click()
    ClrTypes.HashTableTest
End Sub

Private Sub Command3_Click()
    ClrTypes.randomTest
End Sub

Private Sub Command4_Click()
    ClrTypes.stringbuildertest
End Sub

Private Sub Command5_Click()
    ClrTypes.datetimetest
End Sub

Private Sub ConnectToOracle()
    Dim connectionString As String
    connectionString = "DSN=PDBMGYARD;Uid=mgyard;Pwd=mgyl1234;"

    Dim oracleConnection As ADODB.Connection
    Set oracleConnection = New ADODB.Connection
    oracleConnection.connectionString = connectionString
    oracleConnection.Open
    
    Dim result As ADODB.Recordset
    Dim affectedCount As Long
    Set result = oracleConnection.Execute("SELECT BANNER FROM v$version", affectedCount, 1 - adCmdText)
    
    result.MoveFirst
    
    Dim bannerField As ADODB.Field
    Set bannerField = result.Fields("BANNER")
    Debug.Print bannerField.Value
    
    result.Close
    oracleConnection.Close
End Sub

Private Sub Command6_Click()
    ConnectToOracle
End Sub
