
Unit uDispatcher;

{$mode objfpc}{$H+}

Interface

Uses uTypes;

Type 
  TCommandProc = Procedure (Head: PNode);

  PCommandNode = ^TCommandNode;

  TCommandNode = Record
    Name: String;
    Description: String;
    Proc: TCommandProc;
    Next: PCommandNode;
  End;

Procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);
Function ExecuteCommand(Name: String; Head: PNode): Boolean;
Procedure PrintHelp(Head: PNode);

Implementation

Var 
  CommandListHead: PCommandNode = nil;
  CleanupTemp: PCommandNode;

Procedure RegisterCommand(Name, Desc: String; Proc: TCommandProc);

Var 
  NewCmd: PCommandNode;
Begin
  New(NewCmd);
  NewCmd^.Name := LowerCase(Name);
  NewCmd^.Description := Desc;
  NewCmd^.Proc := Proc;

  NewCmd^.Next := CommandListHead;
  CommandListHead := NewCmd;
End;


Function ExecuteCommand(Name: String; Head: PNode): Boolean;

Var 
  Current: PCommandNode;
Begin
  Name := LowerCase(Name);
  Result := False;
  Current := CommandListHead;
  While Current <> Nil Do
    Begin
      If Current^.Name = Name Then
        Begin
          Current^.Proc(Head);
          Exit(True);
        End;
      Current := Current^.Next;
    End;
End;


Procedure PrintHelp(Head: PNode);

Var 
  Current: PCommandNode;
Begin
  if Head = nil then ;
  WriteLn('Available commands:');
  Current := CommandListHead;
  While Current <> Nil Do
    Begin
      WriteLn('  ', Current^.Name, ' : ', Current^.Description);
      Current := Current^.Next;
    End;
End;


initialization
RegisterCommand('help', 'Show command list', @PrintHelp);

finalization
While CommandListHead <> Nil Do
  Begin
    CleanupTemp := CommandListHead;
    CommandListHead := CommandListHead^.Next;
    Dispose(CleanupTemp);
  End;

End.
