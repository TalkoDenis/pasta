
Program pasta;

{$mode objfpc}{$H+}

Uses 
SysUtils, Classes,
uTypes, uListUtils, uDispatcher,
uCmdMath;

Var 
  InputLine, Command: String;
  CmdParts: TStringList;
  Head, Tail: PNode;
  MemStatus: TFPCHeapStatus;

Begin
  WriteLn('Pasta v0.1');
  WriteLn('Type "help" to start.');

  CmdParts := TStringList.Create;
  CmdParts.Delimiter := ' ';
  CmdParts.StrictDelimiter := True;

  // Main code.
  Repeat
    Write('pasta> ');
    ReadLn(InputLine);
    If Trim(InputLine) = '' Then Continue;

    CmdParts.DelimitedText := InputLine;
    Command := CmdParts[0];

    If LowerCase(Command) = 'exit' Then Break;

    Head := Nil;
    Tail := Nil;
    If CmdParts.Count > 1 Then LoadData(CmdParts, Head, Tail);

    If Not ExecuteCommand(Command, Head) Then
      WriteLn('  Unknown command: ', Command);

    FreeList(Head);
  Until False;

  CmdParts.Free;
  If Head <> Nil Then FreeList(Head);

  MemStatus := GetFPCHeapStatus;

  WriteLn('--------------------------------');
  WriteLn('Statistics:');
  WriteLn('  Current Memory : ', MemStatus.CurrHeapUsed, ' bytes');
  WriteLn('  Current Memory : ', MemStatus.CurrHeapUsed / 1024:0:2, ' KB');
  WriteLn('  Peak Usage     : ', MemStatus.MaxHeapUsed, ' bytes');
  WriteLn('  Peak Usage     : ', MemStatus.MaxHeapUsed / 1024:0:2, ' KB');
  WriteLn('--------------------------------');
  WriteLn('Bye.');
End.
