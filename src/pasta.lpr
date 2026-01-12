program pasta;

{$mode objfpc}{$H+}

uses
  SysUtils, Classes,
  uTypes, uListUtils, uDispatcher, uHandlers;

var
  InputLine: String;
  CmdParts: TStringList;
  Command: String;
  Head, Tail: PNode;

// Настройка реестра
procedure Setup;
begin
  RegisterCommand('help',  'Show command list', @HandleHelp);
  RegisterCommand('avg',   'Calculate average', @HandleAvg);
  RegisterCommand('min',   'Find minimum value', @HandleMin);
  RegisterCommand('max',   'Find maximum value', @HandleMax);
  RegisterCommand('range', 'Calculate range',    @HandleRange);
  
  WriteLn('Pasta vFinal (Architecture Ready)');
  WriteLn('Type "help" to start.');
end;

begin
  Setup;

  CmdParts := TStringList.Create;
  CmdParts.Delimiter := ' ';
  CmdParts.StrictDelimiter := True;

  // --- REPL LOOP ---
  repeat
    Write('pasta> ');
    ReadLn(InputLine);
    
    if Trim(InputLine) = '' then Continue;

    CmdParts.DelimitedText := InputLine;
    Command := CmdParts[0];

    if LowerCase(Command) = 'exit' then Break;

    // 1. Инициализация списка (обнуление указателей)
    Head := nil; Tail := nil;

    // 2. Загрузка данных (если есть аргументы)
    if CmdParts.Count > 1 then
      LoadData(CmdParts, Head, Tail);

    // 3. Выполнение команды через диспетчер
    if not ExecuteCommand(Command, Head) then
      WriteLn('  Unknown command: ', Command);

    // 4. Очистка памяти списка (важно!)
    FreeList(Head);

  until False;

  CmdParts.Free;
  if Head <> nil then FreeList(Head);
  
  WriteLn('Bye.');
end.
