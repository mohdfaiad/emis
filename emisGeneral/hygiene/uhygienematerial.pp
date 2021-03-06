unit uHygieneMaterial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DividerBevel, ZDataset, ZSequence, ZSqlUpdate,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList, ExtCtrls, Buttons,
  DBGrids, ComCtrls, DbCtrls, uBaseDbForm, db, ZAbstractDataset;

{exception if drug_id is null}
type
  TENoProducts = class(Exception);
type

  { TfrmHygieneMaterial }

  TfrmHygieneMaterial = class(TbaseDbForm)
    actCharFilter: TAction;
    actClearFilter: TAction;
    actFindProduct: TActionList;
    btnCharFilter: TSpeedButton;
    btnShowAll: TSpeedButton;
    cmbCharFilter: TComboBox;
    cmbFieldArg: TComboBox;
    dbBarCode: TDBEdit;
    dbCode: TDBEdit;
    dbgProducts: TDBGrid;
    dbgPropertiesVar: TDBGrid;
    dblGroup: TDBLookupComboBox;
    dblMeasure: TDBLookupComboBox;
    dblProperty: TDBLookupComboBox;
    dblTaxes: TDBLookupComboBox;
    dbName: TDBEdit;
    dbPieces: TDBEdit;
    dbValue1: TDBEdit;
    DividerBevel1: TDividerBevel;
    dsGroups: TDataSource;
    dsMeasure: TDataSource;
    dsProduct: TDataSource;
    dsProperties: TDataSource;
    dsPropertiesVar: TDataSource;
    dsTaxes: TDataSource;
    edtLocate: TEdit;
    edtLocateProperty: TEdit;
    gbEditProduct: TGroupBox;
    gbEditPropertiesVar: TGroupBox;
    Label1: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    panelParams: TPanel;
    pcProduct: TPageControl;
    tsProduct: TTabSheet;
    tsProperties: TTabSheet;
    zqProduct: TZQuery;
    zqProductGROUP_CODE: TStringField;
    zqProductGROUP_NAME: TStringField;
    zqProductHM_BARCODE: TStringField;
    zqProductHM_CODE: TStringField;
    zqProductHM_GROUP: TLongintField;
    zqProductHM_ID: TLongintField;
    zqProductHM_MEASURE: TLongintField;
    zqProductHM_NAME: TStringField;
    zqProductHM_PIECES: TFloatField;
    zqProductHM_TAX: TLongintField;
    zqProductMEASURE_CODE: TStringField;
    zqProductMEASURE_NAME: TStringField;
    zqProductTAX_CODE: TStringField;
    zqProductTAX_VALUE: TFloatField;
    zqPropertiesVar: TZQuery;
    zqPropertiesVarHMATERIAL_CODE: TStringField;
    zqPropertiesVarHMATERIAL_NAME: TStringField;
    zqPropertiesVarHPROPERTY_NAME: TStringField;
    zqPropertiesVarHPV_HMATERIAL: TLongintField;
    zqPropertiesVarHPV_ID: TLongintField;
    zqPropertiesVarHPV_PROPERTY: TLongintField;
    zqPropertiesVarHPV_VALUE: TStringField;
    zroGroups: TZReadOnlyQuery;
    zroGroupsHG_ID: TLongintField;
    zroGroupsHG_NAME: TStringField;
    zroProperties: TZReadOnlyQuery;
    zroMeasure: TZReadOnlyQuery;
    zroMeasureM_ID: TLongintField;
    zroMeasureM_NAME: TStringField;
    zroPropertiesHP_ID: TLongintField;
    zroPropertiesHP_NAME: TStringField;
    zroTaxes: TZReadOnlyQuery;
    zroTaxesTX_CODE: TStringField;
    zroTaxesTX_ID: TLongintField;
    zseqProducts: TZSequence;
    zseqPropertiesVar: TZSequence;
    zupdPropertiesVar: TZUpdateSQL;
    zupdProduct: TZUpdateSQL;
    procedure actCharFilterExecute(Sender: TObject);
    procedure actClearFilterExecute(Sender: TObject);
    procedure cmbFieldArgChange(Sender: TObject);
    procedure dbgProductsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgProductsTitleClick(Column: TColumn);
    procedure dbgPropertiesVarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure dbgPropertiesVarTitleClick(Column: TColumn);
    procedure edtLocateEnter(Sender: TObject);
    procedure edtLocateExit(Sender: TObject);
    procedure edtLocateKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtLocatePropertyEnter(Sender: TObject);
    procedure edtLocatePropertyExit(Sender: TObject);
    procedure edtLocatePropertyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure pcProductChange(Sender: TObject);
    procedure zqProductAfterDelete(DataSet: TDataSet);
    procedure zqProductAfterOpen(DataSet: TDataSet);
    procedure zqProductAfterPost(DataSet: TDataSet);
    procedure zqProductAfterScroll(DataSet: TDataSet);
    procedure zqProductBeforeScroll(DataSet: TDataSet);
    procedure zqProductNewRecord(DataSet: TDataSet);
    procedure zqPropertiesVarAfterDelete(DataSet: TDataSet);
    procedure zqPropertiesVarAfterOpen(DataSet: TDataSet);
    procedure zqPropertiesVarAfterPost(DataSet: TDataSet);
    procedure zqPropertiesVarAfterScroll(DataSet: TDataSet);
    procedure zqPropertiesVarBeforeOpen(DataSet: TDataSet);
    procedure zqPropertiesVarBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    charArg : String; {name-start with this char}
    fieldArg : String; {locate text from field}
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
    {open dataSet using charArg}
    procedure openRODataSets;
    procedure applyCharFilter;
  end;

var
  frmHygieneMaterial: TfrmHygieneMaterial;
const
  {exception msg}
  ENoProductsMsg : String = 'Nije selektovana/izabrana oprema.';
  //**************************** drugs *****************************************
  {fields of tbl hygieneMaterial}
  FD_ID : String = 'HM_ID';
  FD_CODE : String = 'HM_CODE';
  FD_NAME : String = 'HM_NAME';
  FD_BARCODE : String = 'HM_BARCODE';
  FD_GROUP : String = 'HM_GROUP';
  FD_MEASURE : String = 'HM_MEASURE';
  FD_TAX : String = 'HM_TAX';
  FD_PIECES : String = 'HM_PIECES';
  {fields of view hospital_equipment_v}
  GROUP_CODE : String = 'GROUP_CODE';
  GROUP_NAME : String = 'GROUP_NAME';
  MEASURE_CODE : String = 'MEASURE_CODE';
  MEASURE_NAME : String = 'MEASURE_NAME';
  TAX_CODE : String = 'TAX_CODE';
  TAX_VALUE : STring = 'TAX_VALUE';
  {params}
  PARAM_NAME : String = 'HM_NAME'; {:HM_NAME}

  //****************************************************************************
  {fields of table hygiene_properties_var} //fpv- field_properties_var
  FPV_ID : String = 'HPV_ID';
  FPV_PRODUCT : String = 'HPV_HMATERIAL';
  FPV_PROPERTY : String = 'HPV_PROPERTY';
  FPV_VALUE : String = 'HPV_VALUE';
  {fields of view hequipment_properties_var_v}
  {existent --||-- + property_name}
  PROPERTY_NAME : String = 'HPROPERTY_NAME';
implementation
uses
  uDModule, uConfirm;
{$R *.lfm}

{ TfrmHygieneMaterial }

procedure TfrmHygieneMaterial.actCharFilterExecute(Sender: TObject);
begin
  {check current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
  {set filter}
  charArg:= cmbCharFilter.Text + '%';
  {apply filter}
  applyCharFilter;
end;

procedure TfrmHygieneMaterial.actClearFilterExecute(Sender: TObject);
begin
  {check current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
  {set char-argument}
  charArg:= '%'; {show all}
  applyCharFilter;
  {set cmbCharFilter index}
  cmbCharFilter.Text:= 'Materijal na slovo ...'; {message like text}
end;

procedure TfrmHygieneMaterial.cmbFieldArgChange(Sender: TObject);
begin
  {check current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
  {set field-filter}
  case cmbFieldArg.ItemIndex of
    1: fieldArg:= FD_NAME;
    2: fieldArg:= FD_CODE;
    3: fieldArg:= FD_BARCODE;
  else
    fieldArg:= FD_NAME;
  end;
  {set focus}
  edtLocate.SetFocus;
end;

procedure TfrmHygieneMaterial.dbgProductsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor again}
  dbgProducts.Cursor:= crHandPoint;
end;

procedure TfrmHygieneMaterial.dbgProductsTitleClick(Column: TColumn);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0'; {find again recNo}
begin
  {set current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
  {sort}
  doSortDbGrid(TZAbstractDataset(zqProduct), Column);
  {refresh after sort}
  dbgProducts.Refresh;
  { find recNo}
  recCount:= IntToStr(TZAbstractDataset(zqProduct).RecordCount);
  recNo:= IntToStr(TZAbstractDataset(zqProduct).RecNo);
  {create recMsg}
  recMsg:= recNo + ' od ' + recCount;
  edtRecNo.Text:= recMsg;
end;

procedure TfrmHygieneMaterial.dbgPropertiesVarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {set cursor}
  dbgPropertiesVar.Cursor:= crHandPoint;
end;

procedure TfrmHygieneMaterial.dbgPropertiesVarTitleClick(Column: TColumn);
begin
  {sort}
  doSortDbGrid(TZAbstractDataset(zqPropertiesVar), Column);
end;

procedure TfrmHygieneMaterial.edtLocateEnter(Sender: TObject);
begin
  {check current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
  {clear text and set font-color}
  edtLocate.Text:= '';
  edtLocate.Font.Color:= clBlack;
end;

procedure TfrmHygieneMaterial.edtLocateExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocate.Text:= 'Pronadji ...';
  edtLocate.Font.Color:= clGray;
end;

procedure TfrmHygieneMaterial.edtLocateKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(zqProduct).Locate(fieldArg, edtLocate.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocate.SelectAll;
    end;
end;

procedure TfrmHygieneMaterial.edtLocatePropertyEnter(Sender: TObject);
begin
  {clear text and set font-color}
  edtLocateProperty.Text:= '';
  edtLocateProperty.Font.Color:= clBlack;
end;

procedure TfrmHygieneMaterial.edtLocatePropertyExit(Sender: TObject);
begin
  {set text and font-color}
  edtLocateProperty.Text:= 'Pronadji ...';
  edtLocateProperty.Font.Color:= clGray;
end;

procedure TfrmHygieneMaterial.edtLocatePropertyKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  {try to locate}
  if(not TZAbstractDataset(zqPropertiesVar).Locate(PROPERTY_NAME, edtLocateProperty.Text, [loCaseInsensitive, loPartialKey])) then
    begin
      Beep;
      edtLocateProperty.SelectAll;
    end;
end;

procedure TfrmHygieneMaterial.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  {check for unsaved changes}
  saveBeforeClose;
  inherited;
end;

procedure TfrmHygieneMaterial.FormCreate(Sender: TObject);
begin
  {default args}
  charArg:= 'A%';
  fieldArg:= PARAM_NAME; {locate using field_name}
end;

procedure TfrmHygieneMaterial.pcProductChange(Sender: TObject);
var
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  //exception if not drugs
  if(TZAbstractDataset(zqProduct).IsEmpty) then
    if(pcProduct.ActivePageIndex > 0) then
      begin
        pcProduct.ActivePageIndex:= 0;
        Application.ProcessMessages;
        raise TENoProducts.Create(ENoProductsMsg);
        Application.ProcessMessages;
        Exit;
      end;
  {else open dataSet}
  case pcProduct.ActivePageIndex of
    0:
       begin
         {enable-disable scrollBtns}
         doAfterOpenDataSet(TZAbstractDataset(zqProduct));
         {show recNo and countRec}
         if(TZAbstractDataset(zqProduct).IsEmpty) then
           begin
             edtRecNo.Text:= recMsg;
             Exit;
           end;
         {find vars}
         recCount:= IntToStr(TZAbstractDataset(zqProduct).RecordCount);
         recNo:= IntToStr(TZAbstractDataset(zqProduct).RecNo);
         {create recMsg}
         recMsg:= recNo + ' od ' + recCount;
         edtRecNo.Text:= recMsg;
       end;
    1:
       begin
         TZAbstractDataset(zqPropertiesVar).DisableControls;
         TZAbstractDataset(zqPropertiesVar).Close;
         TZAbstractDataset(zqPropertiesVar).Open;
         TZAbstractDataset(zqPropertiesVar).EnableControls;
         dbgPropertiesVar.Refresh;
         Application.ProcessMessages;
       end;
  end;
end;

procedure TfrmHygieneMaterial.zqProductAfterDelete(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqProductAfterOpen(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqProductAfterPost(DataSet: TDataSet);
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
  currText:= TZAbstractDataset(DataSet).FieldByName(FD_NAME).AsString;
  {first char to firstChar-var}
  firstChar:= LeftStr(currText, 2); //two chars
  firstChar:= firstChar + '%';
  {compare current charFilter}
  if(charArg <> firstChar) then
    begin
      {save position}
      currId:= TZAbstractDataset(DataSet).FieldByName(FD_ID).AsInteger;
      charArg:= firstChar;
      applyCharFilter;
      {locate}
      TZAbstractDataset(DataSet).Locate(FD_ID, currId, []);
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

procedure TfrmHygieneMaterial.zqProductAfterScroll(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqProductBeforeScroll(DataSet: TDataSet);
begin
  {check current page}
  if (not(pcProduct.ActivePageIndex = 0)) then
    begin
      pcProduct.ActivePageIndex:= 0;
      Application.ProcessMessages;
    end;
end;

procedure TfrmHygieneMaterial.zqProductNewRecord(DataSet: TDataSet);
begin
  {set default values}
  TZAbstractDataset(DataSet).FieldByName(FD_PIECES).AsFloat:= 1;
end;

procedure TfrmHygieneMaterial.zqPropertiesVarAfterDelete(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqPropertiesVarAfterOpen(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqPropertiesVarAfterPost(DataSet: TDataSet);
var
  {calc records(recNo and countRec)}
  recCount, recNo : String;
  recMsg : String = '0 od 0';
begin
  {upply updates}
  TZAbstractDataset(DataSet).ApplyUpdates;
  {rtefresh current row}
  TZAbstractDataset(DataSet).RefreshCurrentRow(True);
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

procedure TfrmHygieneMaterial.zqPropertiesVarAfterScroll(DataSet: TDataSet);
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

procedure TfrmHygieneMaterial.zqPropertiesVarBeforeOpen(DataSet: TDataSet);
var
  current_product : Integer;
begin
  //find current
  current_product:= TZAbstractDataset(zqProduct).FieldByName(FD_ID).AsInteger;
  TZAbstractDataset(zqPropertiesVar).ParamByName(FPV_PRODUCT).AsInteger:= current_product;
end;

procedure TfrmHygieneMaterial.zqPropertiesVarBeforePost(DataSet: TDataSet);
var
  current_product : Integer;
begin
  //find current
  current_product:= TZAbstractDataset(zqProduct).FieldByName(FD_ID).AsInteger;
  TZAbstractDataset(zqPropertiesVar).FieldByName(FPV_PRODUCT).AsInteger:= current_product;
end;

procedure TfrmHygieneMaterial.saveBeforeClose;
var
  newDlg : TdlgConfirm;
  confirmMsg : String = 'Postoje izmene koje nisu sačuvane!';
  saveAll : Boolean = False;
begin
  {set confirm msg}
  confirmMsg:= confirmMsg + #13#10;
  confirmMsg:= confirmMsg + 'Želite da sačuvamo izmene?';
  if((TZAbstractDataset(zqProduct).State in [dsEdit, dsInsert])
      or
      (TZAbstractDataset(zqPropertiesVar).State in [dsEdit, dsInsert])
     )
  then
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
    begin
      if (TZAbstractDataset(zqProduct).State in [dsEdit, dsInsert]) then
        doSaveRec(TZAbstractDataset(zqProduct)); {pharmacyMaterial dataSet}

      if (TZAbstractDataset(zqPropertiesVar).State in [dsEdit, dsInsert]) then
        doSaveRec(TZAbstractDataset(zqPropertiesVar)); {properties_var dataSet}
    end;
end;

procedure TfrmHygieneMaterial.onActFirst;
begin
  {jump to first rec}
  case pcProduct.ActivePageIndex of
    0: doFirstRec(TZAbstractDataset(zqProduct));
    1: doFirstRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActPrior;
begin
  {jump to prior rec}
  case pcProduct.ActivePageIndex of
    0: doPriorRec(TZAbstractDataset(zqProduct));
    1: doPriorRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActNext;
begin
  {jump to next rec}
  case pcProduct.ActivePageIndex of
    0: doNextRec(TZAbstractDataset(zqProduct));
    1: doNextRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActLast;
begin
  {jump to last rec}
  case pcProduct.ActivePageIndex of
    0: doLastRec(TZAbstractDataset(zqProduct));
    1: doLastRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActInsert;
begin
  {set focus and insert new rec}
  case pcProduct.ActivePageIndex of
    0:
       begin
         dbCode.SetFocus;
         doInsertRec(TZAbstractDataset(zqProduct));
       end;

    1:
       begin
         dblProperty.SetFocus;
         doInsertRec(TZAbstractDataset(zqPropertiesVar));
       end;
  end;
end;

procedure TfrmHygieneMaterial.onActDelete;
begin
  {delete rec}
  case pcProduct.ActivePageIndex of
    0: doDeleteRec(TZAbstractDataset(zqProduct));
    1: doDeleteRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActEdit;
begin
  {set focus and edit rec}
  case pcProduct.ActivePageIndex of
    0:
       begin
         dbCode.SetFocus;
         doEditRec(TZAbstractDataset(zqProduct));
       end;

    1:
       begin
          dblProperty.SetFocus;
          doEditRec(TZAbstractDataset(zqPropertiesVar));
        end;
  end;
end;

procedure TfrmHygieneMaterial.onActSave;
begin
  {save rec}
  case pcProduct.ActivePageIndex of
    0: doSaveRec(TZAbstractDataset(zqProduct));
    1: doSaveRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.onActCancel;
begin
  {cancel rec}
  case pcProduct.ActivePageIndex of
    0: doCancelRec(TZAbstractDataset(zqProduct));
    1: doCancelRec(TZAbstractDataset(zqPropertiesVar));
  end;
end;

procedure TfrmHygieneMaterial.openRODataSets;
begin
  //product groups
  zroGroups.DisableControls;
  zroGroups.Open;
  zroGroups.EnableControls;
  //measure
  zroMeasure.DisableControls;
  zroMeasure.Open;
  zroMeasure.EnableControls;
  //taxes
  zroTaxes.DisableControls;
  zroTaxes.Open;
  zroTaxes.EnableControls;
  //property(of hospital equipment)
  zroProperties.DisableControls;
  zroProperties.Open;
  zroProperties.EnableControls;
end;

procedure TfrmHygieneMaterial.applyCharFilter;
begin
  TZAbstractDataset(zqProduct).DisableControls;
  TZAbstractDataset(zqProduct).Close;
  try
    TZAbstractDataset(zqProduct).ParamByName(PARAM_NAME).AsString:= charArg;
    TZAbstractDataset(zqProduct).Open;
    TZAbstractDataset(zqProduct).EnableControls;
    {show arg in cmbChar}
    //cmbCharFilter.ItemIndex:= cmbCharFilter.Items.IndexOf(LeftStr(charArg, 1)); {without '%'}
  except
    on e : Exception do
    begin
      dModule.zdbh.Rollback;
      TZAbstractDataset(zqProduct).EnableControls;
      ShowMessage(e.Message);
    end;
  end;
end;

end.

