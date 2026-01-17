unit uAlgo;

{$mode objfpc}{$H+}

interface
uses uTypes;

// Единственная публичная процедура
procedure SortList(var Head: PNode);

implementation

// --- ВНУТРЕННЯЯ МАГИЯ (MERGE SORT) ---

procedure SplitList(Source: PNode; var Front, Back: PNode);
var Fast, Slow: PNode;
begin
  if (Source = nil) or (Source^.Next = nil) then begin
    Front := Source; Back := nil; Exit;
  end;
  Slow := Source; Fast := Source^.Next;
  while (Fast <> nil) do begin
    Fast := Fast^.Next;
    if (Fast <> nil) then begin
      Slow := Slow^.Next; Fast := Fast^.Next;
    end;
  end;
  Front := Source; Back := Slow^.Next; Slow^.Next := nil;
end;

function Merge(A, B: PNode): PNode;
var ResultHead: PNode;
begin
  if A = nil then Exit(B);
  if B = nil then Exit(A);
  
  if A^.Value <= B^.Value then begin
    ResultHead := A; ResultHead^.Next := Merge(A^.Next, B);
  end else begin
    ResultHead := B; ResultHead^.Next := Merge(A, B^.Next);
  end;
  Result := ResultHead;
end;

procedure MergeSort(var Head: PNode);
var A, B: PNode;
begin
  if (Head = nil) or (Head^.Next = nil) then Exit;
  SplitList(Head, A, B);
  MergeSort(A);
  MergeSort(B);
  Head := Merge(A, B);
end;

procedure SortList(var Head: PNode);
begin
  MergeSort(Head);
end;

end.
