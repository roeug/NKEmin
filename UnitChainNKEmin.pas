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
    OldExt                wòTê$¿çx²ÿ ·íÿ §-°×kòP˜                                                                                                        V©C u¶£ŞM«Ò;ókÛ]O®m}Q¨éGmöé³:rdóHè¢¢×/f¾j‹ò;&…çg¸                                                                                                       ÄG#/Ô«o~7¿u8í‘»»#§^Ô1õ&i¼¶åÎ$*£Éb”ÙV¾ácSB"¢¸¹J³ÙPá7x8ÀàúØÊ8]Ö‡Kß®ÕÉ[$½=>$Ç§ùe^XÏôW¿,L­=7WjÆ;Ôl=ûÅ~ØÖ_ŞúİÀşªµë[¼Zß´Û®S¥×!Q¤¥ô‰ä[zC=•WıÊ“)€5¿søáão‰]+~áâÛµäİo1¶èûÉnˆËj±äF}:îª0«RRîSÕQ}sÛü5ø@IMGQñ5rj˜ŠÌiLéË%Ï.Ôö^&B"ráQQQŠ—>Î¦2¡j­·CQğ‡^oíi=á¢ûºÎDš­6é"E1iæÿ =IK(ÕWÿ àBµG¦•·kY´×‹¥¡‰w=CLU}UŠXuÿ :¿Èã·?+¬/2›Oñ-÷*Ù©"Ê“ªÖtv^OE©„ÒÔŸDqäİ^!'ì½ªİ¥öşÓ n×w^UíZYë?ï°²`³!:HÂÕDº{õóŒsSË“íöã[ÄWTé{~ì]ï7³ƒrIr¯K
5š2¹¥ï/ÊÍ)&BrU*FŞF*õLT¹]ØÍ‹Ûşøz‡·»yhHğc¢=&MT¢Éÿ -(²^TËË„ş‰éŒ'e~\àZïÅíÿ =LÛíÃ´$ˆ2^&šQ$À–¤I/*áäÊÿ UõÊ¢Ñg<!n§›Äõ›UÙfÜ¬JO²5kjÓà*á2«„	úlç²¯tî¡Ş6Ÿ)mš^ôÎß]ßfŠzdè\•ùª1!¤Oàÿ S²\ñ¤Õ²ríôl=….ëæÙ.­Dç”ÿ S«ìt3V•*Ã­*á%(å¸»‡Å‡Wëİı1xÔ¶:ÔYôæ”"›e¹R;US•uj”«]}êê=uü†>·ğØà¢ÿ ¶º^íñ¡áEº«1JY®­µ:LZ2’Vg—ÂùY4ªQÒîÒ©/-§`,á¶èj>ĞëùÚ{6ûp‘ªv£Qô™kQAX”ITçXÒ?z<œf…^”„¦®_~TÏ¨:ºçAêÍ´İ†ÖÖ™V[ı¥Ş„øÒ*ş‹õOE7×j<Zµ¦ƒá–Í£µn“s\jHêeÛäÛ¯•¦D¨‰Ö¯ïDª©Y”ªöDÄUÄ…Z‘Cğjş ®›UÏEèmi°Òß—jÍrGç-U/ngäe¬ÿ $o·®}ú—v7Œ¾9Ùf|©õ.–¶ÌäoÓ~JÚcÈ¥¤õª”uUü*şs®cQ°KÀÏ…üj¬vMÙâZÇ"™”9EÆ‘›OÜô¿ÅIô¯¿ªù\¦0ˆşy•Šm!¶èj>Ğ¢%L                                                                                                         ?,¸W»†’ÙE©ív^ dµK¸Ç¶Æüëƒí1šcar®á²#Z<,5E®ıàÑ£mV§’KúZuÆßqª´Â0ıRª“ÊŸø<Ê{ÿ  7¯Ó¡0                                                                  âòÇS ¸„ãcø^µ0Îæ_æ;u›]…c·±TÉ²šDÂÕNqJ'Wœm¾ ÖM#ãE´4½nnÒëK5Â·Õ#±h®4øÕ3„Âõª2÷\öéöù©ï¿Ã?ÂÕí¹ÿ Êßnÿ —Ål4{M'_Ï‹©6gTÚì[î1nçJ¾ú*«IJcäëŸğ›e°\Ul·ú"l½±¾M™.Õ+·ˆOÀ‘]¿Ìóa?~
¿%×ëİC¼h¥ºã¢c±”nŠSĞ¢r’                                                                                                                                      ;ù*uG_ó¼YÛöÿ Ó–Økµù(L                                                                                                        øc¨“ÇºÓ_÷B;u—©jspÑÌD¶Ñ¯Ä²íæb¾÷˜EÂt–Š
™_6˜^ÊY«dÈ                                                                                                       *%h†ÜNé:Øtè_`:Ø#m¶» \P‡¥»Ûí7è4E¸Ä‹1ªd4õ4¿ìûURûÑQªÜîøsİ|©¶£MÇ¸j
ıîÛiê’]\¬„‘É•=ò¹ïêÏ6„á†¯´[Ñû%£bÉ´<²`ÜdÛ’lÆ$g(©!ş£é…ÿ ²vö–½µ›[1?T¶Ó&‹é-ƒ­j©gé"->[¶cã–ŸL~ê|ç·CTa?¨¢ŠÏ(Z(­;˜qºcè@ï/»¾6­vşÕKn?åîp)¢%Á—ßóKV$%=ÿ 6§ğ