unit uDbIni;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, Grids, uReportBase;

type

  { TfrmDbIni }

  TfrmDbIni = class(TfrmReportBase)
    btnTestConnection: TButton;
    edtHost: TEdit;
    edtPwd: TEdit;
    edtUserName: TEdit;
    edtDbPath: TEdit;
    edtAlias: TEdit;
    gbDbEditList: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    sbtnFinDb: TSpeedButton;
    sgRegisteredDb: TStringGrid;
    zTestConnection: TZConnection;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmDbIni: TfrmDbIni;

implementation

{$R *.lfm}

end.
