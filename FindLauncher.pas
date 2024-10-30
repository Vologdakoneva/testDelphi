unit FindLauncher;

interface
uses Generics.Collections, ThreadFind, system.Classes;

type TFindLauncher = class


public
   ListThread : TList<TTreadFind>;
   constructor Create();
   function ExecFind(Pattern, startpath:string; useRecurce:boolean; textTofind:string; hwnd:THandle; CallBackFunc:TCallbackEvent):TFindLauncher;
   destructor Destroy; override;


end;




implementation

constructor TFindLauncher.Create();
Begin
    // inherited Create;
    ListThread:= TList<TTreadFind>.Create;

End;

function TFindLauncher.ExecFind(Pattern, startpath:string; useRecurce:boolean; textTofind:string;hwnd:THandle; CallBackFunc:TCallbackEvent):TFindLauncher;
var treadfindOne:TTreadFind;
    ListOfStrings:TStringList;
    patternIem:string;
    launcher:TFindLauncher;
Begin
   ListOfStrings:=TStringList.Create;
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := ',';
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Pattern;
   for patternIem in ListOfStrings do
   begin
    treadfindOne := TTreadFind.Create(true);
    treadfindOne.Pattern :=patternIem;
    treadfindOne.StartPath := startpath;
    treadfindOne.useRecurse := useRecurce;
    treadfindOne.Texttofind := textTofind;
    treadfindOne.callbackFunctions := CallBackFunc;
    treadfindOne.hwnd := hwnd;
    treadfindOne.Start();
    ListThread.Add(treadfindOne);
   end;
   //ExecFind := launcher;
End;

destructor TFindLauncher.Destroy;
var Elem: TTreadFind;
Begin
      for Elem in ListThread do
      begin
        Elem.Terminate;
      end;
      ListThread.Free;
End;


end.
