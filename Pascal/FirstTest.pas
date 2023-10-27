{$mode objfpc}{$J-}
program FirstTest;

uses
    cwstring,
    Classes,
    fpcunit,
    testutils,
    testregistry,
    consoletestrunner,
    SysUtils;

type
   TFirstTest = class(TTestCase)
   published
             procedure SampleTest;
   end;

procedure TFirstTest.SampleTest;
begin
   AssertTrue('SampleTest', True);
end;

var
   runner : TTestRunner;

begin
   RegisterTest(TFirstTest);

   try
       runner := TTestRunner.Create(nil);
       runner.Run;
   finally
       FreeAndNil(runner);
   end;
end.
