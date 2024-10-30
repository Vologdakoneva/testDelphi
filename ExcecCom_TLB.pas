unit ExcecCom_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 98336 $
// File generated on 29.10.2024 9:43:34 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\VICTOR_TEST\dllForFind\ExcecCom (1)
// LIBID: {14531AF6-671E-43B9-8154-2CF8025FC55C}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ExcecComMajorVersion = 1;
  ExcecComMinorVersion = 0;

  LIBID_ExcecCom: TGUID = '{14531AF6-671E-43B9-8154-2CF8025FC55C}';

  IID_IIexec: TGUID = '{11E18420-DE93-456C-A62F-910FE928312A}';
  CLASS_Iexec: TGUID = '{C610BCC1-8660-4CD1-85D1-CA82A4B47FC2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IIexec = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Iexec = IIexec;


// *********************************************************************//
// Interface: IIexec
// Flags:     (256) OleAutomation
// GUID:      {11E18420-DE93-456C-A62F-910FE928312A}
// *********************************************************************//
  IIexec = interface(IUnknown)
    ['{11E18420-DE93-456C-A62F-910FE928312A}']
    function ExecApp(const AppName: WideString; const Param: WideString; hwnd: Integer;
                     var ProcessID: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoIexec provides a Create and CreateRemote method to
// create instances of the default interface IIexec exposed by
// the CoClass Iexec. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoIexec = class
    class function Create: IIexec;
    class function CreateRemote(const MachineName: string): IIexec;
  end;

implementation

uses System.Win.ComObj;

class function CoIexec.Create: IIexec;
begin
  Result := CreateComObject(CLASS_Iexec) as IIexec;
end;

class function CoIexec.CreateRemote(const MachineName: string): IIexec;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Iexec) as IIexec;
end;

end.

