unit uCmdMath;

{$mode objfpc}{$H+}

interface
uses uTypes, uDispatcher, Math;

implementation

// =========================================================
// 1. ВАЛИДАТОР (Единая точка проверки)
// =========================================================
// Возвращает TRUE, если данные есть.
// Если данных нет, сама пишет ошибку и возвращает FALSE.
function HasData(Head: PNode): Boolean;
begin
  if Head = nil then
  begin
    WriteLn('  Error: No data loaded.');
    Result := False;
  end
  else
    Result := True;
end;

// =========================================================
// 2. ЧИСТАЯ МАТЕМАТИКА (LOGIC)
// =========================================================
// Внимание: Эти функции больше не проверяют Head на nil.
// Мы гарантируем (Контракт), что вызываем их только если HasData = True.

function GetMin(Head: PNode): Double;
begin
  // Мы сразу берем значение, так как знаем, что список не пуст
  Result := Head^.Value;
  Head := Head^.Next;
  
  while Head <> nil do 
  begin
    if Head^.Value < Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

function GetMax(Head: PNode): Double;
begin
  Result := Head^.Value;
  Head := Head^.Next;
  
  while Head <> nil do 
  begin
    if Head^.Value > Result then Result := Head^.Value;
    Head := Head^.Next;
  end;
end;

// Процедура считает сразу и Среднее, и Отклонение (оптимизация прохода)
procedure GetAvgStd(Head: PNode; out Avg, Std: Double);
var 
  Sum, SumSq, Val: Double; 
  Count: Integer;
begin
  Sum := 0; SumSq := 0; Count := 0;
  
  while Head <> nil do 
  begin
    Val := Head^.Value;
    Sum := Sum + Val;
    SumSq := SumSq + (Val * Val);
    Inc(Count);
    Head := Head^.Next;
  end;
  
  // Деление на Count (мы знаем, что Count > 0, благодаря HasData)
  Avg := Sum / Count;
  
  if Count > 1 then
    Std := Sqrt((SumSq - (Sqr(Sum)/Count)) / (Count - 1))
  else 
    Std := 0.0;
end;

// =========================================================
// 3. ОБРАБОТЧИКИ (UI)
// =========================================================
// Теперь они выглядят одинаково и чисто.

procedure HandleMin(Head: PNode);
begin
  if not HasData(Head) then Exit; // <-- Одна проверка
  WriteLn('  Minimum: ', GetMin(Head):0:4);
end;

procedure HandleMax(Head: PNode);
begin
  if not HasData(Head) then Exit;
  WriteLn('  Maximum: ', GetMax(Head):0:4);
end;

procedure HandleAvg(Head: PNode);
var Avg, Std: Double;
begin
  if not HasData(Head) then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Average: ', Avg:0:4);
end;

procedure HandleStd(Head: PNode);
var Avg, Std: Double;
begin
  if not HasData(Head) then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Std Dev: ', Std:0:4);
end;

// =========================================================
// 4. РЕГИСТРАЦИЯ
// =========================================================
initialization
  RegisterCommand('min', 'Find minimum value', @HandleMin);
  RegisterCommand('max', 'Find maximum value', @HandleMax);
  RegisterCommand('avg', 'Calculate average',  @HandleAvg);
  RegisterCommand('std', 'Standard deviation', @HandleStd);

end.
