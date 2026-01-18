unit uCmdMath;

{$mode objfpc}{$H+}

interface
uses uTypes, uDispatcher, Math, uListUtils, uAlgo, SysUtils;

implementation

// Here checks what kind of data there is and what shoud to show:
// integer or float.
function FormatVal(Val: Double): String;
begin
  if Abs(Val - Round(Val)) < 0.000001 then
    Result := IntToStr(Round(Val)) // It's Int
  else
    Result := Format('%.4f', [Val]); // It's Float 
end;


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


function GetMin(Head: PNode): Double;
begin
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

// Here gets Averege and Std values
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
  
  // Because of HasData func we may get Count (Count > 0)
  Avg := Sum / Count;
  
  if Count > 1 then
    Std := Sqrt((SumSq - (Sqr(Sum)/Count)) / (Count - 1))
  else 
    Std := 0.0;
end;


function GetMedian(Head: PNode): Double;
var Count: Integer;
begin
  SortList(Head);
  
  Count := CountNodes(Head);
  
  if Count = 0 then Exit(0.0);

  if (Count mod 2) = 1 then
    Result := GetNthValue(Head, Count div 2)
  else
    Result := (GetNthValue(Head, (Count div 2) - 1) + GetNthValue(Head, Count div 2)) / 2.0;
end;

procedure HandleMedian(Head: PNode);
begin
  if not HasData(Head) then Exit;
  WriteLn('  Median:  ', FormatVal(GetMedian(Head)));
end;


procedure HandleMin(Head: PNode);
begin
  if not HasData(Head) then Exit; 
  WriteLn('  Minimum: ', FormatVal(GetMin(Head)));
end;


procedure HandleMax(Head: PNode);
begin
  if not HasData(Head) then Exit;
  WriteLn('  Maximum: ', FormatVal(GetMax(Head)));
end;

procedure HandleAvg(Head: PNode);
var Avg, Std: Double;
begin
  if not HasData(Head) then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Average: ', FormatVal(Avg));
end;

procedure HandleStd(Head: PNode);
var Avg, Std: Double;
begin
  if not HasData(Head) then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Std Dev: ', FormatVal(Std));
end;


initialization
  RegisterCommand('min', 'Find minimum value', @HandleMin);
  RegisterCommand('max', 'Find maximum value', @HandleMax);
  RegisterCommand('avg', 'Calculate average',  @HandleAvg);
  RegisterCommand('std', 'Standard deviation', @HandleStd);
  RegisterCommand('median', 'Median (Warning: Sorts data)', @HandleMedian);

end.
