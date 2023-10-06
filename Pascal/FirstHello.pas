{$MODE OBJFPC}
{$codepage UTF8}
program FirstHello;

(* why called PascalCase *)

type
   HelloMessage =  record
                      Target : UTF8String;
                   end;

const
   (* dobule quotes are not used for strings or characters *)
   First                 = 'First';
   My                    = 'My';
   HelloWord             = 'Hello';
   ChineseOutputConst    = '中文输出';
   Message: HelloMessage = (Target: 'My World');
   Alfabetica: array[1..26] of char =
   ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');

var
   ChineseOutput : AnsiString;

begin
   WriteLn('My First hello');
   ChineseOutput := ChineseOutputConst;
   WriteLn(ChineseOutput);
end.
