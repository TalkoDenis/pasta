
Unit uCmdMath;

{$mode objfpc}{$H+}

Interface

Uses uTypes, uDispatcher, uListUtils, uAlgo, SysUtils;

Implementation

// Here checks what kind of data there is and what shoud to show:
// integer or float.
Function FormatVal(Val: Double): String;
Begin
  If Abs(Val - Round(Val)) < 0.000001 Then
    Result := IntToStr(Round(Val)) // It's Int
  Else
    Result := Format('%.4f', [Val]);
  // It's Float 
End;


Function HasData(Head: PNode): Boolean;
Begin
  If Head = Nil Then
    Begin
      WriteLn('  Error: No data loaded.');
      Result := False;
    End
  Else
    Result := True;
End;


Function GetMin(Head: PNode): Double;
Begin
  Result := Head^.Value;
  Head := Head^.Next;

  While Head <> Nil Do
    Begin
      If Head^.Value < Result Then Result := Head^.Value;
      Head := Head^.Next;
    End;
End;


Function GetMax(Head: PNode): Double;
Begin
  Result := Head^.Value;
  Head := Head^.Next;

  While Head <> Nil Do
    Begin
      If Head^.Value > Result Then Result := Head^.Value;
      Head := Head^.Next;
    End;
End;

// Here gets Averege and Std values
Procedure GetAvgStd(Head: PNode; out Avg, Std: Double);

Var 
  Sum, SumSq, Val: Double;
  Count: Integer;
Begin
  Sum := 0;
  SumSq := 0;
  Count := 0;

  While Head <> Nil Do
    Begin
      Val := Head^.Value;
      Sum := Sum + Val;
      SumSq := SumSq + (Val * Val);
      Inc(Count);
      Head := Head^.Next;
    End;

  // Because of HasData func we may get Count (Count > 0)
  Avg := Sum / Count;

  If Count > 1 Then
    Std := Sqrt((SumSq - (Sqr(Sum)/Count)) / (Count - 1))
  Else
    Std := 0.0;
End;


Function GetMedian(Head: PNode): Double;

Var Count: Integer;
Begin
  SortList(Head);

  Count := CountNodes(Head);

  If Count = 0 Then Exit(0.0);

  If (Count Mod 2) = 1 Then
    Result := GetNthValue(Head, Count Div 2)
  Else
    Result := (GetNthValue(Head, (Count Div 2) - 1) + GetNthValue(Head, Count Div 2)) / 2.0;
End;

Procedure HandleMedian(Head: PNode);
Begin
  If Not HasData(Head) Then Exit;
  WriteLn('  Median:  ', FormatVal(GetMedian(Head)));
End;


Procedure HandleMin(Head: PNode);
Begin
  If Not HasData(Head) Then Exit;
  WriteLn('  Minimum: ', FormatVal(GetMin(Head)));
End;


Procedure HandleMax(Head: PNode);
Begin
  If Not HasData(Head) Then Exit;
  WriteLn('  Maximum: ', FormatVal(GetMax(Head)));
End;

Procedure HandleAvg(Head: PNode);

Var Avg, Std: Double;
Begin
  If Not HasData(Head) Then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Average: ', FormatVal(Avg));
End;

Procedure HandleStd(Head: PNode);

Var Avg, Std: Double;
Begin
  If Not HasData(Head) Then Exit;
  GetAvgStd(Head, Avg, Std);
  WriteLn('  Std Dev: ', FormatVal(Std));
End;


initialization
RegisterCommand('min', 'Find minimum value', @HandleMin);
RegisterCommand('max', 'Find maximum value', @HandleMax);
RegisterCommand('avg', 'Calculate average',  @HandleAvg);
RegisterCommand('std', 'Standard deviation', @HandleStd);
RegisterCommand('median', 'Median (Warning: Sorts data)', @HandleMedian);

End.
