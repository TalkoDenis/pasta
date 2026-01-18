unit uListUtils;

{$mode objfpc}{$H+}

interface

uses SysUtils, Classes, uTypes;

procedure LoadData(Args: TStringList; var Head, Tail: PNode);
procedure FreeList(var Head: PNode);

function CountNodes(Head: PNode): Integer;
function GetNthValue(Head: PNode; Index: Integer): Double;

implementation

procedure AddValue(var Head, Tail: PNode; Val: Double);
var
  NewNode: PNode;
begin
  New(NewNode);           
  NewNode^.Value := Val;
  NewNode^.Next := nil;

  if Head = nil then
    Head := NewNode
  else
    Tail^.Next := NewNode; 
    
  Tail := NewNode;         
end;


procedure AddFromFile(FileName: String; var Head, Tail: PNode);
var
  F: TextFile;
  Line: String;
  Val: Double;
begin
  AssignFile(F, FileName);
  {$I-} Reset(F); {$I+} 
  
  if IOResult <> 0 then 
  begin
    WriteLn('Error: Cannot open file -> ', FileName);
    Exit;
  end;

  while not Eof(F) do
    begin
      ReadLn(F, Line);
      if TryStrToFloat(Trim(Line), Val) then
        AddValue(Head, Tail, Val);
    end;
  CloseFile(F);
end;


procedure LoadData(Args: TStringList; var Head, Tail: PNode);
var
  i: Integer;
  Token: String;
  Val: Double;
begin
  for i := 1 to Args.Count - 1 do
    begin
      Token := Args[i];
    
      if FileExists(Token) then
        AddFromFile(Token, Head, Tail)
      else if TryStrToFloat(Token, Val) then
        AddValue(Head, Tail, Val)
      else
        WriteLn('Warning: Skipped -> ', Token);
    end;
end;


procedure FreeList(var Head: PNode);
var
  Temp: PNode;
begin
  while Head <> nil do
    begin
      Temp := Head;       
      Head := Head^.Next; 
      Dispose(Temp);      
    end;
end;


function CountNodes(Head: PNode): Integer;
begin
  Result := 0;
  while Head <> nil do
     begin
      Inc(Result);
      Head := Head^.Next;
    end;
end;

function GetNthValue(Head: PNode; Index: Integer): Double;
var i: Integer;
begin
  for i := 0 to Index - 1 do
    begin
      if Head = nil then Exit(0.0);
      Head := Head^.Next;
    end;
  if Head <> nil then Result := Head^.Value else Result := 0.0;
end;

end.
