unit uDispatcher;

{$mode objfpc}{$H+}

interface
uses uTypes;

type
  // Контракт для всех команд: процедура, принимающая список
  TCommandProc = procedure(Head: PNode);

  TCommandEntry = record
    Name: String;
    Description: String;
    Proc: TCommandProc;
  end;

procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);
function ExecuteCommand(Name: String; Head: PNode): Boolean;
procedure PrintHelp; // Публичная, чтобы Handlers могли её вызывать

implementation

var
  CommandTable: array of TCommandEntry;

procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);
var Idx: Integer;
begin
  Idx := Length(CommandTable);
  SetLength(CommandTable, Idx + 1);
  CommandTable[Idx].Name := LowerCase(Name);
  CommandTable[Idx].Description := Desc;
  CommandTable[Idx].Proc := Proc;
end;

function ExecuteCommand(Name: String; Head: PNode): Boolean;
var i: Integer;
begin
  Name := LowerCase(Name);
  Result := False;
  for i := 0 to High(CommandTable) do
  begin
    if CommandTable[i].Name = Name then
    begin
      CommandTable[i].Proc(Head); // Вызов по указателю
      Exit(True);
    end;
  end;
end;

procedure PrintHelp;
var i: Integer;
begin
  WriteLn('Available commands:');
  for i := 0 to High(CommandTable) do
    WriteLn('  ', CommandTable[i].Name, ' : ', CommandTable[i].Description);
end;

end.
