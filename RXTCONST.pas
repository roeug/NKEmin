{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1995, 1996 AO ROSNO             }
{                                                       }
{*******************************************************}

unit RXTCONST;

{ RX tools components constants }
{
  Reserved diapasone
  from MaxExtStrID - 136
  to   MaxExtStrID - 184
}

interface

const
{ The minimal VCL's used string ID is 61440. The custom IDs must be
  less that above. }
  MaxExtStrID = 61300;

const

{ MathParser }

  SParseSyntaxError           = MaxExtStrID - 145;
  SParseNotCramp              = MaxExtStrID - 146;
  SParseDivideByZero          = MaxExtStrID - 147;
  SParseSqrError              = MaxExtStrID - 148;
  SParseLogError              = MaxExtStrID - 149;
  SParseInvalidFloatOperation = MaxExtStrID - 150;

implementation

end.
