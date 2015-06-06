unit uBaseModuleForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, BCPanel, DividerBevel, Forms, Controls, Graphics,
  Dialogs, ActnList, Menus, ComCtrls, ExtCtrls, LCLIntf, StdCtrls;

type

  { TbaseModuleForm }

  TbaseModuleForm = class(TForm)
    actGeneral: TActionList;
    actQuitApp: TAction;
    divExDatis: TDividerBevel;
    Image1: TImage;
    lblModuleTitle: TLabel;
    panelForms: TBCPanel;
    imgGeneral: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mnuGeneral: TMainMenu;
    panelMnu: TPanel;
    shapeLogo: TShape;
    statusBarGeneral: TStatusBar;
    toolBarGeneral: TToolBar;
    ToolButton1: TToolButton;
    procedure actQuitAppExecute(Sender: TObject);
    procedure divExDatisClick(Sender: TObject);
    procedure divExDatisMouseEnter(Sender: TObject);
    procedure divExDatisMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure lblModuleTitleClick(Sender: TObject);
    procedure lblModuleTitleMouseEnter(Sender: TObject);
    procedure lblModuleTitleMouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  baseModuleForm: TbaseModuleForm;
const
  PRJ_HOME : String = 'http://sourceforge.net/projects/emissoftware/';

implementation

{$R *.lfm}

{ TbaseModuleForm }

procedure TbaseModuleForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  { free and nil }
  CloseAction:= caFree;
  self:= nil;
end;

procedure TbaseModuleForm.lblModuleTitleClick(Sender: TObject);
begin
  {open project home-page}
  Screen.Cursor:= crHourGlass;
  try
    OpenURL(PRJ_HOME);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TbaseModuleForm.lblModuleTitleMouseEnter(Sender: TObject);
begin
  {underline}
  lblModuleTitle.Font.Underline:= True;
end;

procedure TbaseModuleForm.lblModuleTitleMouseLeave(Sender: TObject);
begin
  {reset - underline = False}
  lblModuleTitle.Font.Underline:= False;
end;

procedure TbaseModuleForm.actQuitAppExecute(Sender: TObject);
begin
  {close main form and terminate app}
  self.Close;
  Application.Terminate;
end;

procedure TbaseModuleForm.divExDatisClick(Sender: TObject);
begin
  {open project home-page}
  Screen.Cursor:= crHourGlass;
  try
    OpenURL(PRJ_HOME);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TbaseModuleForm.divExDatisMouseEnter(Sender: TObject);
begin
  {underline}
  divExDatis.Font.Underline:= True;
end;

procedure TbaseModuleForm.divExDatisMouseLeave(Sender: TObject);
begin
  {underline}
  divExDatis.Font.Underline:= False;
end;

end.

