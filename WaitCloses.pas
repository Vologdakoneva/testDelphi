unit WaitCloses;

interface

uses
  System.Classes, windows, Forms;

type
  WaitClose = class(TThread)
  private
    { Private declarations }
  protected
  public
    ProcID:integer;
    Hwnd:THandle;
    procedure Execute; override;
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure WaitClose.UpdateCaption;
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

uses shredunit;

{ WaitClose }

procedure WaitClose.Execute;
var ProcIDs: array of integer;
begin

           while WaitForSingleObject(ProcID, 100) = WAIT_TIMEOUT do //
               Application.ProcessMessages;
//
//       repeat
//        if MsgWaitForMultipleObjects(1, ProcID, false, INFINITE, QS_ALLINPUT) = (WAIT_OBJECT_0+1) then
//
//          application.ProcessMessages
//        else
//          Break;
//      until False;
       PostMessage(Hwnd,MsgTerminate,ProcID,0);
      CloseHandle(ProcID);
end;

end.
