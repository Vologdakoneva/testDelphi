unit ThreadFind;

interface

uses
  System.Classes, System.SysUtils, Generics.Collections, Windows, forms;

type
 TfindObjet = class(TObject)
 public
  Filename:string;
  size:Int64;
  basePath:string;
  attr:integer;
 end;

type
  TCallbackEvent = procedure(Sender: TfindObjet) of object;
  TTreadFind = class(TThread)
  private
    { Private declarations }
  protected

  public
     Pattern:string;
     StartPath:string;
     attr:integer;
     callbackFunctions:TCallbackEvent;
     useRecurse:boolean;
     Texttofind:string;
     hwnd:THandle;
     ListFinded: TList<TfindObjet>;
     procedure Execute(); override;
  published
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TTreadFind.UpdateCaption;
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

{ TTreadFind }

procedure TTreadFind.Execute();
var founds:TSearchRec;
    simple:TObject;
    findObjet:TfindObjet;

begin
  attr := faAnyFile;
  ListFinded:= TList<TfindObjet>.Create;
  SetCurrentDir(StartPath);



        if FindFirst(StartPath+'\'+'*', attr, founds) = 0 then
        Begin
             findObjet:=TfindObjet.Create;
             findObjet.Filename := founds.Name;
             findObjet.size := founds.Size;
             findObjet.attr :=founds.Attr;
             findObjet.basePath:= StartPath;
             ListFinded.Add(findObjet);
             //callbackFunctions(findObjet);
          while ((FindNext(founds)=0) and not Terminated) do
          Begin
                 findObjet:=TfindObjet.Create;
                 findObjet.Filename := founds.Name;
                 findObjet.size := founds.Size;
                 findObjet.attr :=founds.Attr;
                 findObjet.basePath:= StartPath;
                 ListFinded.Add(findObjet);
              PostMessage(Hwnd,MsgFind,0,0);


          End;
          FindClose(founds.FindHandle);
           PostMessage(Hwnd,MsgFind,0,0);


        End;
end;

end.
