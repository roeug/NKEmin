unit UnitChainNKEmin;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, NuclideClassesMin, StdCtrls; // Messages,

type

  { T_FormChainNKEmin }

  T_FormChainNKEmin = class(TForm)
    PanelBottom: TPanel;
    SaveDialog: TSaveDialog;
    ScrollBoxImage: TScrollBox;
    Image: TImage;
    ButtonClose: TButton;
    ButtonSaveChain: TButton;
    ButtonSaveImage: TButton;
    CheckBoxAsDecayChain: TCheckBox;
    procedure ButtonSaveImageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ButtonSaveChainClick(Sender: TObject);
  private
    fMamaThZpA_s: integer;
    fMamaState: TNuclideState;
    fNuclideList: TNuclideList;
    fSubBranchingRecordList: TSubBranchingRecordList;
    fSaveDialog: TSaveDialog;
    procedure SetMamaThZpA_s(aMamaThZpA_s: integer);
    procedure SetImageSize(const aWidth, aHeight: integer);
  public
    { Public declarations }
    procedure PaintTheChain;
    procedure PaintDecayChain;
    property SubBranchingRecordList: TSubBranchingRecordList read fSubBranchingRecordList write fSubBranchingRecordList;
    property MamaThZpA_s: integer read fMamaThZpA_s write SetMamaThZpA_s;
    property NuclideList: TNuclideList read fNuclideList write fNuclideList;
  end;

var
  _FormChainNKEmin: T_FormChainNKEmin;

implementation

{$R *.frm}

uses
  ChainClassesMin, CadClassesMin, EuLibMin, UnitNKmin;

var
  fChain: TChain;
  fChainImage: TChainCAD;

{ T_FormChainNKE }

procedure T_FormChainNKEmin.SetImageSize(const aWidth, aHeight: integer);

  procedure AdjustImagePictureGraphicSize(InWidth, InHeight: integer);
  const
    Divider = 100;
    Factor = 99;
  begin
    if ((InHeight > 0) and (InWidth > 0)) then
      try
        Image.Picture.Graphic.Height := InHeight;
        Image.Picture.Graphic.Width := InWidth;
      except
        AdjustImagePictureGraphicSize(InWidth * Factor div Divider, InHeight * Factor div Divider);
      end;
  end;

begin
  if ((Image.Picture.Graphic) <> nil) then
    try
      if ((Image.Picture.Graphic.Height <> aHeight) or (Image.Picture.Graphic.Width <> aWidth)) then
      begin
        Image.Height := aHeight;
        Image.Picture.Graphic.Height := aHeight;
        Image.Width := aWidth;
        Image.Picture.Graphic.Width := aWidth;
      end;
    except
      on EOutOfResources do
      begin
        MessageDlg('Can not set new image size !' + #10#13 + 'Out of resources: not enough storage is available. Sorry.', mtWarning, [mbOK], 0);
        AdjustImagePictureGraphicSize(aWidth, aHeight);
      end
      else
        MessageDlg('Can not set new image height !', mtWarning, [mbOK], 0);
    end;
end;

procedure T_FormChainNKEmin.SetMamaThZpA_s(aMamaThZpA_s: integer);
var
  I, SavefMamaThZpA_s: integer;
  MamaAndChilds: TLongIntList;
  aState: TNuclideState;
  StateName: string;
begin
  SavefMamaThZpA_s := fMamaThZpA_s;
  try
    aState := NuclideList.FindThZpA_sState(aMamaThZpA_s);
    if (aState <> nil) then
    begin
      if not ((aState.IsStable) or (aState.T1_2 <= 0)) then
      begin
        fChain.Links.Clear;
        fChain.States.Clear;
        fMamaThZpA_s := aMamaThZpA_s;
        fMamaState := fNuclideList.FindThZpA_sState(fMamaThZpA_s);
        if fMamaState <> nil then
        begin
          Self.Caption := 'Network chain ' + fMamaState.Name + ' and decay products';
          PanelBottom.Enabled := True;
          // Build Chain
          MamaAndChilds := TLongIntList.Create;
          try
            MamaAndChilds.AddUniq(fMamaThZpA_s);
            if GetAllDPR(fMamaThZpA_s, fNuclideList, fSubBranchingRecordList, MamaAndChilds) > 0 then
            begin
              fChainImage.Links.Clear;
              fChainImage.States.Clear;
              for I := 0 to MamaAndChilds.Count - 1 do
              begin
                aState := fNuclideList.FindThZpA_sState(MamaAndChilds[I]);
                StateName := aState.Name;
                fChainImage.AddStateByName(StateName, True, [ntDecay], fNuclideList, nil);
                repeat
                  Application.ProcessMessages;
                until not (fChainImage.Working);
              end;
              if CheckBoxAsDecayChain.Checked then
                PaintDecayChain
              else
                PaintTheChain;
            end;
          finally
            MamaAndChilds.Free;
          end;
        end
        else
        begin
          Self.Caption := 'NIL in Mama.State !!! ';
          PanelBottom.Enabled := False;
          MessageDlg(
            'The nuclide state not found' + #13 + #10 + 'The decay chain is empty !', mtWarning, [mbOK], 0);
          fMamaThZpA_s := SavefMamaThZpA_s;
        end;
      end
      else
      begin
        MessageDlg('The decay chain is empty ' + #13 + #10 + 'May be parent is stable ' + #13 + #10 + '       or ' +
          #13 + #10 + 'the half-life unknown', mtWarning, [mbOK], 0);
        fMamaThZpA_s := SavefMamaThZpA_s;
        exit;
      end;
    end
    else
    begin
      MessageDlg('The decay chain is empty (Nuclide was not found in NuclideList)', mtWarning, [mbOK], 0);
      fMamaThZpA_s := SavefMamaThZpA_s;
      exit;
    end;
  except
    fMamaThZpA_s := SavefMamaThZpA_s;
  end;
end;

procedure T_FormChainNKEmin.FormCreate(Sender: TObject);
begin
  fNuclideList := _FormNKmin.NuclideList;
  fChain := TChain.Create;
  fChainImage := TChainCAD.Create(fChain);
  fChainImage.OnChange := nil;
  fChainImage.Canvas := nil;
  fChainImage.ShowHalfLife := True;
end;

procedure T_FormChainNKEmin.ButtonSaveImageClick(Sender: TObject);
var
  OldFilterIndex: integer;
  OldFilter, OldExt: string;
  Bitmap: TBitmap;
  Png: TPortableNetworkGraphic;
  FileExtenstion: string;
begin
  with SaveDialog do
  begin
    OldFilterIndex := FilterIndex;
    OldExt := DefaultExt;
    OldFilter := Filter;
    Filter := 'Bitmap (*.bmp)|*.bmp|Portable network graphic (*.png)|*.png';
    DefaultExt := 'bmp';
    FilterIndex := 1;
    FileName := '';
    if SaveDialog.Execute then
    begin
      FileExtenstion := UpperCase(Trim(ExtractFileExt(SaveDialog.FileName)));
      Bitmap := TBitmap.Create;
      Png := TPortableNetworkGraphic.Create;
      try
        if (FileExtenstion = '.BMP') then
        begin
          // BMP
          try
            Bitmap.LoadFromDevice(Image.Canvas.Handle);
            Bitmap.SaveToFile(SaveDialog.FileName);
          except
          end;
        end
        else
        if (FileExtenstion = '.PNG') then
          // PNG
        begin
          try
            Png.LoadFromDevice(Image.Canvas.Handle);
            Png.SaveToFile(SaveDialog.FileName);
          except
          end;
        end
        else
        begin
          MessageDlg('Unsupported format (' + FileExtenstion + ')' + #10#13 + ' Use BMP|PNG *TODO others)!' + #10#13 +
            ' Will not export', mtWarning, [mbOK], 0);
        end;
      finally
        Bitmap.Free;
        Png.Free;
        Filter := OldFilter;
        DefaultExt := OldExt;
        FilterIndex := OldFilterIndex;
      end;
    end;
  end;
end;


procedure T_FormChainNKEmin.ButtonCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure T_FormChainNKEmin.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  Image.Visible := True;
  SetImageSize(fChainImage.Width, fChainImage.Height);
  Application.ProcessMessages;
end;

procedure T_FormChainNKEmin.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = vk_escape then
    Close;
end;

procedure T_FormChainNKEmin.ButtonSaveChainClick(Sender: TObject);
var
  OldFilterIndex: integer;
  OldFilter, OldExt: string;
begin
  with SaveDialog do
  begin
    OldFilterIndex := FilterIndex;
    OldExt                w?T??$??x?? ??? ?-??k?P?                                                                                                        V?C u???M??;?k?]O?m}Q??Gm???:rd?H????/f?j??;&??g?                                                                                                       ??G#/??o~7?u8????#?^?1?&i????$*??b???V??cSB"???J??P??7x8??????8]??K????[$?=>$???e^X??W?,L?=7Wj?;?l=??~??_????????[?Z????S??!Q?????[zC=?W???)?5?s???o?]+~??????o1????n??j??F}:??0?RR?S?Q}s??5?@IMGQ?5rj???iL??%?.??^?&B"r?QQQ??>??2?j??CQ???^o?i=??????D??6?"E1i??? =IK(???W? ?B?G????kY???????w=CLU}U?Xu? :?????+??/2?O?-?*??"????tv^OE??????Dq??^!'?????????n?w^U?ZY?????`?!:H??D?{???sS???????[?WT?{~?]?7??rIr?K
5?2???/??)&BrU*F?F*?LT?]??????z???yhH?c?=&MT???? -(?^T???????'e~\?Z????? =L????$?2^?&?Q$???I/*???? U????g<!n?????U?f??JO?5kj???*?2??	?l???t???6??)m?^???]?f?zd?\???1!?O??? S?\????r??l=?.???.?D???? S??t3V?*??*?%(??????W????1x???:?Y????"?e?R;US?uj??]}??=?u??>?????? ???^????E??1JY???:LZ2?Vg???Y4?Q?????/-?`,???j>????{6?p??v?Q??kQAX?IT?X??z<?f?^????_~T??:??A?????????V[??????*???OE7?j<Z????????n?s\jH?e??????D??????D??Y???D?U??Z?C?j?? ???U?E?mi????j?rG?-U/ng?e?? $o??}??v7??9?f|???.?????o?~J?c??????uU?*?s?c?Q?K????j?vM??Z?"??9E???O????I?????\?0??y??m!??j>??%L                                                                                                         ?,?W????E??v^??d?K????????1?car???#Z<,5E?????mV??K?Zu??q???0?R?????<?{?  7???0                                                                  ???S????c?^?0??_?;u?]?c??T???D??NqJ'W?m? ?M#?E?4?nn??K5???#?h?4??3?????2?\?????????????? ??n? ??l4{M'_???6gT??[?1n?J??*?IJc?????e?\Ul??"l???M?.?+??O??]???a?~
?%???C?h????c??n?S??r?                                                                                                                                      ;?*uG_??Y???? ???k??(L                                                                                                        ?c?????_?B;u??j?s?p??D???????b???E?t??
?_6?^?Y?d?                                                                                                       *%h??N??:?t?_`:?#m??? \P?????7?4E???1?d4?4???UR??Q????s??|????M??j
?????i???]\?????=??????6??????[??%?b??<?`?d??l?$g(?!????? ?v?????[1??T???&??-??j??g?"->[?c???L~?|????CTa?????(Z(?;?q?c?@?/??6??v??Kn???p)?%????KV$%=? 6??