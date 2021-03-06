{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1995, 1996 AO ROSNO             }
{         Copyright (c) 1997, 1998 Master-Bank          }
{                                                       }
{*******************************************************}

unit Parsing;

{$MODE Delphi}

interface

//{$I RX.INC}

uses SysUtils, Classes;

type
  TParserFunc = (pfArcTan, pfCos, pfSin, pfTan, pfAbs, pfExp, pfLn, pfLog,
    pfSqrt, pfSqr, pfInt, pfFrac, pfTrunc, pfRound, pfArcSin, pfArcCos,
    pfSign, pfNot);
  ERxParserError = class(Exception);
{$IFDEF WINDOWS} // was {$IFDEF WIN32}
  TUserFunction = function(Value: double): double;
{$ELSE}
  TUserFunction = Pointer;
{$ENDIF}

  TRxMathParser = class(TObject)
  private
    FCurPos: Cardinal;
    FParseText: string;
    function GetChar: Char;
    procedure NextChar;
    function GetNumber(var AValue: double): Boolean;
    function GetConst(var AValue: double): Boolean;
    function GetFunction(var AValue: TParserFunc): Boolean;
    function GetUserFunction(var Index: Integer): Boolean;
    function Term: double;
    function SubTerm: double;
    function Calculate: double;
  public
    function Exec(const AFormula: string): double;
    class procedure RegisterUserFunction(const Name: string; Proc: TUserFunction);
    class procedure UnregisterUserFunction(const Name: string);
  end;

function GetFormulaValue(const Formula: string): double;

{$IFNDEF WIN32}
function Power(Base, Exponent: double): double;
{$ENDIF}

implementation

uses math, RXTCONST;

const
  SpecialChars = [#0..' ', '+', '-', '/', '*', ')', '^'];

  FuncNames: array[TParserFunc] of PChar =
    ('ARCTAN', 'COS', 'SIN', 'TAN', 'ABS', 'EXP', 'LN', 'LOG',
    'SQRT', 'SQR', 'INT', 'FRAC', 'TRUNC', 'ROUND', 'ARCSIN', 'ARCCOS',
    'SIGN', 'NOT');

{ Parser errors }

procedure InvalidCondition(Str: Word);
begin
  raise ERxParserError.Create(LoadStr(Str));
end;

{ IntPower and Power functions are copied from Borland's MATH.PAS unit }

function IntPower(Base: double; Exponent: Integer): double;
begin
  Result:= IntPower(Base, Exponent);
end;

(*
function IntPower(Base: double; Exponent: Integer): double; // was
var
  Y: Longint;
begin
  Y := Abs(Exponent);
  Result := 1.0;
  while Y > 0 do begin
    while not Odd(Y) do begin
      Y := Y shr 1;
      Base := Base * Base;
    end;
    Dec(Y);
    Result := Result * Base;
  end;
  if Exponent < 0 then Result := 1.0 / Result;
end;
*)

function Power(Base, Exponent: double): double;
begin
  if Exponent = 0.0 then Result := 1.0
  else if (Base = 0.0) and (Exponent > 0.0) then Result := 0.0
  else if (Frac(Exponent) = 0.0) and (Abs(Exponent) <= MaxInt) then
    Result := IntPower(Base, Trunc(Exponent))
  else Result := Exp(Exponent * Ln(Base))
end;

{ User defined functions }

type
{$IFDEF WIN32}
  TFarUserFunction = TUserFunction;
{$ELSE}
  TFarUserFunction = function(Value: double): double;
{$ENDIF}

var
  UserFuncList: TStrings;

function GetUserFuncList: TStrings;
begin
  if not Assigned(UserFuncList) then begin
    UserFuncList := TStringList.Create;
    with TStringList(UserFuncList) do begin
      Sorted := True;
      Duplicates := dupIgnore;
    end;
  end;
  Result := UserFuncList;
end;

procedure FreeUserFunc; far;
begin
  UserFuncList.Free;
  UserFuncList := nil;
end;

{ Parsing routines }

function GetFormulaValue(const Formula: string): double;
begin
  with TRxMathParser.Create do
  try
    Result := Exec(Formula);
  finally
    Free;
  end;
end;

{ TRxMathParser }

function TRxMathParser.GetChar: Char;
begin
  Result := FParseText[FCurPos];
end;

procedure TRxMathParser.NextChar;
begin
  Inc(FCurPos);
end;

function TRxMathParser.GetNumber(var AValue: double): Boolean;
var
  C: Char;
  SavePos: Cardinal;
  Code: Integer;
  IsHex: Boolean;
  TmpStr: string;
begin
  Result := False;
  C := GetChar;
  SavePos := FCurPos;
  TmpStr := '';
  IsHex := False;
  if C = '$' then begin
    TmpStr := C;
    NextChar;
    C := GetChar;
    while C in ['0'..'9', 'A'..'F', 'a'..'f'] do begin
      TmpStr := TmpStr + C;
      NextChar;
      C := GetChar;
    end;
    IsHex := True;
    Result := (Length(TmpStr) > 1) and (Length(TmpStr) <= 9);
  end
  else if C in ['+', '-', '0'..'9', '.', DecimalSeparator] then begin
    if (C in ['.', DecimalSeparator]) then TmpStr := '0' + '.'
    else TmpStr := C;
    NextChar;
    C := GetChar;
    if (Length(TmpStr) = 1) and (TmpStr[1] in ['+', '-']) and
      (C in ['.', DecimalSeparator]) then TmpStr := TmpStr + '0';
    while C in ['0'..'9', '.', 'E', 'e', DecimalSeparator] do begin
      if C = DecimalSeparator then TmpStr := TmpStr + '.'
      else TmpStr := TmpStr + C;
      if (C = 'E') then begin
        if (Length(TmpStr) > 1) and (TmpStr[Length(TmpStr) - 1] = '.') then
          Insert('0', TmpStr, Length(TmpStr));
        NextChar;
        C := GetChar;
        if (C in ['+', '-']) then begin
          TmpStr := TmpStr + C;
          NextChar;
        end;
      end
      else NextChar;
      C := GetChar;
    end;
    if (TmpStr[Length(TmpStr)] = '.') and (Pos('E', TmpStr) = 0) then
      TmpStr := TmpStr + '0';
    Val(TmpStr, AValue, Code);
    Result := (Code = 0);
  end;
  Result := Result and (FParseText[FCurPos] in SpecialChars);
  if Result then begin
    if IsHex then AValue := StrToInt(TmpStr)
    { else AValue := StrToFloat(TmpStr) };
  end
  else begin
    AValue := 0;
    FCurPos := SavePos;
  end;
end;

function TRxMathParser.GetConst(var AValue: double): Boolean;
begin
  Result := False;
  case FParseText[FCurPos] of
    'E':
      if FParseText[FCurPos + 1] in SpecialChars then
      begin
        AValue := Exp(1);
        Inc(FCurPos);
        Result := True;
      end;
    'P':
      if (FParseText[FCurPos + 1] = 'I') and
        (FParseText[FCurPos + 2] in SpecialChars) then
      begin
        AValue := Pi;
        Inc(FCurPos, 2);
        Result := True;
      end;
  end
end;

function TRxMathParser.GetUserFunction(var Index: Integer): Boolean;
var
  TmpStr: string;
  I: Integer;
begin
  Result := False;
  if (FParseText[FCurPos] in ['A'..'Z', 'a'..'z', '_']) and
    Assigned(UserFuncList) then
  begin
    with UserFuncList do
      for I := 0 to Count - 1 do begin
        TmpStr := Copy(FParseText, FCurPos, Length(Strings[I]));
        if (CompareText(TmpStr, Strings[I]) = 0) and
          (Objects[I] <> nil) then
        begin
          if FParseText[FCurPos + Cardinal(Length(TmpStr))] = '(' then
          begin
            Result := True;
            Inc(FCurPos, Length(TmpStr));
            Index := I;
            Exit;
          end;
        end;
      end;
  end;
  Index := -1;
end;

function TRxMathParser.GetFunction(var AValue: TParserFunc): Boolean;
var
  I: TParserFunc;
  TmpStr: string;
begin
  Result := False;
  AValue := Low(TParserFunc);
  if FParseText[FCurPos] in ['A'..'Z', 'a'..'z', '_'] then begin
    for I := Low(TParserFunc) to High(TParserFunc) do begin
      TmpStr := Copy(FParseText, FCurPos, StrLen(FuncNames[I]));
      if CompareText(TmpStr, StrPas(FuncNames[I])) = 0 then begin
        AValue := I;
        if FParseText[FCurPos + Cardinal(Length(TmpStr))] = '(' then begin
          Result := True;
          Inc(FCurPos, Length(TmpStr));
          Break;
        end;
      end;
    end;
  end;
end;

function TRxMathParser.Term: double;
var
  Value: double;
  NoFunc: TParserFunc;
  UserFunc: Integer;
  Func: Pointer;
begin
  if FParseText[FCurPos] = '(' then begin
    Inc(FCurPos);
    Value := Calculate;
    if FParseText[FCurPos] <> ')' then InvalidCondition(SParseNotCramp);
    Inc(FCurPos);
  end
  else begin
    if not GetNumber(Value) then
      if not GetConst(Value) then
        if GetUserFunction(UserFunc) then begin
          Inc(FCurPos);
          Func := UserFuncList.Objects[UserFunc];
          Value := TFarUserFunction(Func)(Calculate);
          if FParseText[FCurPos] <> ')' then InvalidCondition(SParseNotCramp);
          Inc(FCurPos);
        end
        else if GetFunction(NoFunc) then begin
          Inc(FCurPos);
          Value := Calculate;
          try
            case NoFunc of
              pfArcTan: Value := ArcTan(Value);
              pfCos: Value := Cos(Value);
              pfSin: Value := Sin(Value);
              pfTan:
                if Cos(Value) = 0 then InvalidCondition(SParseDivideByZero)
                else Value := Sin(Value) / Cos(Value);
              pfAbs: Value := Abs(Value);
              pfExp: Value := Exp(Value);
              pfLn:
                if Value <= 0 then InvalidCondition(SParseLogError)
                else Value := Ln(Value);
              pfLog:
                if Value <= 0 then InvalidCondition(SParseLogError)
                else Value := Ln(Value) / Ln(10);
              pfSqrt:
                if Value < 0 then InvalidCondition(SParseSqrError)
                else Value := Sqrt(Value);
              pfSqr: Value := Sqr(Value);
              pfInt: Value := Round(Value);
              pfFrac: Value := Frac(Value);
              pfTrunc: Value := Trunc(Value);
              pfRound: Value := Round(Value);
              pfArcSin:
                if Value = 1 then Value := Pi / 2
                else Value := ArcTan(Value / Sqrt(1 - Sqr(Value)));
              pfArcCos:
                if Value = 1 then Value := 0
                else Value := Pi / 2 - ArcTan(Value / Sqrt(1 - Sqr(Value)));
              pfSign:
                if Value > 0 then Value := 1
                else if Value < 0 then Value := -1;
              pfNot: Value := not Trunc(Value);
            end;
          except
            on E: ERxParserError do raise
            else InvalidCondition(SParseInvalidFloatOperation);
          end;
          if FParseText[FCurPos] <> ')' then InvalidCondition(SParseNotCramp);
          Inc(FCurPos);
        end
        else InvalidCondition(SParseSyntaxError);
  end;
  Result := Value;
end;

function TRxMathParser.SubTerm: double;
var
  Value: double;
begin
  Value := Term;
  while FParseText[FCurPos] in ['*', '^', '/'] do begin
    Inc(FCurPos);
    if FParseText[FCurPos - 1] = '*' then
      Value := Value * Term
    else if FParseText[FCurPos - 1] = '^' then
      Value := Power(Value, Term)
    else if FParseText[FCurPos - 1] = '/' then
      try
        Value := Value / Term;
      except
        InvalidCondition(SParseDivideByZero);
      end;
  end;
  Result := Value;
end;

function TRxMathParser.Calculate: double;
var
  Value: double;
begin
  Value := SubTerm;
  while FParseText[FCurPos] in ['+', '-'] do begin
    Inc(FCurPos);
    if FParseText[FCurPos - 1] = '+' then Value := Value + SubTerm
    else Value := Value - SubTerm;
  end;
  if not (FParseText[FCurPos] in [#0, ')', '>', '<', '=', ',']) then
    InvalidCondition(SParseSyntaxError);
  Result := Value;
end;

function TRxMathParser.Exec(const AFormula: string): double;
var
  I, J: Integer;
begin
  J := 0;
  Result := 0;
  FParseText := '';
  for I := 1 to Length(AFormula) do begin
    case AFormula[I] of
      '(': Inc(J);
      ')': Dec(J);
    end;
    if AFormula[I] > ' ' then FParseText := FParseText + UpCase(AFormula[I]);
  end;
  if J = 0 then begin
    FCurPos := 1;
    FParseText := FParseText + #0;
    if (FParseText[1] in ['-', '+']) then FParseText := '0' + FParseText;
    Result := Calculate;
  end
  else InvalidCondition(SParseNotCramp);
end;

class procedure TRxMathParser.RegisterUserFunction(const Name: string;
  Proc: TUserFunction);
var
  I: Integer;
begin
  if (Length(Name) > 0) and (Name[1] in ['A'..'Z', 'a'..'z', '_']) then
  begin
    if not Assigned(Proc) then UnregisterUserFunction(Name)
    else begin
      with GetUserFuncList do begin
        I := IndexOf(Name);
        if I < 0 then I := Add(Name);
{$IFDEF WINDOWS}
        Objects[I] := @Proc;
{$ELSE}
        Objects[I] := Proc;
{$ENDIF}
      end;
    end;
  end
  else InvalidCondition(SParseSyntaxError);
end;

class procedure TRxMathParser.UnregisterUserFunction(const Name: string);
var
  I: Integer;
begin
  if Assigned(UserFuncList) then
    with UserFuncList do begin
      I := IndexOf(Name);
      if I >= 0 then Delete(I);
      if Count = 0 then FreeUserFunc;
    end;
end;

initialization
  UserFuncList := nil;
{$IFDEF WIN32}
finalization
  FreeUserFunc;  
{$ELSE}
  AddExitProc(FreeUserFunc);
{$ENDIF}
end.
