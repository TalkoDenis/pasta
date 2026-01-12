unit uStats;

{$mode objfpc}{$H+}

interface
uses uTypes, Math;

function CalcAvg(Head: PNode): Double;
function CalcMin(Head: PNode): Double;
function CalcMax(Head: PNode): Double;
function CalcRange(Head: PNode): Double;

implementation

function CalcAvg(Head: PNode): Double;
var Sum: Double; Count: Integer;
begin
  Sum := 0; Count := 0;
  while Head <> nil do begin
    Sum := Sum + Head^.Value;
    Inc(Count);
    Head := Head^.Next;
  end;
  if Count = 0 then Exit(0.0);
  Result := Sum / Count;
end;

function CalcMin(Head: PNode): Double;
begin
  if Head = nil then Exit(0.0);
  Result := Head^.Value;
  // Ищем минимум
  while Head <> nil do begin
    if Head^.Value < Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

function CalcMax(Head: PNode): Double;
begin
  if Head = nil then Exit(0.0);
  Result := Head^.Value;
  // Ищем максимум
  while Head <> nil do begin
    if Head^.Value > Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

function CalcRange(Head: PNode): Double;
begin
  Result := CalcMax(Head) - CalcMin(Head);
end;

end.
