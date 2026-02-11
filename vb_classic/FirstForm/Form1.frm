VERSION 5.00
Begin VB.Form MainForm 
   Caption         =   "Rectangle Form"
   ClientHeight    =   2475
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5805
   LinkTopic       =   "Form1"
   ScaleHeight     =   2475
   ScaleWidth      =   5805
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton CommandEvaluate 
      Caption         =   "&Evaluate"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Index           =   0
      Left            =   3000
      TabIndex        =   9
      Top             =   960
      Width           =   1335
   End
   Begin VB.TextBox txtWidth 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   2055
   End
   Begin VB.TextBox txtPerimeter 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   3600
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   480
      Width           =   2055
   End
   Begin VB.TextBox txtHeight 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   120
      TabIndex        =   5
      Top             =   1680
      Width           =   2055
   End
   Begin VB.TextBox txtArea 
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   3600
      Locked          =   -1  'True
      TabIndex        =   7
      Top             =   1680
      Width           =   2055
   End
   Begin VB.CommandButton CommandEvaluate 
      Caption         =   "&Evaluate"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Index           =   5
      Left            =   1560
      TabIndex        =   8
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label labelArea 
      Caption         =   "&Area"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   3600
      TabIndex        =   6
      Top             =   1440
      Width           =   1095
   End
   Begin VB.Label labelHeight 
      Caption         =   "&Height"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   1440
      Width           =   1095
   End
   Begin VB.Label LabelPerimeter 
      Caption         =   "&Perimeter"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   3600
      TabIndex        =   2
      Top             =   240
      Width           =   1095
   End
   Begin VB.Label labelWidth 
      Caption         =   "&Width"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "MainForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CommandEvaluate_Click(Index As Integer)
    ' Declare two floating point variables.
    Dim reWidth As Double, reHeight As Double
    On Error GoTo InvalidInputDimensions
    ' Extract values from input TextBox controls.
    reWidth = CDbl(txtWidth.Text)
    reHeight = CDbl(txtHeight.Text)
    If reWidth <= 0 Or reHeight <= 0 Then
        GoTo InvalidInputDimensions
    End If
    ' Evaluate results and assign to output text boxes.
    txtPerimeter.Text = CStr((reWidth + reHeight) * 2)
    txtArea.Text = CStr(reWidth * reHeight)
    Exit Sub
InvalidInputDimensions:
    Call MsgBox("Please input valid height and width", vbExclamation)
End Sub

Private Sub txtHeight_Validate(Cancel As Boolean)
    On Error GoTo InvalidInputDimensions
    Dim h As Double
    h = CDbl(txtHeight.Text)
    If h <= 0 Then
        GoTo InvalidInputDimensions
    End If
    Exit Sub
InvalidInputDimensions:
    Cancel = True
    Call MsgBox("Please input valid height", vbExclamation)
End Sub

Private Sub txtWidth_Validate(Cancel As Boolean)
    On Error GoTo InvalidInputDimensions
    Dim h As Double
    h = CDbl(txtWidth.Text)
    If h <= 0 Then
        GoTo InvalidInputDimensions
    End If
    Exit Sub
InvalidInputDimensions:
    Cancel = True
    Call MsgBox("Please input valid width", vbExclamation)
End Sub

Private Sub MainForm_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    ' You can't close this form without validating all the fields on it.
    If UnloadMode = vbFormControlMenu Then
        On Error Resume Next
        Dim ctrl As Control
        ' Give the focus to each control on the form, and then
        ' validate it.
        For Each ctrl In Controls
            Err.Clear
            ctrl.SetFocus
            If Err = 0 Then
                ' Don't validate controls that can't receive input focus.
                ValidateControls
                If Err = 380 Then
                    ' Validation failed, refuse to close.
                    Cancel = True: Exit Sub
                End If
            End If
        Next
    End If
End Sub
Private Sub txtHeight_Change()
    txtPerimeter.Text = ""
    txtArea.Text = ""
End Sub

Private Sub txtWidth_Change()
    txtPerimeter.Text = ""
    txtArea.Text = ""
End Sub
