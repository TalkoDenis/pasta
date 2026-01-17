program pasta;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes,
  uTypes, uListUtils, uDispatcher,
  uCmdMath;

var
  InputLine, Command: String;
  CmdParts: TStringList;
  Head, Tail: PNode;
  
  // ИЗМЕНЕНИЕ 1: Используем TFPCHeapStatus вместо THeapStatus
  MemStatus: TFPCHeapStatus;

begin
  WriteLn('Pasta v5.0 (Plugin Architecture)');
  WriteLn('Type "help" to start.');

  CmdParts := TStringList.Create;
  CmdParts.Delimiter := ' ';
  CmdParts.StrictDelimiter := True;

  repeat
    Write('pasta> ');
    ReadLn(InputLine);
    if Trim(InputLine) = '' then Continue;

    CmdParts.DelimitedText := InputLine;
    Command := CmdParts[0];

    if LowerCase(Command) = 'exit' then Break;

    Head := nil; Tail := nil;
    if CmdParts.Count > 1 then LoadData(CmdParts, Head, Tail);

    if not ExecuteCommand(Command, Head) then
      WriteLn('  Unknown command: ', Command);

    FreeList(Head);
  until False;

  CmdParts.Free;
  if Head <> nil then FreeList(Head);
  
  // ИЗМЕНЕНИЕ 2: Вызываем GetFPCHeapStatus
  MemStatus := GetFPCHeapStatus;
  
  WriteLn('--------------------------------');
  WriteLn('Statistics:');
  // CurrHeapUsed - сколько занято прямо сейчас
  WriteLn('  Current Memory : ', MemStatus.CurrHeapUsed, ' bytes');
  WriteLn('  Current Memory : ', MemStatus.CurrHeapUsed / 1024:0:2, ' KB');
  // MaxHeapUsed - сколько было занято на пике нагрузки
  WriteLn('  Peak Usage     : ', MemStatus.MaxHeapUsed, ' bytes');
  
  WriteLn('  Peak Usage     : ', MemStatus.MaxHeapUsed / 1024:0:2, ' KB');
  WriteLn('--------------------------------');
  WriteLn('Bye.');
end.
