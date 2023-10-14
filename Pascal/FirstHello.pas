{$MODE OBJFPC}{$J-}
program FirstHello;

(* why called PascalCase *)
Uses
    sysutils,
    cwstring;


procedure ConstParameterProc(const A : Integer);
begin
   WriteLn('A + 10 is: ', A + 10);
end;

type
   HelloMessage =  record
                      Target : String;
                   end;

const
   (* dobule quotes are not used for strings or characters *)
   First                 = 'First';
   My                    = 'My';
   HelloWord             = 'Hello';
   ChineseOutputConst    = '中文输出'; { the compiler sees as CP_ACP and no conversion to UTF-16 in the binary object }
   Message: HelloMessage = (Target: 'My World');
   Alfabetica: array[1..26] of char =
   ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');

var
   ChineseOutput : AnsiString;
   UTF8Output    : UTF8String;
   WideOutput    : WideString;
   ShortOutput   : ShortString;

begin
   ConstParameterProc(10);

   Write(Format('%s %d %s', ['DefaultSystemCodePage: ', DefaultSystemCodePage, LineEnding]));

   ChineseOutput := ChineseOutputConst;
   WriteLn(ChineseOutput);

   UTF8Output := ChineseOutputConst;
   WriteLn(UTF8Output);

   WideOutput := ChineseOutputConst;
   WriteLn(WideOutput);

   ShortOutput := ChineseOutputConst;
   WriteLn(ShortOutput);
end.
