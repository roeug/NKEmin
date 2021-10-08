unit UnitFormListMin;

{$MODE Delphi}

interface

uses
 LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
 Grids, NuclideClassesMin, Menus, ExtCtrls, Buttons, EuLibMin;

type

 { T_FormListMin }

 T_FormListMin=class(TForm)
  PanelTop: TPanel;
  SpeedButtonUndock: TSpeedButton;
  StringGridChosenList: TStringGrid;
  procedure FormShow(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
  procedure ItemDelClick(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure SpeedButtonUndockClick(Sender: TObject);
  procedure StringGridChosenListDblClick(Sender: TObject);
  procedure FormResize(Sender: TObject);
  procedure StringGridChosenListKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
 private
    { Private declarations }
 public
    { Public declarations }
  ActiveThZpA: integer;
  ThZpA_sList: TLongIntList;
  procedure InvalidateGrid(Sender: TObject);
 end;
 
var
 _FormListMin: T_FormListMin;
 
implementation

uses UnitNKmin, UnitEditNuclideMin;

{$R *.frm}

procedure T_FormListMin.FormShow(Sender: TObject);
begin
 if ThZpA_Slist.Count=0 then begin
  MessageDlg('The state list is empty !', mtWarning, [mbOK], 0);
  Exit;
 end;
end;

procedure T_FormListMin.InvalidateGrid(Sender: TObject);
var
 I, J, ThZpA, State, InNKlistNo: integer;
 WasShown: Boolean;
 Col0, Col1: TStringList;
begin
 Col0:= TStringList.Create;
 Col1:= TStringList.Create;
 try
  if Visible then begin
   WasShown:= True;
   Hide;
  end
  else
   WasShown:= False;
  Cursor:= crHourGlass;
  with StringGridChosenList, ThZpA_Slist do begin
   RowCount:= 1;
   Col0.Clear;
   Col0.Add('State');
   Col1.Clear;
   Col1.Add('Half life');
  //out Dupljs
   for I:= ThZpA_sList.Count-1 downto 1 do
    for J:= I-1 downto 0 do
     if (ThZpA_sList[I]=ThZpA_sList[J]) then begin
      ThZpA_sList.Delete(J);
      break;
     end;
   ThZpA_sList.Order(False);
   for I:= ThZpA_sList.Count-1 downto 0 do begin
    ThZpA:= ThZpA_sList[I]div 10;
    State:= ThZpA_sList[I]mod 10;
    with _FormNKmin do begin
     InNKlistNo:= _FormNKmin.NuclideList.FindInList(ThZpA div 1000, ThZpA mod 1000);
     if (InNKlistNo>=0) then
      if State<_FormNKmin.NuclideList[InNKlistNo].StateList.Count then
       with _FormNKmin.NuclideList[InNKlistNo].StateList[State] do begin
        RowCount:= RowCount+1;
        Col0.Add(Name);
        if T1_2>0 then
         Col1.Add(T1_2ToStr(T1_2))
        else
         Col1.Add('');
       end
      else begin
       ThZpA_Slist.Delete(I);
      end
     else begin
      ThZpA_Slist.Delete(I);
      end
    end;
   end;
   ThZpA_sList.Order(True);
   Cols[0].Assign(Col0);
   Cols[1].Assign(Col1);
   if RowCount>1 then
    FixedRows:= 1;
  end;
  Caption:= 'The filter list ('+IntToStr(ThZpA_Slist.Count)+')';
  for I:=0 to _FormNKmin.PageControlDockLeft.DockClientCount-1 do
   if (_FormNKmin.PageControlDockLeft.DockClients[I] = Self) then
     _FormNKmin.PageControlDockLeft.Pages[I].Caption := Self.Caption;
  for I:=0 to _FormNKmin.PageControlDockRight.DockClientCount-1 do
   if (_FormNKmin.PageControlDockRight.DockClients[I] = Self) then
     _FormNKmin.PageControlDockRight.Pages[I].Caption := Self.Caption;
 finally
  Cursor:= crDefault;
  Col0.Free;
  Col1.Free;
 end;
 if WasShown then begin
  Show;
 end;
end;

procedure T_FormListMin.FormCreate(Sender: TObject);
begin
 ThZpA_sList:= TLongIntList.Create;
end;

procedure T_FormListMin.FormKeyDown(Sender: TObject; var Key: Word;
 Shift: TShiftState);
begin
 if Key=vk_escape then
  Close;
end;

procedure T_FormListMin.ItemDelClick(Sender: TObject);
var
 I: integer;
begin
 Hide;
 with StringGridChosenList do begin
  if ((Row-1)<ThZpA_Slist.Count) then begin
   ThZpA_Slist.Delete(Row-1);
   for I:= Row to RowCount-1 do
    Rows[I].Assign(Rows[I+1]);
   RowCount:= RowCount-1;
  end;
 end;
 InvalidateGrid(Self);
 if ThZpA_Slist.Count>0 then
  Show;
end;

procedure T_FormListMin.FormDestroy(Sender: TObject);
begin
 ThZpA_sList.Free;
end;

procedure T_FormListMin.SpeedButtonUndockClick(Sender: TObject);
var
  aRect: TRect;
begin
  aRect.Left := Screen.Width div 2 - Self.Width;
  aRect.Top := Screen.Height div 3;
  aRect.Right := aRect.Left + 85;
  aRect.Bottom := aRect.Top + 425;
 Self.ManualFloat(aRect);
 SpeedButtonUndock.Visible:= False;
end;

procedure T_FormListMin.StringGridChosenListDblClick(Sender: TObject);
var
 ThZpA, State, InNKlistNo: integer;
begin
 with StringGridChosenList do begin
  ThZpA:= ThZpA_sList[Row-1]div 10;
  State:= ThZpA_sList[Row-1]mod 10;
  InNKlistNo:= _FormNKmin.NuclideList.FindInList(ThZpA div 1000, ThZpA mod 1000);
 end;
 with _FormNKmin do
  if ((Visible)and(InNKlistNo>=0)) then begin
   if State<NuclideList[InNKlistNo].StateList.Count then begin
    ActiveThZpA:= ThZpA;
    GoToThZpACenter(ActiveThZpA);
    StringGridNKDblClick(Self);
    with _FormEditNuclideMin do
     if Visible then
      case State of
       0: if SpeedButtonGstate.Visible then begin
           SpeedButtonGstate.Down:= True;
           SpeedButtonGstateClick( Self);
          end;
       1: if SpeedButtonM1state.Visible then begin
           SpeedButtonM1state.Down:= True;
           SpeedButtonM1stateClick( Self);
          end;
       2: if SpeedButtonM2state.Visible then begin
           SpeedButtonM2state.Down:= True;
           SpeedButtonM2stateClick( Self);
          end;
      end;
   end
   else
    MessageDlg('The state not found in NUKLIDKARTE !', mtWarning, [mbOK], 0);
  end;
end;

procedure T_FormListMin.FormResize(Sender: TObject);
begin
 with StringGridChosenList do begin
  ColWidths[0]:= ((ClientWidth)div 7)*3-ColCount;
  ColWidths[1]:= ClientWidth-ColWidths[0]-ColCount;
 end;
 SpeedButtonUndock.Left:= Self.Width - Self.SpeedButtonUndock.Width;
end;

procedure T_FormListMin.StringGridChosenListKeyDown(Sender: TObject;
 var Key: Word; Shift: TShiftState);
begin
 if (StringGridChosenList.Selection.Left<StringGridChosenList.Selection.Right)or((StringGridChosenList.Selection.Bottom>StringGridChosenList.Selection.Top)  ) then
 begin
   // Ctrl+Ins or Ctrl+C
   if (not (ssAlt in Shift) and (ssCtrl in Shift) and ((Key = VK_INSERT) or (Key = Ord('C')))) then
   begin
    CopyToClipboardFromStringGrid(StringGridChosenList)
   end;
 end;
 if (not (ssAlt in Shift) and (ssCtrl in Shift) and (Key = VK_RETURN)) then
  StringGridChosenListDblClick(Self);
end;


end.

