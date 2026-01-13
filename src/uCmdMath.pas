unit uCmdMath;

{$mode objfpc}{$H+}

interface
// Нам не нужно ничего выносить в interface, 
// так как модуль регистрирует себя сам!
uses uTypes, uDispatcher, Math;

implementation

// === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (ЛОГИКА) ===

function GetMin(Head: PNode): Double;
begin
  if Head = nil then Exit(0.0);
  Result := Head^.Value;
  Head := Head^.Next;
  while Head <> nil do begin
    if Head^.Value < Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

function GetMax(Head: PNode): Double;
begin
  if Head = nil then Exit(0.0);
  Result := Head^.Value;
  Head := Head^.Next;
  while Head <> nil do begin
    if Head^.Value > Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

procedure GetAvgStd(Head: PNode; out Avg, Std: Double);
var Sum, SumSq, Val: Double; Count: Integer;
begin
  Sum := 0; SumSq := 0; Count := 0;
  while Head <> nil do begin
    Val := Head^.Value;
    Sum := Sum + Val;
    SumSq := SumSq + (Val * Val);
    Inc(Count);
    Head := Head^.Next;
  end;
  
  if Count > 0 then Avg := Sum / Count else Avg := 0;
  
  if Count > 1 then
    Std := Sqrt((SumSq - (Sqr(Sum)/Count)) / (Count - 1))
  else Std := 0;
end;

// === ОБРАБОТЧИКИ (UI) ===

procedure HandleMin(Head: PNode);
begin
  if Head = nil then WriteLn('  No data.')
  else WriteLn('  Minimum: ', GetMin(Head):0:4);
end;

procedure HandleMax(Head: PNode);
begin
  if Head = nil then WriteLn('  No data.')
  else WriteLn('  Maximum: ', GetMax(Head):0:4);
end;

procedure HandleAvg(Head: PNode);
var Avg, Std: Double;
begin
  if Head = nil then WriteLn('  No data.') else begin
    GetAvgStd(Head, Avg, Std);
    WriteLn('  Average: ', Avg:0:4);
  end;
end;

procedure HandleStd(Head: PNode);
var Avg, Std: Double;
begin
  if Head = nil then WriteLn('  No data.') else begin
    GetAvgStd(Head, Avg, Std);
    WriteLn('  Std Dev: ', Std:0:4);
  end;
end;

// === АВТОРЕГИСТРАЦИЯ ===
initialization
  RegisterCommand('min', 'Find minimum value', @HandleMin);
  RegisterCommand('max', 'Find maximum value', @HandleMax);
  RegisterCommand('avg', 'Calculate average',  @HandleAvg);
  RegisterCommand('std', 'Standard deviation', @HandleStd);

end.
