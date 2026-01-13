program pasta;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes,
  uTypes, uListUtils, uDispatcher,
  uCmdMath; // Подключаем математику, она сама зарегистрируется!

var
  InputLine, Command: String;
  CmdParts: TStringList;
  Head, Tail: PNode;

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
  WriteLn('Bye.');
end.
