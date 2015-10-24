unit uSServicesGroups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZDataset, ZSequence, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ActnList, ExtCtrls, DbCtrls, DBGrids, uBaseDbForm, db,
  ZAbstractDataset;

type

  { TfrmSServicesGroups }

  TfrmSServicesGroups = class(TbaseDbForm)
    dbCode: TDBEdit;
    dbgGroups: TDBGrid;
    dbName: TDBEdit;
    dsGroups: TDataSource;
    edtLocate: TEdit;
    groupBoxEdit: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    panelSearch: TPanel;
    zseqSServicesGroups: TZSequence;
    ztGroups: TZTable;
    ztGroupsSSG_CODE: TStringField;
    ztGroupsSSG_ID: TLongintField;
    ztGroupsSSG_NAME: TStringField;
    procedure dbgGroupsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgGroupsTitleClick(Column: TColumn);
    procedure edtLocateEnter(Sender: TObject);
    procedure edtLocateExit(Sender: TObject);
    procedure edtLocateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ztGroupsAfterDelete(DataSet: TDataSet);
    procedure ztGroupsAfterOpen(DataSet: TDataSet);
    procedure ztGroupsAfterPost(DataSet: TDataSet);
    procedure ztGroupsAfterScroll(DataSet: TDataSet);
  private
    { private declarations }
    procedure saveBeforeClose;
  public
    { public declarations }
    procedure onActFirst; override;
    procedure onActPrior; override;
    procedure onActNext; override;
    procedure onActLast; override;
    procedure onActInsert; override;
    procedure onActDelete; override;
    procedure onActEdit; override;
    procedure onActSave; override;
    procedure onActCancel; override;
    {open dataSet}
    procedure openDataSet;
  end;

var
  frmSServicesGroups: TfrmSServicesGroups;
const
  {fields of tbl supply_services_group}
  FG_ID : String = 'SSG_ID';
  FG_CODE : String = 'SSG_CODE';
  FG_NAME : String = 'SSG_NAME';
implementation
uses
  uDModule, uConfirm;
{$R *.lfm}

{ TfrmSServicesGroups }

procedure TfrmSServicesGroups.dbgGroupsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor again}
  dbgGroups.Cursor:= crHandPoint;
end;

procedure TfrmSServicesGroups.dbgGroupsTitleClick(Column: TColumn);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0'; {find again recNo}
begin
  {sort}
  doSortDbGrid(TZAbstractDataset(ztGroups), Column);
  {refresh after sort}
  dbgGroups.Refresh;
  { find recNo}
  recCount:= IntToStr(TZAbstractDataset(ztGroups).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(ztGroups).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmSServicesGroups.edtLocateEnter(Sender: TObject);
begin
  {clear text and set font-color}
  edtLocate.Text:= '';
  edtLocate.Font.Color:= clBlack;
end;

procedure TfrmSServicesGroups.edtLocateExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocate.Text:= 'Pronadji ...';
  edtLocate.Font.Color:= clGray;
end;

procedure TfrmSServicesGroups.edtLocateKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(ztGroups).Locate(FG_NAME, edtLocate.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocate.SelectAll;
    end;
end;

procedure TfrmSServicesGroups.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  {check for unsaved changes}
  saveBeforeClose;
  inherited;
end;

procedure TfrmSServicesGroups.ztGroupsAfterDelete(DataSet: TDataSet);
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

procedure TfrmSServicesGroups.ztGroupsAfterOpen(DataSet: TDataSet);
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

procedure TfrmSServicesGroups.ztGroupsAfterPost(DataSet: TDataSet);
var
  {calc records(recNo and countRec)}
  recCount, recNo : String;
  recMsg : String = '0 od 0';
  currId : Longint = 0; {to find after refresh}
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {rtefresh current row}
  currId:= TZAbstractDataset(DataSet).FieldByName(FG_ID).AsInteger;
  TZAbstractDataset(DataSet).DisableControls;
  TZAbstractDataset(DataSet).Refresh;
  TZAbstractDataset(DataSet).Locate(FG_ID, currId, []);
  TZAbstractDataset(DataSet).EnableControls;
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

procedure TfrmSServicesGroups.ztGroupsAfterScroll(DataSet: TDataSet);
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

procedure TfrmSServicesGroups.saveBeforeClose;
var
  newDlg : TdlgConfirm;
  confirmMsg : String = 'Postoje izmene koje nisu sačuvane!';
  saveAll : Boolean = False;
begin
  {set confirm msg}
  confirmMsg:= confirmMsg + #13#10;
  confirmMsg:= confirmMsg + 'Želite da sačuvamo izmene?';
  if(TZAbstractDataset(ztGroups).State in [dsEdit, dsInsert]) then
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
    doSaveRec(TZAbstractDataset(ztGroups)); {in this case just one dataSet}
end;

procedure TfrmSServicesGroups.onActFirst;
begin
  {jump to first rec}
  doFirstRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActPrior;
begin
  {jump to prior rec}
  doPriorRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActNext;
begin
  {jump to next rec}
  doNextRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActLast;
begin
  {jump to last rec}
  doLastRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActInsert;
begin
  {set focus and insert new rec}
  dbCode.SetFocus;
  doInsertRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActDelete;
begin
  {delete rec}
  doDeleteRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActEdit;
begin
  {set focus and edit rec}
  dbCode.SetFocus;
  doEditRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActSave;
begin
  {save rec}
  doSaveRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.onActCancel;
begin
  {cancel rec}
  doCancelRec(TZAbstractDataset(ztGroups));
end;

procedure TfrmSServicesGroups.openDataSet;
begin
  TZAbstractDataset(ztGroups).DisableControls;
  TZAbstractDataset(ztGroups).Close;
  try
    TZAbstractDataset(ztGroups).Open;
    TZAbstractDataset(ztGroups).EnableControls;
  except
    on e : Exception do
    begin
      dModule.zdbh.Rollback;
      TZAbstractDataset(ztGroups).EnableControls;
      ShowMessage(e.Message);
    end;
  end;
end;

end.

