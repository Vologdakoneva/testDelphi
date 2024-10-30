unit WaiCloseApp;

interface

uses
  System.Classes, other, shredunit, Generics.Collections, forms, windows, System.SyncObjs;

type
  WaitCloseApp = class(TThread)
  private
    { Private declarations }
     FLock: TCriticalSection;
  public
    ListExec:TList<ProcIdObject>;
    hwnd:THandle;
    procedure Execute; override;
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure WaitCloseApp.UpdateCaption;
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



{ WaitCloseApp }


procedure WaitCloseApp.Execute;
var
    i:integer;
    procID:integer;
begin
 if ListExec = nil then
    ListExec:= TList<ProcIdObject>.Create;
 if FLock = nil then
   FLock:=TCriticalSection.Create;

 While not Terminated do
 Begin
// ListExec.Count;
   FLock.Enter;

       for i:=0 to ListExec.Count-1 do
       begin
        procID := ListExec[i].procID;
        if (WaitForSingleObject(procID, 100) <> WAIT_TIMEOUT) and not ListExec[i].Closed then //
         Begin
              PostMessage(hwnd,MsgTerminate,procID,0);
              ListExec[i].Closed := true;
         end;
       end;


   FLock.Leave;
     //Application.ProcessMessages;
     //sleep(100);
 End;
end;

end.
