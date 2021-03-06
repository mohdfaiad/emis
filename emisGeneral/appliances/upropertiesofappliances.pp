unit uPropertiesOfAppliances;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZDataset, ZSequence, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ActnList, ExtCtrls, DbCtrls, DBGrids, uBaseDbForm, db,
  ZAbstractDataset;

type

  { TfrmPropertiesOfAppliances }

  TfrmPropertiesOfAppliances = class(TbaseDbForm)
    dbCode: TDBEdit;
    dbgProperties: TDBGrid;
    dbName: TDBEdit;
    dsProperties: TDataSource;
    edtLocate: TEdit;
    groupBoxEdit: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    panelSearch: TPanel;
    zseqProperties: TZSequence;
    ztProperty: TZTable;
    ztPropertyPOA_CODE: TStringField;
    ztPropertyPOA_ID: TLongintField;
    ztPropertyPOA_NAME: TStringField;
    procedure dbgPropertiesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgPropertiesTitleClick(Column: TColumn);
    procedure edtLocateEnter(Sender: TObject);
    procedure edtLocateExit(Sender: TObject);
    procedure edtLocateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ztPropertyAfterDelete(DataSet: TDataSet);
    procedure ztPropertyAfterOpen(DataSet: TDataSet);
    procedure ztPropertyAfterPost(DataSet: TDataSet);
    procedure ztPropertyAfterScroll(DataSet: TDataSet);
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
  frmPropertiesOfAppliances: TfrmPropertiesOfAppliances;
const
  {fields of tbl propertiesOfAppliances}
  FP_ID : String = 'POA_ID';
  FP_CODE : String = 'POA_CODE';
  FP_NAME : String = 'POA_NAME';
implementation
uses
  uDModule, uConfirm;
{$R *.lfm}

{ TfrmPropertiesOfAppliances }

procedure TfrmPropertiesOfAppliances.dbgPropertiesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor again}
  dbgProperties.Cursor:= crHandPoint;
end;

procedure TfrmPropertiesOfAppliances.dbgPropertiesTitleClick(Column: TColumn);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0'; {find again recNo}
begin
  {sort}
  doSortDbGrid(TZAbstractDataset(ztProperty), Column);
  {refresh after sort}
  dbgProperties.Refresh;
  { find recNo}
  recCount:= IntToStr(TZAbstractDataset(ztProperty).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(ztProperty).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmPropertiesOfAppliances.edtLocateEnter(Sender: TObject);
begin
  {clear text and set font-color}
  edtLocate.Text:= '';
  edtLocate.Font.Color:= clBlack;
end;

procedure TfrmPropertiesOfAppliances.edtLocateExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocate.Text:= 'Pronadji ...';
  edtLocate.Font.Color:= clGray;
end;

procedure TfrmPropertiesOfAppliances.edtLocateKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(ztProperty).Locate(FP_NAME, edtLocate.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocate.SelectAll;
    end;
end;

procedure TfrmPropertiesOfAppliances.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  {check for unsaved changes}
  saveBeforeClose;
  inherited;
end;

procedure TfrmPropertiesOfAppliances.ztPropertyAfterDelete(DataSet: TDataSet);
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

procedure TfrmPropertiesOfAppliances.ztPropertyAfterOpen(DataSet: TDataSet);
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

procedure TfrmPropertiesOfAppliances.ztPropertyAfterPost(DataSet: TDataSet);
var
  {calc records(recNo and countRec)}
  recCount, recNo : String;
  recMsg : String = '0 od 0';
  currId : Longint = 0; {to find after refresh}
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {rtefresh current row}
  currId:= TZAbstractDataset(DataSet).FieldByName(FP_ID).AsInteger;
  TZAbstractDataset(DataSet).DisableControls;
  TZAbstractDataset(DataSet).Refresh;
  TZAbstractDataset(DataSet).Locate(FP_ID, currId, []);
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

procedure TfrmPropertiesOfAppliances.ztPropertyAfterScroll(DataSet: TDataSet);
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

procedure TfrmPropertiesOfAppliances.saveBeforeClose;
var
  newDlg : TdlgConfirm;
  confirmMsg : String = 'Postoje izmene koje nisu sačuvane!';
  saveAll : Boolean = False;
begin
  {set confirm msg}
  confirmMsg:= confirmMsg + #13#10;
  confirmMsg:= confirmMsg + 'Želite da sačuvamo izmene?';
  if(TZAbstractDataset(ztProperty).State in [dsEdit, dsInsert]) then
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
    doSaveRec(TZAbstractDataset(ztProperty)); {in this case just one dataSet}
end;

procedure TfrmPropertiesOfAppliances.onActFirst;
begin
  {jump to first rec}
  doFirstRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActPrior;
begin
  {jump to prior rec}
  doPriorRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActNext;
begin
  {jump to next rec}
  doNextRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActLast;
begin
  {jump to last rec}
  doLastRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActInsert;
begin
  {set focus and insert new rec}
  dbCode.SetFocus;
  doInsertRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActDelete;
begin
  {delete rec}
  doDeleteRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActEdit;
begin
  {set focus and edit rec}
  dbCode.SetFocus;
  doEditRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActSave;
begin
  {save rec}
  doSaveRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.onActCancel;
begin
  {cancel rec}
  doCancelRec(TZAbstractDataset(ztProperty));
end;

procedure TfrmPropertiesOfAppliances.openDataSet;
begin
  TZAbstractDataset(ztProperty).DisableControls;
  TZAbstractDataset(ztProperty).Close;
  try
    TZAbstractDataset(ztProperty).Open;
    TZAbstractDataset(ztProperty).EnableControls;
  except
    on e : Exception do
    begin
      dModule.zdbh.Rollback;
      TZAbstractDataset(ztProperty).EnableControls;
      ShowMessage(e.Message);
    end;
  end;
end;

end.

