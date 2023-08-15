Get-ChildItem -Path $env:windir/*.log | 
Select-String -List error |
Format-Table Path,LineNumber -AutoSize