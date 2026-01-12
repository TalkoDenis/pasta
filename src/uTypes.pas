unit uTypes;

{$mode objfpc}{$H+}

interface

type
  // Указатель на узел (адрес в памяти)
  PNode = ^TNode;
  
  // Сам узел списка
  TNode = record
    Value: Double; // Полезная нагрузка
    Next: PNode;   // Ссылка на следующий вагон
  end;

implementation

end.
