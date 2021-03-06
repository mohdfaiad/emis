unit uDonors;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZDataset, ZSequence, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ActnList, ExtCtrls, DbCtrls, DBGrids, uBaseDbForm, db,
  ZAbstractDataset;

type

  { TfrmDonors }

  TfrmDonors = class(TbaseDbForm)
    dbCode: TDBEdit;
    dbCountry: TDBEdit;
    dbgDonors: TDBGrid;
    dbMobile: TDBEdit;
    dbMail: TDBEdit;
    dbFax: TDBEdit;
    dbPhone: TDBEdit;
    dbName: TDBEdit;
    dsDonors: TDataSource;
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
    panelSearch: TPanel;
    zseqDonors: TZSequence;
    ztDonors: TZTable;
    ztDonorsD_CODE: TStringField;
    ztDonorsD_COUNTRY: TStringField;
    ztDonorsD_FAX: TStringField;
    ztDonorsD_ID: TLongintField;
    ztDonorsD_MAIL: TStringField;
    ztDonorsD_MOBILE: TStringField;
    ztDonorsD_NAME: TStringField;
    ztDonorsD_PHONE: TStringField;
    procedure dbgDonorsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgDonorsTitleClick(Column: TColumn);
    procedure edtLocateEnter(Sender: TObject);
    procedure edtLocateExit(Sender: TObject);
    procedure edtLocateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure ztDonorsAfterDelete(DataSet: TDataSet);
    procedure ztDonorsAfterOpen(DataSet: TDataSet);
    procedure ztDonorsAfterPost(DataSet: TDataSet);
    procedure ztDonorsAfterScroll(DataSet: TDataSet);
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
  frmDonors: TfrmDonors;
const
  {fields of tbl Donors}
  FD_ID : String = 'D_ID';
  FD_CODE : String = 'D_CODE';
  FD_COUNTRY : String = 'D_COUNTRY';
  FD_NAME : String = 'D_NAME';
  FD_PHONE : String = 'D_PHONE';
  FD_FAX : String = 'D_FAX';
  FD_MOBILE : String = 'D_MOBILE';
  FD_MAIL : String = 'D_MAIL';
implementation
uses
  uDModule, uConfirm;
{$R *.lfm}

{ TfrmDonors }

procedure TfrmDonors.dbgDonorsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {set cursor again}
  dbgDonors.Cursor:= crHandPoint;
end;

procedure TfrmDonors.dbgDonorsTitleClick(Column: TColumn);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0'; {find again recNo}
begin
  {sort}
  doSortDbGrid(TZAbstractDataset(ztDonors), Column);
  {refresh after sort}
  dbgDonors.Refresh;
  { find recNo}
  recCount:= IntToStr(TZAbstractDataset(ztDonors).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(ztDonors).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmDonors.edtLocateEnter(Sender: TObject);
begin
  {clear text and set font-color}
  edtLocate.Text:= '';
  edtLocate.Font.Color:= clBlack;
end;

procedure TfrmDonors.edtLocateExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocate.Text:= 'Pronadji ...';
  edtLocate.Font.Color:= clGray;
end;

procedure TfrmDonors.edtLocateKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(ztDonors).Locate(FD_NAME, edtLocate.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocate.SelectAll;
    end;
end;

procedure TfrmDonors.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  {check for unsaved changes}
  saveBeforeClose;
  inherited;
end;

procedure TfrmDonors.ztDonorsAfterDelete(DataSet: TDataSet);
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

procedure TfrmDonors.ztDonorsAfterOpen(DataSet: TDataSet);
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

procedure TfrmDonors.ztDonorsAfterPost(DataSet: TDataSet);
var
  {calc records(recNo and countRec)}
  recCount, recNo : String;
  recMsg : String = '0 od 0';
  currId : Longint = 0; {to find after refresh}
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {rtefresh current row}
  currId:= TZAbstractDataset(DataSet).FieldByName(FD_ID).AsInteger;
  TZAbstractDataset(DataSet).DisableControls;
  TZAbstractDataset(DataSet).Refresh;
  TZAbstractDataset(DataSet).Locate(FD_ID, currId, []);
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

procedure TfrmDonors.ztDonorsAfterScroll(DataSet: TDataSet);
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

procedure TfrmDonors.saveBeforeClose;
var
  newDlg : TdlgConfirm;
  confirmMsg : String = 'Postoje izmene koje nisu sačuvane!';
  saveAll : Boolean = False;
begin
  {set confirm msg}
  confirmMsg:= confirmMsg + #13#10;
  confirmMsg:= confirmMsg + 'Želite da sačuvamo izmene?';
  if(TZAbstractDataset(ztDonors).State in [dsEdit, dsInsert]) then
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
    doSaveRec(TZAbstractDataset(ztDonors)); {in this case just one dataSet}
end;

procedure TfrmDonors.onActFirst;
begin
  {jump to first rec}
  doFirstRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActPrior;
begin
  {jump to prior rec}
  doPriorRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActNext;
begin
  {jump to next rec}
  doNextRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActLast;
begin
  {jump to last rec}
  doLastRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActInsert;
begin
  {set focus and insert new rec}
  dbCode.SetFocus;
  doInsertRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActDelete;
begin
  {delete rec}
  doDeleteRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActEdit;
begin
  {set focus and edit rec}
  dbCode.SetFocus;
  doEditRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActSave;
begin
  {save rec}
  doSaveRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.onActCancel;
begin
  {cancel rec}
  doCancelRec(TZAbstractDataset(ztDonors));
end;

procedure TfrmDonors.openDataSet;
begin
  TZAbstractDataset(ztDonors).DisableControls;
  TZAbstractDataset(ztDonors).Close;
  try
    TZAbstractDataset(ztDonors).Open;
    TZAbstractDataset(ztDonors).EnableControls;
  except
    on e : Exception do
    begin
      dModule.zdbh.Rollback;
      TZAbstractDataset(ztDonors).EnableControls;
      ShowMessage(e.Message);
    end;
  end;
end;

end.

