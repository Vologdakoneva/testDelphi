unit shredunit;


interface
uses Windows;
type
 ProcIdObject = class(TObject)
   public
    procID:integer;
    nameproc:String;
    Closed:boolean;
end;
Var
    MsgFind:Cardinal;
    MsgExec:Cardinal;
    MsgTerminate:Cardinal;

implementation


initialization
 MsgFind := RegisterWindowMessage('MsgFind');
 MsgExec := RegisterWindowMessage('MsgExec');
 MsgTerminate := RegisterWindowMessage('MsgTerminate');
end.
