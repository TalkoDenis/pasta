
Unit uListUtils;

{$mode objfpc}{$H+}

Interface

Uses SysUtils, Classes, uTypes;

Procedure LoadData(Args: TStringList; Var Head, Tail: PNode);
Procedure FreeList(Var Head: PNode);

Function CountNodes(Head: PNode): Integer;
Function GetNthValue(Head: PNode; Index: Integer): Double;

Implementation

Procedure AddValue(Var Head, Tail: PNode; Val: Double);

Var 
  NewNode: PNode;
Begin
  New(NewNode);
  NewNode^.Value := Val;
  NewNode^.Next := Nil;

  If Head = Nil Then
    Head := NewNode
  Else
    Tail^.Next := NewNode;

  Tail := NewNode;
End;


Procedure AddFromFile(FileName: String; Var Head, Tail: PNode);

Var 
  F: TextFile;
  Line: String;
  Val: Double;
Begin
  AssignFile(F, FileName);
  {$I-}
  Reset(F); {$I+}

  If IOResult <> 0 Then
    Begin
      WriteLn('Error: Cannot open file -> ', FileName);
      Exit;
    End;

  While Not Eof(F) Do
    Begin
      ReadLn(F, Line);
      If TryStrToFloat(Trim(Line), Val) Then
        AddValue(Head, Tail, Val);
    End;
  CloseFile(F);
End;


Procedure LoadData(Args: TStringList; Var Head, Tail: PNode);

Var 
  i: Integer;
  Token: String;
  Val: Double;
Begin
  For i := 1 To Args.Count - 1 Do
    Begin
      Token := Args[i];

      If FileExists(Token) Then
        AddFromFile(Token, Head, Tail)
      Else If TryStrToFloat(Token, Val) Then
             AddValue(Head, Tail, Val)
      Else
        WriteLn('Warning: Skipped -> ', Token);
    End;
End;


Procedure FreeList(Var Head: PNode);

Var 
  Temp: PNode;
Begin
  While Head <> Nil Do
    Begin
      Temp := Head;
      Head := Head^.Next;
      Dispose(Temp);
    End;
End;


Function CountNodes(Head: PNode): Integer;
Begin
  Result := 0;
  While Head <> Nil Do
    Begin
      Inc(Result);
      Head := Head^.Next;
    End;
End;

Function GetNthValue(Head: PNode; Index: Integer): Double;

Var i: Integer;
Begin
  For i := 0 To Index - 1 Do
    Begin
      If Head = Nil Then Exit(0.0);
      Head := Head^.Next;
    End;
  If Head <> Nil Then Result := Head^.Value
  Else Result := 0.0;
End;

End.
