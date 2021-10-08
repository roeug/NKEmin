unit DM_OOD;

{$MODE Delphi}

interface

uses NuclideClassesMin, ObjectsMin;

type
 AlphaRec = TAlpha;
 BetaRec = TBeta;
 GammaRec = TGamma;
//  SubBranching - later  TODO?
(*
 TSubBranchType= ( sbA, sbBM, sbEC, sbIT, sbN, sbP, sbSF, sbQ,  // Decay
                   sbCaptureT, sbCaptureR, sbCaptureF,          // Capture
                   sbYieldT, sbYieldF, sbYieldS,                // Fission
                   sbNP, sbNA, sbN2N, sbNN, sbNG                // Threshold
                   );
 function sd2dt(const aSubBranchingType:  TSubBranchType): TDecayType; TODO?
*)
 TVUniThZpA_s = class(TVUniNumberObj) // abstract !!!
  function GetThZpA_s: integer;
  procedure SetThZpA_s(aThZpA_s: integer);
 public
  property ThZpA_s: integer read GetThZpA_s write SetThZpA_s;
 end;

 TVState = class(TVUniThZpA_s)
 private
  fT1_2: double;      // 10 bytes 80 bit double in FPC64 - 8 bytes
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor CreateFromNuclideState(aState: TNuclideState);
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property T1_2: double read fT1_2 write fT1_2;
 end;

 TVStateColl = class(TVUniNumberColl) // TVCollection)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVAbundance = class(TVUniNumberObj)
 private
  fAbundance: double;
  function GetThZpA: integer;
  procedure SetThZpA(aThZpA: integer);
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA: integer read GetThZpA write SetThZpA;
  property Abundance: double read fAbundance write fAbundance;
 end;

 TVAbundanceColl = class(TVUniNumberColl) // TVCollection)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVElement = class(TVUniNumberObj)
 private
  fAmassMean: double;
  fSymbol: string[2];
  fRo: double; // Ro_g/cm^3
  fksi: double;
  fSigmaS: double;
  fRI: double;
  fSigmaA: double;
  function GetSymbol: shortstring;
  procedure SetSymbol(const Value: shortstring);
  function GetZnum: integer;
  procedure SetZnum(aZnum: integer);
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor CreateFromElement(aElement: TElement);
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property AmassMean: double read fAmassMean write fAmassMean;
  property Symbol: shortstring read GetSymbol write SetSymbol;
  property Znum: integer read GetZnum write SetZnum;
  property Ro: double read fRo write fRo;
  property ksi: double read fksi write fksi;
  property SigmaS: double read fSigmaS write fSigmaS;
  property RI: double read fRI write fRI;
  property SigmaA: double read fSigmaA write fSigmaA;
 end;

 TVElementColl = class(TVUniNumberColl)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVDecay = class(TVObject)
 private
  fThZpA_s: integer;
  fDecayType: TDecayType;
  fBranching: double;
  fState: TVState; // VState pointer
 public
  function IsEqual(Obj: Pointer): Boolean; virtual;
  constructor Create; override;
  constructor CreateFromStateDecay(const aState: TNuclideState; const aDecay: TDecay);
  constructor Load(S: TVStream; Version: Word); override;
  procedure SetDecayType(const DecayMode: shortstring);
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property DecayType: TDecayType read fDecayType write fDecayType;
  property Branching: double read fBranching write fBranching;
 end;

 TVDecayColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ThZpA_s;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  procedure UpdateLink(const LinkID: ShortString; AColl: TVUniCollection); virtual; // QQQQ was override;
  procedure RemoveLink(const LinkID: ShortString); virtual; // QQQQ was override;
 end;

 TVSigmaC = class(TVObject)
 private
  fThZpA_s: integer;
  fProductState: integer;
  fSigma: double;
  fg_factor: double;
 public
  function IsEqual(Obj: Pointer): Boolean; virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property ProductState: integer read fProductState write fProductState;
  property Sigma: double read fSigma write fSigma;
  property g_factor: double read fg_factor write fg_factor;
 end;

 TVSigmaCColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ThZpA_s;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVRI = class(TVObject)
 private
  fThZpA_s: integer;
  fProductState: integer;
  fRI: double;
 public
  function IsEqual(Obj: Pointer): Boolean; virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property ProductState: integer read fProductState write fProductState;
  property RI: double read fRI write fRI;
 end;

 TVRIColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ThZpA_s;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVSigmaF = class(TVUniThZpA_s)
 private
  fSigma: double;
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property Sigma: double read fSigma write fSigma;
 end;

 TVSigmaFColl = class(TVUniNumberColl)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVRIf = class(TVUniThZpA_s)
 private
  fRI: double;
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property RI: double read fRI write fRI;
 end;

 TVRIFColl = class(TVUniNumberColl)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVSigmaThreshold = class(TVUniThZpA_s)
 private
  fg_factor: double;
  fSigmaNP: double;
  fSigmaNA: double; // (n,alpha)
  fSigmaN2N: double;
  fSigmaNN: double; // (n,n')
  fSigmaNG: double; // (n,gamma)-fast
 public
  function IsEqual(Obj: Pointer): Boolean; override; // virtual;
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property g_factor: double read fg_factor write fg_factor;
  property SigmaNP: double read fSigmaNP write fSigmaNP;
  property SigmaNA: double read fSigmaNA write fSigmaNA;
  property SigmaN2N: double read fSigmaN2N write fSigmaN2N;
  property SigmaNN: double read fSigmaNN write fSigmaNN;
  property SigmaNG: double read fSigmaNG write fSigmaNG;
 end;

 TVSigmaThresholdColl = class(TVUniNumberColl)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

{ TVYield }
 TVYield = class(TVObject)
 private
  fThZpA_s: integer;
  fProductThZpA_s: integer;
  fIndYield: double;
  fCumYield: double;
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property ProductThZpA_s: integer read fProductThZpA_s write fProductThZpA_s;
  property IndYield: double read fIndYield write fIndYield;
  property CumYield: double read fCumYield write fCumYield;
 end;

 TVYieldColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ProductThZpA_s;  // The only for Yields
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVYieldT = class(TVYield);
 TVYieldF = class(TVYield);
 TVYieldTColl = class(TVYieldColl);
 TVYieldFColl = class(TVYieldColl);

{ TVAlpha }
 TVAlpha = class(TVObject)
 private
  fThZpA_s: integer;
  fProbability: double;
  fMeV: double;
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property Probability: double read fProbability write fProbability;
  property MeV: double read fMeV write fMeV;
 end;

 TVAlphaColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ThZpA_s;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVGamma = class(TVAlpha);
 TVGammaColl = class(TVAlphaColl);
 TVElectron = class(TVAlpha);
 TVElectronColl = class(TVAlphaColl);

 TVBeta = class(TVAlpha)
 private
  fMaxMeV: double;
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property MaxMeV: double read fMaxMeV write fMaxMeV;
 end;

 TVBetaColl = class(TVAlphaColl);
 TVPositron = class(TVBeta);
 TVPositronColl = class(TVBetaColl);

 TVSubBranching = class(TVObject)
 private
  fThZpA_s: integer;
  fBranchingName: string[2];
  fBranchingToG: double;
  fBranchingToM1: double;
  fBranchingToM2: double;
  function GetName: shortstring;
  procedure SetName(const Value: shortstring);
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property SubBranchingName: shortstring read GetName write SetName;
  property BranchingToG: double read fBranchingToG write fBranchingToG;
  property BranchingToM1: double read fBranchingToM1 write fBranchingToM1;
  property BranchingToM2: double read fBranchingToM2 write fBranchingToM2;
 end;

 TVSubBranchingColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ThZpA_s;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVFastFission = class(TVUniThZpA_s)
 private
// fThZpA_s: integer;
  fSigma: double;
// fg_factor: double;
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
// property ThZpA_s: integer read fThZpA_s write fThZpA_s;
  property Sigma: double read fSigma write fSigma;
// property g_factor: double read fg_factor write fg_factor;
 end;

 TVFastFissionColl = class(TVUniNumberColl)
 private
 public
  constructor Create; override;
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

 TVSpecialCaptureCase = class(TVObject)
 private
  fParentThZpA_s: integer;
  fChildThZpA_s: integer;
  fSigma: double;
  fg_factor: double;
  fRI: double;
 public
  constructor Create; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
  function Clone: Pointer; override;
  property ParentThZpA_s: integer read fParentThZpA_s write fParentThZpA_s;
  property ChildThZpA_s: integer read fChildThZpA_s write fChildThZpA_s;
  property Sigma: double read fSigma write fSigma;
  property g_factor: double read fg_factor write fg_factor;
  property RI: double read fRI write fRI;
 end;

 TVSpecialCaptureCaseColl = class(TVUniCollection)
 private
 public
  constructor Create; override;
  procedure MakeIndexBy_ParentThZpA_s; // the only
  function Clone: Pointer; override;
  constructor Load(S: TVStream; Version: Word); override;
  procedure Store(S: TVStream); override;
 end;

const
 IndexBy_T1_2 = 'IndexBy_T1_2';
 IndexBy_ThZpA_s = 'IndexBy_ThZpA_s';
 IndexBy_ParentThZpA_s = 'IndexBy_ParentThZpA_s';
 IndexBy_Branching = 'IndexBy_Branching';
 IndexBy_Abundance = 'IndexBy_Abundance';
 IndexBy_Sigma = 'IndexBy_Sigma';
 IndexBy_RI = 'IndexBy_RI';
 IndexBy_CumYield = 'IndexBy_CumYield';
 IndexBy_ProductThZpA_s = 'IndexBy_ProductThZpA_s';
 IndexBy_Probability = 'IndexBy_Probability';
 IndexBy_MeV = 'IndexBy_MeV';
 rg_TVState = 1001;
 rg_TVStateColl = 1002;
 rg_TVElement = 1003;
 rg_TVElementColl = 1004;
 rg_TVDecay = 1005;
 rg_TVDecayColl = 1006;
 rg_TVAbundance = 1007;
 rg_TVAbundanceColl = 1008;
 rg_TVSigmaF = 1009;
 rg_TVSigmaFColl = 1010;
 rg_TVRIF = 1011;
 rg_TVRIFColl = 1012;
 rg_TVSigmaThreshold = 1013;
 rg_TVSigmaThresholdColl = 1014;
 rg_TVSigmaC = 1015;
 rg_TVSigmaCColl = 1016;
 rg_TVRI = 1017;
 rg_TVRIColl = 1018;
 rg_TVYieldT = 1019;
 rg_TVYieldTColl = 1020;
 rg_TVYieldF = 1021;
 rg_TVYieldFColl = 1022;
 rg_TVAlpha = 1023;
 rg_TVAlphaColl = 1024;
 rg_TVGamma = 1025;
 rg_TVGammaColl = 1026;
 rg_TVElectron = 1027;
 rg_TVElectronColl = 1028;
 rg_TVBeta = 1029;
 rg_TVBetaColl = 1030;
 rg_TVPositron = 1031;
 rg_TVPositronColl = 1032;
 rg_TVSubBranching = 1033;
 rg_TVSubBranchingColl = 1034;
 rg_TVFastFission = 1035;
 rg_TVFastFissionColl = 1036;
 rg_TVSpecialCaptureCase = 1037;
 rg_TVSpecialCaptureCaseColl = 1038;
{ Links }
 ThZpA_s_Link = 'ThZpA_s';

implementation

uses QStringsMin;
{ TVUniThZpA_s }

function TVUniThZpA_s.GetThZpA_s: integer;
begin
 Result:= Number;
end;

procedure TVUniThZpA_s.SetThZpA_s(aThZpA_s: integer);
begin
 if aThZpA_s <> Number then
  Number:= aThZpA_s;
end;
{ TVState }

function TVState.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVState.Create;
begin
 inherited;
end;

constructor TVState.CreateFromNuclideState(aState: TNuclideState);
begin
 Create;
 fT1_2:= aState.T1_2;
 Number:= 10 * (1000 * aState.Nuclide.Znum + aState.Nuclide.Amass) + aState.State;
end;

function TVState.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= inherited IsEqual(Obj) and
  (Self.fT1_2 = TVState(Obj).fT1_2);
end;

procedure TVState.Store(S: TVStream);
begin
 inherited;
 S.Write(fT1_2, SizeOf(fT1_2));
end;

constructor TVState.Load(S: TVStream; Version: Word);
begin
 inherited;
 S.read(fT1_2, SizeOf(fT1_2));
end;
{ TVStateColl }

function TVStateColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVStateColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVStateColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function CompTVStatesT1_2(Item1, Item2: Pointer): integer;
var
 P1, P2: TVState;
begin
 P1:= TVState(Item1);
 P2:= TVState(Item2);
 if P1.fT1_2 < P2.fT1_2 then
  Result:= -1
 else if P1.fT1_2 > P2.fT1_2 then
  Result:= 1
 else
  Result:= 0;
end;

function TVT1_2OfState(Item: Pointer): double;
begin
 Result:= TVState(Item).fT1_2;
end;

procedure TVStateColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVElement }

function TVElement.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVElement.Create;
begin
 inherited;
end;

constructor TVElement.CreateFromElement(aElement: TElement);
begin
 inherited Create;
 with Self, aElement do
 begin
  Znum:= aElement.Znum;
  fAmassMean:= aElement.AmassMean;
  fSymbol:= aElement.Symbol;
  fSigmaA:= aElement.SigmaA;
  fRo:= aElement.Ro;
  fksi:= aElement.ksi;
  fSigmaS:= aElement.SigmaS;
  fRI:= aElement.RI;
 end;
end;

function TVElement.GetSymbol: shortstring;
begin
 Result:= fSymbol;
end;

function TVElement.GetZnum: integer;
begin
 Result:= Number;
end;

function TVElement.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= inherited IsEqual(Obj) and
  (Self.fAmassMean = TVElement(Obj).fAmassMean) and
  (Self.fSymbol = TVElement(Obj).fSymbol) and
  (Self.fRo = TVElement(Obj).fRo) and
  (Self.fksi = TVElement(Obj).fksi) and
  (Self.fSigmaS = TVElement(Obj).fSigmaS) and
  (Self.fRI = TVElement(Obj).fRI) and
  (Self.fSigmaA = TVElement(Obj).fSigmaA);
end;

constructor TVElement.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fAmassMean, SizeOf(fAmassMean));
  S.read(fSymbol, SizeOf(fSymbol));
  S.read(fRo, SizeOf(fRo));
  S.read(fksi, SizeOf(fksi));
  S.read(fSigmaS, SizeOf(fSigmaS));
  S.read(fRI, SizeOf(fRI));
  S.read(fSigmaA, SizeOf(fSigmaA));
 end;
end;

procedure TVElement.SetSymbol(const Value: shortstring);
begin
 fSymbol:= Value;
end;

procedure TVElement.SetZnum(aZnum: integer);
begin
 if aZnum <> Number then
  Number:= aZnum;
end;

procedure TVElement.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fAmassMean, SizeOf(fAmassMean));
  S.Write(fSymbol, SizeOf(fSymbol));
  S.Write(fRo, SizeOf(fRo));
  S.Write(fksi, SizeOf(fksi));
  S.Write(fSigmaS, SizeOf(fSigmaS));
  S.Write(fRI, SizeOf(fRI));
  S.Write(fSigmaA, SizeOf(fSigmaA));
 end;
end;
{ TVElementColl }

function TVElementColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVElementColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVElementColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

procedure TVElementColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVDecay }

function TVDecay.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVDecay(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fDecayType:= Self.fDecayType;
  fBranching:= Self.fBranching;
 end;
end;

constructor TVDecay.Create;
begin
 inherited;
end;

constructor TVDecay.CreateFromStateDecay(const aState: TNuclideState; const aDecay: TDecay);
begin
 inherited Create;
 with Self, aState, aDecay do
 begin
  if aState.Nuclide <> nil
  then
   Self.fThZpA_s:= 10 * (1000 * aState.Nuclide.Znum + aState.Nuclide.Amass) + aState.State;
  Self.fDecayType:= aDecay.DecayType;
  Self.fBranching:= aDecay.Branching;
 end;
end;

function TVDecay.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= IsEqual(Obj) and
  (Self.fThZpA_s = TVDecay(Obj).fThZpA_s) and
  (Self.fDecayType = TVDecay(Obj).fDecayType) and
  (Self.fBranching = TVDecay(Obj).fBranching) and
  (Self.fState = TVDecay(Obj).fState);
end;

constructor TVDecay.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fDecayType, SizeOf(fDecayType));
  S.read(fBranching, SizeOf(fBranching));
 end;
end;

procedure TVDecay.SetDecayType(const DecayMode: shortstring);
begin
 fDecayType:= StrToDecayType(DecayMode);
end;

procedure TVDecay.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fDecayType, SizeOf(fDecayType));
  S.Write(fBranching, SizeOf(fBranching));
 end;
end;
{ TVDecayColl }

function TVDecayColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVDecayColl.Create;
begin
 inherited;
 MakeIndexBy_ThZpA_s;
// MakeIndexBy_Branching;
end;

constructor TVDecayColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVDecayThZpA_s_OfDecay(Item: Pointer): integer;
begin
 Result:= TVDecay(Item).fThZpA_s;
end;

function CompTVDecaysThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVDecay;
begin
 P1:= TVDecay(Item1);
 P2:= TVDecay(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVDecayColl.MakeIndexBy_ThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ThZpA_s;
  IndCompare:= CompTVDecaysThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVDecayThZpA_s_OfDecay;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

function TVDecayBranching(Item: Pointer): double;
begin
 Result:= TVDecay(Item).fBranching;
end;

function CompTVDecayBranching(Item1, Item2: Pointer): integer;
var
 P1, P2: TVDecay;
begin
 P1:= TVDecay(Item1);
 P2:= TVDecay(Item2);
 if P1.fBranching < P2.fBranching then
  Result:= -1
 else if P1.fBranching > P2.fBranching then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVDecayColl.RemoveLink(const LinkID: ShortString);
var
 I: integer;
begin
// inherited;// QQQQ was override;
 TVUniCollection(Self).RemoveLink(LinkID);
 if Q_SameText(LinkID, ThZpA_s_Link) then
  for I:= 0 to Count - 1 do
   TVDecay(List^[I]).fState:= nil
 else
  RaiseLinkIDNotIdentified(Self, LinkID);
end;

procedure TVDecayColl.Store(S: TVStream);
begin
 inherited;
end;

procedure TVDecayColl.UpdateLink(const LinkID: ShortString; AColl: TVUniCollection);
var
 I, J: integer;
 StateColl, PB: TVStateColl;
begin
// inherited; // QQQQ was override;
 TVUniCollection(Self).UpdateLink(LinkID, AColl);
 if Q_SameText(LinkID, ThZpA_s_Link) then
 begin
  StateColl:= TVStateColl(AColl);
  PB:= TVStateColl(StateColl.Bin);
  for I:= 0 to Count - 1 do
   TVDecay(List^[I]).fState:= nil;
  for I:= 0 to Count - 1 do
   with TVDecay(List^[I]) do
    if fState = nil then
    begin
     fState:= TVState(StateColl.SearchNumberObj(fThZpA_s));
     if fState <> nil then
     begin
      for J:= I + 1 to Count - 1 do
       if TVDecay(List^[J]).fThZpA_s = fThZpA_s then
        TVDecay(List^[J]).fState:= fState;
     end
     else if PB <> nil then
      fState:= TVState(PB.SearchNumberObj(fThZpA_s));
    end;
 end
 else
  RaiseLinkIDNotIdentified(Self, LinkID);
end;
{ TVAbundance }

function TVAbundance.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVAbundance.Create;
begin
 inherited;
end;

function TVAbundance.GetThZpA: integer;
begin
 Result:= Number;
end;

function TVAbundance.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= inherited IsEqual(Obj) and
  (Self.fAbundance = TVAbundance(Obj).fAbundance);
end;

constructor TVAbundance.Load(S: TVStream; Version: Word);
begin
 inherited;
 S.read(fAbundance, SizeOf(fAbundance));
end;

procedure TVAbundance.SetThZpA(aThZpA: integer);
begin
 if aThZpA <> Number then
  Number:= aThZpA;
end;

procedure TVAbundance.Store(S: TVStream);
begin
 inherited;
 S.Write(fAbundance, SizeOf(fAbundance));
end;
{ TVAbundanceColl }

function TVAbundanceColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVAbundanceColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
// qq MakeIndexBy_Abundance;
end;

constructor TVAbundanceColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function CompTVStatesAbundance(Item1, Item2: Pointer): integer;
var
 P1, P2: TVAbundance;
begin
 P1:= TVAbundance(Item1);
 P2:= TVAbundance(Item2);
 if P1.fAbundance < P2.fAbundance then
  Result:= -1
 else if P1.fAbundance > P2.fAbundance then
  Result:= 1
 else
  Result:= 0;
end;

function TVAbundanceOfState(Item: Pointer): double;
begin
 Result:= TVAbundance(Item).fAbundance;
end;

procedure TVAbundanceColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVSigmaF }

function TVSigmaF.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVSigmaF(Result) do
 begin
  fSigma:= Self.fSigma;
 end;
end;

constructor TVSigmaF.Create;
begin
 inherited;
end;

function TVSigmaF.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= IsEqual(Obj) and
  (Self.fSigma = TVSigmaF(Obj).fSigma);
end;

constructor TVSigmaF.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fSigma, SizeOf(fSigma));
 end;
end;

procedure TVSigmaF.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fSigma, SizeOf(fSigma));
 end;
end;
{ TVSigmaFColl }

function TVSigmaFColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVSigmaFColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVSigmaFColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVSigmaFSigma(Item: Pointer): double;
begin
 Result:= TVSigmaF(Item).fSigma;
end;

function CompTVSigmaFSigma(Item1, Item2: Pointer): integer;
var
 P1, P2: TVSigmaF;
begin
 P1:= TVSigmaF(Item1);
 P2:= TVSigmaF(Item2);
 if P1.fSigma < P2.fSigma then
  Result:= -1
 else if P1.fSigma > P2.fSigma then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVSigmaFColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVRIF }

function TVRIf.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVRIf(Result) do
 begin
  fRI:= Self.fRI;
 end;
end;

constructor TVRIf.Create;
begin
 inherited;
end;

function TVRIf.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= inherited IsEqual(Obj) and
  (Self.fRI = TVRIf(Obj).fRI);
end;

constructor TVRIf.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fRI, SizeOf(fRI));
 end;
end;

procedure TVRIf.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fRI, SizeOf(fRI));
 end;
end;
{ TVRIFColl }

function TVRIFColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVRIFColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVRIFColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVRIFRI(Item: Pointer): double;
begin
 Result:= TVRIf(Item).fRI;
end;

function CompTVRIfRI(Item1, Item2: Pointer): integer;
var
 P1, P2: TVRIf;
begin
 P1:= TVRIf(Item1);
 P2:= TVRIf(Item2);
 if P1.fRI < P2.fRI then
  Result:= -1
 else if P1.fRI > P2.fRI then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVRIFColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVSigmaThreshold }

function TVSigmaThreshold.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVSigmaThreshold(Result) do
 begin
  fg_factor:= Self.fg_factor;
  fSigmaNP:= Self.fSigmaNP;
  fSigmaNA:= Self.fSigmaNA;
  fSigmaN2N:= Self.fSigmaN2N;
  fSigmaNN:= Self.fSigmaNN;
  fSigmaNG:= Self.fSigmaNG;
 end;
end;

constructor TVSigmaThreshold.Create;
begin
 inherited;
end;

function TVSigmaThreshold.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= IsEqual(Obj) and
  (Self.fg_factor = TVSigmaThreshold(Obj).fg_factor) and
  (Self.fSigmaNP = TVSigmaThreshold(Obj).fSigmaNP) and
  (Self.fSigmaNA = TVSigmaThreshold(Obj).fSigmaNA) and
  (Self.fSigmaN2N = TVSigmaThreshold(Obj).fSigmaN2N) and
  (Self.fSigmaNN = TVSigmaThreshold(Obj).fSigmaNN) and
  (Self.fSigmaNG = TVSigmaThreshold(Obj).fSigmaNG);
end;

constructor TVSigmaThreshold.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fg_factor, SizeOf(fg_factor));
  S.read(fSigmaNP, SizeOf(fSigmaNP));
  S.read(fSigmaNA, SizeOf(fSigmaNA));
  S.read(fSigmaN2N, SizeOf(fSigmaN2N));
  S.read(fSigmaNN, SizeOf(fSigmaNN));
  S.read(fSigmaNG, SizeOf(fSigmaNG));
 end;
end;

procedure TVSigmaThreshold.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fg_factor, SizeOf(fg_factor));
  S.Write(fSigmaNP, SizeOf(fSigmaNP));
  S.Write(fSigmaNA, SizeOf(fSigmaNA));
  S.Write(fSigmaN2N, SizeOf(fSigmaN2N));
  S.Write(fSigmaNN, SizeOf(fSigmaNN));
  S.Write(fSigmaNG, SizeOf(fSigmaNG));
 end;
end;
{ TVSigmaThresholdColl }

function TVSigmaThresholdColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVSigmaThresholdColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVSigmaThresholdColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

(*
function TVSigmaThresholdSigma(Item: Pointer): double;
begin
 Result:= TVSigmaF(Item).fSigma;
end;
*)
procedure TVSigmaThresholdColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVSigmaC }

function TVSigmaC.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVSigmaC(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fProductState:= Self.fProductState;
  fSigma:= Self.fSigma;
  fg_factor:= Self.fg_factor;
 end;
end;

constructor TVSigmaC.Create;
begin
 inherited;
end;

function TVSigmaC.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= IsEqual(Obj) and
  (Self.fThZpA_s = TVSigmaC(Obj).fThZpA_s) and
  (Self.fProductState = TVSigmaC(Obj).fProductState) and
  (Self.fSigma = TVSigmaC(Obj).fSigma) and
  (Self.fg_factor = TVSigmaC(Obj).fg_factor);
end;

constructor TVSigmaC.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fProductState, SizeOf(fProductState));
  S.read(fSigma, SizeOf(fSigma));
  S.read(fg_factor, SizeOf(fg_factor));
 end;
end;

procedure TVSigmaC.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fProductState, SizeOf(fProductState));
  S.Write(fSigma, SizeOf(fSigma));
  S.Write(fg_factor, SizeOf(fg_factor));
 end;
end;
{ TVSigmaCColl }

function TVSigmaCColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVSigmaCColl.Create;
begin
 inherited;
 MakeIndexBy_ThZpA_s;
end;

constructor TVSigmaCColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVSigmaCThZpA_s_OfSigmaC(Item: Pointer): integer;
begin
 Result:= TVSigmaC(Item).fThZpA_s;
end;

function CompTVSigmaCThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVSigmaC;
begin
 P1:= TVSigmaC(Item1);
 P2:= TVSigmaC(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVSigmaCColl.MakeIndexBy_ThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ThZpA_s;
  IndCompare:= CompTVSigmaCThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVSigmaCThZpA_s_OfSigmaC;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

function TVSigmaCSigma(Item: Pointer): double;
begin
 Result:= TVSigmaC(Item).fSigma;
end;

function CompTVSigmaCSigma(Item1, Item2: Pointer): integer;
var
 P1, P2: TVSigmaC;
begin
 P1:= TVSigmaC(Item1);
 P2:= TVSigmaC(Item2);
 if P1.fSigma < P2.fSigma then
  Result:= -1
 else if P1.fSigma > P2.fSigma then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVSigmaCColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVRI }

function TVRI.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVRI(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fProductState:= Self.fProductState;
  fRI:= Self.fRI;
 end;
end;

constructor TVRI.Create;
begin
 inherited;
end;

function TVRI.IsEqual(Obj: Pointer): Boolean;
begin
 Result:= IsEqual(Obj) and
  (Self.fThZpA_s = TVRI(Obj).fThZpA_s) and
  (Self.fProductState = TVRI(Obj).fProductState) and
  (Self.fRI = TVRI(Obj).fRI);
end;

constructor TVRI.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fProductState, SizeOf(fProductState));
  S.read(fRI, SizeOf(fRI));
 end;
end;

procedure TVRI.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fProductState, SizeOf(fProductState));
  S.Write(fRI, SizeOf(fRI));
 end;
end;
{ TVRIColl }

function TVRIColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVRIColl.Create;
begin
 inherited;
 MakeIndexBy_ThZpA_s;
end;

constructor TVRIColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVRIThZpA_s_OfRI(Item: Pointer): integer;
begin
 Result:= TVRI(Item).fThZpA_s;
end;

function CompTVRIThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVRI;
begin
 P1:= TVRI(Item1);
 P2:= TVRI(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVRIColl.MakeIndexBy_ThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ThZpA_s;
  IndCompare:= CompTVRIThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVRIThZpA_s_OfRI;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

function TVRIRI(Item: Pointer): double;
begin
 Result:= TVRI(Item).fRI;
end;

function CompTVRIRI(Item1, Item2: Pointer): integer;
var
 P1, P2: TVRI;
begin
 P1:= TVRI(Item1);
 P2:= TVRI(Item2);
 if P1.fRI < P2.fRI then
  Result:= -1
 else if P1.fRI > P2.fRI then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVRIColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVYield }

function TVYield.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVYield(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fProductThZpA_s:= Self.fProductThZpA_s;
  fIndYield:= Self.fIndYield;
  fCumYield:= Self.fCumYield;
 end;
end;

constructor TVYield.Create;
begin
 inherited;
end;

constructor TVYield.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fProductThZpA_s, SizeOf(fProductThZpA_s));
  S.read(fIndYield, SizeOf(fIndYield));
  S.read(fCumYield, SizeOf(fCumYield));
 end;
end;

procedure TVYield.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fProductThZpA_s, SizeOf(fProductThZpA_s));
  S.Write(fIndYield, SizeOf(fIndYield));
  S.Write(fCumYield, SizeOf(fCumYield));
 end;
end;
{ TVYieldColl }

function TVYieldColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVYieldColl.Create;
begin
 inherited;
 MakeIndexBy_ProductThZpA_s;
end;

constructor TVYieldColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVThZpA_s_OfYield(Item: Pointer): integer;
begin
 Result:= TVYield(Item).fThZpA_s;
end;

function CompTVYieldThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVYield;
begin
 P1:= TVYield(Item1);
 P2:= TVYield(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

function TVProductThZpA_s_OfYield(Item: Pointer): integer;
begin
 Result:= TVYield(Item).fProductThZpA_s;
end;

function CompTVYieldProductThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVYield;
begin
 P1:= TVYield(Item1);
 P2:= TVYield(Item2);
 if P1.fProductThZpA_s < P2.fProductThZpA_s then
  Result:= -1
 else if P1.fProductThZpA_s > P2.fProductThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;


procedure TVYieldColl.MakeIndexBy_ProductThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ProductThZpA_s;
  IndCompare:= CompTVYieldProductThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVProductThZpA_s_OfYield;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;


function TVYieldCumYield(Item: Pointer): double;
begin
 Result:= TVYield(Item).fCumYield;
end;

function CompTVYieldCumYield(Item1, Item2: Pointer): integer;
var
 P1, P2: TVYield;
begin
 P1:= TVYield(Item1);
 P2:= TVYield(Item2);
 if P1.fCumYield < P2.fCumYield then
  Result:= -1
 else if P1.fCumYield > P2.fCumYield then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVYieldColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVAlpha }

function TVAlpha.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVAlpha(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fProbability:= Self.fProbability;
  fMeV:= Self.fMeV;
 end;
end;

constructor TVAlpha.Create;
begin
 inherited;
end;

constructor TVAlpha.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fProbability, SizeOf(fProbability));
  S.read(fMeV, SizeOf(fMeV));
 end;
end;

procedure TVAlpha.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fProbability, SizeOf(fProbability));
  S.Write(fMeV, SizeOf(fMeV));
 end;
end;
{ TVAlphaColl }

function TVAlphaColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVAlphaColl.Create;
begin
 inherited;
 MakeIndexBy_ThZpA_s;
end;

constructor TVAlphaColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVThZpA_s_OfAlpha(Item: Pointer): integer;
begin
 Result:= TVAlpha(Item).fThZpA_s;
end;

function CompTVAlphaThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVAlpha;
begin
 P1:= TVAlpha(Item1);
 P2:= TVAlpha(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVAlphaColl.MakeIndexBy_ThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ThZpA_s;
  IndCompare:= CompTVAlphaThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVThZpA_s_OfAlpha;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

function TVAlphaProbability(Item: Pointer): double;
begin
 Result:= TVAlpha(Item).fProbability;
end;

function CompTVAlphaProbability(Item1, Item2: Pointer): integer;
var
 P1, P2: TVAlpha;
begin
 P1:= TVAlpha(Item1);
 P2:= TVAlpha(Item2);
 if P1.fProbability < P2.fProbability then
  Result:= -1
 else if P1.fProbability > P2.fProbability then
  Result:= 1
 else
  Result:= 0;
end;

function TVAlphaMeV(Item: Pointer): double;
begin
 Result:= TVAlpha(Item).fMeV;
end;

function CompTVAlphaMeV(Item1, Item2: Pointer): integer;
var
 P1, P2: TVAlpha;
begin
 P1:= TVAlpha(Item1);
 P2:= TVAlpha(Item2);
 if P1.fMeV < P2.fMeV then
  Result:= -1
 else if P1.fMeV > P2.fMeV then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVAlphaColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVBeta }

function TVBeta.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVBeta.Create;
begin
 inherited;
end;

constructor TVBeta.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fMaxMeV, SizeOf(fMeV));
 end;
end;

procedure TVBeta.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fMaxMeV, SizeOf(fMeV));
 end;
end;
{ TVSubBranching }

function TVSubBranching.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVSubBranching(Result) do
 begin
  fThZpA_s:= Self.fThZpA_s;
  fBranchingName:= Self.fBranchingName;
  fBranchingToG:= Self.fBranchingToG;
  fBranchingToM1:= Self.fBranchingToM1;
  fBranchingToM2:= Self.fBranchingToM2;
 end;
end;

constructor TVSubBranching.Create;
begin
 inherited;
end;

constructor TVSubBranching.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fThZpA_s, SizeOf(fThZpA_s));
  S.read(fBranchingName, SizeOf(fBranchingName));
  S.read(fBranchingToG, SizeOf(fBranchingToG));
  S.read(fBranchingToM1, SizeOf(fBranchingToM1));
  S.read(fBranchingToM2, SizeOf(fBranchingToM2));
 end;
end;

function TVSubBranching.GetName: shortstring;
begin
 Result:= fBranchingName;
end;

procedure TVSubBranching.SetName(const Value: shortstring);
begin
 fBranchingName:= Value;
end;

procedure TVSubBranching.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fThZpA_s, SizeOf(fThZpA_s));
  S.Write(fBranchingName, SizeOf(fBranchingName));
  S.Write(fBranchingToG, SizeOf(fBranchingToG));
  S.Write(fBranchingToM1, SizeOf(fBranchingToM1));
  S.Write(fBranchingToM2, SizeOf(fBranchingToM2));
 end;
end;
{ TVSubBranchingColl }

function TVSubBranchingColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVSubBranchingColl.Create;
begin
 inherited;
 MakeIndexBy_ThZpA_s;
end;

constructor TVSubBranchingColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVSubBranchingThZpA_s_OfSubBranching(Item: Pointer): integer;
begin
 Result:= TVSubBranching(Item).fThZpA_s;
end;

function CompTVSubBranchingsThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVSubBranching;
begin
 P1:= TVSubBranching(Item1);
 P2:= TVSubBranching(Item2);
 if P1.fThZpA_s < P2.fThZpA_s then
  Result:= -1
 else if P1.fThZpA_s > P2.fThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVSubBranchingColl.MakeIndexBy_ThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ThZpA_s;
  IndCompare:= CompTVSubBranchingsThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVSubBranchingThZpA_s_OfSubBranching;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

procedure TVSubBranchingColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVFastFission }

function TVFastFission.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVFastFission(Result) do
 begin
  fSigma:= Self.fSigma;
 end;
end;

constructor TVFastFission.Create;
begin
 inherited;
end;

constructor TVFastFission.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fSigma, SizeOf(fSigma));
 end;
end;

procedure TVFastFission.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fSigma, SizeOf(fSigma));
 end;
end;
{ TVFastFissionColl }

function TVFastFissionColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVFastFissionColl.Create;
begin
 inherited;
 GetIndexRec('Number').Descending:= False;
end;

constructor TVFastFissionColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

procedure TVFastFissionColl.Store(S: TVStream);
begin
 inherited;
end;
{ TVSpecialCaptureCase }

function TVSpecialCaptureCase.Clone: Pointer;
begin
 Result:= inherited Clone;
 with TVSpecialCaptureCase(Result) do
 begin
  fParentThZpA_s:= Self.fParentThZpA_s;
  fChildThZpA_s:= Self.fChildThZpA_s;
  fSigma:= Self.fSigma;
  fg_factor:= Self.fg_factor;
  fRI:= Self.fRI;
 end;
end;

constructor TVSpecialCaptureCase.Create;
begin
 inherited;
end;

constructor TVSpecialCaptureCase.Load(S: TVStream; Version: Word);
begin
 inherited;
 with Self, S do
 begin
  S.read(fParentThZpA_s, SizeOf(fParentThZpA_s));
  S.read(fChildThZpA_s, SizeOf(fChildThZpA_s));
  S.read(fSigma, SizeOf(fSigma));
  S.read(fg_factor, SizeOf(fg_factor));
  S.read(fRI, SizeOf(fRI));
 end;
end;

procedure TVSpecialCaptureCase.Store(S: TVStream);
begin
 inherited;
 with Self, S do
 begin
  S.Write(fParentThZpA_s, SizeOf(fParentThZpA_s));
  S.Write(fChildThZpA_s, SizeOf(fChildThZpA_s));
  S.Write(fSigma, SizeOf(fSigma));
  S.Write(fg_factor, SizeOf(fg_factor));
  S.Write(fRI, SizeOf(fRI));
 end;
end;
{ TVSpecialCaptureCaseColl }

function TVSpecialCaptureCaseColl.Clone: Pointer;
begin
 Result:= inherited Clone;
end;

constructor TVSpecialCaptureCaseColl.Create;
begin
 inherited;
 MakeIndexBy_ParentThZpA_s;
end;

constructor TVSpecialCaptureCaseColl.Load(S: TVStream; Version: Word);
begin
 inherited;
end;

function TVSpecialCaptureCaseParentThZpA_s_OfSpecialCaptureCase(Item: Pointer): integer;
begin
 Result:= TVSpecialCaptureCase(Item).fParentThZpA_s;
end;

function CompTVSpecialCaptureCaseParentThZpA_s(Item1, Item2: Pointer): integer;
var
 P1, P2: TVSpecialCaptureCase;
begin
 P1:= TVSpecialCaptureCase(Item1);
 P2:= TVSpecialCaptureCase(Item2);
 if P1.fParentThZpA_s < P2.fParentThZpA_s then
  Result:= -1
 else if P1.fParentThZpA_s > P2.fParentThZpA_s then
  Result:= 1
 else
  Result:= 0;
end;

procedure TVSpecialCaptureCaseColl.MakeIndexBy_ParentThZpA_s;
var
 PIR: PTVIndexRec;
begin
 CreateIndexRec(PIR);
 with PIR^ do
 begin
  IndName:= IndexBy_ParentThZpA_s;
  IndCompare:= CompTVSpecialCaptureCaseParentThZpA_s;
  Regular:= True;
  Unique:= False;
  IndType:= itInteger;
  KeyOf_Integer:= TVSpecialCaptureCaseParentThZpA_s_OfSpecialCaptureCase;
  Descending:= False;
 end;
 AddIndex(PIR, True);
end;

function TVSpecialCaptureCaseSigma(Item: Pointer): double;
begin
 Result:= TVSpecialCaptureCase(Item).fSigma;
end;

procedure TVSpecialCaptureCaseColl.Store(S: TVStream);
begin
 inherited;
end;

initialization

RegisterTVObject(rg_TVState, TVState, 1, True);
RegisterTVObject(rg_TVStateColl, TVStateColl, 1, True);
RegisterTVObject(rg_TVElement, TVElement, 1, True);
RegisterTVObject(rg_TVElementColl, TVElementColl, 1, True);
RegisterTVObject(rg_TVDecay, TVDecay, 1, True);
RegisterTVObject(rg_TVDecayColl, TVDecayColl, 1, True);
RegisterTVObject(rg_TVAbundance, TVAbundance, 1, True);
RegisterTVObject(rg_TVAbundanceColl, TVAbundanceColl, 1, True);
RegisterTVObject(rg_TVSigmaF, TVSigmaF, 1, True);
RegisterTVObject(rg_TVSigmaFColl, TVSigmaFColl, 1, True);
RegisterTVObject(rg_TVRIF, TVRIf, 1, True);
RegisterTVObject(rg_TVRIFColl, TVRIFColl, 1, True);
RegisterTVObject(rg_TVSigmaThreshold, TVSigmaThreshold, 1, True);
RegisterTVObject(rg_TVSigmaThresholdColl, TVSigmaThresholdColl, 1, True);
RegisterTVObject(rg_TVSigmaC, TVSigmaC, 1, True);
RegisterTVObject(rg_TVSigmaCColl, TVSigmaCColl, 1, True);
RegisterTVObject(rg_TVRI, TVRI, 1, True);
RegisterTVObject(rg_TVRIColl, TVRIColl, 1, True);
RegisterTVObject(rg_TVYieldT, TVYieldT, 1, True);
RegisterTVObject(rg_TVYieldTColl, TVYieldTColl, 1, True);
RegisterTVObject(rg_TVYieldF, TVYieldF, 1, True);
RegisterTVObject(rg_TVYieldFColl, TVYieldFColl, 1, True);
RegisterTVObject(rg_TVAlpha, TVAlpha, 1, True);
RegisterTVObject(rg_TVAlphaColl, TVAlphaColl, 1, True);
RegisterTVObject(rg_TVGamma, TVGamma, 1, True);
RegisterTVObject(rg_TVGammaColl, TVGammaColl, 1, True);
RegisterTVObject(rg_TVElectron, TVElectron, 1, True);
RegisterTVObject(rg_TVElectronColl, TVElectronColl, 1, True);
RegisterTVObject(rg_TVBeta, TVBeta, 1, True);
RegisterTVObject(rg_TVBetaColl, TVBetaColl, 1, True);
RegisterTVObject(rg_TVPositron, TVPositron, 1, True);
RegisterTVObject(rg_TVPositronColl, TVPositronColl, 1, True);
RegisterTVObject(rg_TVSubBranching, TVSubBranching, 1, True);
RegisterTVObject(rg_TVSubBranchingColl, TVSubBranchingColl, 1, True);
RegisterTVObject(rg_TVFastFission, TVFastFission, 1, True);
RegisterTVObject(rg_TVFastFissionColl, TVFastFissionColl, 1, True);
RegisterTVObject(rg_TVSpecialCaptureCase, TVSpecialCaptureCase, 1, True);
RegisterTVObject(rg_TVSpecialCaptureCaseColl, TVSpecialCaptureCaseColl, 1, True);

end.
