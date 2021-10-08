program NKEminW32;

{$MODE Delphi}

uses
  Forms, Sysutils, Dialogs,
  Interfaces,
  UnitDM_OOB,
  UnitSplashMin in 'UnitSplashMin.pas' {_FormSplash},
  UnitNKmin in 'UnitNKmin.pas' {_FormNKmin},
  ChainClassesMin in 'ChainClassesMin.pas',
  Encryp in 'Encryp.pas',
  NuclideClassesMin in 'NuclideClassesMin.pas',
  UnitDPrChooseCriteriaNKEmin in 'UnitDPrChooseCriteriaNKEmin.pas' {_FormDPRChooseCriteria},
  UnitEditElementMin in 'UnitEditElementMin.pas' {_FormEditElement},
  UnitEditNuclideMin in 'UnitEditNuclideMin.pas' {_FormEditNuclide},
  UnitFormListMin in 'UnitFormListMin.pas' {_FormListMin},
  UnitGoToDialogMin in 'UnitGoToDialogMin.pas' {_FormGoToDialog},
  UnitLegendMin in 'UnitLegendMin.pas' {_FormLegend},
  DM_OOD in 'DM_OOD.pas',
  UnitDecayMin in 'UnitDecayMin.pas' {_FormDecay},
  EuLibMin in 'EuLibMin.pas',
  UnitChooseCriteriaMin in 'UnitChooseCriteriaMin.pas' {_FormChooseCriteria},
  UnitChainNKEmin in 'UnitChainNKEmin.pas' {_FormChainNKEmin},
  QStringsMin in 'QStringsMin.pas',
  ObjectsMin in 'ObjectsMin.pas';

// {.$R *.RES}
(*
const
// HelpContext - no help TODO?
  hc_Introduction = 1;
  hc_Overview = 2;
  hc_Main_Program_Window = 3;
  hc_Filter_Utility = 4;
  hc_Contents = 5;
  hc_Nuclide_Properties = 6;
  hc_Ground_state = 7;
  hc_Metastable_M1_State = 8;
  hc_Alpha_Lines = 9;
  hc_Beta_Spectrum = 10;
  hc_Gamma_Lines = 11;
  hc_Positron_Spectrum = 12;
  hc_Electron_Lines = 13;
  hc_Neutron_Reactions_Cross_Sections = 14;
  hc_Fission_Yields = 15;
  hc_Decay_Calculator = 16;
  hc_Element_Properties = 17;
  hc_Data_Sources = 18;
  hc_Loading_another_data_file = 19;
  hc_Coding_Team = 20;
  hc_Filter_Results = 21;
  hc_FilterPlus_Utility = 22;
  hc_ChainNKE = 23;
*)
var
  _DataModuleOOB: T_DataModuleOOB;
  aNoOfStatesLoaded: integer;
  aDataFileNameToLoad: string;

{$R *.res}

begin
  RequireDerivedFormResource := False;
  Application.Scaled := True;

  Application.Initialize;
  Application.Title := 'NUKLIDKARTE';
  // no help TODO?
  // Application.HelpFile := '';
  _FormSplashMin := T_FormSplashMin.Create(Application);
  _FormSplashMin.WindowState := wsNormal;
  with _FormSplashMin do
  begin
    Show;
    Update; {Process any pending Windows paint messages}
  end;
  _DataModuleOOB := T_DataModuleOOB.Create;
  aDataFileNameToLoad:= ExtractFilePath(Application.ExeName)+'ORIP_XXId.oob';
  aNoOfStatesLoaded:= _DataModuleOOB.AfterCreate( aDataFileNameToLoad);
  if (aNoOfStatesLoaded<=0) then
    ShowMessage('No states loaded!');
  Application.CreateForm(T_FormNKmin, _FormNKmin);
  _FormNKmin.WindowState := wsMaximized;
  _FormNKmin.TheDataModule := _DataModuleOOB;
  try
    with _FormSplashMin do
    begin
      Update; {Process any pending Windows paint messages}
      if (_FormNKmin.TheDataModule is T_DataModuleOOB) then
        T_DataModuleOOB(_FormNKmin.TheDataModule).PanelDatabaseName := _FormNKmin.PanelDatabaseName;
      _FormNKmin.MainMenuNKEItemReloadDBClick(_FormNKmin); //Load NuclideList
      _FormNKmin.LoadElements;;
    end;
    Application.ProcessMessages;
  finally {Make sure the splash screen gets released}
    _FormSplashMin.Close;
    _FormNKmin.ShowSplashScreen := True;
  end;
  _FormNKmin.Show;
  _FormLegendMin:= T_FormLegendMin.Create(Application);
  _FormLegendMin.WindowState:= wsNormal;
  _FormEditNuclideMin:= T_FormEditNuclideMin.Create(Application);
  _FormEditNuclideMin.WindowState:= wsNormal;
  _FormEditElementMin:= T_FormEditElementMin.Create(Application) ;
  _FormEditElementMin.WindowState:= wsNormal;
  _FormDecayMin:= T_FormDecayMin.Create(Application);
  _FormDecayMin.WindowState:= wsNormal;
  _FormChainNKEmin:= T_FormChainNKEmin.Create(Application);
  _FormChainNKEmin.WindowState:= wsNormal;

  _FormChooseCriteriaMin:= T_FormChooseCriteriaMin.Create(Application);
  _FormChooseCriteriaMin.WindowState:= wsNormal;
  _FormDPRChooseCriteriaMin:= T_FormDPRChooseCriteriaMin.Create(Application) ;
  _FormDPRChooseCriteriaMin.WindowState:= wsNormal;
  _FormListMin:= T_FormListMin.Create(Application);
  _FormListMin.WindowState:= wsNormal;
  _FormGoToDialogMin:= T_FormGoToDialogMin.Create(Application) ;
  _FormGoToDialogMin.WindowState:= wsNormal;
  // HelpContext - no help TODO?
(*
 _FormNKmin.HelpContext:= hc_Main_Program_Window;
 _FormChooseCriteriaMin.HelpContext:= hc_Filter_Utility;
 _FormDPRChooseCriteriaMin.HelpContext:= hc_FilterPlus_Utility;
 _FormChainNKEmin.HelpContext:=  hc_ChainNKE;
 _FormEditNuclideMin.HelpContext:= hc_Nuclide_Properties;
 _FormDecayMin.HelpContext:= hc_Decay_Calculator;
 _FormEditElementMin.HelpContext:= hc_Element_Properties;
 _FormListMin.HelpContext:= hc_Filter_Results;
//  HelpContext end
*)
  Application.Run;
end.
