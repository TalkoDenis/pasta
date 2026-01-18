unit uTypes;

{$mode objfpc}{$H+}

interface

type
  PNode = ^TNode;
  
  TNode = record
    Value: Double; 
    Next: PNode;   
  end;

implementation

end.
