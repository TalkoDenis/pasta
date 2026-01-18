
Unit uAlgo;

{$mode objfpc}{$H+}

Interface

Uses uTypes;

Procedure SortList(Var Head: PNode);

Implementation

Procedure SplitList(Source: PNode; out Front, Back: PNode);

Var Fast, Slow: PNode;
Begin
  If (Source = Nil) Or (Source^.Next = Nil) Then
    Begin
      Front := Source;
      Back := Nil;
      Exit;
    End;
  Slow := Source;
  Fast := Source^.Next;
  While (Fast <> Nil) Do
    Begin
      Fast := Fast^.Next;
      If (Fast <> Nil) Then
        Begin
          Slow := Slow^.Next;
          Fast := Fast^.Next;
        End;
    End;
  Front := Source;
  Back := Slow^.Next;
  Slow^.Next := Nil;
End;


Function Merge(A, B: PNode): PNode;

Var ResultHead: PNode;
Begin
  If A = Nil Then Exit(B);
  If B = Nil Then Exit(A);

  If A^.Value <= B^.Value Then
    Begin
      ResultHead := A;
      ResultHead^.Next := Merge(A^.Next, B);
    End
  Else
    Begin
      ResultHead := B;
      ResultHead^.Next := Merge(A, B^.Next);
    End;
  Result := ResultHead;
End;


Procedure MergeSort(Var Head: PNode);

Var A, B: PNode;
Begin
  If (Head = Nil) Or (Head^.Next = Nil) Then Exit;
  SplitList(Head, A, B);
  MergeSort(A);
  MergeSort(B);
  Head := Merge(A, B);
End;


Procedure SortList(Var Head: PNode);
Begin
  MergeSort(Head);
End;

End.
