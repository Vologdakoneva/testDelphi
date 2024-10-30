unit FindFilesCom_TLB;

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
// File generated on 27.10.2024 9:20:55 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\VICTOR_TEST\dllForFind\FindFilesCom (1)
// LIBID: {A3A2C0BC-9942-4630-AFA0-4499CB6AA30C}
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
  FindFilesComMajorVersion = 1;
  FindFilesComMinorVersion = 0;

  LIBID_FindFilesCom: TGUID = '{A3A2C0BC-9942-4630-AFA0-4499CB6AA30C}';

  IID_IFindFiles: TGUID = '{F0DA7A97-2922-4D5E-8F4F-61103F6D7D8A}';
  CLASS_FindFiles: TGUID = '{A9CD9248-1551-473E-863E-D095E1AE87F4}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IFindFiles = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  FindFiles = IFindFiles;


// *********************************************************************//
// Interface: IFindFiles
// Flags:     (256) OleAutomation
// GUID:      {F0DA7A97-2922-4D5E-8F4F-61103F6D7D8A}
// *********************************************************************//
  IFindFiles = interface(IUnknown)
    ['{F0DA7A97-2922-4D5E-8F4F-61103F6D7D8A}']
    function Start(const Path: WideString; const Mask: WideString; Userecurse: SYSINT;
                   const TextToSearch: WideString; Hwnd: SYSINT): HResult; stdcall;
    function GetLastFinded(var Filename: WideString; var Diectory: WideString; var Size: int64;
                           var Attr: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoFindFiles provides a Create and CreateRemote method to
// create instances of the default interface IFindFiles exposed by
// the CoClass FindFiles. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoFindFiles = class
    class function Create: IFindFiles;
    class function CreateRemote(const MachineName: string): IFindFiles;
  end;

implementation

uses System.Win.ComObj;

class function CoFindFiles.Create: IFindFiles;
begin
  Result := CreateComObject(CLASS_FindFiles) as IFindFiles;
end;

class function CoFindFiles.CreateRemote(const MachineName: string): IFindFiles;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FindFiles) as IFindFiles;
end;

end.

