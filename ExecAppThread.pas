unit ExecAppThread;

interface

uses
  System.Classes, ShellAPI, Winapi.Windows;

type
  ExecApps = class(TThread)
  private
    { Private declarations }
  protected
  public
    pathFile:string;
    Params:string;
    HandleApp:THandle;
    procedure Execute; override;
  end;

function AppExecute(pathFile, Params:string;HandleApp:THandle ):ExecApps;


implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure ExecApps.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ ExecApps }

function AppExecute(pathFile, Params:string; HandleApp:THandle):ExecApps;
var ExecApp:ExecApps;
Begin
  ExecApp:=ExecApps.Create(true);
  ExecApp.pathFile := String( pathFile );
  ExecApp.Params := String( Params );
  ExecApp.HandleApp := HandleApp;
  ExecApp.Execute;
  AppExecute :=  ExecApp;
End;

procedure ExecApps.Execute;
Var SeInfo:TShellExecuteInfo;
    MsgRec:TMsg;
begin
  { Place thread code here }
  FillChar(SEInfo,SizeOf(SEInfo),0);
With SEInfo Do
 Begin
  cbSize:=SizeOf(TShellExecuteInfo);
  fmask:=SEE_MASK_NOCLOSEPROCESS;
  Wnd:=HandleApp;
  lpFile:=PChar(pathFile);
  lpParameters:=PChar(Params);
  lpDirectory:=nil;
  nShow:=SW_SHOWNORMAL;
 End;
 ShellExecuteEx(@SEInfo);

repeat
        if MsgWaitForMultipleObjects(1, SEInfo.hProcess, FALSE, INFINITE, QS_ALLINPUT) = (WAIT_OBJECT_0+1) then
          Sleep(100)
        else
          Break;
      until False;
      CloseHandle(SEInfo.hProcess);
end;

end.
