unit execUnit;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, ComObj, ExcecCom_TLB, StdVcl, shellapi, WaiCloseApp, Forms, shredunit, Generics.Collections;

type
  TIexec = class(TTypedComObject, IIexec)
  protected
    function ExecApp(const AppName, Param: WideString; hwnd: Integer; var ProceddID: Integer): HResult;
          winapi;
  private
    cnt:integer;
    ListExec:TList<ProcIdObject>;
    WaitApp:WaitCloseApp;
  public
   constructor create();
  end;

implementation

uses ComServ;

constructor TIexec.create;
begin
 cnt:=0;


end;

function TIexec.ExecApp(const AppName, Param: WideString; hwnd: Integer; var ProceddID: Integer): HResult;

Var SeInfo:TShellExecuteInfo;
    MsgRec:TMsg;
    procObj:ProcIdObject;
begin
  cnt:=cnt+1;
  FillChar(SEInfo,SizeOf(SEInfo),0);
With SEInfo Do
 Begin
  cbSize:=SizeOf(TShellExecuteInfo);
  fmask:=SEE_MASK_NOCLOSEPROCESS;
  Wnd:=hwnd;
  lpFile:=PChar(AppName);
  lpParameters:=PChar(Param);
  lpDirectory:=nil;
  nShow:=SW_SHOWNORMAL;
 End;
 ShellExecuteEx(@SEInfo);
 ProceddID := SEInfo.hProcess;

  procObj:= ProcIdObject.Create;
  procObj.procID:=ProceddID;
  procObj.nameproc := AppName;
  procObj.Closed:=false;
  if ListExec=nil then
    ListExec:=TList<ProcIdObject>.Create ;
  ListExec.Add(procObj);
  if WaitApp=nil then
     WaitApp:=WaitCloseApp.Create(true);
  WaitApp.ListExec :=  ListExec;
  WaitApp.hwnd:= hwnd;

  if not WaitApp.Started then
    WaitApp.Start;

 PostMessage(Hwnd,MsgExec,ProceddID,0);

end;




initialization
  TTypedComObjectFactory.Create(ComServer, TIexec, Class_Iexec,
    ciMultiInstance, tmApartment);
end.
