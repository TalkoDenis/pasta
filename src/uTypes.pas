
Unit uTypes;

{$mode objfpc}{$H+}

Interface

Type 
  PNode = ^TNode;

  TNode = Record
    Value: Double;
    Next: PNode;
  End;

Implementation

End.
