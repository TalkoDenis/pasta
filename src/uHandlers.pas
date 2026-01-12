unit uHandlers;

{$mode objfpc}{$H+}

interface
uses uTypes, uStats, uDispatcher;

procedure HandleAvg(Head: PNode);
procedure HandleMin(Head: PNode);
procedure HandleMax(Head: PNode);
procedure HandleRange(Head: PNode);
procedure HandleHelp(Head: PNode);

implementation

// Вспомогательная проверка
function CheckData(Head: PNode): Boolean;
begin
  if Head = nil then
  begin
    WriteLn('  Error: No data provided.');
    Result := False;
  end else Result := True;
end;

procedure HandleAvg(Head: PNode);
begin
  if CheckData(Head) then WriteLn('  Average: ', CalcAvg(Head):0:4);
end;

procedure HandleMin(Head: PNode);
begin
  if CheckData(Head) then WriteLn('  Minimum: ', CalcMin(Head):0:4);
end;

procedure HandleMax(Head: PNode);
begin
  if CheckData(Head) then WriteLn('  Maximum: ', CalcMax(Head):0:4);
end;

procedure HandleRange(Head: PNode);
begin
  if CheckData(Head) then WriteLn('  Range:   ', CalcRange(Head):0:4);
end;

procedure HandleHelp(Head: PNode);
begin
  uDispatcher.PrintHelp;
end;

end.
