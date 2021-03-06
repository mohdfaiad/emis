unit uSuppliers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZDataset, ZSequence, ZSqlUpdate, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ActnList, Menus, ExtCtrls, Buttons, DbCtrls,
  DBGrids, uBaseDbForm, db, ZAbstractDataset, ZAbstractRODataset, LCLIntf, LCLType;

type

  { TfrmSuppliers }

  TfrmSuppliers = class(TbaseDbForm)
    actFind: TActionList;
    actFindLocationByCode: TAction;
    actFindLocationByName: TAction;
    actFindLocationHelpPdf: TAction;
    actCharFilter: TAction;
    actClearFilter: TAction;
    actFindLocationHelpDoc: TAction;
    actSuppliers: TActionList;
    btnCharFilter: TSpeedButton;
    btnFindLocation: TSpeedButton;
    btnLocationCancel: TButton;
    btnLocationOk: TButton;
    btnShowAll: TSpeedButton;
    cmbCharFilter: TComboBox;
    cmbFieldArg: TComboBox;
    dbCode: TDBEdit;
    dbAddress: TDBEdit;
    dbgLocation: TDBGrid;
    dbgSuppliers: TDBGrid;
    dbMobile: TDBEdit;
    dbMail: TDBEdit;
    dbFax: TDBEdit;
    dbPhone: TDBEdit;
    dbLocation: TDBEdit;
    dbName: TDBEdit;
    dbReg: TDBEdit;
    dsFindLocation: TDataSource;
    dsSuppliers: TDataSource;
    edtGridSearch: TEdit;
    edtLocate: TEdit;
    groupBoxEdit: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    panelFindLocation: TPanel;
    panelParams: TPanel;
    pupFindLocation: TPopupMenu;
    zqSuppliers: TZQuery;
    zqSuppliersL_CODE: TStringField;
    zqSuppliersL_NAME: TStringField;
    zqSuppliersS_ADDRESS: TStringField;
    zqSuppliersS_CODE: TStringField;
    zqSuppliersS_FAX: TStringField;
    zqSuppliersS_ID: TLongintField;
    zqSuppliersS_LOCATION: TLongintField;
    zqSuppliersS_MAIL: TStringField;
    zqSuppliersS_MOBILE: TStringField;
    zqSuppliersS_NAME: TStringField;
    zqSuppliersS_PHONE: TStringField;
    zqSuppliersS_REG: TStringField;
    zroFindLocation: TZReadOnlyQuery;
    zroFindLocationL_CODE: TStringField;
    zroFindLocationL_ID: TLongintField;
    zroFindLocationL_NAME: TStringField;
    zseqSuppliers: TZSequence;
    zupdSuppliers: TZUpdateSQL;
    procedure actCharFilterExecute(Sender: TObject);
    procedure actClearFilterExecute(Sender: TObject);
    procedure actFindLocationByCodeExecute(Sender: TObject);
    procedure actFindLocationByNameExecute(Sender: TObject);
    procedure actFindLocationHelpDocExecute(Sender: TObject);
    procedure actFindLocationHelpPdfExecute(Sender: TObject);
    procedure btnFindLocationClick(Sender: TObject);
    procedure btnLocationCancelClick(Sender: TObject);
    procedure btnLocationOkClick(Sender: TObject);
    procedure cmbFieldArgChange(Sender: TObject);
    procedure dbgLocationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgLocationMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgLocationTitleClick(Column: TColumn);
    procedure dbgSuppliersMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgSuppliersTitleClick(Column: TColumn);
    procedure dbLocationKeyPress(Sender: TObject; var Key: char);
    procedure edtGridSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtGridSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtLocateEnter(Sender: TObject);
    procedure edtLocateExit(Sender: TObject);
    procedure edtLocateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure zqSuppliersAfterDelete(DataSet: TDataSet);
    procedure zqSuppliersAfterOpen(DataSet: TDataSet);
    procedure zqSuppliersAfterPost(DataSet: TDataSet);
    procedure zqSuppliersAfterScroll(DataSet: TDataSet);
  private
    { private declarations }
    charArg : String; {name-start with this char}
    fieldArg : String; {locate text from field}
    locationArg : String;
    procedure saveBeforeClose;
    procedure findLocation(textArg : String);
    procedure useThisLocation;
  public
    { public declarations }
    HELP_PATH : String;
    procedure onActFirst; override;
    procedure onActPrior; override;
    procedure onActNext; override;
    procedure onActLast; override;
    procedure onActInsert; override;
    procedure onActDelete; override;
    procedure onActEdit; override;
    procedure onActSave; override;
    procedure onActCancel; override;
    {open dataSet using charArg}
    procedure applyCharFilter;
  end;

var
  frmSuppliers: TfrmSuppliers;
const
  {msg}
  EMPTY_SET : String = 'Prazan skup podataka.';
  {fields of tbl suppliers}
  FS_ID : String = 'S_ID';
  FS_CODE : String = 'S_CODE';
  FS_REG : String = 'S_REG';
  FS_NAME : String = 'S_NAME';
  FS_LOCATION : String = 'S_LOCATION';
  FS_ADDRESS : String = 'S_ADDRESS';
  FS_PHONE : String = 'S_PHONE';
  FS_FAX : String = 'S_FAX';
  FS_MOBILE : String = 'S_MOBILE';
  FS_MAIL : String = 'S_MAIL';
  {fields of view supplier_v}
  FS_LOCATION_ZIP : String = 'L_CODE';
  FS_LOCATION_NAME : String = 'L_NAME';
  {params}
  PARAM_NAME : String = 'S_NAME'; {:S_NAME}
implementation
uses
  uDModule, uConfirm;
{$R *.lfm}

{ TfrmSuppliers }

procedure TfrmSuppliers.FormCreate(Sender: TObject);
begin
  {default args for query}
  charArg:= 'A%';
  fieldArg:= PARAM_NAME; {locate using field_name}
  {default arg to find location - location(NAME)}
  locationArg:= FS_LOCATION_NAME;
end;

procedure TfrmSuppliers.zqSuppliersAfterDelete(DataSet: TDataSet);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {show recNo and countRec}
  if(TZAbstractDataset(DataSet).IsEmpty) then
    begin
      edtRecNo.Text:= recMsg;
      Exit;
    end;
  {find vars}
  recCount:= IntToStr(TZAbstractDataset(DataSet).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(DataSet).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSuppliers.zqSuppliersAfterOpen(DataSet: TDataSet);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  {set btns cheking recCount}
  doAfterOpenDataSet(TZAbstractDataset(DataSet));
  {show recNo and countRec}
  if(TZAbstractDataset(DataSet).IsEmpty) then
    begin
      edtRecNo.Text:= recMsg;
      Exit;
    end;
  {find vars}
  recCount:= IntToStr(TZAbstractDataset(DataSet).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(DataSet).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSuppliers.zqSuppliersAfterPost(DataSet: TDataSet);
var
  currId : Longint;
  firstChar : String = '';
  currText : String;
  {calc records(recNo and countRec)}
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {rtefresh current row}
  TZAbstractDataset(DataSet).RefreshCurrentRow(True);
  {find currText}
  currText:= TZAbstractDataset(DataSet).FieldByName(FS_NAME).AsString;
  {first char to firstChar-var}
  firstChar:= LeftStr(currText, 1);
  firstChar:= firstChar + '%';
  {compare current charFilter}
  if(charArg <> firstChar) then
    begin
      {save position}
      currId:= TZAbstractDataset(DataSet).FieldByName(FS_ID).AsInteger;
      charArg:= firstChar;
      applyCharFilter;
      {locate}
      TZAbstractDataset(DataSet).Locate(FS_ID, currId, []);
    end;
  {show recNo and countRec}
  if(TZAbstractDataset(DataSet).IsEmpty) then {*** never ***}
    begin
      edtRecNo.Text:= recMsg;
      Exit;
    end;
  {find vars}
  recCount:= IntToStr(TZAbstractDataset(DataSet).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(DataSet).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSuppliers.zqSuppliersAfterScroll(DataSet: TDataSet);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  {set btns cheking recCount}
  if(TZAbstractDataset(DataSet).State in [dsEdit, dsInsert]) then
    Exit;
  {show recNo and countRec}
  if(TZAbstractDataset(DataSet).IsEmpty) then
    begin
      edtRecNo.Text:= recMsg;
      Exit;
    end;
  {find vars}
  recCount:= IntToStr(TZAbstractDataset(DataSet).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(DataSet).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSuppliers.actCharFilterExecute(Sender: TObject);
begin
  {set filter}
  charArg:= cmbCharFilter.Text + '%';
  {apply filter}
  applyCharFilter;
end;

procedure TfrmSuppliers.actClearFilterExecute(Sender: TObject);
begin
  {set char-argument}
  charArg:= '%'; {show all}
  applyCharFilter;
  {set cmbCharFilter index}
  cmbCharFilter.Text:= 'Mesta na slovo ...'; {message like text}
end;

procedure TfrmSuppliers.actFindLocationByCodeExecute(Sender: TObject);
begin
  locationArg:= FS_LOCATION_ZIP; //set search arg
  findLocation(dbLocation.Text); //set text arg
end;

procedure TfrmSuppliers.actFindLocationByNameExecute(Sender: TObject);
begin
  locationArg:= FS_LOCATION_NAME; //set search arg
  findLocation(dbLocation.Text); //set text arg
end;

procedure TfrmSuppliers.actFindLocationHelpDocExecute(Sender: TObject);
var
  full_path : String;
begin
  {help file path(pdf file)}
  full_path:= HELP_PATH + 'FindLocation.pdf';
  {open doc}
  Screen.Cursor:= crHourGlass;
  try
    OpenDocument(full_path);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TfrmSuppliers.actFindLocationHelpPdfExecute(Sender: TObject);
var
  full_path : String;
begin
  {help file path(pdf file)}
  full_path:= HELP_PATH + 'FindLocation.pdf';
  {open doc}
  Screen.Cursor:= crHourGlass;
  try
    OpenDocument(full_path);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TfrmSuppliers.btnFindLocationClick(Sender: TObject);
begin
  {show popUpMnu}
  pupFindLocation.PopUp(Mouse.CursorPos.x, Mouse.CursorPos.y);
end;

procedure TfrmSuppliers.btnLocationCancelClick(Sender: TObject);
begin
  {hide panel and set focus}
  if(edtGridSearch.Visible) then
    edtGridSearch.Visible:= False;
  panelFindLocation.Visible:= False;
  //set ficus
  dbLocation.SetFocus;
  dbLocation.SelectAll;
  Application.ProcessMessages;
end;

procedure TfrmSuppliers.btnLocationOkClick(Sender: TObject);
begin
  {use current location}
  useThisLocation;
end;

procedure TfrmSuppliers.cmbFieldArgChange(Sender: TObject);
begin
  {set field-filter}
  case cmbFieldArg.ItemIndex of
    1: fieldArg:= FS_NAME;
    2: fieldArg:= FS_CODE;
    3: fieldArg:= FS_REG
  else
    fieldArg:= FS_NAME;
  end;
  {set focus}
  edtLocate.SetFocus;
end;

procedure TfrmSuppliers.dbgLocationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {Ctrl+space to use this result}
  if (ssCtrl in Shift)and (Key = VK_SPACE) then
    btnLocationOk.Click;
  {Advanced search}
  if (ssCtrl in Shift)and (Key = VK_F) then
    begin
      edtGridSearch.Visible:= True;
      edtGridSearch.SetFocus;
      Application.ProcessMessages;
    end;
end;

procedure TfrmSuppliers.dbgLocationMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor again}
  dbgLocation.Cursor:= crHandPoint;
end;

procedure TfrmSuppliers.dbgLocationTitleClick(Column: TColumn);
begin
  doSortDbGrid(TZAbstractDataset(TZAbstractRODataset(zroFindLocation)), Column);
end;

procedure TfrmSuppliers.dbgSuppliersMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor again}
  dbgSuppliers.Cursor:= crHandPoint;
end;

procedure TfrmSuppliers.dbgSuppliersTitleClick(Column: TColumn);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0'; {find again recNo}
begin
  {sort}
  doSortDbGrid(TZAbstractDataset(zqSuppliers), Column);
  {refresh after sort}
  dbgSuppliers.Refresh;
  { find recNo}
  recCount:= IntToStr(TZAbstractDataset(zqSuppliers).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(zqSuppliers).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSuppliers.dbLocationKeyPress(Sender: TObject; var Key: char);
begin
  {on pres Return}
  if(Key = #13) then
    begin
      locationArg:= FS_LOCATION_NAME;
      findLocation(dbLocation.Text);
    end;
end;

procedure TfrmSuppliers.edtGridSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {Escape to exit}
  if (Key = VK_ESCAPE) then
    begin
      edtGridSearch.Visible:= False;
      dbgLocation.SetFocus;
      Application.ProcessMessages;
      Exit;
    end;
  {Ctrl+space to use this result}
  if (ssCtrl in Shift)and (Key = VK_SPACE) then
    btnLocationOk.Click;
end;

procedure TfrmSuppliers.edtGridSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractRODataset(zroFindLocation).Locate(FS_LOCATION_NAME, edtGridSearch.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtGridSearch.SelectAll;
    end;
end;

procedure TfrmSuppliers.edtLocateEnter(Sender: TObject);
begin
  {clear text and set font-color}
  edtLocate.Text:= '';
  edtLocate.Font.Color:= clBlack;
end;

procedure TfrmSuppliers.edtLocateExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocate.Text:= 'Pronadji ...';
  edtLocate.Font.Color:= clGray;
end;

procedure TfrmSuppliers.edtLocateKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(zqSuppliers).Locate(fieldArg, edtLocate.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocate.SelectAll;
    end;
end;

procedure TfrmSuppliers.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  {check for unsaved changes}
  saveBeforeClose;
  inherited;
end;

procedure TfrmSuppliers.saveBeforeClose;
var
  newDlg : TdlgConfirm;
  confirmMsg : String = 'Postoje izmene koje nisu sačuvane!';
  saveAll : Boolean = False;
begin
  {set confirm msg}
  confirmMsg:= confirmMsg + #13#10;
  confirmMsg:= confirmMsg + 'Želite da sačuvamo izmene?';
  if(TZAbstractDataset(zqSuppliers).State in [dsEdit, dsInsert]) then
    begin
      {ask user to confirm}
      newDlg:= TdlgConfirm.Create(nil);
      newDlg.memoMsg.Lines.Text:= confirmMsg;
      if(newDlg.ShowModal = mrOK) then
        saveAll:= True;
      {free dialog}
      newDlg.Free;
    end;
  {check all}
  if saveAll then
    doSaveRec(TZAbstractDataset(zqSuppliers)); {in this case just one dataSet}
end;

procedure TfrmSuppliers.findLocation(textArg: String);
var
  argCode, argName : String;
begin
  {find argument}
  if(locationArg = FS_LOCATION_NAME) then
    begin
      argCode:= '%';
      argName:= '%' + textArg + '%';
    end
  else
    begin
      argCode:= '%' + textArg + '%';
      argName:= '%';
    end;
  {set params}
  zroFindLocation.DisableControls;
  zroFindLocation.Params[0].AsString:= argCode;
  zroFindLocation.Params[1].AsString:= argName;
  try
    zroFindLocation.Open;
    zroFindLocation.EnableControls;
  except
    on e : Exception do
    begin
      ShowMessage(e.Message);
      zroFindLocation.EnableControls;
      //focus(back)
      dbLocation.SetFocus;
      dbLocation.SelectAll;
      Exit;
    end;
  end;
  {again if dataSet is empty}
  if(zroFindLocation.IsEmpty) then
    begin
      ShowMessage(EMPTY_SET);
      //set focus
      dbLocation.SetFocus;
      dbLocation.SelectAll;
      Exit;
    end;
  {else show panel(results)}
  panelFindLocation.Visible:= True;
  dbgLocation.SetFocus;
  Application.ProcessMessages;
end;

procedure TfrmSuppliers.useThisLocation;
begin
  TZAbstractDataset(zqSuppliers).FieldByName(FS_LOCATION).AsInteger:= zroFindLocation.Fields[0].AsInteger;
  TZAbstractDataset(zqSuppliers).FieldByName(FS_LOCATION_NAME).AsString:= zroFindLocation.Fields[2].AsString;
  //hide panel
  if(edtGridSearch.Visible) then
    edtGridSearch.Visible:= False;
  panelFindLocation.Visible:= False;
  //set focus
  dbAddress.SetFocus;
  Application.ProcessMessages;
end;

procedure TfrmSuppliers.onActFirst;
begin
  {jump to first rec}
  doFirstRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActPrior;
begin
  {jump to prior rec}
  doPriorRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActNext;
begin
  {jump to next rec}
  doNextRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActLast;
begin
  {jump to last rec}
  doLastRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActInsert;
begin
  {set focus and insert new rec}
  dbCode.SetFocus;
  doInsertRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActDelete;
begin
  {delete rec}
  doDeleteRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActEdit;
begin
  {set focus and edit rec}
  dbCode.SetFocus;
  doEditRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActSave;
begin
  {save rec}
  doSaveRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.onActCancel;
begin
  {hide panel}
  if(edtGridSearch.Visible) then
    edtGridSearch.Visible:= False;
  if(panelFindLocation.Visible) then
    panelFindLocation.Visible:= False;
  {cancel rec}
  doCancelRec(TZAbstractDataset(zqSuppliers));
end;

procedure TfrmSuppliers.applyCharFilter;
begin
  TZAbstractDataset(zqSuppliers).DisableControls;
  TZAbstractDataset(zqSuppliers).Close;
  try
    TZAbstractDataset(zqSuppliers).ParamByName(PARAM_NAME).AsString:= charArg;
    TZAbstractDataset(zqSuppliers).Open;
    TZAbstractDataset(zqSuppliers).EnableControls;
    {show arg in cmbChar}
    //cmbCharFilter.ItemIndex:= cmbCharFilter.Items.IndexOf(LeftStr(charArg, 1)); {without '%'}
  except
    on e : Exception do
    begin
      dModule.zdbh.Rollback;
      TZAbstractDataset(zqSuppliers).EnableControls;
      ShowMessage(e.Message);
    end;
  end;
end;

end.

