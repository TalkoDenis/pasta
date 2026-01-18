unit uDispatcher;

{$mode objfpc}{$H+}

interface
uses uTypes;

type
  TCommandProc = procedure(Head: PNode);

  PCommandNode = ^TCommandNode;

  TCommandNode = record
    Name: String;
    Description: String;
    Proc: TCommandProc;
    Next: PCommandNode;
  end;

procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);
function ExecuteCommand(Name: String; Head: PNode): Boolean;
procedure PrintHelp(Head: PNode);

implementation

var
  CommandListHead: PCommandNode = nil;
  CleanupTemp: PCommandNode;

procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);
var
  NewCmd: PCommandNode;
begin
  New(NewCmd);
  NewCmd^.Name := LowerCase(Name);
  NewCmd^.Description := Desc;
  NewCmd^.Proc := Proc;
  
  NewCmd^.Next := CommandListHead;
  CommandListHead := NewCmd;
end;


function ExecuteCommand(Name: String; Head: PNode): Boolean;
var
  Current: PCommandNode;
begin
  Name := LowerCase(Name);
  Result := False;
  Current := CommandListHead;
  while Current <> nil do
    begin
      if Current^.Name = Name then
        begin
          Current^.Proc(Head);
          Exit(True);
        end;
    Current := Current^.Next;
    end;
end;


procedure PrintHelp(Head: PNode);
var
  Current: PCommandNode;
begin
  WriteLn('Available commands:');
  Current := CommandListHead;
  while Current <> nil do
    begin
      WriteLn('  ', Current^.Name, ' : ', Current^.Description);
      Current := Current^.Next;
    end;
end;


initialization
  RegisterCommand('help', 'Show command list', @PrintHelp);

finalization
  while CommandListHead <> nil do
    begin
      CleanupTemp := CommandListHead;
      CommandListHead := CommandListHead^.Next;
      Dispose(CleanupTemp);
    end;

end.
