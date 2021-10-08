///QStringsMin/////////////////////////////////////////
//   QStrings 6.07.424      ( pre release )   2 //
//
// ingo to linux it were rewritten:
// procedure Q_MoveMem(Source, Dest: Pointer; L: cardinal);
// procedure Q_MoveLongs(Source, Dest: Pointer; Count: cardinal);
// procedure Q_MoveWords(Source, Dest: Pointer; Count: cardinal);
// function Q_CompText(const S1, S2: String): integer;
// function Q_ScanWord(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
// function Q_ScanByte(N: Integer; ArrPtr: Pointer; L: Cardinal): Integer;

unit QStringsMin;
{$PIC OFF}
{$H+}

{$asmmode intel}
{$IFDEF FPC}
 {$MODE Delphi}
{$ELSE}

{$ENDIF}

{
   Список изменений:

  07.07.2003 г. (v6.07) - исправлена ошибка в функциях Q_ReplaceStr,
                          Q_ReplaceText (проявлялась, если результат замены
                          оказывался пустой строкой). Ошибку нашел и исправил
                          Alexander Sviridenkov. Большое ему спасибо!
  13.11.2001 г. (v6.06) - исправлена ошибка в функции Q_Delete;
  02.07.2001 г. (v6.05) - новые функции: Q_PosStrLimited и Q_PosTextLimited;
  17.03.2001 г. (v6.04) - добавлены функции Q_GetWordN_1 для работы с данными
                          в формате CSV;
  07.01.2001 г. (v6.03) - добавлена функция Q_CompMemS для сравнения блоков
                          памяти на больше-меньше (по содержимому), начиная
                          с байтов, расположенных по младшим адресам; усилен
                          алгоритм генерации ключа симметричного шифрования,
                          используемый в процедуре Q_DHGetCipherKey;
                          добавлены функции для преобразования строки в число;
                          эта версия QStrings совместима с Delphi 4;
  19.11.2000 г. (v6.01) - новые функции для моделирования случайных величин
                          с равномерным и нормальным законами распределения
                          на базе генератора Mersenne Twister; добавлены
                          функции для быстрой сортировки массивов 4-байтных
                          или 2-байтных элементов и бинарного поиска в этих
                          массивах, для слияния таких массивов на основе
                          различных логических операций, функции, выполняющие
                          сканирование двойных слов и битовых строк в поисках
                          единичных или нулевых битов, устанавливающие и
                          сбрасывающие группы битов; добавлена функция
                          Q_StrTok1, которая не группирует идущие подряд
                          символы-разделители в исходной строке; добавлены
                          функции для удаления элементов с определенным
                          значением из массива (со сдвигом элементов) и
                          удаления повторяющихся элементов, функции для
                          сканирования массива в поисках значения, большего
                          или меньшего заданного; теперь для проверки на
                          пустую строку вместо Length(S)<>0 можно писать
                          S<>'' (исправлены функции Q_DelXXX и Q_TrimXXX);
  07.10.2000 г. (v5.12) - добавлены функции Q_TestWildStr и Q_TestWildText
                          для сравнения строк по маске с учетом WildCard-
                          символов, функция Q_IsDecimal; еще раз изменен
                          алгоритм работы функций Q_MixHashXXX (!!!); убраны
                          процедуры Q_IncludeChar, Q_ExcludeChar (вместо них
                          надо вызывать стандартные Include, Exclude);
  02.10.2000 г. (v5.11) - добавлены функции для проверки символьной записи
                          числа в строке и проверки того, что число в строке
                          принадлежит заданному диапазону; добавлены функции
                          Q_SwapMem, Q_SwapLongs, Q_NotByteArr, Q_IsEmptySet,
                          функции для работы с битовыми масками, для обмена
                          значений переменных типа Word и Byte;
  23.09.2000 г. (v5.10) - изменен (!!!) алгоритм работы 320-битной hash-
                          функции (Q_MixHashXXX); исправлена реализация метода
                          RC4; удалены процедуры Q_RC4, Q_RC4(En/De)cryptCBC;
  20.09.2000 г. (v5.09) - оптимизирован код некоторых функций (Q_GetCharSet,
                          Q_SameStr, Q_Delete, Q_CompareMem и других);
  17.09.2000 г. (v5.08) - добавлены процедуры Q_MixHashXXX, для получения
                          320-битного значения односторонней hash-функции;
                          добавлена поддержка шифрования с открытым ключом
                          (метод Диффи-Хеллмана); исправлено несколько
                          процедур и функций (в том числе, метод CAST-256,
                          Q_RotateBitsLeft/Right, Q_RandRC6Update);
  05.09.2000 г. (v5.07) - добавлена функция Q_PadInside (выравнивание текста
                          по обоим краям) и функция Q_ChangeBase (перевод
                          числа из одной системы счисления в другую);
  23.08.2000 г. (v5.06) - переименованы функции, реализующие сжатие RLE;
  19.08.2000 г. (v5.05) - добавлены функции Q_TabsToSpaces и Q_SpacesToTabs;
  18.08.2000 г. (v5.04) - оптимизирован алгоритм работы процедур Q_FillLong,
                          Q_CopyLongs; добавлены новые процедуры: Q_OnesMem,
                          Q_CompareMem, Q_CompLongs, Q_ReverseBits; добавлено
                          сжатие строк и байтовых массивов методом RLE;
  27.07.2000 г. (v5.03) - внесены изменения в работу безопасного генератора
                          псевдослучайных чисел;
  24.07.2000 г. (v5.02) - исправлена ошибка в функциях Q_PadLeft, Q_PadRight,
                          Q_CenterStr; об ошибке сообщил Sergey G. Menylenko
                          e-mail: serega@pricenews.ru;
  18.07.2000 г. (v4.12) - исправлена ошибка в следующих функциях: Q_StrMoveL,
                          Q_StrUpperMoveL, Q_StrLowerMoveL, возникающая при
                          передаче в них пустой строки в параметре Dest;
                          исправлен алгоритм работы датчика случайных чисел
                          Mersenne Twister; добавлены функции Q_SecureRandNext,
                          Q_SecureRandFill; функция Q_RandXOR заменена на
                          Q_SecureRandXOR; добавлены типы описателей TRC4ID,
                          TRC6ID, TCASTID, TSHAID, TMTID;
  28.06.2000 г. (v4.11) - добавлены функции для сопоставления, подстановки
                          и вырезки фрагментов строк по маске: Q_TestByMask,
                          Q_ApplyMask(InPlace), Q_ExtractByMask(InPlace);
  25.06.2000 г. (v4.10) - функции Q_SetBitCount и Q_FreeBitCount теперь
                          называются, соответственно, Q_CountOfSetBits и
                          Q_CountOfFreeBits; Q_ReplaceAllByOne переименована
                          в Q_ReplaceCharsByOneChar; добавлены функции
                          Q_DeleteStr и Q_DeleteText для удаления заданной
                          подстроки; исправлена ошибка в Q_PStrLen; добавлены
                          следующие функции: Q_PosLastStr, Q_PosLastText,
                          Q_ReplaceFirst/LastXXXX, Q_DeleteFirst/LastXXXX;
  19.06.2000 г. (v4.09) - добавлена функция для быстрого вычисления длины
                          строки типа PAnsiChar (автором реализации является
                          Robert Lee), функции Q_SetBitCount и Q_FreeBitCount
                          для подсчета в байтовом массиве числа единичных и
                          нулевых битов соответственно;
  31.05.2000 г. (v4.08) - функция Q_CharSet переименована в Q_GetCharStr;
                          Q_RemoveChars -> Q_DelChars; Q_ReplaceChars теперь
                          реализована как процедура; добавлена поддержка
                          символьных множеств (TCharSet); добавлены функции
                          для работы с байтовыми строками;
  19.05.2000 г. (v4.07) - исправлена ошибка в функции Q_CenterStr; добавлена
                          поддержка динамических таблиц перекодировки;
  16.05.2000 г. (v4.06) - добавлен третий параметр в функцию Q_StrRScan;
  03.05.2000 г. (v4.05) - добавлены новые функции для работы с обычными
                          и бинарными строками; добавлены криптографические
                          функции; добавлена поддержка кодировки Base64 и
                          команды процессора RDTSC;
  09.03.2000 г. (v3.05) - добавлено несколько функций для шифрования строк;
  26.02.2000 г. (v3.03) - исправлено несколько ошибок; процедура Q_XORByKey
                          переименована в Q_XORByStr; добавлена процедура
                          Q_SetDelimiters; добавлены примечания;
  21.02.2000 г. (v3.01) - добавлено много новых функций, некоторые функции
                          переименованы; добавлены функции для преобразования
                          десятичных чисел в шестнадцатеричные, восьмеричные,
                          двоичные, римские и наоборот; исправлено несколько
                          ошибок (в т.ч. Q_FillChar);
  09.02.2000 г. (v2.10) - при записи денежных сумм первая буква делается
                          большой, изменены функции Q_CRC32 и Q_NextCRC32,
                          (!!!) чтобы соответствовать общепринятому алгоритму
                          вычисления CRC32, добавлены функции для работы с
                          датой, внесены исправления в комментарии;
  07.02.2000 г. (v2.09) - добавлено несколько функций для работы с байтовыми
                          строками, функции для преобразования числа в строку
                          и для получения записи денежных сумм прописью;
  25.01.2000 г. (v2.07) - исправлено несколько ошибок, добавлены функций для
                          работы с байтовыми массивами;
  конец 1999 г.         - первые версии QStrings.


    ВНИМАНИЕ !!!

 1. Если необходимо применить Q_FillChar, Q_NOTByteArr или другую подобную
    функцию (в которую передается указатель и данные по указателю изменяются)
    к строке S, то сначала надо вызвать стандартную процедуру UniqueString(S)
    для фактического выделения памяти и исключения множественных ссылок и
    ссылок на константную строку. Только после этого можно изменять строку
    по указателю, например: Q_FillChar( Pointer(S), Length(S), '*' ).

 2. Когда вы распределяете память под строку S с помощью SetString или
    SetLength, а затем вызываете какие-либо функции или процедуры из этой
    библиотеки, принимающие в качестве var-параметра (не const-) строку S,
    то при выходе из этих функций или процедур размер памяти, выделенный
    под строку S, может отличаться от исходного (т.е. в ходе выполнения
    функции память под строку может быть перераспределена). Это замечание
    не относится к процедурам Q_StrMoveL, Q_StrUpperMoveL, Q_StrLowerMoveL,
    Q_IntToStrBuf, Q_UIntToStrBuf, Q_UIntToStrLBuf, Q_UIntToHexBuf,
    Q_UIntToOctBuf, Q_UIntToBinBuf и процедурам, в которые строка передается
    как указатель. В ходе выполнения перечисленных процедур память
    не перераспределяется.
}

interface

{ Множество символов в языке Паскаль. }

type
  TCharSet = set of ansichar;

{ Символы, по умолчанию используемые как разделители слов. }

const
  Q_StdDelimsSet = [#0..#32, '!', '"', '(', ')', '*', '+', ',', '-', '.', '/', ':', ';', '<', '=', '>', '?', '[', '\', ']', '^', '{', '}', '|'];

  { Названия месяцев и дней недели. }

  Q_MonthsUp: array[1..12] of string =
    ('Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август',
    'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь');

  Q_MonthsLo: array[1..12] of string =
    ('января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа',
    'сентября', 'октября', 'ноября', 'декабря');

  Q_MonthsEng: array[1..12] of string =
    ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December');

  Q_SMonthsUp: array[1..12] of string =
    ('Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек');

  Q_SMonthsLo: array[1..12] of string =
    ('янв', 'фев', 'мар', 'апр', 'мая', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек');

  Q_SMonthsEng: array[1..12] of string =
    ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

  Q_WeekDays: array[1..7] of string =
    ('Воскресенье', 'Понедельник', 'Вторник', 'Среда', 'Четверг',
    'Пятница', 'Суббота');

  Q_WeekDaysEng: array[1..7] of string =
    ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

  Q_SWeekDays2: array[1..7] of string =
    ('Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб');

  Q_SWeekDays3: array[1..7] of string =
    ('Вск', 'Пон', 'Втр', 'Срд', 'Чет', 'Пят', 'Суб');

  Q_SWeekDaysEng: array[1..7] of string =
    ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');


{ Функции для сравнения строк. }

{ Q_CompStr сравнивает две строки с учетом регистра. Возвращаемый результат
  меньше нуля, если S1 < S2; больше нуля, если S1 > S2, и равен нулю, если
  S1 = S2. Эта функция прекращает сравнение, когда обнаружено различие строк
  или когда обнаружен символ с кодом 0. Если этот символ может встречаться в
  середине строки, используйте вместо Q_CompStr функцию Q_CompStrL. Вторая
  функция Q_PCompStr аналогична Q_CompStr для PAnsiChar и Pointer(String). Если
  необходимо выяснить только, равны две строки или не равны, воспользуйтесь
  вместо Q_CompStr функцией Q_SameStr. }

function Q_CompStr(const S1, S2: String): integer;
function Q_PCompStr(P1, P2: pansichar): integer;

{ Q_CompStrL сравнивает две строки по MaxL первым символам с учетом регистра.
  Возвращаемый результат меньше нуля, если Copy(S1,1,MaxL) < Copy(S2,1,MaxL);
  результат больше нуля, если Copy(S1,1,MaxL) > Copy(S2,1,MaxL), иначе
  результат равен нулю (если Copy(S1,1,MaxL) = Copy(S2,1,MaxL) ). Если Вам
  надо выяснить только, равны две строки или не равны, воспользуйтесь
  вместо Q_CompStrL функцией Q_SameStrL. }

function Q_CompStrL(const S1, S2: String; MaxL: cardinal = MaxInt): integer;

{ Q_CompText сравнивает две строки без учета регистра. Возвращаемый результат
  меньше нуля, если S1 < S2; больше нуля, если S1 > S2, и равен нулю, если
  S1 = S2. Эта функция прекращает сравнение, когда обнаружено различие строк
  или когда обнаружен символ с кодом 0. Если этот символ может встречаться в
  середине строки, используйте вместо Q_CompText функцию Q_CompTextL. Вторая
  функция Q_PCompText аналогична Q_CompText для PAnsiChar и Pointer(String). Если
  необходимо выяснить только, равны ли две строки или нет, воспользуйтесь
  вместо Q_CompText функцией Q_SameText. }

function Q_CompText(const S1, S2: String): integer;
function Q_PCompText(P1, P2: pansichar): integer;

{ Q_CompTextL сравнивает две строки по MaxL первым символам без учета регистра.
  Если фрагмент первой строки больше (в алфавитном порядке), чем фрагмент
  второй строки, возвращаемое значение больше нуля. Если фрагмент первой строки
  меньше, чем фрагмент второй строки, возвращаемое значение меньше нуля, иначе
  результат равен нулю. Если необходимо выяснить только, равны ли две строки
  или не равны, используйте вместо Q_CompTextL функцию Q_SameTextL. }

function Q_CompTextL(const S1, S2: String; MaxL: cardinal = MaxInt): integer;

{ Q_SameStr сравнивает две строки с учетом регистра и возвращает True, если
  строки равны, иначе возвращает False. Функция Q_PSameStr аналогична Q_SameStr
  для Pointer(String). }

function Q_SameStr(const S1, S2: String): boolean;
function Q_PSameStr(P1, P2: Pointer): boolean;

{ Q_SameStrL сравнивает две строки по MaxL первым символам с учетом регистра.
  Возвращает True, если строки равны, иначе возвращает False. }

function Q_SameStrL(const S1, S2: String; MaxL: cardinal): boolean;

{ Q_SameText сравнивает две строки без учета регистра и возвращает True, если
  строки равны, иначе - False. Функция Q_PSameText аналогична Q_SameStr для
  Pointer(String). }

function Q_SameText(const S1, S2: String): boolean;
function Q_PSameText(P1, P2: Pointer): boolean;

{ Q_SameTextL сравнивает две строки по MaxL первым символам без учета регистра.
  Возвращает True, если строки равны, иначе возвращает False. }

function Q_SameTextL(const S1, S2: String; MaxL: cardinal): boolean;

{ Q_MatchStr проверяет, имеет ли место вхождение подстроки SubStr в строку S,
  начиная с символа S[Pos]. При сравнении учитывается регистр символов. Если
  вхождение имеет место, функция возвращает True, иначе - False. Эта функция
  реализует собой быстрый вариант проверки Q_SameStr(X,Copy(S,Pos,Length(X))).
  В отличие от других аналогичных функций, подстрока нулевой длины входит в
  любую строку. Идея этой функции заимствована из модуля cStrings.pas, автором
  которого является David Butler (david@e.co.za). }

function Q_MatchStr(const SubStr, S: String; Pos: integer = 1): boolean;

{ Q_MatchText проверяет, имеет ли место вхождение подстроки SubStr в строку S,
  начиная с символа S[Pos]. При сравнении регистр символов не учитывается. Если
  вхождение имеет место, функция возвращает True, иначе - False. Эта функция
  реализует собой быстрый вариант проверки Q_SameText(X,Copy(S,Pos,Length(X))).
  В отличие от других аналогичных функций, подстрока нулевой длины входит в
  любую строку. Идея этой функции заимствована из модуля cStrings.pas, автором
  которого является David Butler (david@e.co.za). }

function Q_MatchText(const SubStr, S: String; Pos: integer = 1): boolean;

{ Q_TestByMask проверяет, удовлетворяет ли строка S маске Mask, предполагая,
  что символы MaskChar из строки Mask могут быть заменены в строке S любыми
  другими символами. При сравнении регистр символов принимается во внимание.
  Если строка S удовлетворяет маске, функция возвращает True, иначе False.
  Например, Q_TestMask('ISBN 5-09-007017-2','ISBN ?-??-??????-?','?') вернет
  значение True. }

function Q_TestByMask(const S, Mask: String; MaskChar: ansichar = 'X'): boolean;

{ Q_TestWildStr проверяет, удовлетворяет ли строка S маске Mask, предполагая,
  что символы MaskChar из строки Mask могут быть заменены в строке S любыми
  другими символами, а символы WildCard могут быть заменены любым количеством
  других символов. При сравнении большие и маленькие буквы различаются. Символ
  WildCard должен быть отличен от #0. Если строка S удовлетворяет маске,
  функция возвращает True, иначе False. Например, следующий вызов функции
  вернет True: Q_TestWildStr('abc12345_infQ_XL.dat','abc*_???Q_*.d*at'). }

function Q_TestWildStr(const S, Mask: String; MaskChar: ansichar = '?'; WildCard: ansichar = '*'): boolean;

{ Q_TestWildText аналогична функции Q_TestWildStr, но регистр символов
  не принимается во внимание (большие и маленькие буквы не различаются). }

function Q_TestWildText(const S, Mask: String; MaskChar: ansichar = '?'; WildCard: ansichar = '*'): boolean;


{ Функции для изменения регистра символов. }

{ Q_CharUpper переводит символ Ch в верхний регистр (в большую букву). }

function Q_CharUpper(Ch: ansichar): ansichar;

{ Q_CharLower переводит символ Ch в нижний регистр (в маленькую букву). }

function Q_CharLower(Ch: ansichar): ansichar;

{ Q_StrUpper переводит строку S в верхний регистр (в большие буквы). При
  этом изменяется исходная строка. Функция Q_PStrUpper аналогична процедуре
  Q_StrUpper для PAnsiChar и Pointer(String), за исключением того, что она
  дополнительно возвращает указатель на начало строки. }

procedure Q_StrUpper(var S: String);
function Q_PStrUpper(P: pansichar): pansichar;

{ Q_StrLower переводит строку S в нижний регистр (в маленькие буквы). При
  этом изменяется исходная строка. Функция Q_PStrLower аналогична процедуре
  Q_StrLower для PAnsiChar и Pointer(String), за исключением того, что она
  дополнительно возвращает указатель на начало строки. }

procedure Q_StrLower(var S: String);
function Q_PStrLower(P: pansichar): pansichar;

{ Q_StrUpperMoveL копирует содержимое строки Source в строку Dest. При этом
  символы переводятся в верхний регистр. Максимальное число копируемых
  символов равно MaxL. Длина строки Dest устанавливается  равной числу
  скопированных символов. Память для строки Dest должна быть распределена
  заблаговременно вызовом функции SetString (или SetLength) (размером
  не менее MaxL символов). }

procedure Q_StrUpperMoveL(const Source: String; var Dest: String; MaxL: cardinal);

{ Q_StrLowerMoveL копирует содержимое строки Source в строку Dest. При этом
  символы переводятся в нижний регистр. Максимальное число копируемых
  символов равно MaxL. Длина строки Dest устанавливается  равной числу
  скопированных символов. Память для строки Dest должна быть распределена
  предварительно вызовом функции SetString (или SetLength) (размером
  не менее MaxL символов). }

procedure Q_StrLowerMoveL(const Source: String; var Dest: String; MaxL: cardinal);

{ Q_UpperCase переводит строку S в верхний регистр (в большие буквы). Исходная
  строка при этом не изменяется. Эта функция работает медленнее, чем Q_StrUpper
  или Q_StrUpperMoveL. }

function Q_UpperCase(const S: String): String;

{ Q_LowerCase переводит строку S в нижний регистр (в маленькие буквы). Исходная
  строка при этом не изменяется. Эта функция работает медленнее, чем Q_StrLower
  или Q_StrLowerMoveL. }

function Q_LowerCase(const S: String): String;

{ Q_UpLowerInPlace преобразует первый символ строки к верхнему регистру, а все
  остальные символы - к нижнему регистру. Исходная строка изменяется. }

procedure Q_UpLowerInPlace(var S: String);

{ Q_UpLowerStr преобразует первый символ строки к верхнему регистру, а все
  остальные символы - к нижнему регистру. Исходная строка не изменяется.
  Например: 'мЫРблКА bsDSFc' -> 'Мырблка bsdsfc'.  }

function Q_UpLowerStr(const S: String): String;

{ Q_ProperCaseInPlace изменяет строку S таким образом, что каждое слово будет
  начинаться с большой, а продолжаться маленькими буквами (первая буква каждого
  слова преобразуется к верхнему регистру, а остальные буквы - к нижнему
  регистру). Исходная строка S изменяется. В строке Delimiters передаются
  символы, которые рассматриваются как разделители слов в строке S. Если
  Delimiters равна пустой строке, используется список разделителей, которые
  были заданы в ходе предыдущего вызова одной из следующих функций Q_StrTok,
  Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_ProperCaseInPlace, Q_WordAtPos,
  Q_GetWordN, Q_SetDelimiters, Q_CountOfWords. Если разделители передаются
  в виде множества, они не запоминаются для последующих вызовов функций. }

procedure Q_ProperCaseInPlace(var S: String; const Delimiters: String); overload;
procedure Q_ProperCaseInPlace(var S: String; const Delimiters: TCharSet = Q_StdDelimsSet); overload;

{ Q_ProperCase возвращает строку S, преобразованную таким образом, что каждое
  слово начинается с большой буквы (первая буква каждого слова переводится в
  верхний регистр, а остальные буквы - в нижний регистр). В строке Delimiters
  передаются символы, которые рассматриваются как разделители слов в строке S.
  Например, вызов функции Q_ProperCase('средства ИНТЕРНЕТА',' ') вернет строку
  'Средства Интернета'. Если Delimiters равна пустой строке, используется
  список разделителей, которые были заданы в ходе предыдущего вызова одной из
  следующих функций: Q_ProperCaseInPlace, Q_ProperCase, Q_StrTok, Q_StrSpn,
  Q_StrCSpn, Q_WordAtPos, Q_GetWordN, Q_SetDelimiters, Q_CountOfWords. Если
  разделители передаются в виде множества, они не запоминаются для последующих
  вызовов функций. }

function Q_ProperCase(const S, Delimiters: String): String; overload;
function Q_ProperCase(const S: String; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;


{ Функции перекодировки строк: из DOS в Windows и наоборот. }

{ Q_StrToAnsi переводит строку S из кодировки DOS в кодировку Windows. При
  этом изменяется исходная строка. Q_PStrToAnsi аналогична процедуре
  Q_StrToAnsi для PAnsiChar и Pointer(String), за исключением того, что она
  дополнительно возвращает указатель на начало строки. }

procedure Q_StrToAnsi(var S: String);
function Q_PStrToAnsi(P: pansichar): pansichar;

{ Q_StrToOem переводит строку S из кодировки Windows в кодировку DOS. При
  этом изменяется исходная строка. Функция Q_PStrToOem аналогична процедуре
  Q_StrToOem для PAnsiChar и Pointer(String), за исключением того, что она
  дополнительно возвращает указатель на начало строки. }

procedure Q_StrToOem(var S: String);
function Q_PStrToOem(P: pansichar): pansichar;

{ Q_PStrToAnsiL переводит L первых символов строки, указываемой параметром P,
  из кодировки DOS в кодировку Windows. При этом изменяется исходная строка.
  Функция возвращает указатель на начало строки. }

function Q_PStrToAnsiL(P: pansichar; L: cardinal): pansichar;

{ Q_PStrToOemL переводит L первых символов строки, указываемой параметром P,
  из кодировки Windows в кодировку DOS. При этом изменяется исходная строка.
  Функция возвращает указатель на начало строки. }

function Q_PStrToOemL(P: pansichar; L: cardinal): pansichar;

{ Q_Str2ToAnsi переводит строку Source из кодировки DOS в кодировку Windows.
  Результат сохраняется в строке Dest. Q_PStr2ToAnsi аналогична процедуре
  Q_Str2ToAnsi для PAnsiChar и Pointer(String), за исключение того, что она
  дополнительно возвращает указатель на начало строки-приемника Dest. }

procedure Q_Str2ToAnsi(const Source: String; var Dest: String);
function Q_PStr2ToAnsi(Source, Dest: pansichar): pansichar;

{ Q_Str2ToOem переводит строку Source из кодировки Windows в кодировку DOS.
  Результат сохраняется в строке Dest. Q_PStr2ToOem аналогична процедуре
  Q_Str2ToOem для PAnsiChar и Pointer(String), за исключение того, что она
  дополнительно возвращает указатель на начало строки-приемника Dest. }

procedure Q_Str2ToOem(const Source: String; var Dest: String);
function Q_PStr2ToOem(Source, Dest: pansichar): pansichar;

{ Q_PStr2ToAnsiL переводит L первых символов строки Source из кодировки
  DOS в кодировку Windows. Результат сохраняется в строке Dest. Функция
  возвращает указатель на начало строки-приемника Dest. }

function Q_PStr2ToAnsiL(Source, Dest: pansichar; L: cardinal): pansichar;

{ Q_PStr2ToOemL переводит L первых символов строки Source из кодировки Windows
  в кодировку DOS. Результат сохраняется в строке Dest. Функция возвращает
  указатель на начало строки-приемника Dest. }

function Q_PStr2ToOemL(Source, Dest: pansichar; L: cardinal): pansichar;

{ Q_ToAnsi переводит строку OemStr из кодировки DOS в кодировку Windows. При
  этом исходная строка не изменяется. Эта функция работает медленнее, чем
  другие аналогичные функции и процедуры из этого модуля. }

function Q_ToAnsi(const OemStr: String): String;

{ Q_ToOem переводит строку AnsiStr из кодировки Windows в кодировку DOS. При
  этом исходная строка не изменяется. Эта функция работает медленнее, чем
  другие аналогичные функции и процедуры из этого модуля. }

function Q_ToOem(const AnsiStr: String): String;


{ Поиск, замена и удаление подстрок и отдельных символов. }

{ Q_PosStr находит первое входение подстроки FindString в строке SourceString,
  начиная с позиции StartPos. Возвращается номер символа, с которого начинается
  вхождение или 0, если подстрока FindString не найдена в строке SourceString.
  Поиск подстроки производится с учетом регистра (большие и маленькие буквы
  различаются). Автор алгоритма - Peter Morris (UK) (модуль FastStrings). }

function Q_PosStr(const FindString, SourceString: String; StartPos: integer = 1): integer;

{ Q_PosText находит первое входение подстроки FindString в строке SourceString,
  начиная с позиции StartPos. Возвращается номер символа, с которого начинается
  вхождение или 0, если подстрока FindString не найдена в строке SourceString.
  Поиск подстроки производится без учета регистра (большие и маленькие буквы
  не различаются). Автор алгоритма - Peter Morris (UK) (модуль FastStrings). }

function Q_PosText(const FindString, SourceString: String; StartPos: integer = 1): integer;

{ Q_PosStrLimited находит первое входение подстроки FindString в строке
  SourceString, начиная с позиции StartPos и заканчивая позицией EndPos.
  Возвращается номер символа, с которого начинается вхождение или 0, если
  подстрока FindString не найдена в строке SourceString. Поиск подстроки
  производится с учетом регистра (большие и маленькие буквы различаются). }

function Q_PosStrLimited(const FindString, SourceString: String; StartPos: integer = 1; EndPos: integer = MaxInt): integer;

{ Q_PosTextLimited находит первое входение подстроки FindString в строке
  SourceString, начиная с позиции StartPos и заканчивая позицией EndPos.
  Возвращается номер символа, с которого начинается вхождение или 0, если
  подстрока FindString не найдена. Поиск подстроки производится без учета
  регистра (большие и маленькие буквы не различаются). }

function Q_PosTextLimited(const FindString, SourceString: String; StartPos: integer = 1; EndPos: integer = MaxInt): integer;

{ Q_PosLastStr находит последнее входение подстроки FindString в строке
  SourceString, полагая, что следующее вхождение было найдено в позиции
  LastPos. Возвращается номер символа, с которого начинается искомая подстрока
  или 0, если данная подстрока не найдена ранее (левее) указанной позиции.
  Предполагается, что отдельные вхождения подстроки не перекрывают друг друга.
  Поиск подстроки производится с учетом регистра (большие и маленькие буквы
  различаются). Если LastPos превышает длину строки SourceString, то ищется
  самое последнее вхождение подстроки FindString. }

function Q_PosLastStr(const FindString, SourceString: String; LastPos: integer = MaxInt): integer;

{ Q_PosLastText находит последнее входение подстроки FindString в строке
  SourceString, полагая, что следующее вхождение было найдено в позиции
  LastPos. Возвращается номер символа, с которого начинается искомая подстрока
  или 0, если данная подстрока не найдена ранее (левее) указанной позиции.
  Предполагается, что отдельные вхождения подстроки не перекрывают друг друга.
  Поиск подстроки производится без учета регистра (большие и маленькие буквы
  не различаются). Если LastPos превышает длину строки SourceString, то
  ищется самое последнее вхождение подстроки FindString. }

function Q_PosLastText(const FindString, SourceString: String; LastPos: integer = MaxInt): integer;

{ Функции Q_TablePosXXX можно использовать для многократного поиска подстроки
  в строке (одной или многих), когда подстрока состоит из нескольких символов.
  Эти функции представляют собой одну из реализаций алгоритма поиска подстрок,
  называемого "Boyer-Moore pattern searching algorithm". Сначала вызывается
  процедура типа Q_InitTablePosXXX для задания искомой подстроки, а затем
  соответствующая функция Q_TablePosXXX для фактического поиска подстроки в
  строке. Эта вторая функция может вызываться многократно для поиска некоторого
  фрагмента во многих строках или для поиска нескольких вхождений подстроки в
  одну строку. Все функции и процедуры являются потокобезопасными, т.е.
  Q_TablePosXXX работает только с подстрокой, которая была указана при вызове
  Q_InitTablePosXXX в том же потоке. Одновременно поиск может проводиться
  в другом потоке, что никак не повлияет на текущий поток. Следует отметить,
  что Q_InitTablePosStr и Q_InitTablePosText используют одну и ту же область
  памяти для хранения искомой подстроки. Таким образом, нельзя смешивать поиск
  подстроки с учетом и без учета регистра. Скорость работы этих функций может
  быть различной в зависимости от длины подстроки и набора входящих в нее
  символов. Во многих случаях эти функции работают быстрее, чем Q_PosStr и
  Q_PosText, но чаще бывает наоборот. }

{ Q_InitTablePosStr инициирует поиск подстроки в строке с учетом регистра
  символов. Эта процедура должна быть вызвана для задания искомой подстроки
  перед тем, как будет вызываться функция Q_TablePosStr. }

procedure Q_InitTablePosStr(const FindString: String);

{ Q_TablePosStr находит в строке SourceString подстроку, определенную при
  вызове Q_InitTablePosStr. В параметре LastPos передается номер символа,
  с которого начиналось предыдущее найденное вхождение этой подстроки в
  строке SourceString. В этом же параметре возвращается позиция нового
  очередного вхождения искомой подстроки. Первоначально, значение параметра
  LastPos должно быть равно нулю. Если подстрока найдена, функция
  Q_TablePosStr возвращает True, иначе - False. Если подстрока не найдена,
  значение параметра LastPos не изменяется. }

function Q_TablePosStr(const SourceString: String; var LastPos: integer): boolean;

{ Q_InitTablePosText инициирует поиск подстроки в строке без учета
  регистра символов. Эта процедура должна быть вызвана для задания искомой
  подстроки перед тем, как будет вызываться функция Q_TablePosText. }

procedure Q_InitTablePosText(const FindString: String);

{ Q_TablePosText находит в строке SourceString подстроку, определенную при
  вызове Q_InitTablePosText. В параметре LastPos передается номер символа,
  с которого начиналось предыдущее найденное вхождение этой подстроки в
  строке SourceString. В этом же параметре возвращается позиция нового
  очередного вхождения искомой подстроки. Первоначально, значение параметра
  LastPos должно быть равно нулю. Если подстрока найдена, функция
  Q_TablePosText возвращает True, иначе - False. Если подстрока не найдена,
  значение параметра LastPos не изменяется. }

function Q_TablePosText(const SourceString: String; var LastPos: integer): boolean;

{ Q_ReplaceStr заменяет все входения подстроки FindString в строке SourceString
  подстрокой ReplaceString. Поиск подстроки производится с учетом регистра
  (большие и маленькие буквы различаются). Функция возвращает строку-результат.
  Если подстрока FindString отсутствует в строке SourceString, то возвращается
  исходная строка SourceString. }

function Q_ReplaceStr(const SourceString, FindString, ReplaceString: String): String;

{ Q_ReplaceText заменяет все входения подстроки FindString в строке
  SourceString подстрокой ReplaceString. Поиск подстроки производится без учета
  регистра (большие и маленькие буквы не различаются). Функция возвращает
  строку-результат. Если подстрока FindString отсутствует в строке SourceString,
  то возвращается исходная строка SourceString. }

function Q_ReplaceText(const SourceString, FindString, ReplaceString: String): String;

{ Q_ReplaceFirstStr заменяет первое вхождение подстроки FindString в строке
  SourceString подстрокой ReplaceString. Подстрока FindString ищется, начиная
  с символа S[StartPos]. Номер символа, с которого начинается найденное вхож-
  дение подстроки, возвращается как результат функции (или ноль, если подстрока
  не найдена). Поиск подстроки FindString выполняется с учетом регистра
  символов (большие и маленькие буквы различаются). }

function Q_ReplaceFirstStr(var S: String; const FindString, ReplaceString: String; StartPos: integer = 1): integer;

{ Q_ReplaceFirstText заменяет первое вхождение подстроки FindString в строке
  SourceString подстрокой ReplaceString. Подстрока FindString ищется, начиная
  с символа S[StartPos]. Номер символа, с которого начинается найденное вхож-
  дение подстроки, возвращается как результат функции (или ноль, если подстрока
  не найдена). Поиск подстроки FindString выполняется без учета регистра
  символов (большие и маленькие буквы не различаются). }

function Q_ReplaceFirstText(var S: String; const FindString, ReplaceString: String; StartPos: integer = 1): integer;

{ Q_ReplaceLastStr заменяет последнее вхождение подстроки FindString в строке
  SourceString подстрокой ReplaceString. Подстрока FindString ищется слева от
  символа S[LastPos] (т.е. во фрагменте Copy(S, 1, LastPos-1)). Номер символа,
  с которого начинается найденное вхождение, возвращается как результат функции
  (или ноль, если подстрока не найдена). Поиск подстроки FindString выполняется
  с учетом регистра символов (большие и маленькие буквы различаются). Если
  LastPos превышает длину строки S, то заменяется самое последнее вхождение
  искомой подстроки. }

function Q_ReplaceLastStr(var S: String; const FindString, ReplaceString: String; LastPos: integer = MaxInt): integer;

{ Q_ReplaceLastText заменяет последнее вхождение подстроки FindString в строке
  SourceString подстрокой ReplaceString. Подстрока FindString ищется слева от
  символа S[LastPos] (т.е. во фрагменте Copy(S, 1, LastPos-1)). Номер символа,
  с которого начинается найденное вхождение, возвращается как результат функции
  (или ноль, если подстрока не найдена). Поиск подстроки FindString выполняется
  без учета регистра символов (большие и маленькие буквы не различаются). Если
  LastPos превышает длину строки S, то заменяется самое последнее вхождение
  искомой подстроки. }

function Q_ReplaceLastText(var S: String; const FindString, ReplaceString: String; LastPos: integer = MaxInt): integer;

{ Q_DeleteStr удаляет из строки S все вхождения подстроки SubStrToDel. Поиск
  подстроки ведется с учетом регистра символов. Функция возвращает количество
  найденных (и удаленных) фрагментов. }

function Q_DeleteStr(var S: String; const SubStrToDel: String): integer;

{ Q_DeleteText удаляет из строки S все вхождения подстроки SubStrToDel. Поиск
  подстроки ведется без учета регистра символов. Функция возвращает количество
  найденных (и удаленных) фрагментов. }

function Q_DeleteText(var S: String; const SubStrToDel: String): integer;

{ Q_DeleteFirstStr удаляет первое вхождение подстроки SubStrToDel из строки
  SourceString. Подстрока SubStrToDel ищется, начиная с символа S[StartPos].
  Номер символа, с которого начинается найденное вхождение подстроки, возвра-
  щается как результат функции (или ноль, если подстрока не найдена). Поиск
  подстроки SubStrToDel выполняется с учетом регистра символов (большие и
  маленькие буквы различаются). }

function Q_DeleteFirstStr(var S: String; const SubStrToDel: String; StartPos: integer = 1): integer;

{ Q_DeleteFirstText удаляет первое вхождение подстроки SubStrToDel из строки
  SourceString. Подстрока SubStrToDel ищется, начиная с символа S[StartPos].
  Номер символа, с которого начинается найденное вхождение подстроки, возвра-
  щается как результат функции (или ноль, если подстрока не найдена). Поиск
  подстроки SubStrToDel выполняется без учета регистра символов (большие и
  маленькие буквы не различаются). }

function Q_DeleteFirstText(var S: String; const SubStrToDel: String; StartPos: integer = 1): integer;

{ Q_DeleteLastStr удаляет последнее вхождение подстроки SubStrToDel в строке
  SourceString. Подстрока SubStrToDel ищется слева от символа S[LastPos]
  (во фрагменте Copy(S, 1, LastPos-1)). Номер символа, с которого начинается
  найденное вхождение подстроки, возвращается как результат функции (или ноль,
  если подстрока не найдена). Поиск подстроки SubStrToDel выполняется с учетом
  регистра символов (большие и маленькие буквы различаются). }

function Q_DeleteLastStr(var S: String; const SubStrToDel: String; LastPos: integer = MaxInt): integer;

{ Q_DeleteLastText удаляет последнее вхождение подстроки SubStrToDel в строке
  SourceString. Подстрока SubStrToDel ищется слева от символа S[LastPos]
  (во фрагменте Copy(S, 1, LastPos-1)). Номер символа, с которого начинается
  найденное вхождение подстроки, возвращается как результат функции (или ноль,
  если подстрока не найдена). Поиск подстроки SubStrToDel выполняется без
  учета регистра символов (большие и маленькие буквы не различаются). }

function Q_DeleteLastText(var S: String; const SubStrToDel: String; LastPos: integer = MaxInt): integer;

{ Q_ReplaceChar заменяет в строке S каждое вхождение символа ChOld на символ
  ChNew. Результат функции равен количеству произведенных замен. Исходная
  строка S изменяется. }

function Q_ReplaceChar(var S: String; ChOld, ChNew: ansichar): integer;

{ Q_ReplaceChars заменяет в строке S все символы из строки StrChOld соответст-
  вующими символами из строки StrChNew. Исходная строка S изменяется. Если
  число символов в строке StrChOld не равно числу символов в строке StrChNew,
  возникает исключительная ситуация типа Exception. }

procedure Q_ReplaceChars(var S: String; const StrChOld, StrChNew: String);

{ Q_ReplaceCharsByOneChar заменяет все подряд идущие вхождения символов из
  множества ChOldSet в строке S одним символом ChNew. Исходная строка S при
  этом изменяется. Если надо заменить несколько символов одним без удаления
  повторений, воспользуйтесь процедурой Q_ReplaceChars. }

procedure Q_ReplaceCharsByOneChar(var S: String; const ChOldSet: TCharSet; ChNew: ansichar);

{ Q_StrScan находит первое вхождение символа Ch в строку S, начиная с символа
  номер StartPos. Возвращает номер найденного символа или ноль, если символ Ch
  в строке S не найден. Функция Q_PStrScan аналогична Q_StrScan для
  Pointer(String). }

function Q_StrScan(const S: String; Ch: ansichar; StartPos: integer = 1): integer;
function Q_PStrScan(P: Pointer; Ch: ansichar; StartPos: integer = 1): integer;

{ Q_StrRScan находит предыдущее вхождение символа Ch в строку S. В параметре
  LastPos передается номер символа, соответствующий текущему вхождению Ch в
  строку S. Поиск начинается с символа, предшествующего символу S[LastPos] или
  с последнего символа строки, если LastPos превышает длину строки S. Функция
  возвращает номер найденного символа или ноль, если символ Ch не найден в
  строке S левее символа с номером LastPos. Функция Q_PStrRScan аналогична
  Q_StrRScan для Pointer(String). }

function Q_StrRScan(const S: String; Ch: ansichar; LastPos: integer = MaxInt): integer;
function Q_PStrRScan(P: Pointer; Ch: ansichar; LastPos: integer = MaxInt): integer;

{ Q_StrSpn возвращает номер первого символа строки S, не входящего в строку
  Delimiters, начиная с символа номер StartPos. Строка Delimiters задает
  множество символов-разделителей, а функция находит первый символ,
  не являющийся разделителем. Если обычные символы в строке S отсутствуют,
  возвращается ноль. Если Delimiters равна пустой строке, используется список
  разделителей, которые были заданы в ходе предыдущего вызова одной из
  следующих функций: Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos,
  Q_GetWordN, Q_ProperCaseInPlace, Q_SetDelimiters, Q_CountOfWords. Если
  разделители передаются в виде множества типа TCharSet, они не запоминаются
  для последующих вызовов функций. }

function Q_StrSpn(const S, Delimiters: String; StartPos: cardinal = 1): integer; overload;
function Q_StrSpn(const S: String; StartPos: cardinal = 1; const Delimiters: TCharSet = Q_StdDelimsSet): integer; overload;

{ Q_StrCSpn возвращает номер первого символа строки S, входящего в строку
  Delimiters, начиная с символа номер StartPos. Строка Delimiters задает
  множество символов-разделителей, а функция находит первый символ-разделитель.
  Если символы-разделители в строке S отсутствуют, возвращается ноль. Если
  Delimiters равна пустой строке, используется список разделителей, которые
  были заданы в ходе предыдущего вызова одной из следующих функций: Q_StrTok,
  Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_ProperCaseInPlace, Q_WordAtPos,
  Q_GetWordN, Q_SetDelimiters, Q_CountOfWords. Если разделители передаются
  в виде множества, они не запоминаются для последующих вызовов функций. }

function Q_StrCSpn(const S, Delimiters: String; StartPos: cardinal = 1): integer; overload;
function Q_StrCSpn(const S: String; StartPos: cardinal = 1; const Delimiters: TCharSet = Q_StdDelimsSet): integer; overload;

{ Q_DelCharInPlace удаляет все символы Ch из строки S. Исходная строка при
  этом изменяется. }

procedure Q_DelCharInPlace(var S: String; Ch: ansichar = ' ');

{ Q_DelChar удаляет все символы Ch из строки, переданной параметром S. }

function Q_DelChar(const S: String; Ch: ansichar = ' '): String;

{ Q_Delete удаляет подстроку из строки S. При этом исходная строка изменяется.
  Index - индекс первого удаляемого символа, Count - количество символов,
  подлежащих удалению. Эта функция работает быстрее, чем стандартная Delete. }

procedure Q_Delete(var S: String; Index, Count: integer);

{ Q_DelChars удаляет из строки S символы, которые присутствуют в строке
  (или множестве) CharsToRemove. Исходная строка S изменяется. }

procedure Q_DelChars(var S: String; const CharsToRemove: String); overload;
procedure Q_DelChars(var S: String; const CharsToRemove: TCharSet); overload;

{ Q_KeepChars оставляет в строке S только те символы, которые присутствуют в
  строке (или множестве) CharsToKeep, остальные символы удаляет. Исходная
  строка S изменяется. }

procedure Q_KeepChars(var S: String; const CharsToKeep: String); overload;
procedure Q_KeepChars(var S: String; const CharsToKeep: TCharSet); overload;

{ Q_ApplyMask применяет маску Mask к строке SourceStr и возвращает полученную
  строку как результат функции. Символ MaskChar используется в строке Mask для
  указания позиций, в которых подставляются символы из строки SourceStr. Длина
  SourceStr должна быть равна количеству символов MaskChar в маске. Пример:
  Q_ApplyMask('(###) ##-##-##','075723293','#') вернет строку '(075) 72-32-93'.
  Идея этой и следующих трех функций заимствована из модуля jbStr.Pas, автором
  которого является Jaro Benes (micrel@micrel.cz). }

function Q_ApplyMask(const Mask, SourceStr: String; MaskChar: ansichar = 'X'): String;

{ Q_ApplyMaskInPlace применяет маску Mask к строке SourceStr и сохраняет
  полученную строку в переменной Mask. Символ MaskChar используется в строке
  Mask для указания позиций, в которых подставляются символы из строки
  SourceStr. Длина строки SourceStr должна соответствовать количеству символов
  подстановки MaskChar в маске Mask. }

procedure Q_ApplyMaskInPlace(var Mask: String; const SourceStr: String; MaskChar: ansichar = 'X');

{ Q_ExtractByMask удаляет из строки S все символы, являющиеся фиксированными
  для данной маски Mask, оставляя только подставленные символы, т.е. символы,
  которым в маске соответствует символ MaskChar. Полученная таким образом
  строка возвращается как результат функции. Длина строк S и Mask должна быть
  одинаковой. Пример: Q_ExtractByMask('7-35-01','X-XX-XX') вернет '73501'. }

function Q_ExtractByMask(const S, Mask: String; MaskChar: ansichar = 'X'): String;

{ Q_ExtractByMaskInPlace удаляет из строки S все символы, являющиеся
  фиксированными для данной маски Mask, оставляя только подставленные символы,
  т.е. символы, которым в маске соответствует символ MaskChar. Полученная
  таким образом строка сохраняется в переменной, переданной параметром S.
  Исходная длина строк S и Mask должна быть одинаковой. }

procedure Q_ExtractByMaskInPlace(var S: String; const Mask: String; MaskChar: ansichar = 'X');


{ Форматирование строк, вырезка фрагментов строки. }

{ Q_TrimInPlace удаляет ведущие и концевые пробелы и управляющие символы из
  строки S. При этом исходная строка изменяется. Эта процедура работает
  быстрее, чем стандартная функция Trim. }

procedure Q_TrimInPlace(var S: String);

{ Q_TrimLeftInPlace удаляет ведущие пробелы и управляющие символы из строки S.
  При этом исходная строка изменяется. Эта процедура работает быстрее, чем
  стандартная функция TrimLeft. }

procedure Q_TrimLeftInPlace(var S: String);

{ Q_TrimRightInPlace удаляет концевые пробелы и управляющие символы из
  строки S. При этом исходная строка изменяется. Эта процедура работает
  быстрее, чем стандартная функция TrimRight. }

procedure Q_TrimRightInPlace(var S: String);

{ Q_TrimChar удаляет ведущие и концевые символы Ch из строки S. Исходная
  строка S не изменяется. }

function Q_TrimChar(const S: String; Ch: ansichar = ' '): String;

{ Q_TrimCharLeft удаляет ведущие символы Ch из строки S. Исходная строка S
  не изменяется.}

function Q_TrimCharLeft(const S: String; Ch: ansichar = ' '): String;

{ Q_TrimCharRight удаляет концевые символы Ch из строки S. Исходная строка S
  не изменяется.}

function Q_TrimCharRight(const S: String; Ch: ansichar = ' '): String;

{ Q_KeepOneChar удаляет все подряд идущие символы Ch, кроме одного, из строки,
  переданной параметром S. Исходная строка при этом не изменяется. Например,
  Q_KeepOneChar('How   do  you    do   ',' ') вернет строку 'How do you do '. }

function Q_KeepOneChar(const S: String; Ch: ansichar = ' '): String;

{ Q_SpaceCompressInPlace удаляет из строки начальные и конечные пробелы и
  управляющие символы (меньше пробела). Кроме того, все подряд идущие пробелы
  и управляющие символы в середине строки заменяются одним пробелом. Исходная
  строка изменяется. }

procedure Q_SpaceCompressInPlace(var S: String);

{ Q_SpaceCompress удаляет из строки начальные и конечные пробелы и управляющие
  символы (меньше пробела). Кроме того, все подряд идущие пробелы и управляющие
  символы в середине строки заменяются одним пробелом. Исходная строка при этом
  не изменяется. Эта функция работает медленнее, чем Q_SpaceCompressInPlace. }

function Q_SpaceCompress(const S: String): String;

{ Q_PadLeft дополняет строку S символами PadCh слева до длины Length. Если
  длина строки S больше Length, то, если параметр Cut = True, строка обрезается
  справа до длины Length, иначе (Cut = False) возвращается исходная строка S. }

function Q_PadLeft(const S: String; Length: integer; PadCh: ansichar = ' '; Cut: boolean = False): String;

{ Q_PadRight дополняет строку S символами PadCh справа до длины Length. Если
  длина строки S больше Length, то, если параметр Cut = True, строка обрезается
  справа до длины Length, иначе (Cut = False) возвращается исходная строка S. }

function Q_PadRight(const S: String; Length: integer; PadCh: ansichar = ' '; Cut: boolean = False): String;

{ Q_CenterStr центрирует строку S символами PadCh относительно длины Length.
  Если длина строки S больше Length, то, если параметр Cut = True, строка
  обрезается справа до длины Length, иначе (Cut = False) возвращается исходная
  строка S. }

function Q_CenterStr(const S: String; Length: integer; PadCh: ansichar = ' '; Cut: boolean = False): String;

{ Q_PadInside добавляет (равномерно) символы PadCh в строку S в тех позициях,
  где они уже присутствуют, до тех пор, пока длина строки не станет равной
  Length. Другими словами, эта функция производит выравнивание текста по обоим
  краям. Если длина строки превышает Length, то, если параметр Cut = True,
  строка обрезается справа до длины Length, иначе (Cut = False) возвращается
  исходная строка S. Никакие специальные символы не распознаются. }

function Q_PadInside(const S: String; Length: integer; PadCh: ansichar = ' '; Cut: boolean = False): String;

{ Q_TabsToSpaces заменяет все символы табуляции (#9) в строке S пробелами.
  Интервал табуляции задается параметром TabStop. }

function Q_TabsToSpaces(const S: String; TabStop: integer = 8): String;

{ Q_SpacesToTabs заменяет последовательности пробелов в строке S символами
  табуляции #9. Интервал табуляции задается параметром TabStop. Эта функция
  работает, даже, если исходная строка уже содержит символы табуляции. }

function Q_SpacesToTabs(const S: String; TabStop: integer = 8): String;

{ Q_StrTok возвращает очередной фрагмент строки S, одновременно удаляя его из
  исходной строки. Q_StrTok рассматривает строку S как последовательность из
  нуля или более текстовых фрагментов, отделенных друг от друга одним или более
  символом-разделителем из строки Delimiters. В параметре Delimiters передается
  строка, которая состоит из символов, которые рассматриваются как разделители
  для строки S. Сами разделители не включаются во фрагмент, возвращаемый
  функцией Q_StrTok. Если строка начинается с символов-разделителей, то все
  они удаляются. Если Delimiters - пустая строке, используются разделители,
  которые были заданы в ходе предыдущего вызова одной из следующих функций:
  Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos, Q_SetDelimiters,
  Q_GetWordN, Q_ProperCaseInPlace, Q_CountOfWords. Если разделители передаются
  в виде множества, они не запоминаются для последующих вызовов функций. }

function Q_StrTok(var S: String; const Delimiters: String): String; overload;
function Q_StrTok(var S: String; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;

{ Q_StrTok1 возвращает очередной фрагмент строки S, одновременно удаляя его
  из исходной строки и удаляя следующий за ним символ-разделитель. Q_StrTok1
  рассматривает строку S как последовательность из нуля или более текстовых
  фрагментов, отделенных друг от друга единичным символом-разделителем из
  строки Delimiters. Если в строке S подряд идет несколько разделителей, то
  функция будет возвращать пустую строку для каждого такого символа, если
  перед ним отсутствует текстовый фрагмент. В параметре Delimiters передается
  строка, которая состоит из символов, которые рассматриваются как разделители
  для строки S. Сами разделители не включаются во фрагмент, возвращаемый
  функцией Q_StrTok1. Если Delimiters - пустая строке, используются символы,
  которые были заданы в ходе предыдущего вызова одной из следующих функций:
  Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos, Q_SetDelimiters,
  Q_GetWordN, Q_ProperCaseInPlace, Q_CountOfWords. Если разделители передаются
  в виде множества, они не запоминаются для последующих вызовов функций. }

function Q_StrTok1(var S: String; const Delimiters: String): String; overload;
function Q_StrTok1(var S: String; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;

{ Q_WordAtPos возвращает слово из строки S, в составе которого находится
  символ S[Pos]. Строка Delimiters задает символы, считающиеся разделителями
  слов в строке S. Если символ в позиции Pos является разделителем, функция
  возвращает пустую строку. Если Delimiters равна пустой строке, используется
  список разделителей, которые были заданы в ходе предыдущего вызова одной из
  следующих функций: Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos,
  Q_GetWordN, Q_ProperCaseInPlace, Q_SetDelimiters, Q_CountOfWords. Если
  разделители передаются в виде множества типа TCharSet, они не запоминаются
  для последующих вызовов функций. }

function Q_WordAtPos(const S: String; Pos: integer; const Delimiters: String): String; overload;
function Q_WordAtPos(const S: String; Pos: integer; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;

{ Q_GetWordN возвращает слово с порядковым номером OrdN из строки S. Слова
  нумеруются с единицы. Строка Delimiters задает символы, считающиеся раздели-
  телями слов в строке S. Если несколько символов-разделителей следует подряд
  один за другим, то вся эта последовательность рассматривается как единствен-
  ный символ-разделитель. Если слово с номером OrdN в строке S отсутствует,
  возвращается пустая строка. Если Delimiters равна пустой строке, используется
  список разделителей, которые были заданы в ходе предыдущего вызова одной из
  следующих функций: Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos,
  Q_GetWordN, Q_ProperCaseInPlace, Q_SetDelimiters, Q_CountOfWords. Если
  разделители передаются в виде множества типа TCharSet, они не запоминаются
  для последующих вызовов функций. }

function Q_GetWordN(OrdN: integer; const S, Delimiters: String): String; overload;
function Q_GetWordN(OrdN: integer; const S: String; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;

{ Функции Q_GetWordN_1 аналогичны функциям Q_GetWordN за исключением того, что
  в них последовательность символов-разделителей не рассматривается как один
  разделитель. В этих функциях предполагается, что строка S состоит из несколь-
  ких слов, разделенных единственным символом-разделителем. Если подряд следует
  два разделителя, то значит соответствующее слово равно пустой строке. }

function Q_GetWordN_1(OrdN: integer; const S, Delimiters: String): String; overload;
function Q_GetWordN_1(OrdN: integer; const S: String; const Delimiters: TCharSet = Q_StdDelimsSet): String; overload;

{ Идея следующих пяти функций позаимствована из модуля cStrings.pas, автором
  которого является David Butler (david@e.co.za). }

{ Q_CopyRange возвращает подстроку из строки S, начиная с символа, индекс
  которого равен Start, и кончая символом с индексом Stop. }

function Q_CopyRange(const S: String; Start, Stop: integer): String;

{ Q_CopyFrom возвращает подстроку из строки S, начиная с символа, индекс
  которого равен Start, и до конца строки. }

function Q_CopyFrom(const S: String; Start: integer): String;

{ Q_CopyLeft возвращает Count первых символов строки, переданной параметром S. }

function Q_CopyLeft(const S: String; Count: integer): String;

{ Q_CopyRight возвращает Count последних символов строки, переданной
  параметром S. }

function Q_CopyRight(const S: String; Count: integer): String;

{ Q_PasteStr заменяет Count символов строки Dest, начиная с позиции Pos, содер-
  жимым строки Source. Строка Dest при этом изменяется. Например, если строка
  Dest равна 'How do you do', то после выполнения процедуры: Q_PasteStr(Dest,
  5,6,'does he'), она будет равна 'How does he do'. Эта процедура выполняется
  быстрее, чем комбинация стандартных Delete-Insert. }

procedure Q_PasteStr(var Dest: String; Pos, Count: integer; const Source: String);

{ Q_CopyDel возвращает подстроку, одновременно удаляя ее из исходной строки.
  S - исходная строка, Start - номер первого вырезаемого символа, Len - длина
  вырезаемой подстроки. Эта функция позаимствована из модуля AGSLib.pas,
  автором которого является Алексей Лукин. }

function Q_CopyDel(var S: String; Start, Length: integer): String;


{ Другие функции для работы со строками. }

{ Q_SetDelimiters задает строку (или множество) символов-разделителей слов
  для последующего вызова таких функций, как Q_StrTok, Q_StrSpn, Q_StrCSpn,
  Q_ProperCase, Q_WordAtPos, Q_GetWordN, Q_ProperCaseInPlace, Q_CountOfWords.
  В этом случае аргумент Delimiters при вызове этих функций должен быть равен
  пустой строке. Если процедура Q_SetDelimiters вызвана без параметров, то в
  качестве разделителей принимаются символы из константного множества
  Q_StdDelimsSet, определенного в начале модуля QStrings. }

procedure Q_SetDelimiters(const Delimiters: String); overload;
procedure Q_SetDelimiters(const Delimiters: TCharSet = Q_StdDelimsSet); overload;

{ Q_GetDelimiters возвращает строку, состоящую из символов-разделителей слов,
  перечисленных в порядке, соответствующим их кодам. Если ранее не вызывались
  какие-либо функции, задающие строку разделителей (например Q_SetDelimiters),
  результат функции Q_GetDelimiters будет неопределенным. }

function Q_GetDelimiters: String;

{ Q_StrMoveL копирует содержимое строки Source в строку Dest. Максимальное
  число копируемых символов равно MaxL. Длина строки Dest устанавливается
  равной числу скопированных символов. Память для строки Dest должна быть
  распределена заранее вызовом функции SetString (или SetLength) (размером
  не менее MaxL символов). Q_StrMoveL работает намного быстрее, чем обычное
  присвоение строки, при котором происходит ее копирование. }

procedure Q_StrMoveL(const Source: String; var Dest: String; MaxL: cardinal);

{ Q_StrReverse переворачивает строку S так, что первый символ становится
  последним, второй -  предпоследним и т.д. При этом изменяется исходная
  строка. Функция Q_PStrReverse аналогична Q_StrReverse для Pointer(String).
  Кроме того, она возвращает указатель на начало строки. }

procedure Q_StrReverse(var S: String);
function Q_PStrReverse(P: Pointer): Pointer;

{ Q_CutLeft обрезает строку S слева на CharCount символов, уменьшая при этом
  ее длину. Если параметр CharCount отрицательный, строка обрезается справа. }

procedure Q_CutLeft(var S: String; CharCount: integer);

{ Q_CutRight обрезает строку S справа на CharCount символов, уменьшая при этом
  ее длину. Если параметр CharCount отрицательный, строка обрезается слева. }

procedure Q_CutRight(var S: String; CharCount: integer);

{ Q_RotateLeft циклически сдвигает строку S на Shift символов влево. Параметр
  Shift может быть как положительным, так и отрицательным. }

procedure Q_RotateLeft(var S: String; Shift: integer);

{ Q_RotateRight циклически сдвигает строку S на Shift символов вправо.
  Параметр Shift может быть как положительным, так и отрицательным. }

procedure Q_RotateRight(var S: String; Shift: integer);

{ Q_Duplicate возвращает строку, состоящую из Count копий строки S. }

function Q_Duplicate(const S: String; Count: integer): String;

{ Q_Base64Encode возвращает строку S или байтовый массив, адресуемый параметром
  P, длиной L байт, закодированные в формате Base64 (MIME), часто используемом
  при пересылке файлов по электронной почте. Результирующая строка дополняется
  в конце символами '=' до длины, кратной 4. Чтобы избежать дополнения, длина
  исходной строки или байтового массива должна быть кратной 3. }

function Q_Base64Encode(const S: String): String; overload;
function Q_Base64Encode(P: Pointer; L: cardinal): String; overload;

{ Q_Base64Decode возвращает результат раскодирования строки S из кодировки
  Base64, т.е. восстанавливает первоначальное содержимое строки. Длина
  закодированной строки должна быть кратной 4. }

function Q_Base64Decode(const S: String): String;

{ Следующие функции реализуют сжатие текстовых и бинарных строк методом RLE.
  Данный метод основан на удалении из текста последовательностей одинаковых
  символов (замене их одним символом и счетчиком). Если текст не содержит
  подобных последовательностей, то его длина обычно не меняется. Длина текста
  может даже увеличиться (в худшем случае в два раза), если он содержит
  специальные символы (см. константы RLECC в разделе implementation). Этот
  алгоритм является очень быстрым и обеспечивает эффективное сжатие информации,
  содержащей группы повторяющихся байтов.

  Если символ повторяется менее трех раз, то никаких замен не производится.
  Если число повторений символа от трех до восьми, то эта последовательность
  заменяется двумя символами, от 9 до 127 - тремя символами, от 128 до 16383 -
  четырьмя, от 16384 до 2097151 - пятью символами, от 2097152 до 268435455 -
  шестью символами, иначе - семью символами. Каждый единичный специальный
  символ заменяется парой символов, последовательность из двух специальных
  символов (одинаковых) заменяется парой символов, последовательность от 3
  до 127 специальных символов заменяется тремя символами, далее - как обычно.
  Если предполагается использовать эти процедуры для сжатия полутоновых
  графических изображений, алгоритм их работы следует пересмотреть на предмет
  уменьшения числа специальных символов с семи до двух или трех. }

{ Q_GetPackRLESize возвращает размер выходного массива (в байтах), который
  необходим для сохранения в нем результатов сжатия методом RLE данных,
  адресуемых параметром Source размером SrcL байт. Максимально возможный
  размер равен удвоенному значению параметра SrcL (наихудший вариант). }

function Q_GetPackRLESize(Source: Pointer; SrcL: cardinal): cardinal;

{ Q_GetUnpackRLESize возвращает размер выходного массива (в байтах), который
  необходим для сохранения в нем результатов распаковки данных, сжатых методом
  RLE, адресуемых параметром Source размером SrcL байт. Эта функция вызывается
  перед вызовом Q_UnpackRLE для байтового массива. }

function Q_GetUnpackRLESize(Source: Pointer; SrcL: cardinal): cardinal;

{ Q_PackRLE выполняет сжатие данных, адресуемых параметром Source, длиной
  SrcL байт методом RLE. Результат сохраняется в области памяти указываемой
  Dest. Результат функции равен размеру (в байтах) выходного массива данных.
  Размер области памяти Dest должен быть достаточным (необходимый размер
  определяется с помощью Q_GetPackRLESize). Внутри самой функции никаких
  подобных проверок не выполняется. }

function Q_PackRLE(Source, Dest: Pointer; SrcL: cardinal): cardinal; overload;

{ Q_UnpackRLE выполняет распаковку данных, адресуемых параметром Source, длиной
  SrcL байт, сжатых методом RLE. Выходные данные сохраняются в области памяти
  указываемой Dest. Результат функции равен размеру (в байтах) выходного
  массива данных. Размер области памяти Dest должен быть достаточным для того,
  чтобы вместить все данные (его можно определить с помощью Q_GetUnpackRLESize).
  Внутри функции Q_UnpackRLE размер области памяти не проверяется. }

function Q_UnpackRLE(Source, Dest: Pointer; SrcL: cardinal): cardinal; overload;

{ Q_PackRLE упаковывает строку S методом RLE. В параметре MaxL передается
  максимально возможная длина выходной строки или -1, для автоматического
  определения длины выходной строки. }

function Q_PackRLE(const S: String; MaxL: integer = -1): String; overload;

{ Q_UnpackRLE выполняет распаковку строки S, сжатой методом RLE. В параметре
  MaxL передается максимально возможная длина выходной строки или -1, для
  автоматического определения длины выходной строки. }

function Q_UnpackRLE(const S: String; MaxL: integer = -1): String; overload;


{ Информационные функции. }

{ Q_PStrLen возвращает длину строки типа PAnsiChar, адресуемой параметром P. Эта
  функция работает значительно быстрее стандартной StrLen. Автором реализации
  является Robert Lee (rhlee@optimalcode.com). }

function Q_PStrLen(P: pansichar): integer;

{ Q_IsEmptyStr возвращает True, если строка S содержит только символы из строки
  (или множества) EmptyChars, иначе функция возвращает False. Эта функция может
  вызываться без параметра EmptyChars. В этом случае все символы меньшие или
  равные пробелу считаются пустыми. }

function Q_IsEmptyStr(const S, EmptyChars: String): boolean; overload;
function Q_IsEmptyStr(const S: String; const EmptyChars: TCharSet): boolean; overload;
function Q_IsEmptyStr(const S: String): boolean; overload;

{ Q_CharCount подсчитывает количество вхождений символа Ch в строку S. }

function Q_CharCount(const S: String; Ch: ansichar): integer;

{ Q_CharsCount подсчитывает в строке S количество вхождений символов,
  присутствующих в множестве CharSet. }

function Q_CharsCount(const S: String; const CharSet: TCharSet): integer;

{ Q_GetCharStr возвращает строку, содержащую в алфавитном порядке все символы
  (по одному), входящие в состав исходной строки S. }

function Q_GetCharStr(const S: String): String;

{ Q_CountOfWords подсчитывает количество слов в строке, переданной параметром
  S. В строке Delimiters передаются символы, которые рассматриваются как раз-
  делители слов в строке S. Если Delimiters равна пустой строке, используется
  список разделителей, которые были заданы в ходе предыдущего вызова одной из
  следующих функций: Q_StrTok, Q_StrSpn, Q_StrCSpn, Q_ProperCase, Q_WordAtPos,
  Q_GetWordN, Q_ProperCaseInPlace, Q_SetDelimiters, Q_CountOfWords. Если
  разделители передаются в виде множества типа TCharSet, они не запоминаются
  для последующих вызовов функций. }

function Q_CountOfWords(const S, Delimiters: String): integer; overload;
function Q_CountOfWords(const S: String; const Delimiters: TCharSet = Q_StdDelimsSet): integer; overload;

{ Q_StrCheckSum возвращает сумму кодов символов, составляющих строку S. Это
  значение может использоваться как контрольная сумма. Функция Q_PStrCheckSum
  аналогична Q_StrCheckSum для Pointer(String). Для контроля целостности
  данных надежнее использовать функцию Q_CRC32. }

function Q_StrCheckSum(const S: String): longword;
function Q_PStrCheckSum(P: Pointer): longword;

{ Q_StrCheckXOR возвращает число, являющееся результатом объединения каждых
  четырех символов строки S в одно двойное слово с помощью "исключающего или".
  Эта операция выполняется очень быстро. Полученное таким образом число может
  использоваться как контрольная сумма или значение hash-функции. Однако, для
  надежного контроля целостности данных, лучше использовать Q_CRC32. Функция
  Q_PStrCheckXOR аналогична Q_StrCheckXOR для Pointer(String). }

function Q_StrCheckXOR(const S: String): longword;
function Q_PStrCheckXOR(P: Pointer): longword;

{ Q_StrHashKey генерирует hash-код для строки, переданной параметром S.
  В строке различаются большие и маленькие буквы. Функция Q_PStrHashKey
  аналогична Q_StrHashKey для Pointer(String). }

function Q_StrHashKey(const S: String): longword;
function Q_PStrHashKey(P: Pointer): longword;

{ Q_TextHashKey генерирует hash-код для строки, переданной параметром S.
  Большие и маленькие буквы не различаются. Функция Q_PTextHashKey аналогична
  Q_TextHashKey для Pointer(String). }

function Q_TextHashKey(const S: String): longword;
function Q_PTextHashKey(P: Pointer): longword;

{ Q_CRC32 вычисляет CRC-32 для области памяти, адресуемой параметром P. Размер
  области памяти (в байтах) задается параметром L. }

function Q_CRC32(P: Pointer; L: cardinal): longword;

{ Q_NextCRC32 вычисляет по базовому значению CRC32 новое значение для области
  памяти, адресуемой параметром P, размером L байт. Новое CRC32 возвращается
  как значение одноименного параметра, а также как результат функции. Если
  ранее CRC32 не вычислялся, то соответствующий параметр должен быть равен 0. }

function Q_NextCRC32(var CRC32: longword; P: Pointer; L: cardinal): longword;

{ Q_TimeStamp считывает содержимое 64-разрядного счетчика времени, который
  увеличивается на единицу при каждом такте процессора (значение счетчика
  читается командой RDTSC). Эта функция не работает на процессорах ниже P5. }

function Q_TimeStamp: int64;


{ Функции для работы со множествами типа TCharSet. }

{ Стандартные процедуры Include, Exclude и оператор 'in' транслируются
  в достаточно эффективный код. Вместо всех других операций со множествами,
  для типа TCharSet следует использовать функции из этого раздела. }

{ Q_GetCharSet возвращает множество типа TCharSet, включающее только символы,
  которые присутствуют в строке S. }

function Q_GetCharSet(const S: String): TCharSet;

{ Q_CharSetToStr возвращает строку символов, которая представляет собой
  перечисление в алфавитном порядке символов, присутствующих во множестве
  CharSet типа TCharSet. }

function Q_CharSetToStr(const CharSet: TCharSet): String;

{ Q_ComplementChar добавляет в множество CharSet символ Ch, если его там
  не было, или удаляет символ Ch из этого множества, если он там был. }

procedure Q_ComplementChar(var CharSet: TCharSet; Ch: ansichar);

{ Q_ClearCharSet удаляет все символы из множества CharSet. После выхода
  из этой процедуры множество CharSet становится пустым. }

procedure Q_ClearCharSet(var CharSet: TCharSet);

{ Q_FillCharSet добавляет в множество CharSet все недостающие символы. После
  выхода из этой процедуры множество CharSet содержит все возможные символы. }

procedure Q_FillCharSet(var CharSet: TCharSet);

{ Q_ComplementSet инвертирует множество CharSet. После выполнения этой
  процедуры множество CharSet будет содержать только те символы, которые
  отсутствовали в этом множестве до вызова Q_ComplementSet. }

procedure Q_ComplementSet(var CharSet: TCharSet);

{ Q_CloneCharSet копирует множество SourceSet во множество DestSet. Оба эти
  множества должны иметь тип TCharSet. После выполнения этой процедуры вызов
  функции Q_IsEqualSet(SourceSet, DestSet) вернет значение True. }

procedure Q_CloneCharSet(const SourceSet: TCharSet; var DestSet: TCharSet);

{ Q_CharSetUnion объединяет множества SourceSet и DestSet и сохраняет результат
  в множестве DestSet. Результирующее множество включает символы, которые
  содержатся хотя бы в одном из исходных множеств. }

procedure Q_CharSetUnion(var DestSet: TCharSet; const SourceSet: TCharSet);

{ Q_CharSetSubtract вычитает множество SourceSet из множества DestSet и
  сохраняет результат в множестве DestSet. Результирующее множество включает
  только символы, которые присутствовали во множестве DestSet, но не присут-
  ствовали (т.е. отсутствовали) во множестве SourceSet. }

procedure Q_CharSetSubtract(var DestSet: TCharSet; const SourceSet: TCharSet);

{ Q_CharSetIntersect находит пересечение (общие элементы) множеств SourceSet
  и DestSet и сохраняет результат в множестве DestSet. Полученное таким образом
  множество содержит только символы, присутствующие в обоих множествах. }

procedure Q_CharSetIntersect(var DestSet: TCharSet; const SourceSet: TCharSet);

{ Q_CharSetXOR добавляет в множество DestSet символы, присутствующие в
  множестве SourceSet, но отсутствующие в множестве DestSet, и удаляет из
  множества DestSet символы, присутствующие в множестве SourceSet и
  одновременно присутствующие в множестве DestSet. }

procedure Q_CharSetXOR(var DestSet: TCharSet; const SourceSet: TCharSet);

{ Q_IsSubset проверяет, является ли множество LeftSet подмножеством в RightSet.
  Эта функция возвращает True, если все символы, присутствующие в множестве
  LeftSet, содержатся также и во множестве RightSet. Если это не выполняется,
  функция возвращает False. }

function Q_IsSubset(const LeftSet, RightSet: TCharSet): boolean;

{ Q_IsSuperset проверяет, является ли множество LeftSet надмножеством для
  RightSet. Эта функция возвращает True, если множество LeftSet содержит по
  крайней мере все символы из множества RightSet. Если это не выполняется,
  функция возвращает False. }

function Q_IsSuperset(const LeftSet, RightSet: TCharSet): boolean;

{ Q_IsEqualSet проверяет равенство множеств LeftSet и RightSet. Функция
  возвращает True, если каждый символ из множества LeftSet присутствует в
  множестве RightSet и наоборот. Иначе, функция возвращает False.  }

function Q_IsEqualSet(const LeftSet, RightSet: TCharSet): boolean;

{ Q_IsEmptySet возвращает True, если CharSet равно пустому множеству (т.е. это
  множество не содержит ни одного символа), иначе функция возвращает False. }

function Q_IsEmptySet(const CharSet: TCharSet): boolean;

{ Q_CharSetCharCount возвращает количество символов в множестве CharSet. }

function Q_CharSetCharCount(const CharSet: TCharSet): integer;


{ Функции для работы с символьной записью чисел. }

{ Большое количество функций для преобразования числа в строку и наоборот,
  для работы с датой и временем находится в модуле SysUtils. Здесь представлены
  некоторые функции, которые являются критичными по времени выполнения или
  отсутствуют в стандартных библиотеках. }

{ Q_IsInteger возвращает True, если строка S содержит символьную запись целого
  десятичного числа, которое может быть сохранено в переменной типа Integer,
  иначе функция возвращает False. }

function Q_IsInteger(const S: String): boolean;

{ Q_IsCardinal возвращает True, если строка S содержит символьную запись
  беззнакового целого десятичного или шестнадцатеричного числа, которое может
  быть сохранено в переменной типа Cardinal, иначе функция возвращает False. }

function Q_IsCardinal(const S: String): boolean;

{ Q_IsDecimal возвращает True, если строка S содержит только символы,
  соответствующие десятичным цифрам, иначе возвращает False. }

function Q_IsDecimal(const S: String): boolean;

{ Q_IsHexadecimal возвращает True, если строка S содержит только символы,
  соответствующие шестнадцатеричным цифрам, иначе возвращает False. }

function Q_IsHexadecimal(const S: String): boolean;

{ Q_IsOctal возвращает True, если строка S содержит только символы,
  соответствующие восьмеричным цифрам, иначе возвращает False. }

function Q_IsOctal(const S: String): boolean;

{ Q_IsBinary возвращает True, если строка S содержит только символы,
  соответствующие двоичным цифрам, иначе возвращает False. }

function Q_IsBinary(const S: String): boolean;

{ Q_IsFloat проверяет, содержит ли строка S символьную запись вещественного
  числа, которая включает мантиссу и, возможно, порядок (они могут быть как
  положительными, так и отрицательными). Для разделения целой и дробной части
  используется символ из стандартной переменной DecimalSeparator. Если строка
  S может быть преобразована к вещественному типу, функция возвращает True,
  иначе возращается False. }

function Q_IsFloat(const S: String): boolean;

{ Q_AdjustSeparator заменяет первую точку в строке S на запятую, если символ
  DecimalSeparator равен запятой, либо заменяет первую запятую в строке S на
  точку, если DecimalSeparator равен точке. После применения этой функции к
  строке она может быть преобразована в число с дробной частью независимо от
  того, каким символом дробная часть отделяется (точкой или запятой). Однако,
  нужно помнить, что процедура Val не обращает внимания на DecimalSeparator и
  всегда ожидает, что дробная часть отделяется точкой. }

function Q_AdjustSeparator(const S: String): String;

{ Функции Q_BetweenXXX возвращают True, если строка S содержит число (целое,
  целое без знака, 64-битное целое, вещественное или число, обозначающее
  денежную сумму), находящееся в диапазоне [LowBound, HighBound]. Иначе,
  функции возвращают False. При работе с Q_BetweenFloat и Q_BetweenCurr
  необходимо учитывать, что целая часть числа должна отделяться от дробной
  части символом, назначенным переменной DecimalSeparator (из SysUtils). }

function Q_BetweenInt(const S: String; LowBound, HighBound: integer): boolean;
function Q_BetweenUInt(const S: String; LowBound, HighBound: longword): boolean;
function Q_BetweenInt64(const S: String; LowBound, HighBound: int64): boolean;
function Q_BetweenFloat(const S: String; LowBound, HighBound: double): boolean;
function Q_BetweenCurr(const S: String; LowBound, HighBound: currency): boolean;

{ Функции Q_StrToXXX преобразуют число, символьная запись которого содержится
  в строке S, в нормальную числовую форму. Переменная, в которой сохраняется
  результат, передается параметром V. Если преобразование строки S в число V
  прошло успешно, функции возвращают True. Если в ходе преобразования возникла
  ошибка, возвращается False. Исключительная ситуация при этом не возникает. }

function Q_StrToInt(const S: String; var V: integer): boolean;
function Q_StrToUInt(const S: String; var V: longword): boolean;
function Q_StrToInt64(const S: String; var V: int64): boolean;
function Q_StrToFloat(const S: String; var V: double): boolean;
function Q_StrToCurr(const S: String; var V: currency): boolean;

{ Q_IntToStr возвращает десятичную запись числа N в виде строки. }

function Q_IntToStr(N: integer): String;

{ Q_IntToStrBuf сохраняет десятичную запись числа N в строке S. Память под
  строку S должна быть выделена заранее вызовом функции SetString (или
  SetLength) размером, достаточным для хранения максимально возможного числа N
  с учетом знака. Q_IntToStrBuf работает быстрее, чем Q_IntToStr. }

procedure Q_IntToStrBuf(N: integer; var S: String);

{ Q_UIntToStr возвращает десятичную запись беззнакового числа N в виде строки. }

function Q_UIntToStr(N: longword): String;

{ Q_UIntToStrBuf сохраняет десятичную запись беззнакового числа N в строке S.
  Память под строку S должна быть выделена заранее вызовом функции SetString
  (или SetLength) размером, достаточным для хранения максимально возможного
  числа N. Q_UIntToStrBuf работает быстрее, чем Q_UIntToStr. }

procedure Q_UIntToStrBuf(N: longword; var S: String);

{ Q_UIntToStrL возвращает десятичную запись беззнакового числа N в виде строки.
  Параметр Digits задает количество символов в возвращаемом числе. Если надо,
  оно обрезается слева или дополняется нулями слева до длины Digits. }

function Q_UIntToStrL(N: longword; Digits: cardinal): String;

{ Q_UIntToStrLBuf сохраняет десятичную запись беззнакового числа N в строке S.
  Параметр Digits задает количество символов в возвращаемом числе. Если надо,
  строка S обрезается слева или дополняется нулями слева до длины Digits.
  Память под строку S должна быть выделена заранее вызовом функции SetString
  размером не менее Digits символов. Q_UIntToStrLBuf работает быстрее, чем
  Q_UIntToStrL. }

procedure Q_UIntToStrLBuf(N: longword; Digits: cardinal; var S: String);

{ Q_IntToRoman возвращает строку, содержащую число N, записанное римскими
  цифрами. Возможный диапазон чисел: от 1 до 5000. Если число N не лежит в
  указанном диапазоне, возвращается строка '?????'. }

function Q_IntToRoman(N: integer): String;

{ Q_RomanToInt преобразует римское число (беззнаковое), передаваемое строкой S,
  в обыкновенное целое число. Если в ходе преобразования возникает ошибка,
  возбуждается исключительная ситуация EConvertError. }

function Q_RomanToInt(const S: String): integer;

{ Q_UIntToHex возвращает шестнадцатеричную запись беззнакового числа N в виде
  строки. Параметр Digits задает количество цифр в возвращаемом числе. Если
  надо, оно обрезается слева или дополняется нулями слева до длины Digits. }

function Q_UIntToHex(N: longword; Digits: cardinal): String;

{ Q_UIntToHexBuf сохраняет шестнадцатеричную запись беззнакового числа N в
  строке S. Параметр Digits задает количество цифр в возвращаемом числе. Если
  надо, строка S обрезается слева или дополняется нулями слева до длины Digits.
  Память под строку S должна быть выделена заранее вызовом функции SetString
  размером не менее Digits символов. Q_UIntToHexBuf работает быстрее, чем
  Q_UIntToHex. }

procedure Q_UIntToHexBuf(N: longword; Digits: cardinal; var S: String);

{ Q_HexToUInt преобразует шестнадцатеричное число, переданное строкой S,
  в целое беззнаковое число. Если во время преобразования возникает ошибка,
  возбуждается исключительная ситуация EConvertError. }

function Q_HexToUInt(const S: String): longword;

{ Q_UIntToOct возвращает восьмеричную запись беззнакового числа N в виде
  строки. Параметр Digits задает количество цифр в возвращаемом числе. Если
  надо, оно обрезается слева или дополняется нулями слева до длины Digits. }

function Q_UIntToOct(N: longword; Digits: cardinal): String;

{ Q_UIntToOctBuf сохраняет восьмеричную запись беззнакового числа N в строке S.
  Параметр Digits задает количество цифр в возвращаемом числе. Если необходимо,
  строка S обрезается слева или дополняется нулями слева до длины Digits.
  Память под строку S должна быть выделена заранее вызовом функции SetString
  размером не менее Digits символов. Q_UIntToOctBuf работает быстрее, чем
  Q_UIntToOct. }

procedure Q_UIntToOctBuf(N: longword; Digits: cardinal; var S: String);

{ Q_OctToUInt преобразует восьмеричное число, переданное строкой S,
  в целое беззнаковое число. Если во время преобразования возникает ошибка,
  возбуждается исключительная ситуация EConvertError. }

function Q_OctToUInt(const S: String): longword;

{ Q_UIntToBin возвращает двоичную запись беззнакового числа N в виде строки.
  Параметр Digits задает количество цифр в возвращаемом числе. Если надо, оно
  обрезается слева или дополняется нулями слева до длины Digits. }

function Q_UIntToBin(N: longword; Digits: cardinal): String;

{ Q_UIntToBinBuf сохраняет двоичную запись беззнакового числа N в строке S.
  Параметр Digits задает количество цифр в возвращаемом числе. Если надо,
  строка S обрезается слева или дополняется нулями слева до длины Digits.
  Память под строку S должна быть выделена заранее вызовом функции SetString
  размером не менее Digits символов. Q_UIntToBinBuf работает быстрее, чем
  Q_UIntToBin. }

procedure Q_UIntToBinBuf(N: longword; Digits: cardinal; var S: String);

{ Q_BinToUInt преобразует двоичное число, переданное строкой S, в целое
  беззнаковое число. Если во время преобразования возникает ошибка,
  возбуждается исключительная ситуация EConvertError. }

function Q_BinToUInt(const S: String): longword;

{ Q_ChangeBase переводит беззнаковое число из системы счисления по основанию
  BaseFrom, в систему счисления по основанию BaseTo. Символьная запись числа
  передается строкой Number. Функция возвращает число (строкой), записанное
  по новому основанию. Параметры BaseFrom и BaseTo должны быть в диапазоне от
  2 до 36. Цифры больше девяти обозначаются латинскими буквами от A до Z (или
  от a до z). Количество знаков в числе не ограничено. Если в нем присутствуют
  недопустимые символы, возбуждается исключительная ситуация EConvertError.
  Если параметр DigitsInGroup отличен от нуля, цифры в выходной строке будут
  объединяться в группы по DigitsInGroup цифр. Между собой группы разделяются
  символом GroupSeparator. Этот же символ может использоваться в исходном
  числе Number для разделения групп цифр. }

function Q_ChangeBase(const Number: String; BaseFrom, BaseTo: cardinal; DigitsInGroup: cardinal = 0;
  GroupSeparator: ansichar = ' '): String;

{ Q_StrToCodes возвращает строку, состоящую из шестнадцатеричных кодов,
  символов строки S. Например, Q_StrToCodes('XYZ#$*~') -> '58595A23242A7E'.
  Исходная строка при этом не изменяется. }

function Q_StrToCodes(const S: String): String;

{ Q_CodesToStr преобразует строку S, состоящую из шестнадцатеричных кодов
  символов, в строку символов. Например, Q_StrToCodes('413F3C2A') -> 'A?<*'.
  Исходная строка при этом не изменяется. Если во время преобразования
  возникает ошибка, возбуждается исключительная ситуация EConvertError. }

function Q_CodesToStr(const S: String): String;

{ Q_NumToStr сохраняет в строке S число, переданное параметром N, записанное
  словами (по-русски). Параметр FmtFlags задает способ преобразования числа
  в строку. Функция Q_NumToStr возвращает номер формы, в которой должно стоять
  следующее за данным числом слово (см. комментарии к константам rfmXXXX).
  Строка S всегда заканчивается пробелом. Если хотите убрать его, вызовите
  потом Q_ShiftRight(S,1). }

const
  { Константы для параметра FmtFlags (их можно объединять с помощью "or"): }

  nsMale = 1;    {  Мужской род  }
  nsFemale = 2;    {  Женский род  }
  nsMiddle = 3;    {  Средний род  }

  nsFull = 0;    {  Полное название триад:  тысяча, миллион, ... }
  nsShort = 4;    {  Краткое название триад:  тыс., млн., ... }

  { Возвращаемые значения функции Q_NumToStr: }

  rfmFirst = 1;    {  Первая форма: "один слон" или "двадцать одна кошка"  }
  rfmSecond = 2;    {  Вторая форма: "три слона" или "четыре кошки"  }
  rfmThird = 3;    {  Третья форма: "шесть слонов" или "восемь кошек"  }

function Q_NumToStr(N: int64; var S: String; FmtFlags: longword = nsMale): integer;

{ Q_NumToRub возвращает денежную сумму прописью. Параметр V должен содержать
  численное значение денежной суммы в рублях. Сотые доли выражают копейки.
  Параметры RubFormat и CopFormat определяют формат записи соответственно
  рублей и копеек. Если CopFormat = nrNone, то сумма округляется до рублей и
  копейки не выводятся. Если RubFormat = nrNone, то рубли не выводятся, а к
  копейкам прибавляется число рублей, умноженное на 100. Если оба параметра
  равны nrNone, просто возвращается строка, содержащая число V. Константа
  nrShTriad комбинируется с другими константами с помощью побитовой операции
  "or". Возвращаемая строка начинается с большой буквы. Если денежная сумма
  отрицательная, строка заключается в круглые скобки. Эта функция написана
  после ознакомления с процедурой num_to_rub (N2R.pas) Николая Глушнева. }

const
  nrNumShort = 1; {  Краткий числовой формат: "475084 руб." или "15 коп."  }
  nrShort = 3; {  Краткий строчный формат: "Пять руб." или "десять коп."  }
  nrNumFull = 0; {  Полный числовой формат: "342 рубля" или "25 копеек"  }
  nrFull = 2; {  Полный строчный формат: "Один рубль" или "две копейки"  }
  nrShTriad = 4; {  Краткая запись названий триад: тыс., млн., ...  }
  nrNone = 8; {  Нет рублей, нет копеек или простая числовая запись  }

function Q_NumToRub(V: currency; RubFormat: longword = nrFull; CopFormat: longword = nrNumShort): String;


{ Функции для работы с датами. }

{ Q_GetDateStr возвращает строку, представляющую дату Date по-русски. Например,
  Q_GetDateStr(Now) может вернуть: '9 февраля 2000 г.'. }

function Q_GetDateStr(Date: TDateTime): String;

{ Q_GetMonthStr возвращает строку, представляющую месяц и год, соответствующие
  дате Date, записанную по-русски. Например, Q_GetMonthStr(Now) может вернуть:
  'Февраль 2000 г.'. }

function Q_GetMonthStr(Date: TDateTime): String;


{ Функции для работы с бинарными строками. }

{ Q_ZeroMem обнуляет область памяти, указываемую параметром P. Число байт
  задается параметром L. }

procedure Q_ZeroMem(P: Pointer; L: cardinal);

{ Q_OnesMem заполняет область памяти, адресуемую параметром P, единицами во
  всех битах (байтом $FF). Число байт задается параметром L. }

procedure Q_OnesMem(P: Pointer; L: cardinal);

{ Q_FillChar заполняет L смежных байт, адресуемых параметром P, значением C.
  Эта процедура работает быстрее стандартной FillChar. }

procedure Q_FillChar(P: Pointer; L: cardinal; Ch: ansichar); overload;
procedure Q_FillChar(P: Pointer; L: cardinal; Ch: byte); overload;

{ Q_FillLong заполняет массив элементов типа LongWord (или любого другого
  4-х-байтного типа), указываемый параметром P, значением Value. Количество
  элементов массива (не байтов !!!) передается параметром Count. }

procedure Q_FillLong(Value: longword; P: Pointer; Count: cardinal);

{ Q_TinyFill быстро заполняет до 32 байт памяти (включительно), адресуемых
  параметром P, значением, которое передается параметром Value (используются
  все 4 байта Value). В параметре L задается число байт, которое необходимо
  заполнить. Недопустимо вызывать Q_TinyFill с L больше 32. }

procedure Q_TinyFill(P: Pointer; L: cardinal; Value: longword);

{ Q_FillRandom заполняет байтовый массив, адресуемый P, длиной L байт выходной
  последовательностью стандартного генератора псевдослучайных чисел. Начальное
  значение генератора передается параметром Seed. Необходимо иметь в виду, что
  эта последовательность не является криптографически стойкой и недопустимо
  использовать ее для создания ключей шифрования. }

procedure Q_FillRandom(P: Pointer; L: cardinal; Seed: longword);

{ Q_CopyMem копирует L байт из области памяти, указываемой параметром
  Source, в область памяти, указываемую параметром Dest. Области памяти
  не должны перекрываться. Q_CopyMem работает значительно быстрее, чем
  стандартная процедура Move и, даже, быстрее, чем Q_MoveMem. }

procedure Q_CopyMem(Source, Dest: Pointer; L: cardinal);

{ Q_CopyLongs копирует Count элементов массива типа LongWord (или какого-либо
  другого 4-х-байтного типа, например, Integer или Pointer) из области памяти,
  указываемой параметром Source, в область памяти, адресуемую параметром Dest.
  Области памяти не должны перекрываться. }

procedure Q_CopyLongs(Source, Dest: Pointer; Count: cardinal);

{ Q_TinyCopy быстро копирует до 32 байт (включительно) из области памяти,
  указываемой параметром Source в область памяти, указываемую параметром Dest.
  Число байт для копирования задается параметром L. Перекрытие областей памяти
  не допускается. Вызов с L > 32 приводит к интересным ошибкам. }

procedure Q_TinyCopy(Source, Dest: Pointer; L: cardinal);

{ Q_MoveMem копирует L байт из Source в Dest. Она работает даже в случае,
  когда блоки памяти, адресуемые параметрами Source и Dest, перекрываются.
  Если блоки памяти смещены друг относительно друга менее, чем на 4 байта,
  лучше воспользоваться процедурами Q_MoveBytes или Q_MoveWords. Если заранее
  известно, что блоки памяти не перекрываются, лучше использовать Q_CopyMem.
  Q_MoveMem работает быстрее, чем стандартная процедура Move. }

procedure Q_MoveMem(Source, Dest: Pointer; L: cardinal);

{ Q_MoveLongs копирует Count элементов массива типа LongWord (или другого
  4-х-байтного типа) из области памяти, указываемой параметром Source, в
  область памяти, указываемую параметром Dest. Эта процедура работает даже
  в случае, когда области памяти перекрываются. }

procedure Q_MoveLongs(Source, Dest: Pointer; Count: cardinal);

{ Q_MoveWords копирует Count элементов массива типа Word или Smallint (2-х-
  байтных) из области памяти, указываемой параметром Source, в область памяти,
  указываемую параметром Dest. Области памяти могут перекрываться. }

procedure Q_MoveWords(Source, Dest: Pointer; Count: cardinal);

{ Q_MoveBytes копирует L байт из области памяти, указываемой параметром
  Source в область памяти, указываемую параметром Dest. Эту процедуру
  рекомендуется использовать, если смещение одной области памяти относительно
  другой меньше 4 (особенно, когда оно равно 1). }

procedure Q_MoveBytes(Source, Dest: Pointer; L: cardinal);

{ Q_SwapMem обменивает содержимое двух байтовых массивов, адресуемых P1 и P2,
  длиной L байт. Перед использованием этой процедуры рассмотрите возможность
  обмена значений самих указателей процедурой Q_Exchange. }

procedure Q_SwapMem(P1, P2: Pointer; L: cardinal);

{ Q_SwapLongs обменивает содержимое массивов 4-байтных элементов, адресуемых
  P1 и P2, длиной Count двойных слов. Перед использованием этой процедуры
  подумайте о возможности обмена значений указателей с помощью Q_Exchange. }

procedure Q_SwapLongs(P1, P2: Pointer; Count: cardinal);

{ Q_CompareMem выполняет побайтное сравнение блоков памяти, адресуемых P1 и P2.
  Размер блоков памяти (в байтах) задается параметром L. Функция возвращает
  True, если содержимое блоков памяти полностью идентично. Эта функция работает
  быстрее стандартной CompareMem. }

function Q_CompareMem(P1, P2: Pointer; L: cardinal): boolean;

{ Q_CompLongs выполняет побайтное сравнение массивов четырехбайтный элементов
  (например, типа Integer), адресуемых P1 и P2. Количество элементов в массивах
  задается параметром Count. Функция возвращает True, если все соответствующие
  элементы обоих массивов равны, в противном случае возвращается False. }

function Q_CompLongs(P1, P2: Pointer; Count: cardinal): boolean;

{ Q_CompMemS выполняет побайтное сравнение блоков памяти, адресуемых P1 и P2,
  по принципу больше-меньше. Размер обоих блоков памяти (в байтах) задается
  параметром L. Функция возвращает число меньше нуля, если содержимое первого
  блока меньше второго (больший вес имеют байты с меньшим адресом), возвращает
  число больше нуля, если содержимое первого блока больше второго и 0, если
  содержимое обоих блоков памяти полностью идентично. }

function Q_CompMemS(P1, P2: Pointer; L: cardinal): integer;

{ Q_ScanInteger находит число, переданное параметром N в массиве чисел типа
  Integer, указываемом параметром ArrPtr. Индекс найденного элемента массива
  возвращается как результат функции (элементы нумеруются с нуля). Если число
  N в массиве не найдено, возвращается -1. В параметре Count передается
  количество элементов в массиве. Функции Q_ScanLongWord и Q_ScanPointer
  полностью аналогичны Q_ScanInteger. }

function Q_ScanInteger(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanLongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanPointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): integer;

{ Q_ScanWord находит число, переданное параметром N в массиве чисел типа
  Word, указываемом параметром ArrPtr. Индекс найденного элемента массива
  возвращается как результат функции (элементы нумеруются с нуля). Если число
  N в массиве не найдено, возвращается -1. В параметре Count передается
  количество элементов в массиве. }

function Q_ScanWord(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Q_ScanByte находит число, переданное параметром N в байтовом массиве,
  указываемом параметром ArrPtr. Индекс найденного элемента массива
  возвращается как результат функции (индекс первого байта равен нулю). Если
  число N в массиве не найдено, возвращается -1. В параметре L передается
  размер массива в байтах. }

function Q_ScanByte(N: integer; ArrPtr: Pointer; L: cardinal): integer;

{ Функции Q_ScanGE_XXX сканируют массив, адресуемый ArrPtr, состоящий из
  Count элементов соответствующего типа, в поисках значения, большего или
  равного числу N. Если такое значение найдено, функция возвращает индекс
  соответствующего элемента (индексация с нуля). Если элемент, больший или
  равный N, в массиве отсутствует, функция возвращает -1. }

function Q_ScanGE_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanGE_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanGE_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Функции Q_ScanLesser_XXX сканируют массив, адресуемый ArrPtr, состоящий из
  Count элементов соответствующего типа, в поисках значения, меньшего N. Если
  такое значение найдено, функция возвращает индекс соответствующего элемента
  (индексация с нуля). Если элемент, меньший N, в массиве отсутствует,
  функция возвращает -1. }

function Q_ScanLesser_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanLesser_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_ScanLesser_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Q_CountInteger подсчитывает количество вхождений числа N в массив чисел
  типа Integer, указываемый параметром ArrPtr. В параметре Count передается
  количество элементов в массиве. Функции Q_CountLongWord и Q_CountPointer
  полностью аналогичны Q_CountInteger и введены только для удобства. }

function Q_CountInteger(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_CountLongWord(N: longword; ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_CountPointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): cardinal;

{ Q_CountWord подсчитывает количество вхождений числа N в массив чисел
  типа Word, указываемый параметром ArrPtr. В параметре Count передается
  количество элементов в массиве. }

function Q_CountWord(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;

{ Q_CountByte подсчитывает количество вхождений числа N в байтовый массив,
  указываемый параметром ArrPtr. Параметр L задает размер массива в байтах. }

function Q_CountByte(N: integer; ArrPtr: Pointer; L: cardinal): cardinal;

{ Q_ReverseLongArr переворачивает массив элементов типа LongWord так, что
  первый элемент становится последним, второй - предпоследним и т.д. P - адрес
  массива, Count - количество элементов в массиве. }

procedure Q_ReverseLongArr(P: Pointer; Count: cardinal);

{ Q_ReverseWordArr переворачивает массив элементов типа Word так, что первый
  элемент становится последним, второй - предпоследним и т.д. P - адрес массива,
  Count - количество элементов в массиве. }

procedure Q_ReverseWordArr(P: Pointer; Count: cardinal);

{ Q_ReverseByteArr переворачивает байтовый массив так, что первый элемент
  становится последним, второй - предпоследним и т.д. P - адрес массива,
  L - размер массива в байтах. }

procedure Q_ReverseByteArr(P: Pointer; L: cardinal);

{ Q_BSwap изменяет порядок следования байтов в двойном слове D (первый байт
  становится последним, второй - третьим и наоборот). }

function Q_BSwap(D: longword): longword;

{ Q_BSwapLongs изменяет порядок следования байтов в каждом двойном слове
  массива 4-х-байтных элементов, адрес которого передается параметром P. Count
  задает количество элементов в массиве. }

procedure Q_BSwapLongs(P: Pointer; Count: cardinal);

{ Q_Exchange обменивает значения двух переменных. Тип переменных может быть
  одним из следующих: String, Pointer, PAnsiChar, Integer, Cardinal, Longint,
  LongWord, Single. }

procedure Q_Exchange(var A, B);

{ Q_ExchangeWords обменивает значения переменных любого 2-x-байтного типа.
  Этот тип может быть одним из следующих: Word, SmallInt, WideChar. }

procedure Q_ExchangeWords(var A, B);

{ Q_ExchangeBytes обменивает значения двух переменных размером в один байт.
  Этот тип может быть одним из следующих: Byte, ShortInt, AnsiChar. }

procedure Q_ExchangeBytes(var A, B);

{ Функции Q_RemValue_XXX удаляют из массива элементов соответствующего типа
  все элементы, значения которых равны N (или P для массива указателей).
  ArrPtr - адрес массива, Count (или L для массива байтов) - исходное число
  элементов в массиве. Функции возвращают новое число элементов, которое
  осталось в массиве после удаления указанного значения. }

function Q_RemValue_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_RemValue_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_RemValue_Pointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): cardinal;

function Q_RemValue_Word(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;

function Q_RemValue_Byte(N: integer; ArrPtr: Pointer; L: cardinal): cardinal;

{ Функции Q_RemDuplicates_XXX удаляют из массива 4-байтных, 2-байтных или
  1-байтных элементов, соответственно, все следующие один за другим (подряд)
  повторяющиеся элементы, т.е., если в массиве имеется несколько рядом стоящих
  элементов, имеющих одно и то же значение, то из них останется только один
  элемент с таким значением, а все остальные удалятся. Если исходный массив
  отсортированный, то после применения функции Q_RemDuplicates_XXX, все
  значения в нем будут уникальными. Если два массива, содержащие уникальные
  значения объединить в один массив, потом отсортировать его и применить к
  нему данную функцию, то тогда в полученном массиве будут все элементы (по
  одному), которые есть хотя бы в одном из исходных массивов (операция "ИЛИ").
  ArrPtr - адрес массива, Count (или L для массива байтов) - исходное число
  элементов. Функции возвращают новое число элементов в массиве, которое
  осталось после удаления повторений. }

function Q_RemDuplicates_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_RemDuplicates_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_RemDuplicates_Byte(ArrPtr: Pointer; L: cardinal): cardinal;

{ Функции Q_ANDSetInPlace_XXX удаляют из массива 4-байтных или 2-байтных
  элементов, соответственно, все элементы, которые присутствуют в массиве
  в единственном экземпляре (т.е. элемент будет удален, если сразу после
  него не стоит элемент с тем же значением). Все повторяющиеся подряд
  элементы заменяются одним единственным элементов с таким значением (т.е.,
  если в массиве имеется несколько рядом стоящих элементов, имеющих одно и
  то же значение, то из них останется только один элемент с таким значением,
  а все остальные удалятся). Если два массива, содержащие уникальные значения
  объединить в один массив, потом отсортировать его и применить к нему данную
  функцию, то в результате останутся только значения, которые присутствуют в
  обоих исходных массивах (операция "И"). ArrPtr - адрес массива, Count -
  исходное число элементов. Функции возвращают новое число элементов, которое
  осталось в массиве после удаления повторений и одиночных значений. }

function Q_ANDSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_ANDSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;

{ Функции Q_XORSetInPlace_XXX удаляют из массива 4-байтных или 2-байтных
  элементов, соответственно, все элементы, которые присутствуют в массиве
  в нескольких экземплярах (один за другим, подряд). В массиве остаются только
  элементы, не имеющие "двойников". Если два массива, содержащие уникальные
  значения объединить в один массив, потом отсортировать его и применить к
  нему данную функцию, то в этом массиве останутся только значения, которые
  присутствуют в одном из исходных массивов, но не в обоих сразу (операция
  "исключающее ИЛИ"). ArrPtr - адрес массива, Count - исходное число
  элементов. Функции возвращают новое число элементов, которое осталось
  в массиве после удаления всех неодиночных значений. }

function Q_XORSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
function Q_XORSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;

{ Процедуры Q_Sort_XXX сортируют массив 4-байтных или 2-байтных элементов
  соответствующего типа в порядке возрастания (используется алгоритм быстрой
  сортировки). ArrPtr - адрес массива, Count - число элементов в массиве.
  Значение адреса массива ArrPtr должно быть кратным размеру элемента массива.
  Для сортировки по убыванию отсортируйте массив с помощью одной из следующих
  процедур, а затем переверните его с помощью Q_ReverseLong(Word)Arr. }

procedure Q_Sort_Integer(ArrPtr: Pointer; Count: cardinal);
procedure Q_Sort_LongWord(ArrPtr: Pointer; Count: cardinal);
procedure Q_Sort_Word(ArrPtr: Pointer; Count: cardinal);

{ Функции Q_SearchUnique_XXX выполняют бинарный поиск в массиве 4-байтных или
  2-байтных элементов значения соответствующего типа. Массив предварительно
  должен быть отсортирован по возрастанию. Функция возвращает индекс (начиная
  с нуля) найденного значения N в массиве, адрес которого передается ArrPtr,
  состоящем из Count элементов. Если значение N в массиве не найдено, функция
  возвращает -1. Если массив содержит повторяющиеся элементы, то найденный
  элемент не обязательно будет первым среди имеющих такое значение. }

function Q_SearchUnique_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchUnique_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchUnique_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Функции Q_SearchFirst_XXX выполняют бинарный поиск в массиве 4-байтных или
  2-байтных элементов значения соответствующего типа. Массив предварительно
  должен быть отсортирован по возрастанию. Функция возвращает самый первый
  индекс (начиная с нуля) найденного значения N в массиве, адрес которого
  передается ArrPtr, состоящем из Count элементов. Если значение N в массиве
  не найдено, функция возвращает -1. Если в массиве есть повторяющиеся элементы,
  то найденный индекс всегда будет минимальным для данного значения. }

function Q_SearchFirst_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchFirst_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchFirst_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Функции Q_SearchFirstGE_XXX выполняют бинарный поиск в массиве 4-байтных или
  2-байтных элементов значения соответствующего типа, большего или равного N.
  Массив предварительно должен быть отсортирован по возрастанию. Функция
  возвращает индекс (начиная с нуля) первого элемента, значение которого больше
  или равно N, в массиве, адрес которого передается ArrPtr, состоящем из Count
  элементов. Если значение, большее или равное N, в массиве не найдено,
  функция возвращает -1. }

function Q_SearchFirstGE_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchFirstGE_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
function Q_SearchFirstGE_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;

{ Функции Q_ANDSet_XXX формируют из двух массивов 4-байтных или 2-байтных
  элементов соответствующего типа новый массив, состоящий только из тех
  элементов, которые присутствуют в обоих исходных массивах. P1 - адрес первого
  массива, Count1 - число элементов в первом массиве, P2 - адрес второго
  массива, Count2 - число элементов во втором массиве, OutPlace - адрес области
  памяти, в которой будет сохранен массив-результат. Функции возвращают
  количество элементов в выходном массиве. Если OutPlace равно nil, функции
  не заполняют выходной массив, а только вычисляют количество элементов в нем;
  иначе, OutPlace должен указывать на область памяти, достаточную для хранения
  массива-результата (максимальный размер равен размеру меньшего из исходных
  массивов). Элементы массивов P1 и P2 должны быть отсортированы в порядке
  возрастания. }

function Q_ANDSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ANDSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ANDSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;

{ Функции Q_ORSet_XXX формируют из двух массивов 4-байтных или 2-байтных
  элементов соответствующего типа новый массив, состоящий из элементов,
  которые присутствуют хотя бы в одном из исходных массивов. P1 - адрес
  первого массива, Count1 - число элементов в первом массиве, P2 - адрес
  второго массива, Count2 - число элементов во втором массиве, OutPlace -
  адрес области памяти, в которой будет сохранен массив-результат. Функции
  возвращают количество элементов в выходном массиве. Если OutPlace равно
  nil, функции не заполняют выходной массив, а только вычисляют количество
  элементов в нем; иначе, OutPlace должен указывать на область памяти,
  достаточную для хранения массива-результата (максимальный размер равен
  суммарному размеру первого и второго массивов). Элементы массивов
  P1 и P2 должны быть отсортированы в порядке возрастания. }

function Q_ORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;

{ Функции Q_XORSet_XXX формируют из двух массивов 4-байтных или 2-байтных
  элементов соответствующего типа новый массив, состоящий из элементов,
  которые присутствуют в одном из исходных массивов, но отсутствуют в другом.
  P1 - адрес первого массива, Count1 - число элементов в первом массиве,
  P2 - адрес второго массива, Count2 - число элементов во втором массиве,
  OutPlace - адрес области памяти, в которой будет сохранен массив-результат.
  Функции возвращают количество элементов в выходном массиве. Если OutPlace
  равно nil, функции не заполняют выходной массив, а только вычисляют
  количество элементов в нем; иначе, OutPlace должен указывать на область
  памяти, достаточную для хранения массива-результата (максимальный размер
  равен суммарному размеру первого и второго массивов). Элементы массивов
  P1 и P2 должны быть отсортированы по возрастанию. }

function Q_XORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_XORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_XORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;

{ Функции Q_ANDNOTSet_XXX формируют из двух массивов 4-байтных или 2-байтных
  элементов соответствующего типа новый массив, состоящий только из тех
  элементов, которые присутствуют в первом исходном массиве, но отсутствуют
  во втором. P1 - адрес первого массива, Count1 - число элементов в первом
  массиве, P2 - адрес второго массива, Count2 - число элементов во втором
  массиве, OutPlace - адрес области памяти, в которой будет сохранен массив-
  результат. Функции возвращают количество элементов в выходном массиве. Если
  OutPlace равно nil, функции не заполняют выходной массив, а только вычисляют
  количество элементов в нем; иначе, OutPlace должен указывать на область
  памяти, достаточную для хранения массива-результата (максимальный размер
  равен размеру первого исходного массива). Элементы массивов P1 и P2 должны
  быть отсортированы по возрастанию. }

function Q_ANDNOTSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ANDNOTSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;
function Q_ANDNOTSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer = nil): cardinal;

{ Q_BitTest32 возвращает True, если в двойном слове D бит с номером Index
  установлен (нумерация битов с нуля). Иначе, функция возвращает False. }

function Q_BitTest32(D: longword; Index: cardinal): boolean;

{ Q_BitSet32 устанавливает в двойном слове D бит с индексом Index в единицу. }

function Q_BitSet32(D: longword; Index: cardinal): longword;

{ Q_BitReset32 сбрасывает в двойном слове D бит с индексом Index в ноль. }

function Q_BitReset32(D: longword; Index: cardinal): longword;

{ Q_BitToggle32 инвертирует в двойном слове D бит с индексом Index. }

function Q_BitToggle32(D: longword; Index: cardinal): longword;

{ Q_CountOfSetBits32 возвращает количество установленных (единичных) битов
  в двойном слове D. }

function Q_CountOfSetBits32(D: longword): cardinal;

{ Q_CountOfFreeBits32 возвращает количество сброшенных (нулевых) битов
  в двойном слове D. }

function Q_CountOfFreeBits32(D: longword): cardinal;

{ Q_SetBitScanForward32 сканирует двойное слово D в поисках бита, отличного
  от нуля. Функция возвращает индекс первого установленного бита, начиная с
  бита FirstBit (от 0 до 31). Если бит не найден, функция возвращает -1. }

function Q_SetBitScanForward32(D: longword; FirstBit: integer = 0): integer;

{ Q_FreeBitScanForward32 сканирует двойное слово D в поисках нулевого бита.
  Функция возвращает индекс первого сброшенного бита, начиная с бита FirstBit
  (от 0 до 31). Если нулевой бит не найден, функция возвращает -1. }

function Q_FreeBitScanForward32(D: longword; FirstBit: integer = 0): integer;

{ Q_SetBitScanReverse32 сканирует назад двойное слово D в поисках бита,
  отличного от нуля. Функция возвращает индекс последнего установленного бита,
  начиная с бита LastBit (от 0 до 31). Если единичный бит не найден, функция
  возвращает -1. }

function Q_SetBitScanReverse32(D: longword; LastBit: integer = 31): integer;

{ Q_FreeBitScanReverse32 сканирует назад двойное слово D в поисках нулевого
  бита. Функция возвращает индекс последнего сброшенного бита, начиная с бита
  LastBit (от 0 до 31). Если нулевой бит не найден, функция возвращает -1. }

function Q_FreeBitScanReverse32(D: longword; LastBit: integer = 31): integer;

{ Q_BitTest проверяет бит и возвращает True, если бит установлен и False, если
  он сброшен. Адрес битовой строки передается параметром P. Смещение бита
  относительно начала строки задается параметром Index. Самый первый бит строки
  имеет смещение ноль. Возможно задание отрицательного индекса (смещения). }

function Q_BitTest(P: Pointer; Index: integer): boolean;

{ Q_BitSet устанавливает бит и возвращает True, если до этого бит уже был
  установлен и False, если до этого бит был сброшен. Адрес битовой строки
  передается параметром P. Смещение бита относительно начала строки задается
  параметром Index. Самый первый бит строки имеет смещение ноль. Возможно
  задание отрицательного индекса (смещения). }

function Q_BitSet(P: Pointer; Index: integer): boolean;

{ Q_BitReset сбрасывает бит и возвращает True, если до этого бит был установлен
  и False, если до этого бит был сброшен. Адрес битовой строки передается
  параметром P. Смещение бита относительно начала строки задается параметром
  Index. Нумерация битов начинается с нуля. Возможно задание отрицательного
  индекса (смещения). }

function Q_BitReset(P: Pointer; Index: integer): boolean;

{ Q_BitToggle инвертирует бит и возвращает True, если раньше бит был установлен
  и False, если бит был сброшен. Адрес битовой строки передается параметром P.
  Смещение бита относительно начала строки задается параметром Index. Нумерация
  битов начинается с нуля. Возможно задание отрицательного индекса (смещения). }

function Q_BitToggle(P: Pointer; Index: integer): boolean;

{ Q_SetBits устанавливает каждый бит в массиве, адресуемом параметром P,
  начиная с бита с индексом FirstBit (нумерация от нуля) и кончая битом с
  индексом LastBit. Размер массива и его адрес должны быть кратны 4 байтам. }

procedure Q_SetBits(P: Pointer; FirstBit, LastBit: integer);

{ Q_ResetBits обнуляет (сбрасывает) каждый бит в массиве, адрес которого
  передается параметром P, начиная с бита с индексом FirstBit (нумерация от
  нуля) и кончая битом с индексом LastBit. Размер массива и его адрес должны
  быть кратны 4 байтам. }

procedure Q_ResetBits(P: Pointer; FirstBit, LastBit: integer);

{ Q_ToggleBits инвертирует каждый бит в массиве, адресуемом параметром P,
  начиная с бита с индексом FirstBit (нумерация от нуля) и кончая битом с
  индексом LastBit. Размер массива и его адрес должны быть кратны 4 байтам. }

procedure Q_ToggleBits(P: Pointer; FirstBit, LastBit: integer);

{ Q_CountOfSetBits возвращает число установленных (единичных) битов в байтовом
  массиве, адресуемом параметром P, длиной L байт. }

function Q_CountOfSetBits(P: Pointer; L: cardinal): cardinal;

{ Q_CountOfFreeBits возвращает число сброшенных (нулевых) битов в байтовом
  массиве, адресуемом параметром P, длиной L байт. }

function Q_CountOfFreeBits(P: Pointer; L: cardinal): cardinal;

{ Q_SetBitScanForward сканирует битовый массив, адресуемый P, в поисках бита,
  отличного от нуля. Функция возвращает индекс первого установленного бита,
  начиная с бита с индексом FirstBit (от нуля) и кончая индексом LastBit. Если
  единичный бит в этом диапазоне не найден, функция возвращает -1. Размер
  массива и его адрес должны быть кратны 4 байтам. }

function Q_SetBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;

{ Q_FreeBitScanForward сканирует битовый массив, адресуемый P, в поисках
  нулевого бита. Функция возвращает индекс первого сброшенного бита, начиная
  с бита с индексом FirstBit (нумерация от нуля) и кончая индексом LastBit.
  Если нулевой бит в этом диапазоне не найден, функция возвращает -1. Размер
  массива и его адрес должны быть кратны 4 байтам. }

function Q_FreeBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;

{ Q_SetBitScanReverse сканирует назад битовый массив, адресуемый P, в поисках
  бита, отличного от нуля. Функция возвращает индекс последнего установленного
  бита, начиная с бита с индексом LastBit и кончая индексом FirstBit. Если
  единичный бит в этом диапазоне не найден, функция возвращает -1. Размер
  массива и его адрес должны быть кратны 4 байтам. }

function Q_SetBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;

{ Q_FreeBitScanReverse сканирует назад битовый массив, адресуемый P, в поисках
  нулевого бита. Функция возвращает индекс последнего сброшенного бита, начиная
  с бита с индексом LastBit и кончая индексом FirstBit. Если нулевой бит в
  этом диапазоне не найден, функция возвращает -1. Размер массива и его адрес
  должны быть кратны 4 байтам. }

function Q_FreeBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;

{ Q_NOTByteArr инвертирует каждый бит массива, адресуемого параметром P,
  длиной L байт. }

procedure Q_NOTByteArr(P: Pointer; L: cardinal);

{ Q_XORByData выполняет побитовую операцию "исключающее или" над каждым байтом
  области памяти, адресуемой параметром Source, и соответствующим байтом
  области памяти, адресуемой параметром Dest. Результат сохраняется в Dest.
  Параметр L задает размер областей памяти в байтах. }

procedure Q_XORByData(Dest, Source: Pointer; L: cardinal);

{ Q_ANDLongs выполняет логическое умножение над каждым соответствующим битом
  массивов, адресуемых параметрами Dest и Source, и записывает результат в
  массив Dest ( Dest <- Dest AND Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure Q_ANDLongs(Dest, Source: Pointer; Count: cardinal);

{ Q_ORLongs выполняет логическое сложение над каждым соответствующим битом
  массивов, адресуемых параметрами Dest и Source, и записывает результат в
  массив Dest ( Dest <- Dest OR Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure Q_ORLongs(Dest, Source: Pointer; Count: cardinal);

{ Q_XORLongs выполняет операцию "исключающее или" между соответствующими
  битами массивов, адресуемых параметрами Dest и Source, и записывает результат
  в массив Dest ( Dest <- Dest XOR Source ). В Count передается число двойных
  слов в каждом из массивов. }

procedure Q_XORLongs(Dest, Source: Pointer; Count: cardinal);

{ Q_NOTLongArr инвертирует каждый бит массива, адресуемого параметром P,
  длиной Count двойных слов. }

procedure Q_NOTLongArr(P: Pointer; Count: cardinal);

{ Q_ANDNOTLongs выполняет логическое умножение каждого бита массива,
  адресуемого параметром Dest на соответствующий инвертированный бит массива,
  адресуемого Source, и записывает результат в массив Dest
  ( Dest <- Dest AND NOT Source ). В Count передается число двойных слов
  в каждом из массивов. В результате выполнения этой операции в массиве
  Dest обнуляются все биты, для которых соответствующие биты в массиве Source
  установлены в единицу. }

procedure Q_ANDNOTLongs(Dest, Source: Pointer; Count: cardinal);

{ Q_LShift1Longs сдвигает массив, адресуемый параметром P, длиной Count двойных
  слов на 1 бит влево (умножает его на 2). Младший бит массива обнуляется. }

procedure Q_LShift1Longs(P: Pointer; Count: cardinal);

{ Q_RShift1Longs сдвигает массив, адресуемый параметром P, длиной Count двойных
  слов на 1 бит вправо (делит его на 2). Самый старший бит массива обнуляется. }

procedure Q_RShift1Longs(P: Pointer; Count: cardinal);

{ Q_ReverseBits обращает битовый массив, адресуемый параметром P, так, что
  первые биты становятся последними, а последние - первыми. Длина массива
  (в битах) передается параметром BitCount. Если эта длина не кратна восьми
  битам, то остающиеся до кратности биты заполняются нулями. }

procedure Q_ReverseBits(P: Pointer; BitCount: cardinal);

{ Q_Lrot32 циклически сдвигает двойное слово D на Shift бит влево. }

function Q_Lrot32(D: longword; Shift: byte): longword;

{ Q_Rrot32 циклически сдвигает двойное слово D на Shift бит вправо. }

function Q_Rrot32(D: longword; Shift: byte): longword;

{ Q_Lrot16 циклически сдвигает машинное слово W на Shift бит влево. }

function Q_Lrot16(W: word; Shift: byte): word;

{ Q_Rrot16 циклически сдвигает машинное слово W на Shift бит вправо. }

function Q_Rrot16(W: word; Shift: byte): word;

{ Q_Lrot8 циклически сдвигает байт B на Shift бит влево. }

function Q_Lrot8(B, Shift: byte): byte;

{ Q_Rrot8 циклически сдвигает байт B на Shift бит вправо. }

function Q_Rrot8(B, Shift: byte): byte;

{ Q_RotateLongsLeft циклически сдвигает каждый элемент массива, состоящего из
  Count элементов типа LongWord, адресуемого параметром P, на Shift бит влево. }

procedure Q_RotateLongsLeft(P: Pointer; Count: cardinal; Shift: byte);

{ Q_RotateLongsRight циклически сдвигает каждый элемент массива, состоящего из
  Count элементов типа LongWord, адресуемого параметром P, на Shift бит вправо. }

procedure Q_RotateLongsRight(P: Pointer; Count: cardinal; Shift: byte);

{ Q_RotateWordsLeft циклически сдвигает каждый элемент массива, состоящего из
  Count элементов типа Word, адресуемого параметром P, на Shift бит влево. }

procedure Q_RotateWordsLeft(P: Pointer; Count: cardinal; Shift: byte);

{ Q_RotateWordsRight циклически сдвигает каждый элемент массива, состоящего из
  Count элементов типа Word, адресуемого параметром P, на Shift бит вправо. }

procedure Q_RotateWordsRight(P: Pointer; Count: cardinal; Shift: byte);

{ Q_RotateBytesLeft циклически сдвигает каждый байт в блоке памяти размером L
  байт, адресуемом параметром P, на Shift бит влево. }

procedure Q_RotateBytesLeft(P: Pointer; L: cardinal; Shift: byte);

{ Q_RotateBytesRight циклически сдвигает каждый байт в блоке памяти размером L
  байт, адресуемом параметром P, на Shift бит вправо. }

procedure Q_RotateBytesRight(P: Pointer; L: cardinal; Shift: byte);

{ Q_RotateBitsLeft циклически сдвигает битовую строку длиной L байт, адрес
  которой передается параметром P, на Shift бит влево. Параметр Shift может
  принимать как положительные, так и отрицательные значения. Битовая строка,
  как это принято, записывается, начиная со старших битов. }

procedure Q_RotateBitsLeft(P: Pointer; L: cardinal; Shift: integer);

{ Q_RotateBitsRight циклически сдвигает битовую строку длиной L байт, адрес
  которой передается параметром P, на Shift бит вправо. Параметр Shift может
  принимать как положительные, так и отрицательные значения. Битовая строка
  записывается, начиная со старших битов. }

procedure Q_RotateBitsRight(P: Pointer; L: cardinal; Shift: integer);


{ Криптографические функции. }

{ Прежде, чем использовать какие-либо функции из этого раздела, ознакомьтесь
  с законодательством вашей страны в той части, которая касается использования
  алгоритмов стойкого шифрования !!! Если это не разрешено вашими законами,
  удалите все функции из этого раздела из вашей копии модуля QStrings. }

{ Q_XORByChar выполняет побитовую операцию "исключающее или" над каждым байтом
  области памяти длиной L байт, адресуемой параметром P, и символом (байтом)
  Ch. Повторное применение этой операции с тем же символом Ch восстанавливает
  исходное состояние байтового массива. }

procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: ansichar); overload;
procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: byte); overload;

{ Q_XORByLong аналогична Q_XORByChar, но работает не с байтами, а с двойными
  словами (LongWord). Count задает количество четырехбайтных двойных слов. }

procedure Q_XORByLong(P: Pointer; Count: cardinal; D: longword);

{ Q_XORByWord аналогична Q_XORByChar, но работает не с байтами, а с машинными
  словами (Word). Count задает количество двухбайтных слов. }

procedure Q_XORByWord(P: Pointer; Count: cardinal; W: word);

{ Q_XORByStr выполняет побитовую операцию "исключающее или" над каждым байтом
  области памяти длиной L байт, адресуемой параметром P, и каждым символом
  строки Key. Если размер области памяти превышает длину строки Key, то после
  выборки последнего символа из этой строки она начинает просматриваться с
  начала. Повторное применение этой операции к области памяти с тем же ключом
  восстанавливает исходное состояние области памяти. }

procedure Q_XORByStr(P: Pointer; L: cardinal; const Key: String);

{ Q_XORByRandom выполняет гаммирование (с помощью XOR) байтового массива длиной
  L байт, адресуемого параметром P, датчиком псевдослучайных чисел, аналогичным
  стандартному (Random). Начальное значение псевдослучайной последовательности
  определяется константой Seed. Повторное применение этой операции к той же
  области памяти с тем же Seed восстанавливает исходное состояние данных. }

procedure Q_XORByRandom(P: Pointer; L: cardinal; Seed: longword);

{ Функции Q_RC4XXX реализуют поточный алгоритм шифрования RC4, разработанный
  Роном Ривестом (все права принадлежат RSA Data Security, Inc.), который был
  анонимно опубликован в телеконференции sci.crypt в 1995 году. Алгоритм
  очень быстрый и достаточно надежный. Повторное применение его с тем же
  ключом восстанавливает исходное состояние данных. Не следует использовать
  один и тот же ключ несколько раз. Если вам необходимо быстро зашифровать
  какие-либо данные, сгенерируйте псевдослучайный сеансовый ключ K1 (например,
  с помощью Q_SecureRandFill) размером от 16 до 256 байт, зашифруйте его
  методом CAST6 или RC6 в режиме CBC с некоторым ключом K2 и поместите в
  выходной поток данных, затем с помощью сеансового ключа K1 зашифруйте сами
  данные методом RC4. Ключ K2 для шифрования сеансового ключа может изменяться
  не слишком часто. При чтении данных вы первым делом считываете зашифрованный
  сеансовый ключ и расшифровываете его с помощью известного (вам) ключа K2
  (процедурами Q_CAST6XXX или Q_RC6XXX), получаете сеансовый ключ K1, читаете
  сами данные, расшифровываете их с ключом K1 (методом RC4). }

type
  TRC4ID = type Pointer;

{ Q_RC4Init задает ключевую последовательность для шифрования данных методом
  RC4 и инициализирует процесс шифрования. В качестве ключа принимается
  содержимое байтового массива, адресуемого параметром Key, длиной L байт.
  Длина ключа может быть до 256 символов. В параметре ID возвращается
  идентификатор данного процесса шифрования, который затем передается в
  процедуры Q_RC4Apply и Q_RC4Done. Каждый идентификатор должен в конце
  освобождаться вызовом Q_RC4Done. Начиная с версии QStrings 5.10 метод
  RC4 реализован как полагается (ключ просматривается с первых байтов). }

procedure Q_RC4Init(var ID: TRC4ID; Key: Pointer; KeyLen: cardinal);

{ Q_RC4Apply выполняет фактическое шифрование или дешифрацию данных, адресуемых
  параметром P, длиной L байт ключом, связанным с идентификатором ID. Эта
  процедура может вызываться многократно для последовательного шифрования
  нескольких массивов данных. При этом Q_RC4Init и Q_RC4Done вызываются лишь
  однажды, в начале и в конце всего процесса. }

procedure Q_RC4Apply(ID: TRC4ID; P: Pointer; L: cardinal);

{ Q_RC4Done освобождает внутренние ресурсы, связанные с идентификатором ID.
  После вызова Q_RC4Done этот идентификатор больше не может использоваться
  процедурой Q_RC4Apply. }

procedure Q_RC4Done(ID: TRC4ID);

{ Q_RC4SelfTest проверяет работоспособность алгоритма RC4 по тестовым векторам,
  приведенным в функции RC4SelfTest из модуля RC4.pas (автором этого модуля
  является David Barton (davebarton@bigfoot.com)). Если тест пройден успешно,
  функция возвращает True, иначе False. }

function Q_RC4SelfTest: boolean;

{ Процедуры Q_RC6XXX реализуют блочный алгоритм шифрования RC6(TM). Авторы
  алгоритма: Ronald L. Rivest, M.J.B. Robshaw, R. Sidney и Y.L. Yin (алгоритм
  запатентован). Характерной особенностью этого шифра является его высокая
  стойкость при отличной производительности (один из пяти алгоритмов, прошедших
  во второй раунд AES). Длина ключа - до 255 байт, однако использовать ключи
  длиннее 48 байт не рекомендуется (нормальная длина ключа - 32 байта). Здесь
  реализованы режимы CBC, CFB и OFB. }

type
  TRC6InitVector = array[0..15] of byte;
  TRC6ID = type Pointer;

{ Q_RC6Init инициализирует шифрование методом RC6. Ключ передается параметром
  Key (адрес байтового массива), а длина ключа (в байтах) - параметром KeyLen.
  Идентификатор текущего процесса шифрования возвращается в параметре ID.
  Данный идентификатор передается как первый параметр во все другие процедуры
  Q_RC6XXX, а в конце он должен освобождаться вызовом Q_RC6Done. }

procedure Q_RC6Init(var ID: TRC6ID; Key: Pointer; KeyLen: cardinal);

{ Процедуры шифрования/дешифрации в режиме ECB следует использовать только
  в отладочных целях. Размер блока данных - 128 бит. }

procedure IntRC6EncryptECB(ID: TRC6ID; P: Pointer);
procedure IntRC6DecryptECB(ID: TRC6ID; P: Pointer);

{ Q_RC6SetOrdinaryVector обнуляет начальный вектор, используемый в режимах
  CBC, CFB и OFB, а затем шифрует его текущим ключом. При этом отпадает
  необходимость в синхропосылке. ID - идентификатор процесса шифрования,
  полученный из Q_RC6Init. Эта процедура должна вызываться перед каждым
  сеансом шифрования (дешифрации). Идея процедуры позаимствована из модуля
  RC6.pas в составе DCPcrypt v2, автором которого является David Barton
  (davebarton@bigfoot.com). }

procedure Q_RC6SetOrdinaryVector(ID: TRC6ID);

{ Q_RC6SetInitVector устанавливает начальный вектор, используемый в режимах
  CBC, CFB и OFB, равным вектору, переданному параметром IV. ID - идентификатор
  процесса шифрования, полученный из Q_RC6Init. Эту процедуру следует вызывать
  перед каждым сеансом шифрования (или дешифрации). }

procedure Q_RC6SetInitVector(ID: TRC6ID; const IV: TRC6InitVector);

{ Q_RC6EncryptCBC выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом RC6 в режиме CBC. ID - идентификатор
  процесса шифрования, полученный из Q_RC6Init. Если длина байтового массива
  не кратна 128 битам (16 символам), то хвост шифруется в режиме CFB. }

procedure Q_RC6EncryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6DecryptCBC выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_RC6EncryptCBC.
  ID - идентификатор процесса шифрования, полученный из Q_RC6Init. }

procedure Q_RC6DecryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6EncryptCFB128 выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом RC6 в блочном режиме CFB (128-битном).
  ID - идентификатор процесса шифрования, полученный из Q_RC6Init. }

procedure Q_RC6EncryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6DecryptCFB128 выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_RC6EncryptCFB128.
  ID - идентификатор процесса шифрования, полученный из Q_RC6Init. }

procedure Q_RC6DecryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6EncryptCFB выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом RC6 в режиме CFB (8-битном). ID -
  идентификатор процесса шифрования, полученный из Q_RC6Init. }

procedure Q_RC6EncryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6DecryptCFB выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_RC6EncryptCFB.
  ID - идентификатор процесса шифрования, полученный из Q_RC6Init. }

procedure Q_RC6DecryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6ApplyOFB128 выполняет шифрование или дешифрацию области памяти,
  адресуемой параметром P, длиной L байт методом RC6 в блочном режиме OFB
  (128 бит). Параметр ID задает идентификатор процесса шифрования. Следует
  иметь в виду, что режим OFB не предусматривает распространения ошибок и,
  фактически, является эквивалентом поточного шифра. В этом режиме не следует
  использовать один и тот же ключ несколько раз. Блочный режим OFB следует
  применять с особой осторожностью, так как, если кому-то станет известен
  фрагмент открытого текста, он легко сможет расшифровать весь последующий
  текст. Если размер области памяти не кратен 16 байтам, то фрагмент гаммы,
  приходящийся на недостающие до кратности байты, пропускается. }

procedure Q_RC6ApplyOFB128(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6ApplyOFB выполняет шифрование или дешифрацию области памяти, адресуемой
  параметром P, длиной L байт методом RC6 в режиме OFB (8 бит). Параметр ID
  задает идентификатор процесса шифрования. }

procedure Q_RC6ApplyOFB(ID: TRC6ID; P: Pointer; L: cardinal);

{ Q_RC6Done освобождает идентификатор процесса шифрования ID, полученный из
  процедуры Q_RC6Init и все связанные с ним ресурсы. }

procedure Q_RC6Done(ID: TRC6ID);

{ Q_RC6SelfTest проверяет работоспособность алгоритма RC6 по тестовым векторам,
  приведенным в документе: The RC6(TM) Block Cipher. Ronald L. Rivest, M.J.B.
  Robshaw, R. Sidney, and Y.L. Yin, http://theory.lcs.mit.edu/~rivest/rc6.pdf.
  Если тест пройден успешно, функция возвращает True, иначе False. }

function Q_RC6SelfTest: boolean;

{ Процедуры Q_CAST6XXX реализуют блочный алгоритм шифрования CAST6-256. Его
  авторами являются Carlisle Adams и Jeff Gilchrist (Канада). Этот алгоритм
  является исключительно надежным, но работает в 2.5 раза медленнее, чем RC6.
  Длина ключа - до 256 бит (32 байта). Поддерживаются режимы CBC, CFB и OFB.
  Эта реализация алгоритма полностью соответствует RFC 2612. }

type
  TCAST6InitVector = array[0..15] of byte;
  TCASTID = type Pointer;

{ Q_CAST6Init инициализирует шифрование методом CAST6. Ключ передается пара-
  метром Key (адрес байтового массива), а длина ключа (в байтах) задается
  параметром KeyLen. Идентификатор текущего процесса шифрования возвращается
  в параметре ID. Данный идентификатор передается как первый параметр во все
  другие процедуры Q_CAST6XXX, а в конце он должен освобождаться вызовом
  Q_CAST6Done. }

procedure Q_CAST6Init(var ID: TCASTID; Key: Pointer; KeyLen: cardinal);

{ Процедуры шифрования/дешифрации в режиме ECB следует использовать только
  в отладочных целях. Размер блока данных - 128 бит. }

procedure IntCAST6EncryptECB(ID: TCASTID; P: Pointer);
procedure IntCAST6DecryptECB(ID: TCASTID; P: Pointer);

{ Q_CAST6SetOrdinaryVector обнуляет начальный вектор, который требуется в
  режимах CBC, CFB и OFB, а затем шифрует его текущим ключом. При этом отпадает
  необходимость в синхропосылке. ID - идентификатор процесса шифрования,
  полученный из Q_CAST6Init. Эту процедуру надо вызывать перед каждым сеансом
  шифрования (или дешифрации). Идея процедуры позаимствована из модуля
  Cast256.pas в составе DCPcrypt v2, автором которого является David Barton
  (davebarton@bigfoot.com). }

procedure Q_CAST6SetOrdinaryVector(ID: TCASTID);

{ Q_CAST6SetInitVector устанавливает начальный вектор, используемый в режимах
  CBC, CFB и OFB, равным вектору IV. ID - идентификатор процесса шифрования,
  полученный из Q_CAST6Init. Эту процедуру следует вызывать перед каждым
  сеансом шифрования (или дешифрации). }

procedure Q_CAST6SetInitVector(ID: TCASTID; const IV: TCAST6InitVector);

{ Q_CAST6EncryptCBC выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом CAST6 в режиме CBC. ID - идентификатор
  процесса шифрования, полученный из Q_CAST6Init. Если длина байтового массива
  не кратна 128 битам (16 символам), то хвост шифруется в режиме CFB. }

procedure Q_CAST6EncryptCBC(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6DecryptCBC выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_CAST6EncryptCBC.
  ID - идентификатор процесса шифрования, полученный из Q_CAST6Init. }

procedure Q_CAST6DecryptCBC(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6EncryptCFB128 выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом CAST6 в блочном режиме CFB (128-битном).
  ID - идентификатор процесса шифрования, полученный из Q_CAST6Init. }

procedure Q_CAST6EncryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6DecryptCFB128 выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_CAST6EncryptCFB128.
  ID - идентификатор процесса шифрования, полученный из Q_CAST6Init. }

procedure Q_CAST6DecryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6EncryptCFB выполняет шифрование байтового массива, адресуемого
  параметром P, длиной L байт методом CAST6 в режиме CFB (8-битном). ID -
  идентификатор процесса шифрования, полученный из Q_CAST6Init. }

procedure Q_CAST6EncryptCFB(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6DecryptCFB выполняет дешифрацию байтового массива, адресуемого
  параметром P, длиной L байт, зашифрованного процедурой Q_CAST6EncryptCFB.
  ID - идентификатор процесса шифрования, полученный из Q_CAST6Init. }

procedure Q_CAST6DecryptCFB(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6ApplyOFB128 выполняет шифрование или дешифрацию области памяти,
  адресуемой параметром P, длиной L байт методом CAST6 в блочном режиме OFB
  (128 бит). Параметром ID задается идентификатор процесса шифрования. Следует
  иметь в виду, что режим OFB не предусматривает распространения ошибок и,
  фактически, является эквивалентом поточного шифра. В этом режиме не следует
  использовать один и тот же ключ несколько раз. Блочный режим OFB следует
  применять с особой осторожностью, так как, если кому-то станет известен
  фрагмент открытого текста, он легко сможет расшифровать весь последующий
  текст. Если размер области памяти не кратен 16 байтам, то фрагмент гаммы,
  приходящийся на недостающие до кратности байты, пропускается. }

procedure Q_CAST6ApplyOFB128(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6ApplyOFB выполняет шифрование или дешифрацию области памяти, которая
  адресуется параметром P, длиной L байт методом CAST6 в режиме OFB (8 бит).
  ID - идентификатор процесса шифрования. }

procedure Q_CAST6ApplyOFB(ID: TCASTID; P: Pointer; L: cardinal);

{ Q_CAST6Done освобождает идентификатор процесса шифрования ID, полученный из
  процедуры Q_CAST6Init и все связанные с ним ресурсы. }

procedure Q_CAST6Done(ID: TCASTID);

{ Q_CAST6SelfTest проверяет работоспособность алгоритма CAST6 по тестовым
  векторам, приведенным в RFC 2612. Если тест пройден успешно, функция
  возвращает True, иначе False. }

function Q_CAST6SelfTest: boolean;

{ Функции Q_SHA1XXX предназначены для получения значения hash-функции SHA-1
  (дайджеста) для байтового массива или строки символов. Этот алгоритм (Secure
  Hash Standard-1) разработан NIST (National Institute of Standards and
  Technology) и опубликован в FIPS180-1 (Federal Information Processing
  Standards Publication 180-1). Функции Q_SHA1XXX генерируют 160-битный массив,
  состоящий из пяти двойных слов (или 20 байт). По дайджесту практически
  невозможно восстановить исходное сообщение. Невозможно также найти другое
  сообщение с тем же дайджестом. Данная реализация алгоритма SHA-1 выполнена
  на основе модуля SHA1.pas, автором которого является David Barton. }

type
  TSHA1Digest = array[0..4] of longword;
  TSHAID = type Pointer;

  TMixDigest = array[0..9] of longword;  // См. Q_MixHashXXX (ниже)
  TMixID = type Pointer;

{ Q_SHA1Init инициализирует hash-функцию SHA-1. В параметре ID возвращается
  новый идентификатор дайджеста. В дальнейшем этот идентификатор передается в
  процедуры Q_SHA1Update и Q_SHA1Final. Последняя из этих процедур обязательно
  должна вызываться в конце для освобождения занятых ресурсов. }

procedure Q_SHA1Init(var ID: TSHAID);

{ Q_SHA1Update добавляет к дайджесту, идентификатор которого передан параметром
  ID, информацию о байтовом массиве длиной L байт, адресуемом параметром P. Эта
  процедура может вызывается многократно для нескольких массивов данных, однако
  само значение дайджеста будет получено только при закрытии идентификатора
  процедурой Q_SHA1Final. }

procedure Q_SHA1Update(ID: TSHAID; P: Pointer; L: cardinal);

{ Q_SHA1Final возвращает в параметре Digest значение hash-функции SHA-1 для
  указанного идентификатора ID. При этом освобождаются ресурсы, связанные с
  этим идентификатором. После вызова Q_SHA1Final использовать данный ID
  уже невозможно. }

procedure Q_SHA1Final(ID: TSHAID; var Digest: TSHA1Digest);

{ Q_SHA1 возвращает в параметре Digest значение hash-функции SHA-1 для строки
  символов S, области памяти длиной L байт, адресуемой параметром P, или
  некоторого исходного значения SourceDigest 160-битной или 320-битной
  hash-функции (SHA-1 или MixHash). }

procedure Q_SHA1(const S: String; var Digest: TSHA1Digest); overload;
procedure Q_SHA1(P: Pointer; L: cardinal; var Digest: TSHA1Digest); overload;

procedure Q_SHA1(const SourceDigest: TSHA1Digest; var Digest: TSHA1Digest); overload;
procedure Q_SHA1(const SourceDigest: TMixDigest; var Digest: TSHA1Digest); overload;

{ Q_SHA1SelfTest проверяет реализацию алгоритма SHA-1 по тестовым векторам,
  опубликованным NIST. Если тест пройден успешно, функция возвращает True,
  иначе False. }

function Q_SHA1SelfTest: boolean;

{ Функции Q_MixHashXXX реализуют алгоритм hash-функции с вдвое большей, чем
  у SHA-1 длиной сигнатуры (320 бит): исходная строка (или байтовый массив)
  делится на три приблизительно равные части, для генерации сигнатуры рассчи-
  тываются три 160-битных значения односторонней функции SHA-1: первое значение
  вычисляется по первой и второй частям строки, второе значение - по второй и
  третьей частям, а третье - по третьей и первой частям. Первые два значения
  hash-функции SHA-1 объединяются друг с другом конкатенацией, образуя 320-
  битную строку. Третье значение используется в качестве ключа шифрования для
  модификации полученной битовой строки. Эта модификация выполняется с помощью
  четырехпроходного шифрования с циклическим распространением ошибок на основе
  алгоритма CAST6-160. Четырехпроходное шифрование необходимо, чтобы достичь
  полного распространения ошибок как в одну, так и в другую сторону. При этом
  каждый бит участвует в восьми циклах шифрования. В конце процесса битовая
  строка гаммируется псевдослучайной последовательностью, полученной на основе
  первых двух значений функции SHA-1, и прибавляется (по двойным словам) к
  исходному значению hash-функции. Недостатком данной hash-функции является
  то, что она работает примерно в 2.25 раза медленнее, чем SHA-1. }

{ Q_MixHashInit инициализирует hash-функцию. В параметре ID возвращается
  новый идентификатор дайджеста. В дальнейшем этот идентификатор передается
  в процедуры Q_MixHashUpdate и Q_MixHashFinal. Последняя из этих процедур
  обязательно должна вызываться в конце для освобождения занятых ресурсов. }

procedure Q_MixHashInit(var ID: TMixID);

{ Q_MixHashUpdate добавляет к дайджесту, идентификатор которого передан
  параметром ID, информацию о байтовом массиве длиной L байт, адресуемом
  параметром P. Эта процедура может вызывается многократно для нескольких
  массивов данных, однако само значение дайджеста будет получено только
  при закрытии идентификатора процедурой Q_MixHashFinal. }

procedure Q_MixHashUpdate(ID: TMixID; P: Pointer; L: cardinal);

{ Q_MixHashFinal возвращает в параметре Digest значение hash-функции для
  указанного идентификатора ID. При этом освобождаются ресурсы, связанные с
  этим идентификатором. После вызова Q_MixHashFinal использовать данный ID
  уже невозможно. }

procedure Q_MixHashFinal(ID: TMixID; var Digest: TMixDigest);

{ Q_MixHash возвращает в параметре Digest значение hash-функции для строки
  символов S, области памяти длиной L байт, адресуемой параметром P, или
  некоторого исходного значения SourceDigest данной hash-функции. }

procedure Q_MixHash(const S: String; var Digest: TMixDigest); overload;
procedure Q_MixHash(P: Pointer; L: cardinal; var Digest: TMixDigest); overload;
procedure Q_MixHash(const SourceDigest: TMixDigest; var Digest: TMixDigest); overload;

{ Q_MixHashSelfTest проверяет реализацию алгоритма по тестовым векторам,
  Если тест пройден успешно, функция возвращает True, иначе False. }

function Q_MixHashSelfTest: boolean;

{ Процедуры Q_RandXXX реализуют датчик псевдослучайных чисел Mersenne Twister
  (беззнаковых целых чисел в интервале от 0 до 2^32 - 1) с равномерным законом
  распределения. Его авторы: Makoto Matsumoto <matumoto@math.keio.ac.jp> и
  Takuji Nishimura. Этот датчик разработан на основе нескольких существующих
  генераторов ПСП и вобрал в себя лучшие их качества. Его период составляет
  2^19937 - 1. Сам по себе датчик не предназначен для криптографических целей,
  т.к. по выборке достаточно большого объема можно восстановить исходную
  последовательность. Однако, в представленной здесь реализации к полученным
  значениям датчика может быть применена односторонняя (неинвертируемая) hash-
  функция SHA-1. В этом случае, если датчик был правильно инициализирован
  (процедурами Q_RandInit и Q_RandXXXUpdate), его выходная последовательность
  будет криптографически стойкой. Более полную информацию об этом датчике ПСП
  можно получить на сайте: http://www.math.keio.ac.jp/~matumoto/emt.html. }

type
  TRandVector = array[0..623] of longword;
  TMTID = type Pointer;

{ Q_RandInit инициализирует датчик ПСП. Идентификатор датчика возвращается
  в параметре ID. Он должен передаваться как первый параметр при вызове других
  функций Q_RandXXX. Для инициализации используется беззнаковое целое число
  Seed, неравное нулю, или начальный вектор InitVector. Идентификатор должен
  освобождаться в конце работы с датчиком с помощью вызова Q_RandDone. }

procedure Q_RandInit(var ID: TMTID; Seed: longword = 4357); overload;
procedure Q_RandInit(var ID: TMTID; const InitVector: TRandVector); overload;

{ Процедуры MT_RandXXXUpdate изменяют внутреннее состояние (вектор) датчика
  псевдослучайных чисел. Текущее значение вектора шифруется с помощью одного
  из алгоритмов: CAST-256 или RC6. Второй параметр процедур Q_RandXXXUpdate
  используется как ключ шифрования. Он может быть строкой символов S, байтовым
  массивом, адресуемым P, длиной L байт, или цифровой сигнатурой (SHA-1 или
  MixHash), передаваемой параметром Digest. Если длина строки S, или массива,
  адресуемого параметром P, больше 32 байт (в случае CAST6) или 48 байт (в
  случае RC6), шифрование выполняется несколько раз, используя фрагменты ключа
  длиной до 32 байт или до 48 байт, соответственно. При формировании строки S
  используйте значение счетчика тактов процессора (Q_TimeStamp), текущую дату
  и время, идентификаторы пользователя и системы, произвольную строку символов,
  вводимую пользователем или администратором с клавиатуры и т.д. В конечном
  счете, стойкость датчика определяется именно тем, насколько непредсказуемой
  и длинной будет инициализирующая байтовая последовательность, передаваемая
  в Q_RandXXXUpdate. Эти процедуры могут вызываться в различных комбинациях. }

procedure Q_RandCAST6Update(ID: TMTID; const S: String); overload;
procedure Q_RandCAST6Update(ID: TMTID; P: Pointer; L: cardinal); overload;
procedure Q_RandCAST6Update(ID: TMTID; const Digest: TSHA1Digest); overload;

procedure Q_RandRC6Update(ID: TMTID; const S: String); overload;
procedure Q_RandRC6Update(ID: TMTID; P: Pointer; L: cardinal); overload;
procedure Q_RandRC6Update(ID: TMTID; const Digest: TSHA1Digest); overload;
procedure Q_RandRC6Update(ID: TMTID; const Digest: TMixDigest); overload;

{ Q_RandGetVector копирует текущее содержимое вектора, используемого для
  генерации псевдослучайных чисел, в массив, переданный параметром Vector.
  Таким образом, в дальнейшем генератор можно инициализировать этим вектором
  и воспроизвести последовательность псевдослучайных чисел (начиная со
  следующего числа). В параметре ID передается идентификатор датчика. }

procedure Q_RandGetVector(ID: TMTID; var Vector: TRandVector);

{ Q_RandSetVector задает новое значение вектора, используемого для генерации
  псевдослучайных чисел. Позволяет воспроизвести последовательность, начиная
  с вектора, переданного параметром Vector. ID - идентификатор датчика. }

procedure Q_RandSetVector(ID: TMTID; const Vector: TRandVector);

{ MT_RandNext возвращает следующее псевдослучайное число, которое является
  равномерно распределенным в интервале от 0 до $FFFFFFFF, для датчика,
  идентификатор которого передается параметром ID. Значения этой функции
  не являются криптографически стойкими. }

function Q_RandNext(ID: TMTID): longword;

{ Q_RandUniform возвращает псевдослучайную величину, равномерно распределенную
  в интервале [0,1], для датчика, идентификатор которого передан параметром ID.
  Непрерывная псевдослучайная величина с равномерным распределением в интервале
  [Min,Max] получается по формуле: (Max-Min)*Q_RandUniform(ID)+Min. }

function Q_RandUniform(ID: TMTID): double;

{ Q_RandUInt32 возвращает целое псевдослучайное число (0 <= X < Range) для
  датчика, идентификатор которого передан параметром ID. Функция Q_RandUInt64
  аналогична Q_RandUInt32, но допустимый диапазон задается 64-битным числом.
  Q_RandUInt64 работает значительно медленнее, чем Q_RandUInt32. }

function Q_RandUInt32(ID: TMTID; Range: cardinal): cardinal;
function Q_RandUInt64(ID: TMTID; Range: int64): int64;

{ Q_RandGauss используется для моделирования непрерывной случайной величины
  с нормальным законом распределения. Эта функция возвращает (0,1)-нормально
  распределенное псевдослучайное число для датчика, идентификатор которого
  передается параметром ID. В параметре ExtraNumber может быть передан адрес
  переменной типа Double, в которую запишется другое число с аналогичным
  распределением. Это возможно, так как используемый алгоритм (Marsaglia-Bray)
  генерирует сразу пару чисел с нормальным распределением. Для того, чтобы
  получить величину с математическим ожиданием Mean и среднеквадратическим
  отклонением StdDev, используйте формулу: Q_RandGauss(ID) * StdDev + Mean. }

function Q_RandGauss(ID: TMTID; ExtraNumber: Pointer = nil): double;

{ MT_SecureRandNext возвращает следующее псевдослучайное число, которое
  является равномерно распределенным в интервале от 0 до $FFFFFFFF, для
  датчика, идентификатор которого передается параметром ID. Это значение
  получается в результате применения односторонней функции (SHA-1) к выходной
  последовательности датчика Mersenne Twister. При этом каждые 5 значений
  функции MT_SecureRandNext формируются на основе 14 значений функции
  Q_RandNext. При использовании этого датчика в подсистеме безопасности
  особое внимание следует уделить инициализации датчика. }

function Q_SecureRandNext(ID: TMTID): longword;

{ Q_RandFill заполняет область памяти, адресуемую параметром P, длиной L байт
  псевдослучайными числами с равномерным законом распределения. ID -
  идентификатор датчика, полученный при вызове Q_RandInit. Получаемая таким
  образом последовательность не является криптографически стойкой. }

procedure Q_RandFill(ID: TMTID; P: Pointer; L: cardinal);

{ MT_SecureRandFill заполняет область памяти, адресуемую параметром P длиной
  L байт криптографически стойкой (при правильной инициализации датчика)
  последовательностью псевдослучайных чисел на основе датчика, идентификатор
  которого передается параметром ID. }

procedure Q_SecureRandFill(ID: TMTID; P: Pointer; L: cardinal);

{ Q_SecureRandXOR выполняет наложение с помощью "исключающего ИЛИ" стойкой
  псевдослучайной последовательности на область памяти, адресуемую параметром
  P, длиной L байт. Идентификатор датчика передается параметром ID. Повторное
  наложение той же последовательности восстанавливает исходное состояние
  области памяти. Если эта операция применяется к нескольким фрагментам памяти,
  то при восстановлении данных размеры этих фрагментов должны совпадать с
  исходными, или длина всех фрагментов должна быть кратна четырем байтам.
  Это связано с тем, что, если Q_SecureRandXOR применяется к области памяти,
  размер которой не кратен четырем байтам, то фрагмент гаммы, приходящийся
  на недостающие до кратности байты, теряется. Процедура Q_SecureRandXOR,
  фактически, реализует собой алгоритм поточного шифрования, который при
  соответствующей инициализации датчика ПСП может значительно превосходить
  по стойкости такие методы как RC6 или CAST6. Однако, для этого необходим
  источник длинной псевдослучайной последовательности (например, другой
  аналогичный генератор) и, кроме того, нельзя допускать, чтобы какой-либо
  фрагмент гаммы повторно накладывался на другие данные. }

procedure Q_SecureRandXOR(ID: TMTID; P: Pointer; L: cardinal);

{ Q_RandDone освобождает ресурсы, связанные c идентификатором датчика
  псевдослучайных чисел ID. После вызова этой процедуры данный ID больше
  не может использоваться. }

procedure Q_RandDone(ID: TMTID);

{ Процедуры Q_DHXXX реализуют алгоритм Диффи-Хеллмана, который используется
  в шифровании с открытым ключом. Эти процедуры не выполняют непосредственно
  шифрования информации. Они предназначены для генерации ключа, который может
  затем использоваться для шифрования обычными методами. Этот ключ формируется
  с помощью пары ключей: закрытого и открытого. Закрытый ключ, как правило,
  генерируется датчиком ПСП, а открытый ключ создается на основе закрытого.
  При вычислении открытого ключа используется еще целое число G (возводимое
  в степень псевдослучайное число), размер которого соответствует размеру
  ключей. Оно должно быть одинаковым для обоих участников обмена информацией
  и быть отличным от нуля и единицы. Основная идея алгоритма Диффи-Хеллмана
  заключается в том, что один и тот же секретный ключ, которым шифруются
  данные, может быть получен как из своего закрытого ключа и чужого открытого,
  так и из своего открытого ключа и чужого закрытого. Таким образом, каждый
  участник обмена информацией должен владеть личным закрытым ключом и открытыми
  ключами всех остальных участников. Тогда для каждой пары будет свой секретный
  ключ, и, не зная их закрытых ключей, никто не сможет расшифровывать или
  подделывать сообщения, которыми обмениваются эти два участника. Можно также
  подготовить сообщение для конкретного субъекта (владельца закрытого ключа),
  используя его открытый ключ, так, чтобы никто, кроме этого субъекта, не смог
  прочитать данное сообщение (даже отправитель). Для того, чтобы это сделать,
  нужно сгенерировать временный закрытый ключ, зашифровать сообщение с помощью
  данного ключа и открытого ключа получателя, сформировать временный открытый
  ключ (на основе закрытого) и приложить его к сообщению, после чего временный
  закрытый ключ удалить. Здесь реализован метод Диффи-Хеллмана по основанию
  2^4253 - 1. Это простое число типа Mersenne. По стойкости данная реализация
  соответствует приблизительно 226 битам для симметричных шифров. Имейте в
  виду, что генерация открытого или секретного ключа может занимать несколько
  секунд. Используется самый простой способ модульного возведения в степень. }

type
  PDHKey4253 = ^TDHKey4253;
  TDHKey4253 = array[0..132] of longword;

{ Q_DHCreatePublicKey формируют открытый ключ PublicKey на основе закрытого
  ключа PrivateKey и константы G. Память под открытый ключ распределяется до
  вызова этой процедуры (тем, кто ее вызывает). }

procedure Q_DHCreatePublicKey(G, PrivateKey: PDHKey4253; PublicKey: PDHKey4253);

{ Q_DHGetCipherKey генерируют основной ключ размером KeySize байт, который
  затем используется для шифрования или расшифровки данных (с помощью любого
  симметричного метода), на основе открытого ключа PublicKey (чужого) и
  закрытого ключа PrivateKey (своего). Полученный ключ сохраняется в области
  памяти, указываемой параметром CipherKey. }

procedure Q_DHGetCipherKey(PublicKey, PrivateKey: PDHKey4253; CipherKey: Pointer; KeySize: integer);

{ Q_DHSelfTest проверяет работоспособность процедур, реализующих метод Диффи-
  Хеллмана и возвращает True, если все в порядке, иначе - False. На компьютере
  с процессором PII-233 эта функция выполняется примерно за 8.5 секунд. }

function Q_DHSelfTest: boolean;


{ Полезные стандартные строковые функции. }

{ StringOfChar возвращает строку, состоящую из Count символов Ch. Например,
   StringOfChar('A', 10) вернет строку 'AAAAAAAAAA'. (модуль System)

function StringOfChar(Ch: AnsiChar; Count: Integer): String; }

{ SetString устанавливает S таким образом, чтобы она указывала на заново
  распределенную строку длиной Len символов. Если параметр Buffer равен nil,
  содержимое новой строки остается неопределенным, иначе SetString копирует
  Len символов из Buffer в новую строку. Если для размещения строки
  недостаточно памяти возникает исключительная ситуация EOutOfMemory. Вызов
  функции SetString гарантирует, что S будет уникальной строкой, т.е.
  счетчик ссылок этой строки будет равен единице.

  Для размещения в памяти новой строки S длиной Len символов используйте вызов
  процедуры SetString: SetString(S, nil, Len). (модуль System)

procedure SetString(var S: String; Buffer: PAnsiChar; Len: Integer); }

{ SetLength перераспределяет память под строку адресуемую параметром S, таким
  образом, чтобы ее длина равнялась NewLength. Существующие символы в строке
  сохраняются, а содержимое дополнительной выделенной памяти будет
  неопределенным. Если необходимое количество памяти не может быть выделено,
  вызывается исключение EOutOfMemory. Вызов SetLength гарантирует, что после
  него строка S будет являться уникальной, т.е. ее счетчик ссылок будет равен
  единице. (модуль System)

procedure SetLength(var S; NewLength: Integer); }

{ Copy возвращает подстроку из строки. S - это исходная строка (выражение типа
  String), Index и Count - целочисленные выражения. Copy возвращает подстроку,
  содержащую Count символов, начиная с S[Index]. Если Index больше, чем длина
  строки S, Copy возвращает пустую строку. Если Count задает больше символов,
  чем их есть до конца строки, то возвращаются подстрока, начиная с S[Index]
  и до конца строки. (модуль System)

function Copy(S; Index, Count: Integer): String; }

{ Insert вставляет подстроку в строку, начиная с указанного символа. Подстрока
  Source вставляется в строку S, начиная с символа S[Index]. Index - номер
  символа, с которого начинается вставка. Если Index больше длины строки S,
  подстрока Source просто добавляется в конец строки S. (модуль System)

procedure Insert(Source: String; var S: String; Index: Integer); }

{ UniqueString гарантирует, что данная строка Str будет иметь счетчик ссылок
  равный единице. Вызов этой процедуры необходим, когда в программе строка
  приводится к типу PAnsiChar, а затем содержимое строки изменяется.
  (модуль System)

procedure UniqueString(var Str: String); }

{ WrapText находит в строке Line символы, входящие во множество BreakChars,
  и добавляет перевод строки, переданный параметром BreakStr, после последнего
  символа из BreakChars перед позицией MaxCol. MaxCol - это максимальная длина
  строки (до символов перевода строки). Если параметры BreakStr и BreakChars
  опущены, функция WrapText ищет в строке Line пробелы, символы тире и символы
  табуляции, в позиции которых могут быть добавлены разрывы строки в виде пары
  символов #13#10. Эта функция не вставляет разрывы строки во фрагменты,
  заключенные в одиночные или двойные ковычки. (модуль SysUtils)

function WrapText(const Line, BreakStr: String; BreakChars: TSysCharSet;
  MaxCol: Integer): String; overload;
function WrapText(const Line: String; MaxCol: Integer = 45): String; overload; }

{ AdjustLineBreaks заменяет все переводы строки в строке S на правильную
  последовательность символов CR/LF. Эта функция превращает любой символ CR,
  за которым не следует символ LF, и любой символ LF, перед которым не стоит
  символ CR, в пару символов CR/LF. Она также преобразует пары символов LF/CR
  в пары CR/LF. Последовательность LF/CR обычно используется в текстовых
  файлах Unix. (модуль SysUtils)

function AdjustLineBreaks(const S: String): String; }

{ QuotedStr заключает переданную в нее строку в одинарные кавычки ('). Они
  добавляются в начале и в конце строки. Кроме того, каждый символ одинарной
  кавычки внутри строки удваивается. (модуль SysUtils)

function QuotedStr(const S: String): String; }


{ DEFINE USE_DYNAMIC_TABLES}// Подставьте или уберите $ в начале строки

{ Кодовые таблицы для изменения регистра символов и перекодировки строк из
  OEM в ANSI и наоборот могут формироваться динамически при запуске программы
  (в соответствии с текущими настройками на компьютере пользователя) или они
  могут жестко задаваться при компиляции программы (как константные массивы).
  Если символ USE_DYNAMIC_TABLES определен (с помощью $DEFINE), используются
  динамические таблицы, иначе - статические. }

{$IFNDEF USE_DYNAMIC_TABLES}

{ Если вы собираетесь использовать статические таблицы перекодировки, но с
  другим набором символов (отличным от русской кодировки Win1251), для этого
  необходимо изменить приведенные ниже константные массивы. Они могут быть
  получены следующим образом: устанавливаете в Control Panel нужный Вам язык,
  компилируете и запускаете следующую программу.

  program MakeTables;
  uses
    Windows, SysUtils;
  var
    Ch,N: Byte;
    I,J: Integer;
    F: TextFile;
  begin
    AssignFile(F,'CsTables.txt');
    Rewrite(F);
    WriteLn(F);
    WriteLn(F,'  ToUpperChars: array[0..255] of AnsiChar =');
    Write(F,'    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        Ch := N;
        CharUpperBuff(@Ch, 1);
        Write(F,'#$'+IntToHex(Ch,2));
        if N <> 255 then
          Write(F,',')
        else
          Write(F,');');
      end;
      WriteLn(F);
      Write(F,'     ');
    end;
    WriteLn(F);
    WriteLn(F,'  ToLowerChars: array[0..255] of AnsiChar =');
    Write(F,'    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        Ch := N;
        CharLowerBuff(@Ch, 1);
        Write(F,'#$'+IntToHex(Ch,2));
        if N <> 255 then
          Write(F,',')
        else
          Write(F,');');
      end;
      WriteLn(F);
      Write(F,'     ');
    end;
    WriteLn(F);
    WriteLn(F,'  ToOemChars: array[0..255] of AnsiChar =');
    Write(F,'    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        CharToOemBuff(@N, @Ch, 1);
        Write(F,'#$'+IntToHex(Ch,2));
        if N <> 255 then
          Write(F,',')
        else
          Write(F,');');
      end;
      WriteLn(F);
      Write(F,'     ');
    end;
    WriteLn(F);
    WriteLn(F,'  ToAnsiChars: array[0..255] of AnsiChar =');
    Write(F,'    (');
    for I := 0 to 15 do
    begin
      for J := 0 to 15 do
      begin
        N := (I shl 4) or J;
        OemToCharBuff(@N, @Ch, 1);
        Write(F,'#$'+IntToHex(Ch,2));
        if N <> 255 then
          Write(F,',')
        else
          Write(F,');');
      end;
      WriteLn(F);
      Write(F,'     ');
    end;
    CloseFile(F);
  end.

  В текущем каталоге находите файл CsTables.txt и как есть вставляете его после
  const. Компилируя этот модуль с ключом $J+, вы получаете возможность изменять
  статические таблицы перекодировки во время исполнения программы (динамические
  таблицы вы можете изменять независимо от каких-либо ключей).

  Многобайтные символы и Unicode не поддерживаются.
}

const
  ToUpperChars: array[0..255] of ansichar =
    (#$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$41, #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$41, #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$80, #$81, #$82, #$81, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
    #$80, #$91, #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$8A, #$9B, #$8C, #$8D, #$8E, #$8F,
    #$A0, #$A1, #$A1, #$A3, #$A4, #$A5, #$A6, #$A7, #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
    #$B0, #$B1, #$B2, #$B2, #$A5, #$B5, #$B6, #$B7, #$A8, #$B9, #$AA, #$BB, #$A3, #$BD, #$BD, #$AF,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7, #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7, #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7, #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7, #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF);

  ToLowerChars: array[0..255] of ansichar =
    (#$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$61, #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$90, #$83, #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$9A, #$8B, #$9C, #$9D, #$9E, #$9F,
    #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
    #$A0, #$A2, #$A2, #$BC, #$A4, #$B4, #$A6, #$A7, #$B8, #$A9, #$BA, #$AB, #$AC, #$AD, #$AE, #$BF,
    #$B0, #$B1, #$B3, #$B3, #$B4, #$B5, #$B6, #$B7, #$B8, #$B9, #$BA, #$BB, #$BC, #$BE, #$BE, #$BF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7, #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7, #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF);

  ToOemChars: array[0..255] of ansichar =
    (#$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$0F,
    #$10, #$11, #$12, #$13, #$14, #$15, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$41, #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$3F, #$3F, #$27, #$3F, #$22, #$3A, #$C5, #$D8, #$3F, #$25, #$3F, #$3C, #$3F, #$3F, #$3F, #$3F,
    #$3F, #$27, #$27, #$22, #$22, #$07, #$2D, #$2D, #$3F, #$54, #$3F, #$3E, #$3F, #$3F, #$3F, #$3F,
    #$FF, #$F6, #$F7, #$3F, #$FD, #$3F, #$B3, #$15, #$F0, #$63, #$F2, #$3C, #$BF, #$2D, #$52, #$F4,
    #$F8, #$2B, #$3F, #$3F, #$3F, #$E7, #$14, #$FA, #$F1, #$FC, #$F3, #$3E, #$3F, #$3F, #$3F, #$F5,
    #$80, #$81, #$82, #$83, #$84, #$85, #$86, #$87, #$88, #$89, #$8A, #$8B, #$8C, #$8D, #$8E, #$8F,
    #$90, #$91, #$92, #$93, #$94, #$95, #$96, #$97, #$98, #$99, #$9A, #$9B, #$9C, #$9D, #$9E, #$9F,
    #$A0, #$A1, #$A2, #$A3, #$A4, #$A5, #$A6, #$A7, #$A8, #$A9, #$AA, #$AB, #$AC, #$AD, #$AE, #$AF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF);

  ToAnsiChars: array[0..255] of ansichar =
    (#$00, #$01, #$02, #$03, #$04, #$05, #$06, #$07, #$08, #$09, #$0A, #$0B, #$0C, #$0D, #$0E, #$A4,
    #$10, #$11, #$12, #$13, #$B6, #$A7, #$16, #$17, #$18, #$19, #$1A, #$1B, #$1C, #$1D, #$1E, #$1F,
    #$20, #$21, #$22, #$23, #$24, #$25, #$26, #$27, #$28, #$29, #$2A, #$2B, #$2C, #$2D, #$2E, #$2F,
    #$30, #$31, #$32, #$33, #$34, #$35, #$36, #$37, #$38, #$39, #$3A, #$3B, #$3C, #$3D, #$3E, #$3F,
    #$40, #$41, #$42, #$43, #$44, #$45, #$46, #$47, #$48, #$49, #$4A, #$4B, #$4C, #$4D, #$4E, #$4F,
    #$50, #$51, #$52, #$53, #$54, #$55, #$56, #$57, #$58, #$59, #$5A, #$5B, #$5C, #$5D, #$5E, #$5F,
    #$60, #$61, #$62, #$63, #$64, #$65, #$66, #$67, #$68, #$69, #$6A, #$6B, #$6C, #$6D, #$6E, #$6F,
    #$70, #$71, #$72, #$73, #$74, #$75, #$76, #$77, #$78, #$79, #$7A, #$7B, #$7C, #$7D, #$7E, #$7F,
    #$C0, #$C1, #$C2, #$C3, #$C4, #$C5, #$C6, #$C7, #$C8, #$C9, #$CA, #$CB, #$CC, #$CD, #$CE, #$CF,
    #$D0, #$D1, #$D2, #$D3, #$D4, #$D5, #$D6, #$D7, #$D8, #$D9, #$DA, #$DB, #$DC, #$DD, #$DE, #$DF,
    #$E0, #$E1, #$E2, #$E3, #$E4, #$E5, #$E6, #$E7, #$E8, #$E9, #$EA, #$EB, #$EC, #$ED, #$EE, #$EF,
    #$2D, #$2D, #$2D, #$A6, #$2B, #$A6, #$A6, #$AC, #$AC, #$A6, #$A6, #$AC, #$2D, #$2D, #$2D, #$AC,
    #$4C, #$2B, #$54, #$2B, #$2D, #$2B, #$A6, #$A6, #$4C, #$E3, #$A6, #$54, #$A6, #$3D, #$2B, #$A6,
    #$A6, #$54, #$54, #$4C, #$4C, #$2D, #$E3, #$2B, #$2B, #$2D, #$2D, #$2D, #$2D, #$A6, #$A6, #$2D,
    #$F0, #$F1, #$F2, #$F3, #$F4, #$F5, #$F6, #$F7, #$F8, #$F9, #$FA, #$FB, #$FC, #$FD, #$FE, #$FF,
    #$A8, #$B8, #$AA, #$BA, #$AF, #$BF, #$A1, #$A2, #$B0, #$95, #$B7, #$76, #$B9, #$A4, #$A6, #$A0);

{$ELSE}

var
  ToUpperChars,ToLowerChars: array[0..255] of AnsiChar;
  ToOemChars,ToAnsiChars: array[0..255] of AnsiChar;

{$ENDIF}

implementation

uses
{$IFDEF WINDOWS}
  dialogs, sysutils, math;
{$ELSE}
  SysUtils, Math, Dialogs;

{$ENDIF}

// added for linux migration
type
  TbArray = array [0..MaxInt - 1] of byte;
{$IFDEF CPU32}
 TpArray = array[0..MaxSmallInt - 1] of pointer;
 TLArray = array [0..MaxSmallInt - 1] of LongWord;
 TWArray = array [0..MaxSmallInt - 1] of word;
{$ELSE}
 TpArray = array[0..MaxInt - 1] of pointer;
 TLArray = array [0..MaxInt - 1] of LongWord;        // maxsmallint - ?
 TWArray = array [0..MaxInt - 1] of word;
{$ENDIF}

{ Функции для сравнения строк. }


{$IFDEF CPU32}
function Q_CompStr(const S1, S2: String): Integer;
asm
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EAX
        MOVZX   EAX,BYTE PTR [EAX]
        MOVZX   ECX,BYTE PTR [EDX]
        SUB     EAX,ECX
        JE      @@m
        POP     ECX
        RET
@@m:    POP     EAX
        INC     EAX
        INC     EDX
@@0:    TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX]
        MOV     CH,BYTE PTR [EDX]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+1]
        MOV     CH,BYTE PTR [EDX+1]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+2]
        MOV     CH,BYTE PTR [EDX+2]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+3]
        MOV     CH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     CL,CH
        JE      @@0
@@ne:   MOVZX   EAX,CL
        MOVZX   EDX,CH
        SUB     EAX,EDX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@5:    XOR     EAX,EAX
@@7:
end;
{$ELSE}

function Q_CompStr(const S1, S2: String): integer;
begin
  ShowMessage('Q_CompStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PCompStr(P1, P2: PAnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EAX
        MOVZX   EAX,BYTE PTR [EAX]
        MOVZX   ECX,BYTE PTR [EDX]
        SUB     EAX,ECX
        JE      @@m
        POP     ECX
        RET
@@m:    POP     EAX
        INC     EAX
        INC     EDX
@@0:    TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX]
        MOV     CH,BYTE PTR [EDX]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+1]
        MOV     CH,BYTE PTR [EDX+1]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+2]
        MOV     CH,BYTE PTR [EDX+2]
        CMP     CL,CH
        JNE     @@ne
        TEST    CL,CL
        JE      @@5
        MOV     CL,BYTE PTR [EAX+3]
        MOV     CH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     CL,CH
        JE      @@0
@@ne:   MOVZX   EAX,CL
        MOVZX   EDX,CH
        SUB     EAX,EDX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@5:    XOR     EAX,EAX
@@7:
end;
{$ELSE}

function Q_PCompStr(P1, P2: pansichar): integer;
begin
  ShowMessage('Q_PCompStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CompStrL(const S1, S2: String; MaxL: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@1
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX-4]
        MOV     ESI,[EDX-4]
        SUB     EBX,ESI
        JG      @@w1
        ADD     ESI,EBX
@@w1:   CMP     ECX,ESI
        JA      @@fc
@@dn:   POP     ESI
@@lp:   DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX]
        MOV     BH,BYTE PTR [EDX]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+1]
        MOV     BH,BYTE PTR [EDX+1]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+2]
        MOV     BH,BYTE PTR [EDX+2]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+3]
        MOV     BH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     BL,BH
        JE      @@lp
@@ne:   MOVZX   EAX,BL
        MOVZX   EDX,BH
        SUB     EAX,EDX
        POP     EBX
        RET
@@fc:   LEA     ECX,[ESI+1]
        JMP     @@dn
@@1:    XOR     EAX,EAX
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@5:    XOR     EAX,EAX
@@7:
end;
{$ELSE}

function Q_CompStrL(const S1, S2: String; MaxL: cardinal): integer;
begin
  ShowMessage('Q_CompStrL TODO');
end;

{$ENDIF}

function Q_CompText(const S1, S2: String): integer;
begin
 Result := CompareText(S1, S2);
end;

{$IFDEF CPU32}
function Q_PCompText(P1, P2: PAnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        JMP     @@1
@@0:    TEST    AL,AL
        JE      @@4
        INC     ESI
        INC     EDI
@@1:    MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        CMP     AL,DL
        JE      @@0
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@0
        MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@4:    POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;
{$ELSE}

function Q_PCompText(P1, P2: pansichar): integer;
begin
  ShowMessage('Q_PCompText TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CompTextL(const S1, S2: String; MaxL: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@5
        TEST    EAX,EAX
        JE      @@2
        TEST    EDX,EDX
        JE      @@3
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EAX-4]
        MOV     EDI,[EDX-4]
        SUB     ESI,EDI
        JG      @@w1
        ADD     EDI,ESI
@@w1:   CMP     ECX,EDI
        JA      @@fc
@@dn:   MOV     ESI,EAX
        MOV     EDI,EDX
@@lp:   DEC     ECX
        JS      @@zq
        MOVZX   EAX,BYTE PTR [ESI]
        MOVZX   EDX,BYTE PTR [EDI]
        INC     ESI
        INC     EDI
        CMP     AL,DL
        JE      @@lp
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     AL,DL
        JE      @@lp
@@ne:   MOVZX   EAX,AL
        MOVZX   EDX,DL
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
        RET
@@fc:   LEA     ECX,[EDI+1]
        JMP     @@dn
@@2:    TEST    EDX,EDX
        JE      @@7
        MOV     CH,BYTE PTR [EDX]
        TEST    CH,CH
        JE      @@7
        NOT     EAX
        RET
@@3:    MOV     CL,BYTE PTR [EAX]
        TEST    CL,CL
        JE      @@5
        MOV     EAX,1
        RET
@@zq:   POP     EDI
        POP     ESI
@@5:    XOR     EAX,EAX
@@7:
end;
{$ELSE}
{ Q_CompTextL сравнивает две строки по MaxL первым символам без учета регистра.
  Если фрагмент первой строки больше (в алфавитном порядке), чем фрагмент
  второй строки, возвращаемое значение больше нуля. Если фрагмент первой строки
  меньше, чем фрагмент второй строки, возвращаемое значение меньше нуля, иначе
  результат равен нулю. Если необходимо выяснить только, равны ли две строки
  или не равны, используйте вместо Q_CompTextL функцию Q_SameTextL. }

function Q_CompTextL(const S1, S2: String; MaxL: cardinal): integer;
begin
  ShowMessage('Q_CompTextL TODO');
end;

{$ENDIF}
(*
{$IFDEF CPU32}
function Q_SameStr(const S1, S2: String): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@qt2
        TEST    EDX,EDX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
@@qt2:  RET
@@01:   PUSH    EBX
        SUB     ECX,8
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        MOV     EBX,DWORD PTR [EAX+ECX+4]
        CMP     EBX,DWORD PTR [EDX+ECX+4]
        JNE     @@zq
        SUB     ECX,8
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+32]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq
@@t4:   MOV     EBX,DWORD PTR [EAX]
        CMP     EBX,DWORD PTR [EDX]
        JNE     @@zq
@@eq:   POP     EBX
@@08:   MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
        POP     EBX
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@07:   XOR     EAX,EAX
end;
{$ELSE}

function Q_SameStr(const S1, S2: String): boolean;
begin
  Result := (CompareStr(S1, S2) = 0);
end;

{$ENDIF}
*)
function Q_SameStr(const S1, S2: String): boolean;
begin
  Result := (CompareStr(S1, S2) = 0);
end;

{$IFDEF CPU32}
function Q_PSameStr(P1, P2: Pointer): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@qt2
        TEST    EDX,EDX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
@@qt2:  RET
@@01:   PUSH    EBX
        SUB     ECX,8
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        MOV     EBX,DWORD PTR [EAX+ECX+4]
        CMP     EBX,DWORD PTR [EDX+ECX+4]
        JNE     @@zq
        SUB     ECX,8
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+32]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq
@@t4:   MOV     EBX,DWORD PTR [EAX]
        CMP     EBX,DWORD PTR [EDX]
        JNE     @@zq
@@eq:   POP     EBX
@@08:   MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
        POP     EBX
        MOV     EAX,1
        RET
@@zq:   POP     EBX
@@07:   XOR     EAX,EAX
end;
{$ELSE}

function Q_PSameStr(P1, P2: Pointer): boolean;
begin
  ShowMessage('Q_PSameStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SameStrL(const S1, S2: String; MaxL: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,[EAX-4]
        MOV     ESI,[EDX-4]
        SUB     EBX,ESI
        JG      @@w1
        ADD     ESI,EBX
@@w1:   CMP     ECX,ESI
        JA      @@fc
@@dn:   SUB     ECX,4
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@zq
        SUB     ECX,4
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+16]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq
@@eq:   POP     ESI
        POP     EBX
@@08:   MOV     EAX,1
        RET
@@fc:   MOV     ECX,ESI
        TEST    EBX,EBX
        JE      @@dn
@@zq:   POP     ESI
        POP     EBX
@@07:   XOR     EAX,EAX
@@09:
end;
{$ELSE}

function Q_SameStrL(const S1, S2: String; MaxL: cardinal): boolean;
begin
  ShowMessage('Q_SameStrL TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SameText(const S1, S2: String): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@im
        XOR     EAX,EAX
        RET
@@im:   TEST    ECX,ECX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
@@00:   DEC     ECX
        JS      @@qt
@@01:   MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@00
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@00
        POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@09:   RET
@@qt:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;
{$ELSE}

function Q_SameText(const S1, S2: String): boolean;
begin
  ShowMessage('Q_SameText TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PSameText(P1, P2: Pointer): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@09
        TEST    EDX,EDX
        JE      @@07
        MOV     ECX,[EAX-4]
        CMP     ECX,[EDX-4]
        JE      @@im
        XOR     EAX,EAX
        RET
@@im:   TEST    ECX,ECX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
@@00:   DEC     ECX
        JS      @@qt
@@01:   MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@00
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@00
        POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@09:   RET
@@qt:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;
{$ELSE}

function Q_PSameText(P1, P2: Pointer): boolean;
begin
  ShowMessage('Q_PSameText TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SameTextL(const S1, S2: String; MaxL: Cardinal): Boolean;
asm
        CMP     EAX,EDX
        JE      @@08
        TEST    EAX,EAX
        JE      @@xx
        TEST    EDX,EDX
        JE      @@07
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EAX-4]
        MOV     EDI,[EDX-4]
        SUB     ESI,EDI
        JG      @@w1
        ADD     EDI,ESI
@@w1:   CMP     ECX,EDI
        JA      @@fc
@@dn:   TEST    ECX,ECX
        JE      @@zq
        MOV     ESI,EAX
        MOV     EDI,EDX
@@0:    DEC     ECX
        JS      @@eq
@@1:    MOVZX   EAX,BYTE PTR [ESI+ECX]
        MOVZX   EDX,BYTE PTR [EDI+ECX]
        CMP     AL,DL
        JE      @@0
        MOV     AL,BYTE PTR [EAX+ToUpperChars]
        XOR     AL,BYTE PTR [EDX+ToUpperChars]
        JE      @@0
@@zq:   POP     EDI
        POP     ESI
@@07:   XOR     EAX,EAX
@@xx:   RET
@@fc:   MOV     ECX,EDI
        TEST    ESI,ESI
        JE      @@dn
        JMP     @@zq
@@eq:   POP     EDI
        POP     ESI
@@08:   MOV     EAX,1
end;
{$ELSE}

function Q_SameTextL(const S1, S2: String; MaxL: cardinal): boolean;
begin
  ShowMessage('Q_SameTextL TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_MatchStr(const SubStr, S: String; Pos: Integer): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@zq
        PUSH    EBX
        DEC     ECX
        JL      @@m0
        MOV     EBX,[EDX-4]
        SUB     EBX,ECX
        JLE     @@m0
        ADD     EDX,ECX
        MOV     ECX,[EAX-4]
        CMP     EBX,ECX
        JL      @@m0
        SUB     ECX,4
        JS      @@nx
@@lp:   MOV     EBX,DWORD PTR [EAX+ECX]
        CMP     EBX,DWORD PTR [EDX+ECX]
        JNE     @@m0
        SUB     ECX,4
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+16]
@@tV:   DD      @@m1,@@t1,@@t2,@@t3
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@m0
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@m0
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@m0
@@m1:   POP     EBX
@@qt:   MOV     EAX,1
        RET
@@m0:   POP     EBX
@@zq:   XOR     EAX,EAX
end;
{$ELSE}

function Q_MatchStr(const SubStr, S: String; Pos: integer): boolean;
begin
  ShowMessage('Q_MatchStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_MatchText(const SubStr, S: String; Pos: Integer): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@zq
        PUSH    EBX
        PUSH    ESI
        DEC     ECX
        JL      @@m0
        MOV     EBX,[EDX-4]
        SUB     EBX,ECX
        JLE     @@m0
        ADD     EDX,ECX
        MOV     ESI,[EAX-4]
        CMP     EBX,ESI
        JL      @@m0
@@lp:   DEC     ESI
        JS      @@m1
        MOVZX   EBX,BYTE PTR [EAX+ESI]
        MOVZX   ECX,BYTE PTR [EDX+ESI]
        CMP     BL,CL
        JE      @@lp
        MOV     BL,BYTE PTR [EBX+ToUpperChars]
        XOR     BL,BYTE PTR [ECX+ToUpperChars]
        JE      @@lp
@@m0:   POP     ESI
        POP     EBX
@@zq:   XOR     EAX,EAX
        RET
@@m1:   POP     ESI
        POP     EBX
@@qt:   MOV     EAX,1
end;
{$ELSE}

function Q_MatchText(const SubStr, S: String; Pos: integer): boolean;
begin
  ShowMessage('Q_MatchText TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_TestByMask(const S, Mask: String; MaskChar: AnsiChar): Boolean;
asm
        TEST    EAX,EAX
        JE      @@qt2
        PUSH    EBX
        TEST    EDX,EDX
        JE      @@qt1
        MOV     EBX,[EAX-4]
        CMP     EBX,[EDX-4]
        JE      @@01
@@qt1:  XOR     EAX,EAX
        POP     EBX
@@qt2:  RET
@@01:   DEC     EBX
        JS      @@07
@@lp:   MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JS      @@eq
        MOV     CH,BYTE PTR [EDX+EBX]
        CMP     CL,CH
        JNE     @@cm
        DEC     EBX
        JNS     @@lp
@@eq:   MOV     EAX,1
        POP     EBX
        RET
@@cm:   CMP     CH,BYTE PTR [EAX+EBX]
        JNE     @@07
        DEC     EBX
        JNS     @@lp
        MOV     EAX,1
        POP     EBX
        RET
@@07:   XOR     EAX,EAX
        POP     EBX
end;
{$ELSE}

function Q_TestByMask(const S, Mask: String; MaskChar: ansichar): boolean;
begin
  ShowMessage('Q_TestByMask TODO');
end;

{$ENDIF}

function Q_TestWildStr(const S, Mask: String; MaskChar, WildCard: ansichar): boolean;
label
  99;
var
  L, X, X0, Q: integer;
  P, P1, B: pansichar;
  C: ansichar;
begin
  X := Q_StrScan(Mask, WildCard);
  if X = 0 then
  begin
    Result := Q_TestByMask(S, Mask, MaskChar);
    Exit;
  end;
  L := Length(S);
  P := Pointer(S);
  Result := False;
  B := Pointer(Mask);
  Q := X - 1;
  if L < Q then
    Exit;
  while Q > 0 do
  begin
    C := B^;
    if (C <> MaskChar) and (C <> P^) then
      Exit;
    Dec(Q);
    Inc(B);
    Inc(P);
  end;
  Dec(L, X - 1);
  repeat
    X0 := X;
    P1 := P;
    while Mask[X0] = WildCard do
      Inc(X0);
    X := Q_StrScan(Mask, WildCard, X0);
    if X = 0 then
      Break;
    99:
      P := P1;
    B := @Mask[X0];
    Q := X - X0;
    if L < Q then
      Exit;
    while Q > 0 do
    begin
      C := B^;
      if (C <> MaskChar) and (C <> P^) then
      begin
        Inc(P1);
        Dec(L);
        goto 99;
      end;
      Dec(Q);
      Inc(B);
      Inc(P);
    end;
    Dec(L, X - X0);
  until False;
  X := Length(Mask);
  if L >= X - X0 + 1 then
  begin
    P := Pointer(S);
    Inc(P, Length(S) - 1);
    while X >= X0 do
    begin
      C := Mask[X];
      if (C <> MaskChar) and (C <> P^) then
        Exit;
      Dec(X);
      Dec(P);
    end;
    Result := True;
  end;
end;

function Q_TestWildText(const S, Mask: String; MaskChar, WildCard: ansichar): boolean;
label
  99;
var
  L, X, X0, Q: integer;
  P, P1, B: pansichar;
  C: ansichar;
begin
  X := Q_StrScan(Mask, WildCard);
  Result := False;
  if X = 0 then
  begin
    L := Length(Mask);
    if (L > 0) and (L = Length(S)) then
    begin
      P := Pointer(S);
      B := Pointer(Mask);
      repeat
        C := B^;
        if (C <> MaskChar) and (C <> P^) and (ToUpperChars[byte(C)] <> ToUpperChars[byte(P^)]) then
          Exit;
        Dec(L);
        Inc(B);
        Inc(P);
      until L = 0;
      Result := True;
    end;
    Exit;
  end;
  L := Length(S);
  P := Pointer(S);
  B := Pointer(Mask);
  Q := X - 1;
  if L < Q then
    Exit;
  while Q > 0 do
  begin
    C := B^;
    if (C <> MaskChar) and (C <> P^) and (ToUpperChars[byte(C)] <> ToUpperChars[byte(P^)]) then
      Exit;
    Dec(Q);
    Inc(B);
    Inc(P);
  end;
  Dec(L, X - 1);
  repeat
    X0 := X;
    P1 := P;
    while Mask[X0] = WildCard do
      Inc(X0);
    X := Q_StrScan(Mask, WildCard, X0);
    if X = 0 then
      Break;
    99:
      P := P1;
    B := @Mask[X0];
    Q := X - X0;
    if L < Q then
      Exit;
    while Q > 0 do
    begin
      C := B^;
      if (C <> MaskChar) and (C <> P^) and (ToUpperChars[byte(C)] <> ToUpperChars[byte(P^)]) then
      begin
        Inc(P1);
        Dec(L);
        goto 99;
      end;
      Dec(Q);
      Inc(B);
      Inc(P);
    end;
    Dec(L, X - X0);
  until False;
  X := Length(Mask);
  if L >= X - X0 + 1 then
  begin
    P := Pointer(S);
    Inc(P, Length(S) - 1);
    while X >= X0 do
    begin
      C := Mask[X];
      if (C <> MaskChar) and (C <> P^) and (ToUpperChars[byte(C)] <> ToUpperChars[byte(P^)]) then
        Exit;
      Dec(X);
      Dec(P);
    end;
    Result := True;
  end;
end;


{ Функции для изменения регистра символов. }

function Q_CharUpper(Ch: ansichar): ansichar;
asm
         MOVZX   EDX,AL
         MOV     AL,BYTE PTR [EDX+ToUpperChars]
end;

function Q_CharLower(Ch: ansichar): ansichar;
asm
         MOVZX   EDX,AL
         MOV     AL,BYTE PTR [EDX+ToLowerChars]
end;

procedure Q_StrUpper(var S: String);
asm
         CALL    UniqueString
         TEST    EAX,EAX
         JE      @@2
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@2
         @@1:
         MOVZX   EDX,BYTE PTR [EAX+ECX]
         MOV     DL,BYTE PTR [EDX+ToUpperChars]
         MOV     BYTE PTR [EAX+ECX],DL
         DEC     ECX
         JNS     @@1
         @@2:
end;

{$IFDEF CPU32}
function Q_PStrUpper(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToUpperChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;
{$ELSE}

function Q_PStrUpper(P: pansichar): pansichar;
begin
  ShowMessage('Q_PStrUpper TODO');
end;

{$ENDIF}

procedure Q_StrLower(var S: String);
asm
         CALL    UniqueString
         TEST    EAX,EAX
         JE      @@2
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@2
         @@1:
         MOVZX   EDX,BYTE PTR [EAX+ECX]
         MOV     DL,BYTE PTR [EDX+ToLowerChars]
         MOV     BYTE PTR [EAX+ECX],DL
         DEC     ECX
         JNS     @@1
         @@2:
end;

{$IFDEF CPU32}
function Q_PStrLower(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToLowerChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;
{$ELSE}

function Q_PStrLower(P: pansichar): pansichar;
begin
  ShowMessage('Q_PStrLower TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_StrUpperMoveL(const Source: String; var Dest: String; MaxL: Cardinal);
asm
        MOV     EDX,[EDX]
        TEST    EAX,EAX
        JE      @@x2
        PUSH    EDI
        MOV     EDI,[EAX-4]
        TEST    EDI,EDI
        JE      @@x4
        CMP     ECX,EDI
        JB      @@x0
        MOV     ECX,EDI
@@x0:   MOV     [EDX-4],ECX
        MOV     BYTE PTR [ECX+EDX],$00
        DEC     ECX
        JS      @@qt
        MOV     EDI,EDX
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        MOV     BYTE PTR [EDI+ECX],DL
        DEC     ECX
        JNS     @@1
@@qt:   POP     EDI
        RET
@@x4:   POP     EDI
        XOR     EAX,EAX
@@x2:   TEST    EDX,EDX
        JE      @@x3
        MOV     [EDX-4],EAX
        MOV     BYTE PTR [EDX],AL
@@x3:
end;
{$ELSE}

procedure Q_StrUpperMoveL(const Source: String; var Dest: String; MaxL: cardinal);
begin
  ShowMessage('Q_StrUpperMoveL TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_StrLowerMoveL(const Source: String; var Dest: String; MaxL: Cardinal);
asm
        MOV     EDX,[EDX]
        TEST    EAX,EAX
        JE      @@x2
        PUSH    EDI
        MOV     EDI,[EAX-4]
        TEST    EDI,EDI
        JE      @@x4
        CMP     ECX,EDI
        JB      @@x0
        MOV     ECX,EDI
@@x0:   MOV     [EDX-4],ECX
        MOV     BYTE PTR [ECX+EDX],$00
        DEC     ECX
        JS      @@qt
        MOV     EDI,EDX
@@1:    MOVZX   EDX,BYTE PTR [EAX+ECX]
        MOV     DL,BYTE PTR [EDX+ToLowerChars]
        MOV     BYTE PTR [EDI+ECX],DL
        DEC     ECX
        JNS     @@1
@@qt:   POP     EDI
        RET
@@x4:   POP     EDI
        XOR     EAX,EAX
@@x2:   TEST    EDX,EDX
        JE      @@x3
        MOV     [EDX-4],EAX
        MOV     BYTE PTR [EDX],AL
@@x3:
end;
{$ELSE}

procedure Q_StrLowerMoveL(const Source: String; var Dest: String; MaxL: cardinal);
begin
  ShowMessage('Q_StrLowerMoveL TODO');
end;

{$ENDIF}

function Q_UpperCase(const S: String): String;
var
  L: integer;
begin
  L := Length(S);
  SetString(Result, nil, L);
  Q_StrUpperMoveL(S, Result, L);
end;

function Q_LowerCase(const S: String): String;
var
  L: integer;
begin
  L := Length(S);
  SetString(Result, nil, L);
  Q_StrLowerMoveL(S, Result, L);
end;

procedure Q_UpLowerInPlace(var S: String);
var
  P: pansichar;
begin
  if Length(S) <> 0 then
  begin
    Q_StrLower(S);
    P := Pointer(S);
    P^ := ToUpperChars[byte(P^)];
  end;
end;

function Q_UpLowerStr(const S: String): String;
var
  L: integer;
  P: pansichar;
begin
  L := Length(S);
  if L > 1 then
  begin
    SetString(Result, nil, L);
    Q_StrLowerMoveL(S, Result, L);
    P := Pointer(Result);
    P^ := ToUpperChars[byte(P^)];
  end
  else if L = 1 then
    Result := ToUpperChars[byte(S[1])]
  else
    Result := '';
end;

type
  PDelimsMap = ^TDelimsMap;
  TDelimsMap = array[#0..#255] of boolean;
  PDelimsArr = ^TDelimsArr;
  TDelimsArr = array[0..255] of boolean;

  pbyte = ^byte;
  PWord = ^word;
  PLong = ^longword;

threadvar
  UDelimsMap: TDelimsMap;
  PosTable: array[0..255] of byte;
  TableFindString: String;

procedure Q_ProperCaseInPlace(var S: String; const Delimiters: String); overload;
begin
  ShowMessage('Q_ProperCaseInPlace TODO');
end;

procedure Q_ProperCaseInPlace(var S: String; const Delimiters: TCharSet); overload;
var
  I: integer;
  P: pansichar;
  A: boolean;
begin
  Q_StrLower(S);
  P := Pointer(S);
  A := False;
  for I := 1 to Length(S) do
  begin
    if not (P^ in Delimiters) then
    begin
      if not A then
      begin
        A := True;
        P^ := ToUpperChars[byte(P^)];
      end;
    end
    else
      A := False;
    Inc(P);
  end;
end;

function Q_ProperCase(const S, Delimiters: String): String; overload;
begin
  ShowMessage('Q_ProperCase TODO');
end;

function Q_ProperCase(const S: String; const Delimiters: TCharSet): String; overload;
var
  I: integer;
  L: longword;
  P: pansichar;
  A: boolean;
begin
  L := Length(S);
  if L <> 0 then
  begin
    SetString(Result, nil, L);
    Q_StrLowerMoveL(S, Result, L);
    P := Pointer(Result);
    A := False;
    for I := 1 to L do
    begin
      if not (P^ in Delimiters) then
      begin
        if not A then
        begin
          A := True;
          P^ := ToUpperChars[byte(P^)];
        end;
      end
      else
        A := False;
      Inc(P);
    end;
  end
  else
    Result := '';
end;


{ Функции перекодировки строк: из DOS в Windows и наоборот. }

procedure Q_StrToAnsi(var S: String);
asm
         CALL    UniqueString
         TEST    EAX,EAX
         JE      @@2
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@2
         @@1:
         MOVZX   EDX,BYTE PTR [EAX+ECX]
         MOV     DL,BYTE PTR [EDX+ToAnsiChars]
         MOV     BYTE PTR [EAX+ECX],DL
         DEC     ECX
         JNS     @@1
         @@2:
end;

{$IFDEF CPU32}
function Q_PStrToAnsi(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToAnsiChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;
{$ELSE}

function Q_PStrToAnsi(P: pansichar): pansichar;
begin
  ShowMessage('Q_PStrToAnsi TODO');
end;

{$ENDIF}

procedure Q_StrToOem(var S: String);
asm
         CALL    UniqueString
         TEST    EAX,EAX
         JE      @@2
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@2
         @@1:
         MOVZX   EDX,BYTE PTR [EAX+ECX]
         MOV     DL,BYTE PTR [EDX+ToOemChars]
         MOV     BYTE PTR [EAX+ECX],DL
         DEC     ECX
         JNS     @@1
         @@2:
end;

{$IFDEF CPU32}
function Q_PStrToOem(P: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EAX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EDX+ToOemChars]
        MOV     BYTE PTR [EAX],CL
        INC     EAX
@@1:    MOVZX   EDX,BYTE PTR [EAX]
        TEST    DL,DL
        JNE     @@0
        POP     EAX
@@2:
end;
{$ELSE}

function Q_PStrToOem(P: pansichar): pansichar;
begin
  ShowMessage('Q_PStrToOem TODO');
end;

{$ENDIF}


{$IFDEF CPU32}
function Q_PStrToAnsiL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToAnsiChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;
{$ELSE}

function Q_PStrToAnsiL(P: pansichar; L: cardinal): pansichar;
begin
  ShowMessage('Q_PStrToAnsiL TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrToOemL(P: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     EDX
        JS      @@2
        PUSH    EBX
@@0:    MOVZX   EBX,BYTE PTR [EAX+EDX]
        MOV     CL,BYTE PTR [EBX+ToOemChars]
        MOV     BYTE PTR [EAX+EDX],CL
        DEC     EDX
        JNS     @@0
        POP     EBX
@@2:
end;
{$ELSE}

function Q_PStrToOemL(P: pansichar; L: cardinal): pansichar;
begin
  ShowMessage('Q_PStrToOemL TODO');
end;

{$ENDIF}

procedure Q_Str2ToAnsi(const Source: String; var Dest: String);
begin
  ShowMessage('Q_Str2ToAnsi TODO');
end;

{$IFDEF CPU32}
function Q_PStr2ToAnsi(Source, Dest: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EDX
        PUSH    EBX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EBX+ToAnsiChars]
        MOV     BYTE PTR [EDX],CL
        INC     EAX
        INC     EDX
@@1:    MOVZX   EBX,BYTE PTR [EAX]
        TEST    BL,BL
        JNE     @@0
        POP     EBX
        POP     EAX
        RET
@@2:    MOV     EAX,EDX
end;
{$ELSE}

function Q_PStr2ToAnsi(Source, Dest: pansichar): pansichar;
asm
         TEST    EAX,EAX
         JE      @@2
         PUSH    RDX
         PUSH    RBX
         JMP     @@1
         @@0:
         MOV     CL,BYTE PTR [EBX+ToAnsiChars]
         MOV     BYTE PTR [EDX],CL
         INC     EAX
         INC     EDX
         @@1:
         MOVZX   EBX,BYTE PTR [EAX]
         TEST    BL,BL
         JNE     @@0
         POP     RBX
         POP     RAX
         RET
         @@2:
         MOV     EAX,EDX
end;
{$ENDIF}

procedure Q_Str2ToOem(const Source: String; var Dest: String);
begin
  ShowMessage('Q_Str2ToOem TODO');
end;

{$IFDEF CPU32}
function Q_PStr2ToOem(Source, Dest: PAnsiChar): PAnsiChar;
asm
        TEST    EAX,EAX
        JE      @@2
        PUSH    EDX
        PUSH    EBX
        JMP     @@1
@@0:    MOV     CL,BYTE PTR [EBX+ToOemChars]
        MOV     BYTE PTR [EDX],CL
        INC     EAX
        INC     EDX
@@1:    MOVZX   EBX,BYTE PTR [EAX]
        TEST    BL,BL
        JNE     @@0
        POP     EBX
        POP     EAX
        RET
@@2:    MOV     EAX,EDX
end;
{$ELSE}

function Q_PStr2ToOem(Source, Dest: pansichar): pansichar;
begin
  ShowMessage('Q_PStr2ToOem TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStr2ToAnsiL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToAnsiChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;
{$ELSE}
type
  TacArray = array [0..MaxInt - 1] of ansichar;

function Q_PStr2ToAnsiL(Source, Dest: pansichar; L: cardinal): pansichar;
var
  I: integer;
begin
  Dest := '';
  for I := 0 to L - 1 do
    TacArray(Dest)[I] := TacArray(Source)[I];
  Result := Dest;
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStr2ToOemL(Source, Dest: PAnsiChar; L: Cardinal): PAnsiChar;
asm
        DEC     ECX
        JS      @@2
        PUSH    EBX
@@1:    MOVZX   EBX,BYTE PTR [EAX+ECX]
        MOV     BL,BYTE PTR [EBX+ToOemChars]
        MOV     BYTE PTR [EDX+ECX],BL
        DEC     ECX
        JNS     @@1
        POP     EBX
@@2:    MOV     EAX,EDX
end;
{$ELSE}

function Q_PStr2ToOemL(Source, Dest: pansichar; L: cardinal): pansichar;
begin
  ShowMessage('Q_PStr2ToOemL TODO');
end;

{$ENDIF}

function Q_ToAnsi(const OemStr: String): String;
var
  L: integer;
begin
  L := Length(OemStr);
  SetString(Result, nil, L);
  Q_PStr2ToAnsiL(Pointer(OemStr), Pointer(Result), L);
end;

function Q_ToOem(const AnsiStr: String): String;
var
  L: integer;
begin
  L := Length(AnsiStr);
  SetString(Result, nil, L);
  Q_PStr2ToOemL(Pointer(AnsiStr), Pointer(Result), L);
end;


{ Поиск, замена и удаление подстрок и отдельных символов. }

{$IFDEF CPU32}
function Q_PosStr(const FindString, SourceString: String; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        SUB     EDX,ECX
        JNG     @@qt0
        XCHG    EAX,EDX
        ADD     EDI,ECX
        MOV     ECX,EAX
        JMP     @@nx
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qt0
@@nx:   MOV     EBX,EDX
        MOV     AL,BYTE PTR [ESI]
@@lp1:  CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        SUB     EAX,[ESP]
        POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosStr(const FindString, SourceString: String; StartPos: integer): integer;
begin
  ShowMessage('Q_PosStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PosText(const FindString, SourceString: String; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        PUSH    EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        PUSH    EAX
        SUB     EDX,ECX
        JNG     @@qtx
        ADD     EDI,ECX
        MOV     ECX,EDX
        MOV     EDX,EAX
        MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
@@lp1:  MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qtx:  ADD     ESP,$08
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
        RET
@@ms:   MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOV     EDX,[ESP]
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     BL,BYTE PTR [ESI+EDX]
        MOV     AH,BYTE PTR [EDI+EDX]
        CMP     BL,AH
        JE      @@eq
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOVZX   EBX,AH
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JNE     @@ms
@@eq:   DEC     EDX
        JNZ     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        POP     ECX
        SUB     EAX,[ESP]
        POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosText(const FindString, SourceString: String; StartPos: integer): integer;
begin
  ShowMessage('Q_PosText TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PosStrLimited(const FindString, SourceString: String;
  StartPos, EndPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX,EAX
        JE      @@ex
        TEST    EDX,EDX
        JE      @@qt0
        MOV     EBX,[ESP+24]
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        CMP     EBX,EDX
        JG      @@sk
        MOV     EDX,EBX
@@sk:   DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        SUB     EDX,ECX
        JNG     @@qt0
        XCHG    EAX,EDX
        ADD     EDI,ECX
        MOV     ECX,EAX
        JMP     @@nx
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qt0
@@nx:   MOV     EBX,EDX
        MOV     AL,BYTE PTR [ESI]
@@lp1:  CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qt0
        CMP     AL,BYTE PTR [EDI]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
        JMP     @@ex
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JE      @@fd
        MOV     AL,BYTE PTR [ESI+EBX]
        CMP     AL,BYTE PTR [EDI+EBX]
        JNE     @@fr
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        SUB     EAX,[ESP]
@@ex:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosStrLimited(const FindString, SourceString: String; StartPos, EndPos: integer): integer;
begin
  ShowMessage('Q_PosStrLimited TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PosTextLimited(const FindString, SourceString: String;
  StartPos, EndPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@ex
        TEST    EDX,EDX
        JE      @@qt0
        MOV     EBX,[ESP+20]
        MOV     ESI,EAX
        MOV     EDI,EDX
        PUSH    EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        CMP     EBX,EDX
        JG      @@sk
        MOV     EDX,EBX
@@sk:   DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        PUSH    EAX
        SUB     EDX,ECX
        JNG     @@qtx
        ADD     EDI,ECX
        MOV     ECX,EDX
        MOV     EDX,EAX
        MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
@@lp1:  MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JE      @@qtx
        MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qtx:  ADD     ESP,$08
@@qt0:  XOR     EAX,EAX
        JMP     @@ex
@@ms:   MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOV     EDX,[ESP]
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     BL,BYTE PTR [ESI+EDX]
        MOV     AH,BYTE PTR [EDI+EDX]
        CMP     BL,AH
        JE      @@eq
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOVZX   EBX,AH
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JNE     @@ms
@@eq:   DEC     EDX
        JNZ     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        POP     ECX
        SUB     EAX,[ESP]
        POP     ECX
@@ex:   POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosTextLimited(const FindString, SourceString: String; StartPos, EndPos: integer): integer;
begin
  ShowMessage('Q_PosTextLimited TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PosLastStr(const FindString, SourceString: String;
  LastPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        DEC     ECX
        JLE     @@qt0
        MOV     ESI,EAX
        LEA     EDI,[EDX-1]
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        CMP     ECX,EDX
        JL      @@nu
        MOV     ECX,EDX
@@nu:   SUB     ECX,EAX
        JLE     @@qt0
        JMP     @@ft
@@nx:   SUB     EDI,ECX
        DEC     ECX
        JE      @@qt0
@@ft:   MOV     DL,BYTE PTR [ESI]
@@lp1:  CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        CMP     DL,BYTE PTR [EDI+ECX]
        JE      @@uu
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EAX,EAX
        JE      @@fd
        ADD     EDI,ECX
        MOV     EBX,EAX
@@lp2:  MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JE      @@fd
        MOV     DL,BYTE PTR [ESI+EBX]
        CMP     DL,BYTE PTR [EDI+EBX]
        JNE     @@nx
        DEC     EBX
        JNE     @@lp2
@@fd:   MOV     EAX,ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosLastStr(const FindString, SourceString: String; LastPos: integer): integer;
begin
  ShowMessage('Q_PosLastStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PosLastText(const FindString, SourceString: String;
  LastPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EBP
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        DEC     ECX
        JLE     @@qt0
        MOV     ESI,EAX
        LEA     EDI,[EDX-1]
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        CMP     ECX,EDX
        JL      @@nu
        MOV     ECX,EDX
@@nu:   SUB     ECX,EAX
        JLE     @@qt0
        JMP     @@ft
@@nx:   SUB     EDI,ECX
        DEC     ECX
        JE      @@qt0
@@ft:   MOVZX   EBP,BYTE PTR [ESI]
        MOV     DL,BYTE PTR [EBP+ToUpperChars]
@@lp1:  MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JE      @@qt0
        MOVZX   EBP,BYTE PTR [EDI+ECX]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JE      @@uu
        DEC     ECX
        JNE     @@lp1
@@qt0:  XOR     EAX,EAX
@@qt:   POP     EBP
        POP     EBX
        POP     EDI
        POP     ESI
        RET
@@uu:   TEST    EAX,EAX
        JE      @@fd
        ADD     EDI,ECX
        MOV     EBX,EAX
@@lp2:  MOVZX   EDX,BYTE PTR [ESI+EBX]
        MOVZX   EBP,BYTE PTR [EDI+EBX]
        CMP     EDX,EBP
        JE      @@ws
        MOV     DL,BYTE PTR [EDX+ToUpperChars]
        CMP     DL,BYTE PTR [EBP+ToUpperChars]
        JNE     @@nx
@@ws:   DEC     EBX
        JNE     @@lp2
@@fd:   MOV     EAX,ECX
        POP     EBP
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

function Q_PosLastText(const FindString, SourceString: String; LastPos: integer): integer;
begin
  ShowMessage('Q_PosLastText TODO');
end;

{$ENDIF}

procedure Q_InitTablePosStr(const FindString: String);
begin
  ShowMessage('Q_InitTablePosStr TODO');
end;

function Q_TablePosStr(const SourceString: String; var LastPos: integer): boolean;
begin
  ShowMessage('Q_TablePosStr TODO');
end;

procedure Q_InitTablePosText(const FindString: String);
begin
  ShowMessage('Q_InitTablePosText TODO');
end;

function Q_TablePosText(const SourceString: String; var LastPos: integer): boolean;
begin
  ShowMessage('Q_TablePosText TODO');
end;

{$IFDEF CPU32}
function Q_ReplaceStr(const SourceString, FindString, ReplaceString: String): String;
var
  P,PS: PAnsiChar;
  L,L1,L2,Cnt: Integer;
  I,J,K,M: Integer;
begin
  L1 := Length(FindString);
  Cnt := 0;
  I := Q_PosStr(FindString,SourceString,1);
  while I <> 0 do
  begin
    Inc(I,L1);
    asm
      PUSH    I
    end;
    Inc(Cnt);
    I := Q_PosStr(FindString,SourceString,I);
  end;
  if Cnt <> 0 then
  begin
    L := Length(SourceString);
    L2 := Length(ReplaceString);
    J := L+1;
    Inc(L,(L2-L1)*Cnt);
    if L <> 0 then
    begin
      SetString(Result,nil,L);
      P := Pointer(Result);
      Inc(P, L);
//{$IFDEF CPU32}
      PS := Pointer(LongWord(SourceString)-1);
//{$ELSE}
//      PS := Pointer(Int64(SourceString)-1); // TODO64?
//{$ENDIF}
      if L2 <= 32 then
        for I := 0 to Cnt-1 do
        begin
          asm
            POP     K
          end;
          M := J-K;
          if M > 0 then
          begin
            Dec(P,M);
            Q_CopyMem(@PS[K],P,M);
          end;
          Dec(P,L2);
          Q_TinyCopy(Pointer(ReplaceString),P,L2);
          J := K-L1;
        end
      else
        for I := 0 to Cnt-1 do
        begin
          asm
            POP     K
          end;
          M := J-K;
          if M > 0 then
          begin
            Dec(P,M);
            Q_CopyMem(@PS[K],P,M);
          end;
          Dec(P,L2);
          Q_CopyMem(Pointer(ReplaceString),P,L2);
          J := K-L1;
        end;
      Dec(J);
      if J > 0 then
        Q_CopyMem(Pointer(SourceString),Pointer(Result),J);
    end else
    begin
      Result := '';
      for I := 0 to Cnt-1 do
      asm
            POP     K
      end;
    end;
  end else
    Result := SourceString;
end;
{$ELSE}

function Q_ReplaceStr(const SourceString, FindString, ReplaceString: String): String;
begin
  ShowMessage('Q_ReplaceStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ReplaceText(const SourceString, FindString, ReplaceString: String): String;
var
  P,PS: PAnsiChar;
  L,L1,L2,Cnt: Integer;
  I,J,K,M: Integer;
begin
  L1 := Length(FindString);
  Cnt := 0;
  I := Q_PosText(FindString,SourceString,1);
  while I <> 0 do
  begin
    Inc(I,L1);
    asm
      PUSH    I
    end;
    Inc(Cnt);
    I := Q_PosText(FindString,SourceString,I);
  end;
  if Cnt <> 0 then
  begin
    L := Length(SourceString);
    L2 := Length(ReplaceString);
    J := L+1;
    Inc(L,(L2-L1)*Cnt);
    if L <> 0 then
    begin
      SetString(Result,nil,L);
      P := Pointer(Result);
      Inc(P, L);
      PS := Pointer(LongWord(SourceString)-1);
      if L2 <= 32 then
        for I := 0 to Cnt-1 do
        begin
          asm
            POP     K
          end;
          M := J-K;
          if M > 0 then
          begin
            Dec(P,M);
            Q_CopyMem(@PS[K],P,M);
          end;
          Dec(P,L2);
          Q_TinyCopy(Pointer(ReplaceString),P,L2);
          J := K-L1;
        end
      else
        for I := 0 to Cnt-1 do
        begin
          asm
            POP     K
          end;
          M := J-K;
          if M > 0 then
          begin
            Dec(P,M);
            Q_CopyMem(@PS[K],P,M);
          end;
          Dec(P,L2);
          Q_CopyMem(Pointer(ReplaceString),P,L2);
          J := K-L1;
        end;
      Dec(J);
      if J > 0 then
        Q_CopyMem(Pointer(SourceString),Pointer(Result),J);
    end else
    begin
      Result := '';
      for I := 0 to Cnt-1 do
      asm
            POP     K
      end;
    end;
  end else
    Result := SourceString;
end;
{$ELSE}

function Q_ReplaceText(const SourceString, FindString, ReplaceString: String): String;
begin
  ShowMessage('Q_ReplaceText TODO');
end;

{$ENDIF}

function Q_ReplaceFirstStr(var S: String; const FindString, ReplaceString: String; StartPos: integer): integer;
begin
  Result := Q_PosStr(FindString, S, StartPos);
  if Result <> 0 then
    Q_PasteStr(S, Result, Length(FindString), ReplaceString);
end;

function Q_ReplaceFirstText(var S: String; const FindString, ReplaceString: String; StartPos: integer): integer;
begin
  Result := Q_PosText(FindString, S, StartPos);
  if Result <> 0 then
    Q_PasteStr(S, Result, Length(FindString), ReplaceString);
end;

function Q_ReplaceLastStr(var S: String; const FindString, ReplaceString: String; LastPos: integer): integer;
begin
  Result := Q_PosLastStr(FindString, S, LastPos);
  if Result <> 0 then
    Q_PasteStr(S, Result, Length(FindString), ReplaceString);
end;

function Q_ReplaceLastText(var S: String; const FindString, ReplaceString: String; LastPos: integer): integer;
begin
  Result := Q_PosLastText(FindString, S, LastPos);
  if Result <> 0 then
    Q_PasteStr(S, Result, Length(FindString), ReplaceString);
end;

function Q_DeleteStr(var S: String; const SubStrToDel: String): integer;
var
  I, L1: integer;
begin
  L1 := Length(SubStrToDel);
  I := Q_PosStr(SubStrToDel, S, 1);
  Result := 0;
  while I <> 0 do
  begin
    Q_Delete(S, I, L1);
    I := Q_PosStr(SubStrToDel, S, I);
    Inc(Result);
  end;
end;

function Q_DeleteText(var S: String; const SubStrToDel: String): integer;
var
  I, L1: integer;
begin
  L1 := Length(SubStrToDel);
  I := Q_PosText(SubStrToDel, S, 1);
  Result := 0;
  while I <> 0 do
  begin
    Q_Delete(S, I, L1);
    I := Q_PosText(SubStrToDel, S, I);
    Inc(Result);
  end;
end;

function Q_DeleteFirstStr(var S: String; const SubStrToDel: String; StartPos: integer): integer;
begin
  Result := Q_PosStr(SubStrToDel, S, StartPos);
  if Result <> 0 then
    Q_Delete(S, Result, Length(SubStrToDel));
end;

function Q_DeleteFirstText(var S: String; const SubStrToDel: String; StartPos: integer): integer;
begin
  Result := Q_PosText(SubStrToDel, S, StartPos);
  if Result <> 0 then
    Q_Delete(S, Result, Length(SubStrToDel));
end;

function Q_DeleteLastStr(var S: String; const SubStrToDel: String; LastPos: integer): integer;
begin
  Result := Q_PosLastStr(SubStrToDel, S, LastPos);
  if Result <> 0 then
    Q_Delete(S, Result, Length(SubStrToDel));
end;

function Q_DeleteLastText(var S: String; const SubStrToDel: String; LastPos: integer): integer;
begin
  Result := Q_PosLastText(SubStrToDel, S, LastPos);
  if Result <> 0 then
    Q_Delete(S, Result, Length(SubStrToDel));
end;

{$IFDEF CPU32}
function Q_ReplaceChar(var S: String; ChOld, ChNew: AnsiChar): Integer;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        MOV     ESI,EDX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,EBX
        MOV     EDX,ESI
        MOV     EBX,[EAX-4]
        TEST    EBX,EBX
        JE      @@zq
        LEA     ESI,[EAX-1]
        XOR     EAX,EAX
@@lp:   CMP     DL,BYTE PTR [ESI+EBX]
        JE      @@fn
        DEC     EBX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@fn:   MOV     BYTE PTR [ESI+EBX],CL
        INC     EAX
        DEC     EBX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:   POP     ESI
        POP     EBX
end;
{$ELSE}

function Q_ReplaceChar(var S: String; ChOld, ChNew: ansichar): integer;
begin
  ShowMessage('Q_ReplaceChar TODO');
end;

{$ENDIF}

procedure Int256Chars(P: Pointer);
asm
         MOV     ECX,8
         MOV     EDX,$03020100
         @@lp:
         MOV     [EAX],EDX
         ADD     EDX,$04040404
         MOV     [EAX+4],EDX
         ADD     EDX,$04040404
         MOV     [EAX+8],EDX
         ADD     EDX,$04040404
         MOV     [EAX+12],EDX
         ADD     EDX,$04040404
         MOV     [EAX+16],EDX
         ADD     EDX,$04040404
         MOV     [EAX+20],EDX
         ADD     EDX,$04040404
         MOV     [EAX+24],EDX
         ADD     EDX,$04040404
         MOV     [EAX+28],EDX
         ADD     EDX,$04040404
         ADD     EAX,32
         DEC     ECX
         JNE     @@lp
end;

procedure Q_ReplaceChars(var S: String; const StrChOld, StrChNew: String);
var
  Map: array[#0..#255] of ansichar;
  I, J: integer;
  P: pansichar;
begin
  J := Length(StrChOld);
  Int256Chars(@Map);
  if J <> Length(StrChNew) then
    raise Exception.Create('Неправильный вызов функции Q_ReplaceChars');
  for I := 1 to J do
    Map[StrChOld[I]] := StrChNew[I];
  if J > 0 then
  begin
    UniqueString(S);
    P := Pointer(S);
    for I := 1 to Length(S) do
    begin
      P^ := Map[P^];
      Inc(P);
    end;
  end;
end;

{$IFDEF CPU32}
procedure Q_ReplaceCharsByOneChar(var S: String; const ChOldSet: TCharSet; ChNew: AnsiChar);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EDX
        MOV     BL,CL
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EDI,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EAX
@@lp1:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JC      @@rp
@@nx1:  MOV     BYTE PTR [EDI],DL
        INC     EAX
        INC     EDI
        DEC     ECX
        JNE     @@lp1
@@nx2:  POP     EAX
        MOV     BYTE PTR [EDI],0
        SUB     EDI,EAX
        MOV     [EAX-4],EDI
@@qt:   POP     EDI
        POP     ESI
        POP     EBX
        RET
@@rp:   MOV     BYTE PTR [EDI],BL
        INC     EAX
        INC     EDI
        DEC     ECX
        JE      @@nx2
@@lp2:  MOVZX   EDX,BYTE PTR [EAX]
        BT      [ESI],EDX
        JNC     @@nx1
        INC     EAX
        DEC     ECX
        JNE     @@lp2
        JMP     @@nx2
end;
{$ELSE}

procedure Q_ReplaceCharsByOneChar(var S: String; const ChOldSet: TCharSet; ChNew: ansichar);
begin
  ShowMessage('Q_ReplaceCharsByOneChar TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_StrScan(const S: String; Ch: AnsiChar; StartPos: Integer): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EDI
        MOV     EDI,EAX
        LEA     EAX,[ECX-1]
        MOV     ECX,[EDI-4]
        SUB     ECX,EAX
        JLE     @@m1
        PUSH    EDI
        ADD     EDI,EAX
        MOV     EAX,EDX
        POP     EDX
        REPNE   SCASB
        JNE     @@m1
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        RET
@@m1:   POP     EDI
        XOR     EAX,EAX
@@qt:
end;
{$ELSE}

function Q_StrScan(const S: String; Ch: ansichar; StartPos: integer): integer;
begin
  ShowMessage('Q_StrScan TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrScan(P: Pointer; Ch: AnsiChar; StartPos: Integer): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EDI
        MOV     EDI,EAX
        LEA     EAX,[ECX-1]
        MOV     ECX,[EDI-4]
        SUB     ECX,EAX
        JLE     @@m1
        PUSH    EDI
        ADD     EDI,EAX
        MOV     EAX,EDX
        POP     EDX
        REPNE   SCASB
        JNE     @@m1
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        RET
@@m1:   POP     EDI
        XOR     EAX,EAX
@@qt:
end;
{$ELSE}

function Q_PStrScan(P: Pointer; Ch: ansichar; StartPos: integer): integer;
begin
  ShowMessage('Q_PStrScan TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_StrRScan(const S: String; Ch: AnsiChar; LastPos: Integer): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        DEC     ECX
        JS      @@m1
        MOV     EBX,[EAX-4]
        PUSH    EDI
        CMP     ECX,EBX
        JA      @@ch
	TEST	ECX,ECX
	JE	@@m2
@@nx:   LEA     EDI,[EAX+ECX-1]
        STD
        XCHG    EAX,EDX
        REPNE   SCASB
        INC     EDI
        CLD
        CMP     AL,BYTE PTR [EDI]
        JNE     @@m2
        SUB     EDI,EDX
        MOV     EAX,EDI
        POP     EDI
        INC     EAX
        POP     EBX
        RET
@@ch:   MOV     ECX,EBX
	TEST	EBX,EBX
        JNE	@@nx
@@m2:   POP     EDI
@@m1:   XOR     EAX,EAX
	POP     EBX
@@qt:
end;
{$ELSE}

function Q_StrRScan(const S: String; Ch: ansichar; LastPos: integer): integer;
begin
  ShowMessage('Q_StrRScan TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrRScan(P: Pointer; Ch: AnsiChar; LastPos: Integer): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        DEC     ECX
        JS      @@m1
        MOV     EBX,[EAX-4]
        PUSH    EDI
        CMP     ECX,EBX
        JA      @@ch
	TEST	ECX,ECX
	JE	@@m2
@@nx:   LEA     EDI,[EAX+ECX-1]
        STD
        XCHG    EAX,EDX
        REPNE   SCASB
        INC     EDI
        CLD
        CMP     AL,BYTE PTR [EDI]
        JNE     @@m2
        SUB     EDI,EDX
        MOV     EAX,EDI
        POP     EDI
        INC     EAX
        POP     EBX
        RET
@@ch:   MOV     ECX,EBX
	TEST	EBX,EBX
        JNE	@@nx
@@m2:   POP     EDI
@@m1:   XOR     EAX,EAX
	POP     EBX
@@qt:
end;
{$ELSE}

function Q_PStrRScan(P: Pointer; Ch: ansichar; LastPos: integer): integer;
begin
  ShowMessage('Q_PStrRScan TODO');
end;

{$ENDIF}

function Q_StrSpn(const S, Delimiters: String; StartPos: cardinal): integer; overload;
begin
  ShowMessage('Q_StrSpn TODO');
end;

function Q_StrSpn(const S: String; StartPos: cardinal; const Delimiters: TCharSet): integer; overload;
var
  L: longword;
  P: pansichar;
begin
  L := Length(S);
  if L >= StartPos then
  begin
    P := Pointer(S);
    Inc(L, longword(P));
    Inc(P, StartPos - 1);
    while (longword(P) < L) and (P^ in Delimiters) do Inc(P);
    if longword(P) < L then
      Result := integer(P) - integer(Pointer(S)) + 1
    else
      Result := 0;
  end
  else
    Result := 0;
end;

function Q_StrCSpn(const S, Delimiters: String; StartPos: cardinal): integer; overload;
begin
  ShowMessage('Q_StrCSpn TODO');
end;

function Q_StrCSpn(const S: String; StartPos: cardinal; const Delimiters: TCharSet): integer; overload;
var
  L: longword;
  P: pansichar;
begin
  L := Length(S);
  if L >= StartPos then
  begin
    P := Pointer(S);
    Inc(L, longword(P));
    Inc(P, StartPos - 1);
    while (longword(P) < L) and not (P^ in Delimiters) do Inc(P);
    if longword(P) < L then
      Result := integer(P) - integer(Pointer(S)) + 1
    else
      Result := 0;
  end
  else
    Result := 0;
end;

procedure Q_DelCharInPlace(var S: String; Ch: ansichar);
begin
  ShowMessage('Q_DelCharInPlace TODO');
end;

function Q_DelChar(const S: String; Ch: ansichar): String;
begin
  ShowMessage('Q_DelChar TODO');
end;

procedure Q_Delete(var S: String; Index, Count: integer);
begin
  ShowMessage('Q_Delete TODO');
end;

{$IFDEF CPU32}
procedure Q_DelChars(var S: String; const CharsToRemove: String); overload;
var
  Map: array[#0..#255] of Boolean;
  I,L: Integer;
  P,P1: PAnsiChar;
  PK: ^LongWord;
begin
  Q_FillLong(0,@Map,64);
  for I := 1 to Length(CharsToRemove) do
    Map[CharsToRemove[I]] := True;
  I := 1;
  L := Length(S);
  while (I<=L) and not Map[S[I]] do Inc(I);
  if I <= L then
  begin
    UniqueString(S);
    P := Pointer(S);
    PK := Pointer(S);
    Inc(P,I-1);
    P1 := P;
    Inc(LongWord(PK),L);
    Inc(P1);
    while P1 < PChar(PK) do
    begin
      if not Map[P1^] then
      begin
        P^ := P1^;
        Inc(P);
      end;
      Inc(P1);
    end;
    P1 := Pointer(S);
    if P <> P1 then
    begin
      PK := Pointer(S);
      P^ := #0;
      Dec(PK);
      PK^ := LongWord(P)-LongWord(P1);
    end else
      S := '';
  end;
end;
{$ELSE}

procedure Q_DelChars(var S: String; const CharsToRemove: String); overload;
begin
  ShowMessage('Q_DelChars TODO');
end;

{$ENDIF}

procedure Q_DelChars(var S: String; const CharsToRemove: TCharSet); overload;
begin
  ShowMessage('Q_DelChars TODO');
end;

{$IFDEF CPU32}
procedure Q_KeepChars(var S: String; const CharsToKeep: String); overload;
var
  Map: array[#0..#255] of Boolean;
  I,L: Integer;
  P,P1: PAnsiChar;
  PK: ^LongWord;
begin
  Q_FillLong(0,@Map,64);
  for I := 1 to Length(CharsToKeep) do
    Map[CharsToKeep[I]] := True;
  I := 1;
  L := Length(S);
  while (I<=L) and Map[S[I]] do Inc(I);
  if I <= L then
  begin
    UniqueString(S);
    P := Pointer(S);
    PK := Pointer(S);
    Inc(P,I-1);
    P1 := P;
    Inc(LongWord(PK),L);
    Inc(P1);
    while P1 < PChar(PK) do
    begin
      if Map[P1^] then
      begin
        P^ := P1^;
        Inc(P);
      end;
      Inc(P1);
    end;
    P1 := Pointer(S);
    if P <> P1 then
    begin
      PK := Pointer(S);
      P^ := #0;
      Dec(PK);
      PK^ := LongWord(P)-LongWord(P1);
    end else
      S := '';
  end;
end;
{$ELSE}

procedure Q_KeepChars(var S: String; const CharsToKeep: String); overload;
begin
  ShowMessage('Q_KeepChars TODO');
end;

{$ENDIF}

procedure Q_KeepChars(var S: String; const CharsToKeep: TCharSet); overload;
begin
  ShowMessage('Q_KeepChars TODO');
end;

function Q_ApplyMask(const Mask, SourceStr: String; MaskChar: ansichar): String;
begin
  ShowMessage('Q_ApplyMask TODO');
end;

{$IFDEF CPU32}
procedure Q_ApplyMaskInPlace(var Mask: String; const SourceStr: String; MaskChar: AnsiChar);
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        MOV     ESI,EDX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@qt
        MOV     EDX,[ESI-4]
        LEA     ESI,[ESI+EDX-1]
@@lp:   CMP     BL,BYTE PTR [EAX+ECX]
        JNE     @@nx1
        MOV     DL,BYTE PTR [ESI]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ESI
@@nx1:  DEC     ECX
        JS      @@qt
        CMP     BL,BYTE PTR [EAX+ECX]
        JNE     @@nx2
        MOV     DL,BYTE PTR [ESI]
        MOV     BYTE PTR [EAX+ECX],DL
        DEC     ESI
@@nx2:  DEC     ECX
        JNS     @@lp
@@qt:   POP     ESI
        POP     EBX
end;
{$ELSE}

procedure Q_ApplyMaskInPlace(var Mask: String; const SourceStr: String; MaskChar: ansichar);
begin
  ShowMessage('Q_ApplyMaskInPlace TODO');
end;

{$ENDIF}

function Q_ExtractByMask(const S, Mask: String; MaskChar: ansichar): String;
begin
  ShowMessage('Q_ExtractByMask TODO');
end;

procedure Q_ExtractByMaskInPlace(var S: String; const Mask: String; MaskChar: ansichar);
begin
  ShowMessage('Q_ExtractByMaskInPlace TODO');
end;


{ Форматирование строк, вырезка фрагментов строки. }

procedure Q_TrimInPlace(var S: String);
begin
  ShowMessage('Q_TrimInPlace TODO');
end;

procedure Q_TrimLeftInPlace(var S: String);
begin
  ShowMessage('Q_TrimLeftInPlace TODO');
end;

procedure Q_TrimRightInPlace(var S: String);
begin
  ShowMessage('Q_TrimRightInPlace TODO');
end;

function Q_TrimChar(const S: String; Ch: ansichar): String;
begin
  ShowMessage('Q_TrimChar TODO');
end;

function Q_TrimCharLeft(const S: String; Ch: ansichar): String;
begin
  ShowMessage('Q_TrimCharLeft TODO');
end;

function Q_TrimCharRight(const S: String; Ch: ansichar): String;
begin
  ShowMessage('Q_TrimCharRight TODO');
end;

function Q_KeepOneChar(const S: String; Ch: ansichar): String;
begin
  ShowMessage('Q_KeepOneChar TODO');
end;

{$IFDEF CPU32}
procedure Q_SpaceCompressInPlace(var S: String);
asm
        PUSH    EBX
        PUSH    EAX
        CALL    UniqueString
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        MOV     EBX,EAX
        DEC     ECX
        JS      @@qt
        MOV     EDX,EAX
@@lp0:  CMP     BYTE PTR [EAX+ECX],$20
        JA      @@lp1
        DEC     ECX
        JNS     @@lp0
        JMP     @@nx4
@@lp1:  CMP     BYTE PTR [EBX],$20
        JA      @@lp3
        INC     EBX
        DEC     ECX
        JMP     @@lp1
@@lp3:  MOV     AL,BYTE PTR [EBX]
        INC     EBX
        CMP     AL,$20
        JBE     @@me
@@nx3:  MOV     BYTE PTR [EDX],AL
        INC     EDX
        DEC     ECX
        JNS     @@lp3
@@nx4:  POP     EAX
        MOV     EBX,[EAX]
        MOV     BYTE PTR [EDX],0
        SUB     EDX,EBX
        MOV     [EBX-4],EDX
        POP     EBX
        RET
@@me:   MOV     BYTE PTR [EDX],$20
        INC     EDX
        DEC     ECX
        JS      @@nx4
@@ml:   MOV     AL,BYTE PTR [EBX]
        INC     EBX
        CMP     AL,$20
        JA      @@nx3
        DEC     ECX
        JNS     @@ml
        JMP     @@nx4
@@qt:   POP     ECX
        POP     EBX
end;
{$ELSE}

procedure Q_SpaceCompressInPlace(var S: String);
begin
  ShowMessage('Q_SpaceCompressInPlace TODO');
end;

{$ENDIF}

function Q_SpaceCompress(const S: String): String;
begin
  ShowMessage('Q_SpaceCompress TODO');
end;

function Q_PadLeft(const S: String; Length: integer; PadCh: ansichar; Cut: boolean): String;
var
  K, L: integer;
  P: ^byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    Q_FillChar(P, K, PadCh);
    if L > 0 then
    begin
      Inc(P, K);
      Q_CopyMem(Pointer(S), P, L);
    end;
  end
  else if (K <> 0) and Cut then
    Result := Copy(S, 1, Length)
  else
    Result := S;
end;

function Q_PadRight(const S: String; Length: integer; PadCh: ansichar; Cut: boolean): String;
var
  K, L: integer;
  P: ^byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    if L > 0 then
    begin
      Q_CopyMem(Pointer(S), P, L);
      Inc(P, L);
    end;
    Q_FillChar(P, K, PadCh);
  end
  else if (K <> 0) and Cut then
    Result := Copy(S, 1, Length)
  else
    Result := S;
end;

function Q_CenterStr(const S: String; Length: integer; PadCh: ansichar; Cut: boolean): String;
var
  K, L: integer;
  P: ^byte;
begin
  L := System.Length(S);
  K := Length - L;
  if K > 0 then
  begin
    SetString(Result, nil, Length);
    P := Pointer(Result);
    Q_FillChar(P, K shr 1, PadCh);
    Inc(P, K shr 1);
    if L > 0 then
    begin
      Q_CopyMem(Pointer(S), P, L);
      Inc(P, L);
    end;
    Q_FillChar(P, K - K shr 1, PadCh);
  end
  else if (K <> 0) and Cut then
    Result := Copy(S, 1, Length)
  else
    Result := S;
end;

function Q_PadInside(const S: String; Length: integer; PadCh: ansichar; Cut: boolean): String;
var
  N, I, K: integer;
  P: ^ansichar;
  C: ansichar;
begin
  I := Length - System.Length(S);
  if I > 0 then
  begin
    N := Q_CharCount(S, PadCh);
    if N <> 0 then
    begin
      SetString(Result, nil, Length);
      P := Pointer(Result);
      K := I div N;
      N := I - K * N;
      for I := 1 to System.Length(S) do
      begin
        C := S[I];
        P^ := C;
        Inc(P);
        if C = PadCh then
        begin
          Q_FillChar(P, K, PadCh);
          Inc(P, K);
          if N <> 0 then
          begin
            Dec(N);
            P^ := PadCh;
            Inc(P);
          end;
        end;
      end;
    end
    else
      Result := S;
  end
  else if (I <> 0) and Cut then
    Result := Copy(S, 1, Length)
  else
    Result := S;
end;

function Q_TabsToSpaces(const S: String; TabStop: integer): String;
var
  I, L, T: integer;
  P: ^ansichar;
begin
  T := TabStop;
  L := 0;
  for I := 1 to Length(S) do
    if S[I] <> #9 then
    begin
      Inc(L);
      Dec(T);
      if T = 0 then
        T := TabStop;
    end
    else
    begin
      Inc(L, T);
      T := TabStop;
    end;
  SetString(Result, nil, L);
  T := TabStop;
  P := Pointer(Result);
  for I := 1 to Length(S) do
    if S[I] <> #9 then
    begin
      P^ := S[I];
      Dec(T);
      Inc(P);
      if T = 0 then
        T := TabStop;
    end
    else
    begin
      repeat
        P^ := ' ';
        Dec(T);
        Inc(P);
      until T = 0;
      T := TabStop;
    end;
end;

function Q_SpacesToTabs(const S: String; TabStop: integer): String;
var
  I, L, SC, T: integer;
  P: ^ansichar;
  C: ansichar;
begin
  L := 0;
  T := TabStop;
  SC := 0;
  for I := 1 to Length(S) do
  begin
    if T = 0 then
    begin
      Dec(SC);
      T := TabStop;
      if SC > 0 then
        Dec(L, SC);
      SC := 0;
    end;
    Inc(L);
    C := S[I];
    Dec(T);
    if C <> ' ' then
    begin
      if C = #9 then
        T := TabStop;
      SC := 0;
    end
    else
      Inc(SC);
  end;
  if T = 0 then
  begin
    Dec(SC);
    if SC > 0 then
      Dec(L, SC);
  end;
  SetString(Result, nil, L);
  T := TabStop;
  P := Pointer(Result);
  SC := 0;
  for I := 1 to Length(S) do
  begin
    if T = 0 then
    begin
      T := TabStop;
      if SC <> 0 then
      begin
        if SC > 1 then
          P^ := #9
        else
          P^ := ' ';
        Inc(P);
        SC := 0;
      end;
    end;
    C := S[I];
    Dec(T);
    if C <> ' ' then
    begin
      while SC <> 0 do
      begin
        P^ := ' ';
        Dec(SC);
        Inc(P);
      end;
      P^ := C;
      if C = #9 then
        T := TabStop;
      Inc(P);
    end
    else
      Inc(SC);
  end;
  if SC <> 0 then
    if T <> 0 then
      repeat
        P^ := ' ';
        Dec(SC);
        Inc(P);
      until SC = 0
    else if SC > 1 then
      P^ := #9
    else
      P^ := ' ';
end;

function Q_StrTok(var S: String; const Delimiters: String): String; overload;
begin
  ShowMessage('Q_StrTok TODO');
end;

function Q_StrTok(var S: String; const Delimiters: TCharSet): String; overload;
var
  I: integer;
  P1, P2: pansichar;
  L: longword;
begin
  L := Length(S);
  if L <> 0 then
  begin
    P2 := Pointer(S);
    Inc(L, longword(P2));
    while (longword(P2) < L) and (P2^ in Delimiters) do Inc(P2);
    if longword(P2) >= L then
    begin
      S := '';
      Result := '';
      Exit;
    end;
    P1 := P2;
    while (longword(P2) < L) and not (P2^ in Delimiters) do Inc(P2);
    I := longword(P2) - longword(P1);
    SetString(Result, nil, I);
    Q_CopyMem(P1, Pointer(Result), I);
    P1 := Pointer(S);
    Q_CutLeft(S, longword(P2) - longword(P1));
  end
  else
    Result := '';
end;

function Q_StrTok1(var S: String; const Delimiters: String): String; overload;
begin
  ShowMessage('Q_StrTok1 TODO');
end;

function Q_StrTok1(var S: String; const Delimiters: TCharSet): String; overload;
var
  I, L: longword;
begin
  L := Length(S);
  if L <> 0 then
  begin
    I := 0;
    while (I < L) and not Q_BitTest(@Delimiters, byte(S[I + 1])) do Inc(I);
    if I > 0 then
    begin
      SetString(Result, nil, I);
      Q_CopyMem(Pointer(S), Pointer(Result), I);
    end
    else
      Result := '';
    if I < L then
      Q_CutLeft(S, I + 1)
    else
      S := '';
  end
  else
    Result := '';
end;

function Q_WordAtPos(const S: String; Pos: integer; const Delimiters: String): String; overload;
begin
  ShowMessage('Q_WordAtPos TODO');
end;

function Q_WordAtPos(const S: String; Pos: integer; const Delimiters: TCharSet): String; overload;
var
  I: integer;
  P1, P2: pansichar;
  L: integer;
begin
  L := Length(S);
  if (Pos > 0) and (Pos <= L) and not (S[Pos] in Delimiters) then
  begin
    P1 := Pointer(S);
    P2 := Pointer(S);
    Inc(P1, Pos - 2);
    Inc(P2, Pos);
    for I := Pos - 1 downto 1 do
      if not (P1^ in Delimiters) then
        Dec(P1)
      else
        Break;
    Inc(P1);
    for I := Pos + 1 to L do
      if not (P2^ in Delimiters) then
        Inc(P2)
      else
        Break;
    SetString(Result, P1, longword(P2) - longword(P1));
  end
  else
    Result := '';
end;

function Q_GetWordN(OrdN: integer; const S, Delimiters: String): String; overload;
begin
  ShowMessage('Q_GetWordN TODO');
end;

function Q_GetWordN(OrdN: integer; const S: String; const Delimiters: TCharSet): String; overload;
var
  I, J, N: integer;
  L: longword;
  P: pansichar;
  A: boolean;
begin
  L := Length(S);
  P := Pointer(S);
  A := False;
  N := 1;
  for I := 1 to L do
  begin
    if not (P^ in Delimiters) then
    begin
      if not A then
      begin
        if N = OrdN then
        begin
          N := L + 1;
          Inc(P);
          for J := I + 1 to L do
          begin
            if P^ in Delimiters then
            begin
              N := J;
              Break;
            end;
            Inc(P);
          end;
          Result := Copy(S, I, N - I);
          Exit;
        end;
        A := True;
        Inc(N);
      end;
    end
    else
      A := False;
    Inc(P);
  end;
  Result := '';
end;

function Q_GetWordN_1(OrdN: integer; const S, Delimiters: String): String; overload;
begin
  ShowMessage('Q_GetWordN_1 TODO');
end;

function Q_GetWordN_1(OrdN: integer; const S: String; const Delimiters: TCharSet): String; overload;
var
  I, J, N: integer;
  L: longword;
  P: pansichar;
begin
  L := Length(S);
  P := Pointer(S);
  N := 1;
  for I := 1 to L do
  begin
    if N = OrdN then
    begin
      for J := I to L do
      begin
        if P^ in Delimiters then
        begin
          Result := Copy(S, I, J - I);
          Exit;
        end;
        Inc(P);
      end;
      Result := Copy(S, I, MaxInt);
      Exit;
    end;
    if P^ in Delimiters then
      Inc(N);
    Inc(P);
  end;
  Result := '';
end;

function Q_CopyRange(const S: String; Start, Stop: integer): String;
begin
  Result := Copy(S, Start, Stop - Start + 1);
end;

function Q_CopyFrom(const S: String; Start: integer): String;
begin
  Result := Copy(S, Start, MaxInt);
end;

function Q_CopyLeft(const S: String; Count: integer): String;
begin
  Result := Copy(S, 1, Count);
end;

function Q_CopyRight(const S: String; Count: integer): String;
begin
  Result := Copy(S, Length(S) - Count + 1, Count);
end;

{$IFDEF CPU32}
procedure Q_PasteStr(var Dest: String; Pos, Count: Integer; const Source: String);
var
  L1,L2: Integer;
  P,P1: PByte;
  Temp: String;
begin
  L1 := Length(Dest);
  Dec(Pos);
  if L1 < Count+Pos then
    Count := L1-Pos;
  if (Pos>=0) and (Count>=0) then
  begin
    L2 := Length(Source);
    if L2 <= Count then
    begin
      if (L2>0) or (L1>Count) then
      begin
        UniqueString(Dest);
        P := Pointer(Dest);
        Inc(P,Pos);
        P1 := P;
        if L2 <> 0 then
        begin
          Q_CopyMem(Pointer(Source),P,L2);
          Inc(P,L2);
        end;
        if L2 <> Count then
        begin
          Inc(P1,Count);
          Dec(L1,Count);
          Q_MoveMem(P1,P,L1-Pos+1);
          PLong(LongWord(Dest)-4)^ := L1+L2;
        end;
      end else
        Dest := '';
    end else
    begin
      SetString(Temp,nil,L1-Count+L2);
      P := Pointer(Temp);
      if Pos <> 0 then
      begin
        Q_CopyMem(Pointer(Dest),P,Pos);
        Inc(P,Pos);
      end;
      Q_CopyMem(Pointer(Source),P,L2);
      Inc(P,L2);
      Dec(L1,Count+Pos);
      if L1 <> 0 then
      begin
        P1 := Pointer(Dest);
        Inc(P1,Pos+Count);
        Q_CopyMem(P1,P,L1);
      end;
      Dest := Temp;
    end;
  end;
end;
{$ELSE}

procedure Q_PasteStr(var Dest: String; Pos, Count: integer; const Source: String);
begin
  ShowMessage('Q_PasteStr TODO');
end;

{$ENDIF}

function Q_CopyDel(var S: String; Start, Length: integer): String;
begin
  Result := Copy(S, Start, Length);
  Q_Delete(S, Start, Length);
end;


{ Другие функции для работы со строками. }

procedure Q_SetDelimiters(const Delimiters: String); overload;
begin
  ShowMessage('Q_SetDelimiters TODO');
end;

procedure Q_SetDelimiters(const Delimiters: TCharSet); overload;
begin
  ShowMessage('Q_SetDelimiters TODO');
end;

function Q_GetDelimiters: String;
begin
  ShowMessage('Q_GetDelimiters TODO');
end;

{$IFDEF CPU32}
procedure Q_StrMoveL(const Source: String; var Dest: String; MaxL: Cardinal);
asm
        MOV     EDX,[EDX]
        TEST    EAX,EAX
        JE      @@1
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        TEST    EAX,EAX
        JE      @@3
        CMP     ECX,EAX
        JB      @@0
        MOV     ECX,EAX
@@0:    MOV     [EDI-4],ECX
        MOV     BYTE PTR [EDI+ECX],$00
        MOV     EDX,ECX
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,8
        JB      @@cw
        REP     MOVSD
        JMP     DWORD PTR @@tV[EDX*4]
@@3:    POP     EDI
        POP     ESI
@@1:    TEST    EDX,EDX
        JE      @@2
        MOV     [EDX-4],EAX
        MOV     BYTE PTR [EDX],AL
@@2:    RET
@@cw:   JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        mov     [EDI+ECX*4-20],EAX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        LEA     EAX,[ECX*4]
        ADD     ESI,EAX
        ADD     EDI,EAX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0, @@t1, @@t2, @@t3
@@t0:   POP     EDI
        POP     ESI
        RET
@@t1:   MOV     AL,[ESI]
        MOV     [EDI],AL
        POP     EDI
        POP     ESI
        RET
@@t2:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        POP     EDI
        POP     ESI
        RET
@@t3:   MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_StrMoveL(const Source: String; var Dest: String; MaxL: cardinal);
begin
  ShowMessage('Q_StrMoveL TODO');
end;

{$ENDIF}

procedure Q_StrReverse(var S: String);
asm
         CALL    UniqueString
         TEST    EAX,EAX
         JE      @@qt
         MOV     ECX,[EAX-4]
         LEA     EDX,[EAX+ECX-1]
         @@lp:
         CMP     EAX,EDX
         JAE     @@qt
         MOV     CH,BYTE PTR [EAX]
         MOV     CL,BYTE PTR [EDX]
         MOV     BYTE PTR [EDX],CH
         MOV     BYTE PTR [EAX],CL
         INC     EAX
         DEC     EDX
         JMP     @@lp
         @@qt:
end;

{$IFDEF CPU32}
function Q_PStrReverse(P: Pointer): Pointer;
asm
        TEST    EAX,EAX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        LEA     EDX,[EAX+ECX-1]
        PUSH    EAX
@@lp:   CMP     EAX,EDX
        JAE     @@qt0
        MOV     CH,BYTE PTR [EAX]
        MOV     CL,BYTE PTR [EDX]
        MOV     BYTE PTR [EDX],CH
        MOV     BYTE PTR [EAX],CL
        INC     EAX
        DEC     EDX
        JMP     @@lp
@@qt0:  POP     EAX
@@qt1:
end;
{$ELSE}

function Q_PStrReverse(P: Pointer): Pointer;
begin
  ShowMessage('Q_PStrReverse TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CutLeft(var S: String; CharCount: Integer);
var
  L: Integer;
  P: ^Integer;
begin
  if CharCount > 0 then
  begin
    L := Length(S)-CharCount;
    if L > 0 then
    begin
      UniqueString(S);
      P := Pointer(S);
      Dec(P);
      P^ := L;
      Inc(LongWord(P),CharCount+4);
      if CharCount > 3 then
        Q_MoveMem(P,Pointer(S),L)
      else
        Q_MoveBytes(P,Pointer(S),L);
      P := Pointer(S);
      Inc(LongWord(P),L);
      PByte(P)^ := 0;
    end else
      S := '';
  end
  else if CharCount < 0 then
    Q_CutRight(S,-CharCount);
end;
{$ELSE}

procedure Q_CutLeft(var S: String; CharCount: integer);
begin
  ShowMessage('Q_CutLeft TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CutRight(var S: String; CharCount: Integer);
var
  L: Integer;
  P: ^Integer;
begin
  if CharCount > 0 then
  begin
    L := Length(S)-CharCount;
    if L > 0 then
    begin
      UniqueString(S);
      P := Pointer(S);
      Dec(P);
      P^ := L;
      Inc(LongWord(P),L+4);
      PByte(P)^ := 0;
    end else
      S := '';
  end
  else if CharCount < 0 then
    Q_CutLeft(S,-CharCount);
end;
{$ELSE}

procedure Q_CutRight(var S: String; CharCount: integer);
begin
  ShowMessage('Q_CutRight TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntShortRtLeft(P: Pointer; Shift, Len: LongWord);
var
  P1: Pointer;
  T: LongWord;
begin
  P1 := P;
  case Shift of
    1:
      begin
        T := PByte(P1)^;
        Inc(LongWord(P1));
        Q_MoveBytes(P1,P,Len-1);
        Inc(LongWord(P1),Len-2);
        PByte(P1)^ := Byte(T);
      end;
    2:
      begin
        T := PWord(P1)^;
        Inc(LongWord(P1),2);
        Q_MoveWords(P1,P,(Len-1) shr 1);
        Inc(LongWord(P1),Len-4);
        PWord(P1)^ := Word(T);
      end;
    3:
      begin
        T := PLong(P1)^;
        Inc(LongWord(P1),3);
        Q_MoveWords(P1,P,(Len-2) shr 1);
        Inc(LongWord(P1),Len-6);
        PWord(P1)^ := Word(T);
        Inc(LongWord(P1),2);
        PByte(P1)^ := Byte(T shr 16);
      end;
    4:
      begin
        T := PLong(P1)^;
        Inc(LongWord(P1),4);
        Q_MoveMem(P1,P,Len-4);
        Inc(LongWord(P1),Len-8);
        PLong(P1)^ := T;
      end;
  end;
end;
{$ELSE}

procedure IntShortRtLeft(P: Pointer; Shift, Len: longword);
begin
  ShowMessage('IntShortRtLeft TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntShortRtRight(P: Pointer; Shift, Len: LongWord);
var
  P1: Pointer;
  T: LongWord;
begin
  P1 := P;
  case Shift of
    1:
      begin
        T := PByte(LongWord(P1)+Len-1)^;
        Inc(LongWord(P1));
        Q_MoveBytes(P,P1,Len-1);
        PByte(P)^ := Byte(T);
      end;
    2:
      begin
        T := PWord(LongWord(P1)+Len-2)^;
        Inc(LongWord(P1),2);
        Q_MoveWords(P,P1,(Len-1) shr 1);
        PByte(LongWord(P)+Len)^ := 0;
        PWord(P)^ := Word(T);
      end;
    3:
      begin
        T := PLong(LongWord(P1)+Len-3)^;
        Inc(LongWord(P1),3);
        Q_MoveWords(P,P1,(Len-2) shr 1);
        PByte(LongWord(P)+Len)^ := 0;
        PWord(P)^ := Word(T);
        Dec(LongWord(P1));
        PByte(P1)^ := Byte(T shr 16);
      end;
    4:
      begin
        T := PLong(LongWord(P1)+Len-4)^;
        Inc(LongWord(P1),4);
        Q_MoveMem(P,P1,Len-4);
        PLong(P)^ := T;
      end;
  end;
end;
{$ELSE}

procedure IntShortRtRight(P: Pointer; Shift, Len: longword);
begin
  ShowMessage('IntShortRtRight TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntMediumRtLeft(P: Pointer; Shift, Len: LongWord);
var
  M: array[0..255] of Byte;
begin
  Dec(Len,Shift);
  Q_CopyMem(P,@M,Shift);
  Q_MoveMem(PByte(LongWord(P)+Shift),P,Len);
  Inc(LongWord(P),Len);
  Q_CopyMem(@M,P,Shift);
end;
{$ELSE}

procedure IntMediumRtLeft(P: Pointer; Shift, Len: longword);
begin
  ShowMessage('IntMediumRtLeft TODO');
end;

{$ENDIF}

procedure IntMediumRtRight(P: Pointer; Shift, Len: longword);
var
  M: array[0..255] of byte;
begin
  Dec(Len, Shift);
  Q_CopyMem(Pointer(longword(P) + Len), @M, Shift);
  Q_MoveMem(P, pbyte(longword(P) + Shift), Len);
  Q_CopyMem(@M, P, Shift);
end;

{$IFDEF CPU32}
procedure IntLongRotateStr(P: Pointer; LShift, Len: Integer);
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EBP
        MOV     EBX,ECX
        SUB     EAX,4
        PUSH    EAX
        SHR     ECX,1
        CMP     EDX,ECX
        JA      @@ri
@@le:   MOV     ESI,[ESP]
        LEA     EDI,[ESI+EDX]
@@ln:   MOV     ECX,EDX
        AND     ECX,$FFFFFFFC
        JE      @@tqi
@@lp1:  MOV     EAX,DWORD PTR [ESI+ECX]
        MOV     EBP,DWORD PTR [EDI+ECX]
        MOV     DWORD PTR [EDI+ECX],EAX
        MOV     DWORD PTR [ESI+ECX],EBP
        SUB     ECX,4
        JNE     @@lp1
@@tqi:  LEA     ECX,[EDX+4]
        TEST    ECX,3
        JE      @@tqo
@@ls1:  DEC     ECX
        MOV     AL,BYTE PTR [ESI+ECX]
        MOV     AH,BYTE PTR [EDI+ECX]
        MOV     BYTE PTR [EDI+ECX],AL
        MOV     BYTE PTR [ESI+ECX],AH
        TEST    ECX,3
        JNE     @@ls1
@@tqo:  SUB     EBX,EDX
        MOV     ESI,EDI
        MOV     [ESP],EDI
        ADD     EDI,EDX
        MOV     ECX,EDX
        SHL     ECX,1
        CMP     EBX,ECX
        JL      @@ri
        JMP     @@ln
@@ri:   SUB     EDX,EBX
        TEST    EDX,EDX
        JE      @@qt
        NEG     EDX
        MOV     ECX,[ESP]
        LEA     EDI,[EBX+ECX]
        SUB     EDI,EDX
        MOV     ESI,EDI
        SUB     ESI,EDX
@@rn:   MOV     ECX,EDX
        AND     ECX,$FFFFFFFC
        JE      @@fqi
@@lp2:  MOV     EAX,DWORD PTR [ESI+ECX]
        MOV     EBP,DWORD PTR [EDI+ECX]
        MOV     DWORD PTR [EDI+ECX],EAX
        MOV     DWORD PTR [ESI+ECX],EBP
        SUB     ECX,4
        JNE     @@lp2
@@fqi:  LEA     ECX,[EDX+4]
        TEST    ECX,3
        JE      @@fqo
@@ls2:  DEC     ECX
        MOV     AL,BYTE PTR [ESI+ECX]
        MOV     AH,BYTE PTR [EDI+ECX]
        MOV     BYTE PTR [EDI+ECX],AL
        MOV     BYTE PTR [ESI+ECX],AH
        TEST    ECX,3
        JNE     @@ls2
@@fqo:  SUB     EBX,EDX
        MOV     EDI,ESI
        SUB     ESI,EDX
        CMP     [ESP],ESI
        JA      @@tl
        JMP     @@rn
@@tl:   SUB     EDX,EBX
        TEST    EDX,EDX
        JE      @@qt
        NEG     EDX
        JMP     @@le
@@qt:   POP     ECX
        POP     EBP
        POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure IntLongRotateStr(P: Pointer; LShift, Len: integer);
begin
  ShowMessage('IntLongRotateStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntRtLeft(var S: String; Shift, Len: Integer);
begin
  if Shift > 0 then
  begin
    UniqueString(S);
    if Shift <= 4 then
      IntShortRtLeft(Pointer(S),Shift,Len)
    else if Shift <= 256 then
      IntMediumRtLeft(Pointer(S),Shift,Len)
    else
      IntLongRotateStr(Pointer(S),Shift,Len);
  end;
end;
{$ELSE}

procedure IntRtLeft(var S: String; Shift, Len: integer);
begin
  ShowMessage('IntRtLeft TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntRtRight(var S: String; Shift, Len: Integer);
begin
  if Shift > 0 then
  begin
    UniqueString(S);
    if Shift <= 4 then
      IntShortRtRight(Pointer(S),Shift,Len)
    else if Shift <= 256 then
      IntMediumRtRight(Pointer(S),Shift,Len)
    else
      IntLongRotateStr(Pointer(S),Len-Shift,Len);
  end;
end;
{$ELSE}

procedure IntRtRight(var S: String; Shift, Len: integer);
begin
  ShowMessage('IntRtRight TODO');
end;

{$ENDIF}

procedure Q_RotateLeft(var S: String; Shift: integer);
var
  L: integer;
begin
  L := Length(S);
  if L >= 2 then
  begin
    Shift := Shift mod L;
    if Shift < 0 then
      Inc(Shift, L);
    if Shift <= L shr 1 then
      IntRtLeft(S, Shift, L)
    else
      IntRtRight(S, L - Shift, L);
  end;
end;

procedure Q_RotateRight(var S: String; Shift: integer);
var
  L: integer;
begin
  L := Length(S);
  if L >= 2 then
  begin
    Shift := Shift mod L;
    if Shift < 0 then
      Inc(Shift, L);
    if Shift <= L shr 1 then
      IntRtRight(S, Shift, L)
    else
      IntRtLeft(S, L - Shift, L);
  end;
end;

function Q_Duplicate(const S: String; Count: integer): String;
var
  I, L: integer;
  P, P1: pansichar;
begin
  L := Length(S);
  if (L > 0) and (Count > 0) then
  begin
    SetString(Result, nil, L * Count);
    P := Pointer(S);
    P1 := Pointer(Result);
    for I := 0 to Count - 1 do
    begin
      Q_CopyMem(P, P1, L);
      Inc(P1, L);
    end;
  end
  else
    Result := '';
end;

const
  ToBase64: array[0..63] of ansichar =
    ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
    'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
    'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1',
    '2', '3', '4', '5', '6', '7', '8', '9', '+', '/');

  FromBase64: array[0..79] of byte =
    (62, 0, 0, 0, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51);

{$IFDEF CPU32}
procedure IntBase64Encode(P1, P2: Pointer; L: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        MOV     EDI,EDX
@@lp:   SUB     ESI,3
        JS      @@nx
        XOR     EAX,EAX
        MOV     AH,BYTE PTR [EBX]
        MOV     AL,BYTE PTR [EBX+1]
        MOVZX   EDX,BYTE PTR [EBX+2]
        SHL     EAX,8
        OR      EAX,EDX
        ROL     EAX,14
        MOVZX   EDX,AL
        AND     EAX,$FFFFFF00
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        MOVZX   EDX,AL
        AND     EAX,$FFFF0000
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        MOVZX   EDX,AL
        AND     EAX,$FF000000
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+2],CL
        MOVZX   EDX,AL
        ADD     EBX,3
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+3],CL
        ADD     EDI,4
        JMP     @@lp
@@nx:   ADD     ESI,3
        JMP     DWORD PTR @@tV[ESI*4]
@@tV:   DD      @@tu0,@@tu1,@@tu2
@@tu0:  POP     EDI
        POP     ESI
        POP     EBX
        RET
@@tu1:  XOR     EAX,EAX
        MOV     AL,BYTE PTR [EBX]
        ROR     EAX,2
        MOVZX   EDX,AL
        AND     EAX,$FFFFFF00
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        MOVZX   EDX,AL
        MOV     BYTE PTR [EDI+2],61
        MOV     BYTE PTR [EDI+3],61
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@tu2:  XOR     EAX,EAX
        MOV     AH,BYTE PTR [EBX]
        MOV     AL,BYTE PTR [EBX+1]
        ROR     EAX,10
        MOVZX   EDX,AL
        AND     EAX,$FFFFFF00
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI],CL
        MOVZX   EDX,AL
        AND     EAX,$FFFF0000
        ROL     EAX,6
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+1],CL
        MOVZX   EDX,AL
        MOV     BYTE PTR [EDI+3],61
        MOV     CL,BYTE PTR [EDX+ToBase64]
        MOV     BYTE PTR [EDI+2],CL
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ELSE}

procedure IntBase64Encode(P1, P2: Pointer; L: integer);
begin
  ShowMessage('IntBase64Encode TODO');
end;

{$ENDIF}

function Q_Base64Encode(const S: String): String; overload;
var
  L: integer;
begin
  L := Length(S);
  if L <> 0 then
  begin
    SetString(Result, nil, ((L + 2) div 3) shl 2);
    IntBase64Encode(Pointer(S), Pointer(Result), L);
  end
  else
    Result := '';
end;

function Q_Base64Encode(P: Pointer; L: cardinal): String; overload;
begin
  if L <> 0 then
  begin
    SetString(Result, nil, ((L + 2) div 3) shl 2);
    IntBase64Encode(P, Pointer(Result), L);
  end
  else
    Result := '';
end;

{$IFDEF CPU32}
procedure IntBase64Decode(P1, P2: Pointer; L: Integer);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        MOV     ESI,ECX
        PUSH    EDX
        MOV     EDI,EDX
@@lp:   DEC     ESI
        JE      @@nx0
        MOV     EDX,[EBX]
        MOVZX   EAX,DL
        SUB     EAX,43
        XOR     ECX,ECX
        MOV     CL,BYTE PTR [EAX+FromBase64]
        ROL     ECX,6
        MOVZX   EAX,DH
        SUB     EAX,43
        OR      CL,BYTE PTR [EAX+FromBase64]
        SHR     EDX,16
        MOVZX   EAX,DL
        SUB     EAX,43
        ROL     ECX,6
        OR      CL,BYTE PTR [EAX+FromBase64]
        MOVZX   EAX,DH
        SUB     EAX,43
        ROL     ECX,6
        MOVZX   EDX,BYTE PTR [EAX+FromBase64]
        OR      ECX,EDX
        ADD     EBX,4
        ROR     ECX,8
        MOV     BYTE PTR [EDI],CH
        MOV     BYTE PTR [EDI+1],CL
        SHR     ECX,24
        MOV     BYTE PTR [EDI+2],CL
        ADD     EDI,3
        JMP     @@lp
@@nx0:  MOV     EDX,[EBX]
        MOVZX   EAX,DL
        SUB     EAX,43
        XOR     ECX,ECX
        MOV     CL,BYTE PTR [EAX+FromBase64]
        ROL     ECX,6
        MOVZX   EAX,DH
        SUB     EAX,43
        OR      CL,BYTE PTR [EAX+FromBase64]
        SHR     EDX,16
        CMP     DH,61
        JE      @@nx1
        MOVZX   EAX,DL
        SUB     EAX,43
        ROL     ECX,6
        OR      CL,BYTE PTR [EAX+FromBase64]
        MOVZX   EAX,DH
        SUB     EAX,43
        ROL     ECX,6
        MOVZX   EDX,BYTE PTR [EAX+FromBase64]
        OR      ECX,EDX
        ADD     EBX,4
        ROR     ECX,8
        MOV     BYTE PTR [EDI],CH
        MOV     BYTE PTR [EDI+1],CL
        SHR     ECX,24
        MOV     BYTE PTR [EDI+2],CL
        POP     ECX
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@nx1:  CMP     DL,61
        JE      @@nx2
        MOVZX   EAX,DL
        ROL     ECX,6
        SUB     EAX,43
        MOVZX   EDX,BYTE PTR [EAX+FromBase64]
        OR      ECX,EDX
        SHR     ECX,2
        MOV     BYTE PTR [EDI],CH
        MOV     BYTE PTR [EDI+1],CL
        MOV     BYTE PTR [EDI+2],0
        POP     EDX
        DEC     DWORD PTR [EDX-4]
        POP     EDI
        POP     ESI
        POP     EBX
        RET
@@nx2:  SHR     ECX,4
        MOV     BYTE PTR [EDI],CL
        MOV     BYTE PTR [EDI+1],0
        POP     EDX
        SUB     DWORD PTR [EDX-4],2
        POP     EDI
        POP     ESI
        POP     EBX
end;
{$ELSE}

procedure IntBase64Decode(P1, P2: Pointer; L: integer);
begin
  ShowMessage('IntBase64Decode TODO');
end;

{$ENDIF}

function Q_Base64Decode(const S: String): String;
var
  L: integer;
begin
  L := Length(S);
  if L <> 0 then
  begin
    if L and 3 <> 0 then
      raise EConvertError.Create('Формат строки не соответствует способу кодирования Base64.');
    L := L shr 2;
    SetString(Result, nil, L * 3);
    IntBase64Decode(Pointer(S), Pointer(Result), L);
  end
  else
    Result := '';
end;

type
  PRLECnt = ^TRLECnt;
  TRLECnt = array[0..5] of byte;

const
  RLECC3 = $16;
  RLECC4 = $17;
  RLECC5 = $18;
  RLECC6 = $19;
  RLECC7 = $1D;
  RLECC8 = $1E;
  RLECCN = $7F;

  ExVals: set of byte = [RLECC3, RLECC4, RLECC5, RLECC6, RLECC7, RLECC8, RLECCN];

function Q_GetPackRLESize(Source: Pointer; SrcL: cardinal): cardinal;
var
  P1: pbyte;
  Cnt: cardinal;
  B: byte;
begin
  P1 := Source;
  Result := 0;
  while SrcL <> 0 do
  begin
    Cnt := 1;
    B := P1^;
    Dec(SrcL);
    Inc(P1);
    while SrcL <> 0 do
      if P1^ = B then
      begin
        Inc(P1);
        Dec(SrcL);
        Inc(Cnt);
      end
      else
        Break;
    if not (B in ExVals) then
    begin
      if Cnt = 1 then
        Inc(Result)
      else if Cnt < 9 then
        Inc(Result, 2)
      else
      begin
        Inc(Result, 3);
        while Cnt > 127 do
        begin
          Inc(Result);
          Cnt := Cnt shr 7;
        end;
      end;
    end
    else
    begin
      if Cnt < 3 then
        Inc(Result, 2)
      else
      begin
        Inc(Result, 3);
        while Cnt > 127 do
        begin
          Inc(Result);
          Cnt := Cnt shr 7;
        end;
      end;
    end;
  end;
end;

function Q_GetUnpackRLESize(Source: Pointer; SrcL: cardinal): cardinal;
var
  P1: pbyte;
  N, N1, Cnt, Q: cardinal;
  B: byte;
begin
  P1 := Source;
  Result := 0;
  while SrcL <> 0 do
  begin
    B := P1^;
    Dec(SrcL);
    Inc(P1);
    if not (B in ExVals) then
      Inc(Result)
    else if B = RLECCN then
    begin
      N := 0;
      repeat
        Inc(N);
      until PRLECnt(P1)^[N] and $80 = 0;
      Cnt := 0;
      N1 := N + 1;
      repeat
        Q := PRLECnt(P1)^[N];
        Cnt := (Cnt shl 7) or (Q and $7F);
        Dec(N);
      until N = 0;
      Inc(Result, Cnt);
      Dec(SrcL, N1);
      Inc(P1, N1);
    end
    else
    begin
      Q := P1^;
      Dec(SrcL);
      Inc(P1);
      case B of
        RLECC3:
          Inc(Result, 3);
        RLECC4:
        begin
          if not (byte(Q) in ExVals) then
            Inc(Result, 4)
          else
            Inc(Result, 2);
        end;
        RLECC5:
          Inc(Result, 5);
        RLECC6:
        begin
          if byte(Q) in ExVals then
            Inc(Result)
          else
            Inc(Result, 6);
        end;
        RLECC7:
          Inc(Result, 7);
        else
          Inc(Result, 8);
      end;
    end;
  end;
end;

function Q_PackRLE(Source, Dest: Pointer; SrcL: cardinal): cardinal; overload;
var
  P1: pbyte;
  P2: PRLECnt;
  Cnt: cardinal;
  B: byte;
begin
  P1 := Source;
  P2 := Dest;
  while SrcL <> 0 do
  begin
    Cnt := 1;
    B := P1^;
    Dec(SrcL);
    Inc(P1);
    while SrcL <> 0 do
      if P1^ = B then
      begin
        Inc(P1);
        Dec(SrcL);
        Inc(Cnt);
      end
      else
        Break;
    if not (B in ExVals) then
    begin
      if Cnt = 1 then
      begin
        pbyte(P2)^ := B;
        Inc(pbyte(P2));
      end
      else if Cnt > 8 then
      begin
        P2^[0] := RLECCN;
        P2^[1] := B;
        Inc(pbyte(P2), 2);
        while Cnt > 127 do
        begin
          pbyte(P2)^ := byte(Cnt) or $80;
          Inc(pbyte(P2));
          Cnt := Cnt shr 7;
        end;
        pbyte(P2)^ := Cnt;
        Inc(pbyte(P2));
      end
      else
      begin
        case Cnt of
          2: P2^[0] := B;
          3: P2^[0] := RLECC3;
          4: P2^[0] := RLECC4;
          5: P2^[0] := RLECC5;
          6: P2^[0] := RLECC6;
          7: P2^[0] := RLECC7;
          8: P2^[0] := RLECC8;
        end;
        P2^[1] := B;
        Inc(pbyte(P2), 2);
      end;
    end
    else
    begin
      P2^[1] := B;
      if Cnt = 1 then
      begin
        P2^[0] := RLECC6;
        Inc(pbyte(P2), 2);
      end
      else if Cnt = 2 then
      begin
        P2^[0] := RLECC4;
        Inc(pbyte(P2), 2);
      end
      else
      begin
        P2^[0] := RLECCN;
        Inc(pbyte(P2), 2);
        while Cnt > 127 do
        begin
          pbyte(P2)^ := byte(Cnt) or $80;
          Inc(pbyte(P2));
          Cnt := Cnt shr 7;
        end;
        pbyte(P2)^ := Cnt;
        Inc(pbyte(P2));
      end;
    end;
  end;
  Result := longword(P2);
  Dec(Result, longword(Dest));
end;

function Q_UnpackRLE(Source, Dest: Pointer; SrcL: cardinal): cardinal; overload;
var
  P1, P2: pbyte;
  N, N1, Cnt: cardinal;
  Q, B: longword;
begin
  P1 := Source;
  P2 := Dest;
  while SrcL <> 0 do
  begin
    B := P1^;
    Dec(SrcL);
    Inc(P1);
    if not (byte(B) in ExVals) then
    begin
      P2^ := B;
      Inc(P2);
    end
    else
    begin
      if byte(B) = RLECCN then
      begin
        N := 0;
        repeat
          Inc(N);
        until PRLECnt(P1)^[N] and $80 = 0;
        Cnt := 0;
        N1 := N + 1;
        repeat
          Q := PRLECnt(P1)^[N];
          Cnt := (Cnt shl 7) or (Q and $7F);
          Dec(N);
        until N = 0;
        Q_FillChar(P2, Cnt, P1^);
        Inc(P2, Cnt);
        Dec(SrcL, N1);
        Inc(P1, N1);
      end
      else
      begin
        Q := P1^;
        Dec(SrcL);
        Inc(P1);
        P2^ := byte(Q);
        if byte(B) = RLECC4 then
        begin
          if not (byte(Q) in ExVals) then
          begin
            PRLECnt(P2)^[1] := byte(Q);
            PRLECnt(P2)^[2] := byte(Q);
            PRLECnt(P2)^[3] := byte(Q);
            Inc(P2, 4);
          end
          else
          begin
            PRLECnt(P2)^[1] := byte(Q);
            Inc(P2, 2);
          end;
        end
        else if byte(B) = RLECC6 then
        begin
          if byte(Q) in ExVals then
            Inc(P2)
          else
          begin
            PRLECnt(P2)^[1] := byte(Q);
            PRLECnt(P2)^[2] := byte(Q);
            PRLECnt(P2)^[3] := byte(Q);
            PRLECnt(P2)^[4] := byte(Q);
            PRLECnt(P2)^[5] := byte(Q);
            Inc(P2, 6);
          end;
        end
        else
        begin
          PRLECnt(P2)^[1] := byte(Q);
          PRLECnt(P2)^[2] := byte(Q);
          Inc(P2, 3);
          if byte(B) >= RLECC5 then
          begin
            P2^ := byte(Q);
            PRLECnt(P2)^[1] := byte(Q);
            Inc(P2, 2);
            if byte(B) >= RLECC7 then
            begin
              P2^ := byte(Q);
              PRLECnt(P2)^[1] := byte(Q);
              Inc(P2, 2);
              if byte(B) = RLECC8 then
              begin
                P2^ := byte(Q);
                Inc(P2);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  Result := longword(P2);
  Dec(Result, longword(Dest));
end;

function Q_PackRLE(const S: String; MaxL: integer): String; overload;
var
  L: integer;
  P: pbyte;
begin
  L := Length(S);
  if MaxL = -1 then
    MaxL := Q_GetPackRLESize(Pointer(S), L);
  SetString(Result, nil, MaxL);
  P := Pointer(Result);
  L := Q_PackRLE(Pointer(S), P, L);
  if L > 0 then
  begin
    Dec(P, 4);
    PLong(P)^ := L;
    Inc(P, L + 4);
    P^ := 0;
  end
  else
    Result := '';
end;

function Q_UnpackRLE(const S: String; MaxL: integer): String; overload;
var
  L: integer;
  P: pbyte;
begin
  L := Length(S);
  if MaxL = -1 then
    MaxL := Q_GetUnpackRLESize(Pointer(S), L);
  SetString(Result, nil, MaxL);
  P := Pointer(Result);
  L := Q_UnpackRLE(Pointer(S), P, L);
  if L > 0 then
  begin
    Dec(P, 4);
    PLong(P)^ := L;
    Inc(P, L + 4);
    P^ := 0;
  end
  else
    Result := '';
end;


{ Информационные функции. }

{$IFDEF CPU32}
function Q_PStrLen(P: PAnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        LEA     EDX,[EAX+1]
@L1:    MOV     EBX,[EAX]
        ADD     EAX,4
        LEA     ECX,[EBX-$01010101]
        NOT     EBX
        AND     ECX,EBX
        AND     ECX,$80808080
        JZ      @L1
        TEST    ECX,$00008080
        JZ      @L2
        SHL     ECX,16
        SUB     EAX,2
@L2:    SHL     ECX,9
        SBB     EAX,EDX
        POP     EBX
@@qt:
end;
{$ELSE}

function Q_PStrLen(P: pansichar): integer;
begin
  ShowMessage('Q_PStrLen TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_IsEmptyStr(const S, EmptyChars: String): Boolean; overload;
asm
        TEST    EAX,EAX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@qt1
        PUSH    EDI
        PUSH    EBX
        PUSH    ESI
        MOV     EDI,EAX
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,[EDX-4]
        DEC     ESI
        JS      @@qt0
@@lp1:  MOV     AL,BYTE PTR [EDI+ECX]
        MOV     EBX,ESI
@@lp2:  CMP     AL,BYTE PTR [EDX+EBX]
        JE      @@nx
        DEC     EBX
        JNS     @@lp2
        JMP     @@qt0
@@nx:   DEC     ECX
        JNS     @@lp1
        POP     ESI
        POP     EBX
        POP     EDI
@@qt1:  MOV     EAX,1
        RET
@@qt0:  XOR     EAX,EAX
        POP     ESI
        POP     EBX
        POP     EDI
end;
{$ELSE}

function Q_IsEmptyStr(const S, EmptyChars: String): boolean; overload;
begin
  ShowMessage('Q_IsEmptyStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_IsEmptyStr(const S: String; const EmptyChars: TCharSet): Boolean; overload;
asm
        TEST    EAX,EAX
        JE      @@qt1
        MOV     ECX,[EAX-4]
        DEC     ECX
        JS      @@qt1
        PUSH    EBX
@@lp:   MOVZX   EBX,BYTE PTR [EAX+ECX]
        BT      [EDX],EBX
        JNC     @@qt0
        DEC     ECX
        JNS     @@lp
        POP     EBX
@@qt1:  MOV     EAX,1
        RET
@@qt0:  POP     EBX
        XOR     EAX,EAX
end;
{$ELSE}

function Q_IsEmptyStr(const S: String; const EmptyChars: TCharSet): boolean; overload;
begin
  ShowMessage('Q_IsEmptyStr TODO');
end;

{$ENDIF}

function Q_IsEmptyStr(const S: String): boolean; overload;
asm
         TEST    EAX,EAX
         JE      @@qt1
         MOV     ECX,[EAX-4]
         MOV     DL,32
         DEC     ECX
         JS      @@qt1
         @@lp:
         CMP     DL,BYTE PTR [EAX+ECX]
         JB      @@qt0
         DEC     ECX
         JNS     @@lp
         @@qt1:
         MOV     EAX,1
         RET
         @@qt0:
         XOR     EAX,EAX
end;

{$IFDEF CPU32}
function Q_CharCount(const S: String; Ch: AnsiChar): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@zq
        PUSH    EBX
        LEA     EBX,[EAX-1]
        XOR     EAX,EAX
@@lp:   CMP     DL,BYTE PTR [EBX+ECX]
        JE      @@fn
        DEC     ECX
        JNE     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:
end;
{$ELSE}

function Q_CharCount(const S: String; Ch: ansichar): integer;
begin
  ShowMessage('Q_CharCount TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CharsCount(const S: String; const CharSet: TCharSet): Integer;
asm
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@zq
        PUSH    EBX
        PUSH    ESI
        LEA     EBX,[EAX-1]
        XOR     EAX,EAX
@@lp:   MOVZX   ESI,BYTE PTR [EBX+ECX]
        BT      [EDX],ESI
        JC      @@fn
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@fn:   INC     EAX
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
@@qt:
end;
{$ELSE}

function Q_CharsCount(const S: String; const CharSet: TCharSet): integer;
begin
  ShowMessage('Q_CharsCount TODO');
end;

{$ENDIF}

function Q_GetCharStr(const S: String): String;
var
  CS: TCharSet;
begin
  CS := Q_GetCharSet(S);
  Result := Q_CharSetToStr(CS);
end;

function Q_CountOfWords(const S, Delimiters: String): integer; overload;
begin
  ShowMessage('Q_CountOfWords TODO');
end;

{$IFDEF CPU32}
function Q_CountOfWords(const S: String; const Delimiters: TCharSet): Integer; overload;
asm
        PUSH    EBX
        TEST    EAX,EAX
        JE      @@q0
        MOV     ECX,[EAX-4]
        MOV     EBX,EAX
        DEC     ECX
        JS      @@qz
        PUSH    ESI
        XOR     EAX,EAX
        JMP     @@lp2
@@iw:   INC     EAX
        DEC     ECX
        JS      @@ex
@@lp1:  MOVZX   ESI,BYTE PTR [EBX+ECX]
        BT      [EDX],ESI
        JC      @@nx
        DEC     ECX
        JNS     @@lp1
@@ex:   POP     ESI
        POP     EBX
        RET
@@lp2:  MOVZX   ESI,BYTE PTR [EBX+ECX]
        BT      [EDX],ESI
        JNC     @@iw
@@nx:   DEC     ECX
        JNS     @@lp2
        POP     ESI
        POP     EBX
        RET
@@qz:   XOR     EAX,EAX
@@q0:   POP     EBX
end;
{$ELSE}

function Q_CountOfWords(const S: String; const Delimiters: TCharSet): integer; overload;
begin
  ShowMessage('Q_CountOfWords TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_StrCheckSum(const S: String): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EBX
@@lp:   MOVZX   EBX,BYTE PTR [EDX+ECX]
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
@@qt:
end;
{$ELSE}

function Q_StrCheckSum(const S: String): longword;
begin
  ShowMessage('Q_StrCheckSum TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrCheckSum(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EBX
@@lp:   MOVZX   EBX,BYTE PTR [EDX+ECX]
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
@@qt:
end;
{$ELSE}

function Q_PStrCheckSum(P: Pointer): longword;
begin
  ShowMessage('Q_PStrCheckSum TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_StrCheckXOR(const S: String): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        MOV     ECX,[EAX-4]
        MOV     EDX,ECX
        XOR     EAX,EAX
        SHR     ECX,3
        JE      @@nx
@@lp:   XOR     EAX,[EBX]
        XOR     EAX,[EBX+4]
        ADD     EBX,8
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EDX,7
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@ex,@@t1,@@t2,@@t3
        DD      @@t3,@@t5,@@t6,@@t7
@@t1:   XOR     AL,BYTE PTR [EBX]
        JMP     @@ex
@@t2:   XOR     AX,WORD PTR [EBX]
        JMP     @@ex
@@t3:   XOR     EAX,DWORD PTR [EBX]
        JMP     @@ex
@@t5:   XOR     EAX,DWORD PTR [EBX]
        XOR     AL,BYTE PTR [EBX+4]
        JMP     @@ex
@@t6:   XOR     EAX,DWORD PTR [EBX]
        XOR     AX,WORD PTR [EBX+4]
        JMP     @@ex
@@t7:   XOR     EAX,DWORD PTR [EBX]
        XOR     EAX,DWORD PTR [EBX+4]
@@ex:   POP     EBX
@@qt:
end;
{$ELSE}

function Q_StrCheckXOR(const S: String): longword;
begin
  ShowMessage('Q_StrCheckXOR TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrCheckXOR(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        MOV     ECX,[EAX-4]
        MOV     EDX,ECX
        XOR     EAX,EAX
        SHR     ECX,3
        JE      @@nx
@@lp:   XOR     EAX,[EBX]
        XOR     EAX,[EBX+4]
        ADD     EBX,8
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EDX,7
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@ex,@@t1,@@t2,@@t3
        DD      @@t3,@@t5,@@t6,@@t7
@@t1:   XOR     AL,BYTE PTR [EBX]
        JMP     @@ex
@@t2:   XOR     AX,WORD PTR [EBX]
        JMP     @@ex
@@t3:   XOR     EAX,DWORD PTR [EBX]
        JMP     @@ex
@@t5:   XOR     EAX,DWORD PTR [EBX]
        XOR     AL,BYTE PTR [EBX+4]
        JMP     @@ex
@@t6:   XOR     EAX,DWORD PTR [EBX]
        XOR     AX,WORD PTR [EBX+4]
        JMP     @@ex
@@t7:   XOR     EAX,DWORD PTR [EBX]
        XOR     EAX,DWORD PTR [EBX+4]
@@ex:   POP     EBX
@@qt:
end;
{$ELSE}

function Q_PStrCheckXOR(P: Pointer): longword;
begin
  ShowMessage('Q_PStrCheckXOR TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_StrHashKey(const S: String): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    ESI
        PUSH    EBX
@@lp:   MOV     ESI,EAX
        SHL     EAX,5
        MOVZX   EBX,BYTE PTR [EDX+ECX]
        ADD     EAX,ESI
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
@@qt:
end;
{$ELSE}

function Q_StrHashKey(const S: String): longword;
begin
  ShowMessage('Q_StrHashKey TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PStrHashKey(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    ESI
        PUSH    EBX
@@lp:   MOV     ESI,EAX
        SHL     EAX,5
        MOVZX   EBX,BYTE PTR [EDX+ECX]
        ADD     EAX,ESI
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
@@qt:
end;
{$ELSE}

function Q_PStrHashKey(P: Pointer): longword;
begin
  ShowMessage('Q_PStrHashKey TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_TextHashKey(const S: String): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    ESI
        PUSH    EBX
@@lp:   MOV     ESI,EAX
        SHL     EAX,5
        MOVZX   EBX,BYTE PTR [EDX+ECX]
        AND     EBX,$DF
        ADD     EAX,ESI
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
@@qt:
end;
{$ELSE}

function Q_TextHashKey(const S: String): longword;
begin
  ShowMessage('Q_TextHashKey TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_PTextHashKey(P: Pointer): LongWord;
asm
        TEST    EAX,EAX
        JE      @@qt
        LEA     EDX,[EAX-1]
        MOV     ECX,[EAX-4]
        XOR     EAX,EAX
        TEST    ECX,ECX
        JE      @@qt
        PUSH    ESI
        PUSH    EBX
@@lp:   MOV     ESI,EAX
        SHL     EAX,5
        MOVZX   EBX,BYTE PTR [EDX+ECX]
        AND     EBX,$DF
        ADD     EAX,ESI
        ADD     EAX,EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
@@qt:
end;
{$ELSE}

function Q_PTextHashKey(P: Pointer): longword;
begin
  ShowMessage('Q_PTextHashKey TODO');
end;

{$ENDIF}

const
  CRC32_Table: array[0..255] of longword =
    ($00000000, $77073096, $EE0E612C, $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116, $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
    $76DC4190, $01DB7106, $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0, $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252, $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C, $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

{$IFDEF CPU32}
function Q_CRC32(P: Pointer; L: Cardinal): LongWord;
asm
        PUSH    EBX
        MOV     EBX,EAX
        MOV     EAX,$FFFFFFFF
        PUSH    ESI
        TEST    EDX,EDX
        JE      @@qt
@@lp:   MOVZX   ESI,BYTE PTR [EBX]
        MOVZX   ECX,AL
        XOR     ECX,ESI
        SHR     EAX,8
        XOR     EAX,DWORD PTR [ECX*4+CRC32_Table]
        INC     EBX
        DEC     EDX
        JNE     @@lp
@@qt:   POP     ESI
        NOT     EAX
        POP     EBX
end;
{$ELSE}

function Q_CRC32(P: Pointer; L: cardinal): longword;
begin
  ShowMessage('Q_CRC32 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_NextCRC32(var CRC32: LongWord; P: Pointer; L: Cardinal): LongWord;
asm
        TEST    ECX,ECX
        JE      @@qt
        PUSH    EBX
        PUSH    EAX
        MOV     EAX,[EAX]
        NOT     EAX
        PUSH    ESI
@@lp:   MOVZX   ESI,BYTE PTR [EDX]
        MOVZX   EBX,AL
        SHR     EAX,8
        XOR     EBX,ESI
        XOR     EAX,DWORD PTR [EBX*4+CRC32_Table]
        INC     EDX
        DEC     ECX
        JNE     @@lp
        POP     ESI
        POP     EDX
        NOT     EAX
        MOV     [EDX],EAX
        POP     EBX
        RET
@@qt:   MOV     EAX,[EAX]
end;
{$ELSE}

function Q_NextCRC32(var CRC32: longword; P: Pointer; L: cardinal): longword;
begin
  ShowMessage('Q_NextCRC32 TODO');
end;

{$ENDIF}

function Q_TimeStamp: int64;
asm
         DB      $0F,$31
end;


{ Функции для работы с множествами типа TCharSet. }

{$IFDEF CPU32}
function Q_GetCharSet(const S: String): TCharSet;
asm
        XOR     ECX,ECX
        MOV     [EDX],ECX
        MOV     [EDX+4],ECX
        MOV     [EDX+8],ECX
        MOV     [EDX+12],ECX
        MOV     [EDX+16],ECX
        MOV     [EDX+20],ECX
        MOV     [EDX+24],ECX
        MOV     [EDX+28],ECX
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        PUSH    EBX
        SUB     ECX,8
        JS      @@nx
@@lp:   MOVZX   EBX,BYTE PTR [EAX]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+1]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+2]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+3]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+4]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+5]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+6]
        BTS     [EDX],EBX
        MOVZX   EBX,BYTE PTR [EAX+7]
        BTS     [EDX],EBX
        ADD     EAX,8
        SUB     ECX,8
        JNS     @@lp
@@nx:   JMP     DWORD PTR @@tV[ECX*4+32]
@@tV:   DD      @@ex,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   MOVZX   EBX,BYTE PTR [EAX+6]
        BTS     [EDX],EBX
@@t6:   MOVZX   EBX,BYTE PTR [EAX+5]
        BTS     [EDX],EBX
@@t5:   MOVZX   EBX,BYTE PTR [EAX+4]
        BTS     [EDX],EBX
@@t4:   MOVZX   EBX,BYTE PTR [EAX+3]
        BTS     [EDX],EBX
@@t3:   MOVZX   EBX,BYTE PTR [EAX+2]
        BTS     [EDX],EBX
@@t2:   MOVZX   EBX,BYTE PTR [EAX+1]
        BTS     [EDX],EBX
@@t1:   MOVZX   EBX,BYTE PTR [EAX]
        BTS     [EDX],EBX
@@ex:   POP     EBX
@@qt:
end;
{$ELSE}

function Q_GetCharSet(const S: String): TCharSet;
begin
  ShowMessage('Q_GetCharSet TODO');
end;

{$ENDIF}

function Q_CharSetToStr(const CharSet: TCharSet): String;
begin
  ShowMessage('Q_CharSetToStr TODO');
end;

procedure Q_ComplementChar(var CharSet: TCharSet; Ch: ansichar);
asm
         MOVZX   ECX,DL
         BTC     [EAX],ECX
end;

procedure Q_ClearCharSet(var CharSet: TCharSet);
asm
         XOR     EDX,EDX
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     [EAX+16],EDX
         MOV     [EAX+20],EDX
         MOV     [EAX+24],EDX
         MOV     [EAX+28],EDX
end;

procedure Q_FillCharSet(var CharSet: TCharSet);
asm
         MOV     EDX,$FFFFFFFF
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     [EAX+16],EDX
         MOV     [EAX+20],EDX
         MOV     [EAX+24],EDX
         MOV     [EAX+28],EDX
end;

procedure Q_ComplementSet(var CharSet: TCharSet);
asm
         NOT     DWORD PTR [EAX]
         NOT     DWORD PTR [EAX+4]
         NOT     DWORD PTR [EAX+8]
         NOT     DWORD PTR [EAX+12]
         NOT     DWORD PTR [EAX+16]
         NOT     DWORD PTR [EAX+20]
         NOT     DWORD PTR [EAX+24]
         NOT     DWORD PTR [EAX+28]
end;

procedure Q_CloneCharSet(const SourceSet: TCharSet; var DestSet: TCharSet);
asm
         MOV     ECX,[EAX]
         MOV     [EDX],ECX
         MOV     ECX,[EAX+4]
         MOV     [EDX+4],ECX
         MOV     ECX,[EAX+8]
         MOV     [EDX+8],ECX
         MOV     ECX,[EAX+12]
         MOV     [EDX+12],ECX
         MOV     ECX,[EAX+16]
         MOV     [EDX+16],ECX
         MOV     ECX,[EAX+20]
         MOV     [EDX+20],ECX
         MOV     ECX,[EAX+24]
         MOV     [EDX+24],ECX
         MOV     ECX,[EAX+28]
         MOV     [EDX+28],ECX
end;

procedure Q_CharSetUnion(var DestSet: TCharSet; const SourceSet: TCharSet);
asm
         MOV     ECX,[EDX]
         OR      [EAX],ECX
         MOV     ECX,[EDX+4]
         OR      [EAX+4],ECX
         MOV     ECX,[EDX+8]
         OR      [EAX+8],ECX
         MOV     ECX,[EDX+12]
         OR      [EAX+12],ECX
         MOV     ECX,[EDX+16]
         OR      [EAX+16],ECX
         MOV     ECX,[EDX+20]
         OR      [EAX+20],ECX
         MOV     ECX,[EDX+24]
         OR      [EAX+24],ECX
         MOV     ECX,[EDX+28]
         OR      [EAX+28],ECX
end;

procedure Q_CharSetSubtract(var DestSet: TCharSet; const SourceSet: TCharSet);
asm
         MOV     ECX,[EDX]
         NOT     ECX
         AND     [EAX],ECX
         MOV     ECX,[EDX+4]
         NOT     ECX
         AND     [EAX+4],ECX
         MOV     ECX,[EDX+8]
         NOT     ECX
         AND     [EAX+8],ECX
         MOV     ECX,[EDX+12]
         NOT     ECX
         AND     [EAX+12],ECX
         MOV     ECX,[EDX+16]
         NOT     ECX
         AND     [EAX+16],ECX
         MOV     ECX,[EDX+20]
         NOT     ECX
         AND     [EAX+20],ECX
         MOV     ECX,[EDX+24]
         NOT     ECX
         AND     [EAX+24],ECX
         MOV     ECX,[EDX+28]
         NOT     ECX
         AND     [EAX+28],ECX
end;

procedure Q_CharSetIntersect(var DestSet: TCharSet; const SourceSet: TCharSet);
asm
         MOV     ECX,[EDX]
         AND     [EAX],ECX
         MOV     ECX,[EDX+4]
         AND     [EAX+4],ECX
         MOV     ECX,[EDX+8]
         AND     [EAX+8],ECX
         MOV     ECX,[EDX+12]
         AND     [EAX+12],ECX
         MOV     ECX,[EDX+16]
         AND     [EAX+16],ECX
         MOV     ECX,[EDX+20]
         AND     [EAX+20],ECX
         MOV     ECX,[EDX+24]
         AND     [EAX+24],ECX
         MOV     ECX,[EDX+28]
         AND     [EAX+28],ECX
end;

procedure Q_CharSetXOR(var DestSet: TCharSet; const SourceSet: TCharSet);
asm
         MOV     ECX,[EDX]
         XOR     [EAX],ECX
         MOV     ECX,[EDX+4]
         XOR     [EAX+4],ECX
         MOV     ECX,[EDX+8]
         XOR     [EAX+8],ECX
         MOV     ECX,[EDX+12]
         XOR     [EAX+12],ECX
         MOV     ECX,[EDX+16]
         XOR     [EAX+16],ECX
         MOV     ECX,[EDX+20]
         XOR     [EAX+20],ECX
         MOV     ECX,[EDX+24]
         XOR     [EAX+24],ECX
         MOV     ECX,[EDX+28]
         XOR     [EAX+28],ECX
end;

function Q_IsSubset(const LeftSet, RightSet: TCharSet): boolean;
asm
         MOV     ECX,[EDX]
         NOT     ECX
         AND     ECX,[EAX]
         JNE     @@q0
         MOV     ECX,[EDX+4]
         NOT     ECX
         AND     ECX,[EAX+4]
         JNE     @@q0
         MOV     ECX,[EDX+8]
         NOT     ECX
         AND     ECX,[EAX+8]
         JNE     @@q0
         MOV     ECX,[EDX+12]
         NOT     ECX
         AND     ECX,[EAX+12]
         JNE     @@q0
         MOV     ECX,[EDX+16]
         NOT     ECX
         AND     ECX,[EAX+16]
         JNE     @@q0
         MOV     ECX,[EDX+20]
         NOT     ECX
         AND     ECX,[EAX+20]
         JNE     @@q0
         MOV     ECX,[EDX+24]
         NOT     ECX
         AND     ECX,[EAX+24]
         JNE     @@q0
         MOV     ECX,[EDX+28]
         NOT     ECX
         AND     ECX,[EAX+28]
         JNE     @@q0
         MOV     EAX,1
         RET
         @@q0:
         XOR     EAX,EAX
end;

function Q_IsSuperset(const LeftSet, RightSet: TCharSet): boolean;
asm
         XCHG    EAX,EDX
         CALL    Q_IsSubset
end;

function Q_IsEqualSet(const LeftSet, RightSet: TCharSet): boolean;
asm
         MOV     ECX,[EDX]
         XOR     ECX,[EAX]
         JNE     @@q0
         MOV     ECX,[EDX+4]
         XOR     ECX,[EAX+4]
         JNE     @@q0
         MOV     ECX,[EDX+8]
         XOR     ECX,[EAX+8]
         JNE     @@q0
         MOV     ECX,[EDX+12]
         XOR     ECX,[EAX+12]
         JNE     @@q0
         MOV     ECX,[EDX+16]
         XOR     ECX,[EAX+16]
         JNE     @@q0
         MOV     ECX,[EDX+20]
         XOR     ECX,[EAX+20]
         JNE     @@q0
         MOV     ECX,[EDX+24]
         XOR     ECX,[EAX+24]
         JNE     @@q0
         MOV     ECX,[EDX+28]
         XOR     ECX,[EAX+28]
         JNE     @@q0
         MOV     EAX,1
         RET
         @@q0:
         XOR     EAX,EAX
end;

function Q_IsEmptySet(const CharSet: TCharSet): boolean;
asm
         MOV     EDX,[EAX]
         OR      EDX,[EAX+4]
         OR      EDX,[EAX+8]
         OR      EDX,[EAX+12]
         OR      EDX,[EAX+16]
         OR      EDX,[EAX+20]
         OR      EDX,[EAX+24]
         OR      EDX,[EAX+28]
         JNE     @@zq
         MOV     EAX,1
         RET
         @@zq:
         XOR     EAX,EAX
end;

const
  BitTable: array[0..255] of byte =
    (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

{$IFDEF CPU32}
function Q_CharSetCharCount(const CharSet: TCharSet): Integer;
asm
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
        MOVZX   ECX,BYTE PTR [EBX]
        MOVZX   EDX,BYTE PTR [EBX+1]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+2]
        MOVZX   EDX,BYTE PTR [EBX+3]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+4]
        MOVZX   EDX,BYTE PTR [EBX+5]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+6]
        MOVZX   EDX,BYTE PTR [EBX+7]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+8]
        MOVZX   EDX,BYTE PTR [EBX+9]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+10]
        MOVZX   EDX,BYTE PTR [EBX+11]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+12]
        MOVZX   EDX,BYTE PTR [EBX+13]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+14]
        MOVZX   EDX,BYTE PTR [EBX+15]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+16]
        MOVZX   EDX,BYTE PTR [EBX+17]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+18]
        MOVZX   EDX,BYTE PTR [EBX+19]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+20]
        MOVZX   EDX,BYTE PTR [EBX+21]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+22]
        MOVZX   EDX,BYTE PTR [EBX+23]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+24]
        MOVZX   EDX,BYTE PTR [EBX+25]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+26]
        MOVZX   EDX,BYTE PTR [EBX+27]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+28]
        MOVZX   EDX,BYTE PTR [EBX+29]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        MOVZX   ECX,BYTE PTR [EBX+30]
        MOVZX   EDX,BYTE PTR [EBX+31]
        MOVZX   ECX,BYTE PTR [ECX+BitTable]
        ADD     EAX,ECX
        MOVZX   EDX,BYTE PTR [EDX+BitTable]
        ADD     EAX,EDX
        POP     EBX
end;
{$ELSE}

function Q_CharSetCharCount(const CharSet: TCharSet): integer;
begin
  ShowMessage('Q_CharSetCharCount TODO');
end;

{$ENDIF}


{ Функции для работы с символьной записью чисел. }

function Q_IsInteger(const S: String): boolean;
var
  L, I: integer;
  P: pansichar;
  C: ansichar;
begin
  P := Pointer(S);
  L := Length(S);
  Result := False;
  while (L > 0) and (P^ = ' ') do
  begin
    Dec(L);
    Inc(P);
  end;
  if L > 0 then
  begin
    C := P^;
    Inc(P);
    if C in ['-', '+'] then
    begin
      C := P^;
      Dec(L);
      Inc(P);
      if L = 0 then
        Exit;
    end;
    if ((L < 10) and (C in ['0'..'9'])) or ((L = 10) and (C in ['0'..'1'])) then
    begin
      for I := 1 to L - 1 do
      begin
        if not (P^ in ['0'..'9']) then
          Exit;
        Inc(P);
      end;
      Result := True;
    end
    else if (L = 10) and (C = '2') then
      Result := Q_BetweenInt64(S, -2147483647 - 1, 2147483647);
  end;
end;

function Q_IsCardinal(const S: String): boolean;
var
  L, I: integer;
  P: pansichar;
  C: ansichar;
begin
  P := Pointer(S);
  L := Length(S);
  Result := False;
  while (L > 0) and (P^ = ' ') do
  begin
    Dec(L);
    Inc(P);
  end;
  if L > 0 then
  begin
    C := P^;
    Inc(P);
    if ((L < 10) and (C in ['0'..'9'])) or ((L = 10) and (C in ['0'..'3'])) then
    begin
      for I := 1 to L - 1 do
      begin
        if not (P^ in ['0'..'9']) then
          Exit;
        Inc(P);
      end;
      Result := True;
    end
    else if (C = '$') or ((L = 10) and (C = '4')) then
      Result := Q_BetweenInt64(S, 0, 4294967295);
  end;
end;

function Q_IsDecimal(const S: String): boolean;
asm
         TEST    EAX,EAX
         JE      @@qt
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@zq
         @@lp:
         MOV     DL,[EAX+ECX]
         ADD     DL,$D0
         SUB     DL,$0A
         JNB     @@zq
         DEC     ECX
         JNS     @@lp
         MOV     EAX,1
         @@qt:
         RET
         @@zq:
         XOR     EAX,EAX
end;

{$IFDEF CPU32}
function Q_IsHexadecimal(const S: String): Boolean;
const
  HexDigsSet: TCharSet = ['0'..'9','A'..'F','a'..'f'];
asm
        TEST    EAX,EAX
        JE      @@qt
        MOV     ECX,[EAX-4]
        PUSH    ESI
        DEC     ECX
        JS      @@zq
        LEA     ESI,HexDigsSet
@@lp:   MOVZX   EDX,BYTE PTR [EAX+ECX]
        BT      [ESI],EDX
        JNC     @@zq
        DEC     ECX
        JNS     @@lp
        POP     ESI
        MOV     EAX,1
@@qt:   RET
@@zq:   POP     ESI
        XOR     EAX,EAX
end;
{$ELSE}

function Q_IsHexadecimal(const S: String): boolean;
begin
  ShowMessage('Q_IsHexadecimal TODO');
end;

{$ENDIF}

function Q_IsOctal(const S: String): boolean;
asm
         TEST    EAX,EAX
         JE      @@qt
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@zq
         @@lp:
         MOV     DL,[EAX+ECX]
         ADD     DL,$D0
         SUB     DL,$08
         JNB     @@zq
         DEC     ECX
         JNS     @@lp
         MOV     EAX,1
         @@qt:
         RET
         @@zq:
         XOR     EAX,EAX
end;

function Q_IsBinary(const S: String): boolean;
asm
         TEST    EAX,EAX
         JE      @@qt
         MOV     ECX,[EAX-4]
         DEC     ECX
         JS      @@zq
         @@lp:
         MOV     DL,[EAX+ECX]
         ADD     DL,$D0
         SUB     DL,$02
         JNB     @@zq
         DEC     ECX
         JNS     @@lp
         MOV     EAX,1
         @@qt:
         RET
         @@zq:
         XOR     EAX,EAX
end;

function Q_IsFloat(const S: String): boolean;
var
  L: integer;
  P: pansichar;
begin
  P := Pointer(S);
  L := Length(S);
  Result := False;
  while (L > 0) and (P^ = ' ') do
  begin
    Dec(L);
    Inc(P);
  end;
  if L > 0 then
  begin
    if P^ in ['-', '+'] then
    begin
      Dec(L);
      Inc(P);
      if L = 0 then
        Exit;
    end;
    if not (P^ in ['0'..'9']) then
      Exit;
    repeat
      Dec(L);
      Inc(P);
    until (L = 0) or not (P^ in ['0'..'9']);
    if L = 0 then
    begin
      Result := True;
      Exit;
    end;
    if P^ = ansichar(DecimalSeparator) then
    begin
      Dec(L);
      Inc(P);
      if (L = 0) or not (P^ in ['0'..'9']) then
        Exit;
      repeat
        Dec(L);
        Inc(P);
      until (L = 0) or not (P^ in ['0'..'9']);
      if L = 0 then
      begin
        Result := True;
        Exit;
      end;
    end;
    if P^ in ['E', 'e'] then
    begin
      Dec(L);
      Inc(P);
      if (L <> 0) and (P^ in ['-', '+']) then
      begin
        Dec(L);
        Inc(P);
      end;
      if (L = 0) or not (P^ in ['0'..'9']) then
        Exit;
      repeat
        Dec(L);
        Inc(P);
      until (L = 0) or not (P^ in ['0'..'9']);
      Result := L = 0;
    end;
  end;
end;

function Q_AdjustSeparator(const S: String): String;
var
  I, L: integer;
  P: pansichar;
begin
  L := Length(S);
  if DecimalSeparator = ',' then
  begin
    I := Q_ScanByte(byte('.'), Pointer(S), L);
    if I <> -1 then
    begin
      Result := '';
      SetLength(Result, L);
      P := Pointer(Result);
      if L <= 32 then
        Q_TinyCopy(Pointer(S), P, L)
      else
        Q_CopyMem(Pointer(S), P, L);
      Inc(P, I);
      P^ := ',';
    end
    else
      Result := S;
  end
  else
  begin
    I := Q_ScanByte(byte(','), Pointer(S), L);
    if I <> -1 then
    begin
      Result := '';
      SetLength(Result, L);
      P := Pointer(Result);
      if L <= 32 then
        Q_TinyCopy(Pointer(S), P, L)
      else
        Q_CopyMem(Pointer(S), P, L);
      Inc(P, I);
      P^ := '.';
    end
    else
      Result := S;
  end;
end;

function Q_BetweenInt(const S: String; LowBound, HighBound: integer): boolean;
var
  N: integer;
begin
  Result := Q_StrToInt(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function Q_BetweenUInt(const S: String; LowBound, HighBound: longword): boolean;
var
  N: longword;
begin
  Result := Q_StrToUInt(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function Q_BetweenInt64(const S: String; LowBound, HighBound: int64): boolean;
var
  N: int64;
begin
  Result := Q_StrToInt64(S, N) and (N >= LowBound) and (N <= HighBound);
end;

function Q_BetweenFloat(const S: String; LowBound, HighBound: double): boolean;
var
  N: double;
begin
  Result := TextToFloat(pansichar(S), N, fvDouble) and (N >= LowBound) and (N <= HighBound);
end;

function Q_BetweenCurr(const S: String; LowBound, HighBound: currency): boolean;
var
  N: currency;
begin
  Result := TextToFloat(pansichar(S), N, fvCurrency) and (N >= LowBound) and (N <= HighBound);
end;

function Q_StrToInt(const S: String; var V: integer): boolean;
var
  P: pansichar;
  C: integer;
  Sign: boolean;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ = '-' then
  begin
    Sign := True;
    Inc(P);
  end
  else
  begin
    Sign := False;
    if P^ = '+' then
      Inc(P);
  end;
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := byte(P^);
      if ansichar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < 0) or (V > $CCCCCCC) then
      begin
        Result := False;
        Exit;
      end;
      V := V * 10 + C;
      Inc(P);
    until False;
    if V < 0 then
    begin
      Result := (longword(V) = $80000000) and Sign and (C = 0);
      Exit;
    end;
  end
  else
  begin
    Inc(P);
    repeat
      C := byte(P^);
      case ansichar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
        else
          Break;
      end;
      if longword(V) >= $10000000 then
      begin
        Result := False;
        Exit;
      end;
      V := (V shl 4) or C;
      Inc(P);
    until False;
    if Sign and (longword(V) = $80000000) then
    begin
      Result := False;
      Exit;
    end;
  end;
  if Sign then
    V := -V;
  Result := C = 0;
end;

function Q_StrToUInt(const S: String; var V: longword): boolean;
var
  P: pansichar;
  C: longword;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := byte(P^);
      if ansichar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < $19999999) or ((V = $19999999) and (C < 6)) then
        V := V * 10 + C
      else
      begin
        Result := False;
        Exit;
      end;
      Inc(P);
    until False;
  end
  else
  begin
    Inc(P);
    repeat
      C := byte(P^);
      case ansichar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
        else
          Break;
      end;
      if longword(V) >= $10000000 then
      begin
        Result := False;
        Exit;
      end;
      V := (V shl 4) or C;
      Inc(P);
    until False;
  end;
  Result := C = 0;
end;

function Q_StrToInt64(const S: String; var V: int64): boolean;
type
  PArr64 = ^TArr64;
  TArr64 = array[0..7] of byte;
var
  P: pansichar;
  C: longword;
  Sign: longbool;
begin
  V := 0;
  P := Pointer(S);
  if not Assigned(P) then
  begin
    Result := False;
    Exit;
  end;
  while P^ = ' ' do
    Inc(P);
  if P^ = '-' then
  begin
    Sign := True;
    Inc(P);
  end
  else
  begin
    Sign := False;
    if P^ = '+' then
      Inc(P);
  end;
  if P^ <> '$' then
  begin
    if P^ = #0 then
    begin
      Result := False;
      Exit;
    end;
    repeat
      C := byte(P^);
      if ansichar(C) in ['0'..'9'] then
        Dec(C, 48)
      else
        Break;
      if (V < 0) or (V > $CCCCCCCCCCCCCCC) then
      begin
        Result := False;
        Exit;
      end;
      V := V * 10 + C;
      Inc(P);
    until False;
    if V < 0 then
    begin
      Result := (V = $8000000000000000) and Sign and (C = 0);
      Exit;
    end;
  end
  else
  begin
    Inc(P);
    repeat
      C := byte(P^);
      case ansichar(C) of
        '0'..'9': Dec(C, 48);
        'A'..'F': Dec(C, 55);
        'a'..'f': Dec(C, 87);
        else
          Break;
      end;
      if PArr64(@V)^[7] >= $10 then
      begin
        Result := False;
        Exit;
      end;
      V := V shl 4;
      PLong(@V)^ := PLong(@V)^ or C;
      Inc(P);
    until False;
    if Sign and (V = $8000000000000000) then
    begin
      Result := False;
      Exit;
    end;
  end;
  if Sign then
    V := -V;
  Result := C = 0;
end;

function Q_StrToFloat(const S: String; var V: double): boolean;
begin
  Result := TextToFloat(pansichar(S), V, fvDouble);
end;

function Q_StrToCurr(const S: String; var V: currency): boolean;
begin
  Result := TextToFloat(pansichar(S), V, fvCurrency);
end;

procedure Q_ConvertError(const Msg: String);
begin
  raise EConvertError.Create(Msg);
end;

procedure Q_ConvertErrorFmt(const Msg, S: String);
begin
  raise EConvertError.CreateFmt(Msg, [S]);
end;

function Q_IntToStr(N: integer): String;
begin
  ShowMessage(' TODO');
end;

{$IFDEF CPU32}
procedure Q_IntToStrBuf(N: Integer; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EDX]
        MOV     EDI,ESI
        TEST    EAX,EAX
        JE      @@eq
        JNS     @@ns
        CMP     EAX,$80000000
        JE      @@mm
        MOV     BYTE PTR [ESI],$2D
        INC     ESI
        NEG     EAX
@@ns:   MOV     ECX,$0A
@@lp1:  XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
        MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
        CMP     BYTE PTR [EDI],$2D
        JE      @@ws
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        DEC     ECX
@@ws:   INC     EDI
        JMP     @@lp2
@@qt:   POP     EDI
        POP     ESI
        RET
@@eq:   MOV     WORD PTR [ESI],$0030
        MOV     DWORD PTR [ESI-4],1
        POP     EDI
        POP     ESI
        RET
@@mm:   MOV     DWORD PTR [ESI],$3431322D
        MOV     DWORD PTR [ESI+4],$33383437
        MOV     DWORD PTR [ESI+8],$00383436
        MOV     DWORD PTR [ESI-4],11
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_IntToStrBuf(N: integer; var S: String);
begin
  ShowMessage('Q_IntToStrBuf TODO');
end;

{$ENDIF}

function Q_UIntToStr(N: longword): String;
begin
  ShowMessage('Q_UIntToStr TODO');
end;

{$IFDEF CPU32}
procedure Q_UIntToStrBuf(N: LongWord; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,[EDX]
        MOV     EDI,ESI
        TEST    EAX,EAX
        JE      @@eq
        MOV     ECX,$0A
@@lp1:  XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
        MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EDI
        POP     ESI
        RET
@@eq:   MOV     WORD PTR [ESI],$0030
        MOV     DWORD PTR [ESI-4],1
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_UIntToStrBuf(N: longword; var S: String);
begin
  ShowMessage('Q_UIntToStrBuf TODO');
end;

{$ENDIF}

function Q_UIntToStrL(N: longword; Digits: cardinal): String;
begin
  ShowMessage('Q_UIntToStrL TODO');
end;

{$IFDEF CPU32}
procedure Q_UIntToStrLBuf(N: LongWord; Digits: Cardinal; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,[ECX]
        MOV     EBX,EDX
        MOV     EDI,ESI
        MOV     ECX,$0A
@@lp1:  DEC     EBX
        JS      @@ob
        XOR     EDX,EDX
        DIV     ECX
        ADD     DL,$30
        MOV     BYTE PTR [ESI],DL
        INC     ESI
        TEST    EAX,EAX
        JNE     @@lp1
@@bl:   DEC     EBX
        JS      @@ob
        MOV     BYTE PTR [ESI],$30
        INC     ESI
        JMP     @@bl
@@ob:   MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_UIntToStrLBuf(N: longword; Digits: cardinal; var S: String);
begin
  ShowMessage('Q_UIntToStrLBuf TODO');
end;

{$ENDIF}

function Q_IntToRoman(N: integer): String;
const
  T_s: array[0..5] of String = ('', 'M', 'MM', 'MMM', 'MMMM', 'MMMMM');
  S_s: array[0..9] of String = ('', 'C', 'CC', 'CCC', 'CD', 'D', 'DC', 'DCC', 'DCCC', 'CM');
  D_s: array[0..9] of String = ('', 'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC');
  E_s: array[0..9] of String = ('', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX');
var
  T, S, D: integer;
begin
  if (N >= 1) and (N <= 5000) then
  begin
    T := 0;
    while N >= 1000 do
    begin
      Dec(N, 1000);
      Inc(T);
    end;
    S := 0;
    if N >= 500 then
    begin
      Dec(N, 500);
      S := 5;
    end;
    while N >= 100 do
    begin
      Dec(N, 100);
      Inc(S);
    end;
    D := 0;
    if N >= 50 then
    begin
      Dec(N, 50);
      D := 5;
    end;
    while N >= 10 do
    begin
      Dec(N, 10);
      Inc(D);
    end;
    Result := T_s[T] + S_s[S] + D_s[D] + E_s[N];
  end
  else
    Result := '?????';
end;

function Q_RomanToInt(const S: String): integer;
var
  I, N, PN: integer;
begin
  N := 10000;
  Result := 0;
  for I := 1 to Length(S) do
  begin
    PN := N;
    case S[I] of
      'C': N := 100;
      'D': N := 500;
      'I': N := 1;
      'L': N := 50;
      'M': N := 1000;
      'V': N := 5;
      'X': N := 10;
      'c': N := 100;
      'd': N := 500;
      'i': N := 1;
      'l': N := 50;
      'm': N := 1000;
      'v': N := 5;
      'x': N := 10;
      else
        Q_ConvertErrorFmt('Ошибка в ходе преобразования римского числа %s в целое число.', S);
    end;
    if N <= PN then
      Inc(Result, N)
    else
      Inc(Result, N - (PN shl 1));
  end;
end;

function Q_UIntToHex(N: longword; Digits: cardinal): String;
begin
  ShowMessage('Q_UIntToHex TODO');
end;

{$IFDEF CPU32}
procedure Q_UIntToHexBuf(N: LongWord; Digits: Cardinal; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,[ECX]
        MOV     EDI,ESI
@@lp1:  DEC     EDX
        JS      @@ob
        MOV     BL,AL
        AND     BL,$0F
        CMP     BL,$09
        JA      @@bd
        ADD     BL,$30
        MOV     BYTE PTR [ESI],BL
        INC     ESI
        SHR     EAX,4
        JNE     @@lp1
        JMP     @@bl
@@bd:   ADD     BL,$37
        MOV     BYTE PTR [ESI],BL
        INC     ESI
        SHR     EAX,4
        JNE     @@lp1
@@bl:   DEC     EDX
        JS      @@ob
        MOV     BYTE PTR [ESI],$30
        INC     ESI
        JMP     @@bl
@@ob:   MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_UIntToHexBuf(N: longword; Digits: cardinal; var S: String);
begin
  ShowMessage('Q_UIntToHexBuf TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_HexToUInt(const S: String): LongWord;
const
  Msg: String = 'Ошибка в ходе преобразования шестнадцатеричного числа %s в целое число.';
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        TEST    EAX,EAX
        JE      @@err
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@err
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   MOV     DL,BYTE PTR [EBX]
        SHL     EAX,4
        SUB     DL,$30
        JB      @@err
        CMP     DL,$09
        JBE     @@ct
        SUB     DL,$11
        JB      @@err
        CMP     DL,$05
        JBE     @@pt
        SUB     DL,$20
        JB      @@err
        CMP     DL,$05
        JA      @@err
@@pt:   ADD     DL,$0A
@@ct:   OR      AL,DL
        INC     EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
        RET
@@err:  MOV     EAX,Msg
        MOV     EDX,ESI
        POP     EBX
        POP     ESI
        CALL    Q_ConvertErrorFmt
end;
{$ELSE}

function Q_HexToUInt(const S: String): longword;
begin
  ShowMessage('Q_HexToUInt TODO');
end;

{$ENDIF}

function Q_UIntToOct(N: longword; Digits: cardinal): String;
begin
  ShowMessage('Q_UIntToOct TODO');
end;

{$IFDEF CPU32}
procedure Q_UIntToOctBuf(N: LongWord; Digits: Cardinal; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,[ECX]
        MOV     EDI,ESI
@@lp1:  DEC     EDX
        JS      @@ob
        MOV     BL,AL
        AND     BL,$07
        ADD     BL,$30
        MOV     BYTE PTR [ESI],BL
        INC     ESI
        SHR     EAX,3
        JNE     @@lp1
@@bl:   DEC     EDX
        JS      @@ob
        MOV     BYTE PTR [ESI],$30
        INC     ESI
        JMP     @@bl
@@ob:   MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_UIntToOctBuf(N: longword; Digits: cardinal; var S: String);
begin
  ShowMessage('Q_UIntToOctBuf TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_OctToUInt(const S: String): LongWord;
const
  Msg: String = 'Ошибка в ходе преобразования восьмеричного числа %s в целое число.';
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        TEST    EAX,EAX
        JE      @@err
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@err
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   MOV     DL,BYTE PTR [EBX]
        SHL     EAX,3
        SUB     DL,$30
        JB      @@err
        CMP     DL,$07
        JA      @@err
        OR      AL,DL
        INC     EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
        RET
@@err:  MOV     EAX,Msg
        MOV     EDX,ESI
        POP     EBX
        POP     ESI
        CALL    Q_ConvertErrorFmt
end;
{$ELSE}

function Q_OctToUInt(const S: String): longword;
begin
  ShowMessage('Q_OctToUInt TODO');
end;

{$ENDIF}

function Q_UIntToBin(N: longword; Digits: cardinal): String;
begin
  ShowMessage('Q_UIntToBin TODO');
end;

{$IFDEF CPU32}
procedure Q_UIntToBinBuf(N: LongWord; Digits: Cardinal; var S: String);
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,[ECX]
        MOV     EDI,ESI
@@lp1:  DEC     EDX
        JS      @@ob
        XOR     EBX,EBX
        SHR     EAX,1
        ADC     BL,$30
        MOV     BYTE PTR [ESI],BL
        INC     ESI
        JMP     @@lp1
@@ob:   MOV     BYTE PTR [ESI],0
        LEA     ECX,[ESI-1]
        SUB     ESI,EDI
        MOV     DWORD PTR [EDI-4],ESI
@@lp2:  CMP     EDI,ECX
        JAE     @@qt
        MOV     AH,BYTE PTR [EDI]
        MOV     AL,BYTE PTR [ECX]
        MOV     BYTE PTR [ECX],AH
        MOV     BYTE PTR [EDI],AL
        INC     EDI
        DEC     ECX
        JMP     @@lp2
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;
{$ELSE}

procedure Q_UIntToBinBuf(N: longword; Digits: cardinal; var S: String);
begin
  ShowMessage('Q_UIntToBinBuf TODO');
end;

{$ENDIF}


{$IFDEF CPU32}
function Q_BinToUInt(const S: String): LongWord;
const
  Msg: String = 'Ошибка в ходе преобразования двоичного числа %s в целое число.';
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        TEST    EAX,EAX
        JE      @@err
        MOV     ECX,[EAX-4]
        TEST    ECX,ECX
        JE      @@err
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   MOV     DL,BYTE PTR [EBX]
        SHL     EAX,1
        SUB     DL,$30
        JB      @@err
        TEST    DL,$FE
        JNE     @@err
        OR      AL,DL
        INC     EBX
        DEC     ECX
        JNE     @@lp
        POP     EBX
        POP     ESI
        RET
@@err:  MOV     EAX,Msg
        MOV     EDX,ESI
        POP     EBX
        POP     ESI
        CALL    Q_ConvertErrorFmt
end;
{$ELSE}

function Q_BinToUInt(const S: String): longword;
begin
  ShowMessage('Q_BinToUInt TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntMul(P: Pointer; L: Cardinal; N: Cardinal);
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EBP
        MOV     ESI,EAX
        MOV     EBP,ECX
        MOV     ECX,EDX
        XOR     EBX,EBX
@@lp:   MOV     EAX,[ESI]
        MUL     EBP
        ADD     EAX,EBX
        MOV     EBX,EDX
        MOV     [ESI],EAX
        ADC     EBX,0
        ADD     ESI,4
        DEC     ECX
        JNE     @@lp
        POP     EBP
        POP     ESI
        POP     EBX
end;
{$ELSE}

procedure IntMul(P: Pointer; L: cardinal; N: cardinal);
begin
  ShowMessage('IntMul TODO');
end;

{$ENDIF}

procedure IntAdd(P: Pointer; N: cardinal);
asm
         @@lp:
         ADD     [EAX],EDX
         JC      @@nx
         RET
         @@nx:
         ADD     EAX,4
         MOV     EDX,1
         JMP     @@lp
end;

{$IFDEF CPU32}
function IntDiv(P: Pointer; L: Cardinal; N: Cardinal): Cardinal;
asm
        PUSH    EBX
        PUSH    ESI
        MOV     EBX,ECX
        MOV     ESI,EAX
        LEA     ECX,[EDX-1]
        XOR     EDX,EDX
@@lp:   MOV     EAX,[ESI+ECX*4]
        DIV     EBX
        MOV     [ESI+ECX*4],EAX
        DEC     ECX
        JNS     @@lp
        MOV     EAX,EDX
        POP     ESI
        POP     EBX
end;
{$ELSE}

function IntDiv(P: Pointer; L: cardinal; N: cardinal): cardinal;
begin
  ShowMessage('IntDiv TODO');
end;

{$ENDIF}

function Q_ChangeBase(const Number: String; BaseFrom, BaseTo: cardinal; DigitsInGroup: cardinal; GroupSeparator: ansichar): String;
const
  Letters: String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
type
  PDigits = ^TDigits;
  TDigits = array[1..100000000] of byte;
  PLongs = ^TLongs;
  TLongs = array[1..25000000] of longword;
var
  Digits: PDigits;
  DigOut: PDigits;
  D: double;
  L, I, U, Q: longword;
  P: ^ansichar;
  C: ansichar;
begin
  L := Length(Number) - Q_CharCount(Number, GroupSeparator);
  if (BaseFrom < 2) or (BaseFrom > 36) then
    Q_ConvertErrorFmt('Неправильное исходное основание числа: %s',
      Q_UIntToStr(BaseFrom));
  if (BaseTo < 2) or (BaseTo > 36) then
    Q_ConvertErrorFmt('Неправильное конечное основание числа: %s',
      Q_UIntToStr(BaseTo));
  if L > 0 then
  begin
    GetMem(Digits, L);
    Q := 1;
    for I := 1 to Length(Number) do
    begin
      C := Number[I];
      if C <> GroupSeparator then
      begin
        U := Q_StrScan(Letters, ToUpperChars[byte(C)]);
        if (U = 0) or (U > BaseFrom) then
          Q_ConvertErrorFmt('Невозможно преобразовать символ ''%s'' в функции Q_ChangeBase', C);
        Digits^[Q] := U - 1;
        Inc(Q);
      end;
    end;
    D := Log2(BaseFrom) * L;
    Q := Round(D);
    if D = Int(D) then
      Dec(Q);
    U := (Q shr 5) + 1;
    GetMem(P, U shl 2);
    Q_FillLong(0, P, U);
    for I := 1 to L do
    begin
      IntMul(P, U, BaseFrom);
      IntAdd(P, Digits^[I]);
    end;
    FreeMem(Digits);
    GetMem(DigOut, Round(Q / Log2(BaseTo)) + 1);
    DigOut^[1] := 0;
    while (U > 0) and (PLongs(P)^[U] = 0) do
      Dec(U);
    L := 1;
    while U > 0 do
    begin
      DigOut^[L] := IntDiv(P, U, BaseTo);
      if PLongs(P)^[U] = 0 then
        Dec(U);
      Inc(L);
    end;
    FreeMem(P);
    if L > 1 then
      Dec(L);
    if DigitsInGroup <> 0 then
    begin
      SetString(Result, nil, (L - 1) div DigitsInGroup + L);
      P := Pointer(Result);
      repeat
        P^ := Letters[DigOut^[L] + 1];
        Dec(L);
        Inc(P);
        if (L mod DigitsInGroup = 0) and (L <> 0) then
        begin
          P^ := GroupSeparator;
          Inc(P);
        end;
      until L = 0;
    end
    else
    begin
      SetString(Result, nil, L);
      P := Pointer(Result);
      repeat
        P^ := Letters[DigOut^[L] + 1];
        Inc(P);
        Dec(L);
      until L = 0;
    end;
    FreeMem(DigOut);
  end
  else
    Result := '';
end;

function Q_StrToCodes(const S: String): String;
begin
  ShowMessage('Q_StrToCodes TODO');
end;

function Q_CodesToStr(const S: String): String;
begin
  ShowMessage('Q_CodesToStr TODO');
end;

function ModDiv10(var X: integer): integer;
const
  Base10: integer = 10;
asm
         MOV     ECX,EAX
         MOV     EAX,[EAX]
         XOR     EDX,EDX
         DIV     Base10
         MOV     [ECX],EAX
         MOV     EAX,EDX
end;

function Q_NumToStr(N: int64; var S: String; FmtFlags: longword): integer;
const
  M_Ed: array [1..9] of String =
    ('один ', 'два ', 'три ', 'четыре ', 'пять ', 'шесть ', 'семь ', 'восемь ', 'девять ');
  W_Ed: array [1..9] of String =
    ('одна ', 'две ', 'три ', 'четыре ', 'пять ', 'шесть ', 'семь ', 'восемь ', 'девять ');
  S_Ed: array [1..9] of String =
    ('одно ', 'два ', 'три ', 'четыре ', 'пять ', 'шесть ', 'семь ', 'восемь ', 'девять ');
  E_Ds: array [0..9] of String =
    ('десять ', 'одиннадцать ', 'двенадцать ', 'тринадцать ', 'четырнадцать ',
    'пятнадцать ', 'шестнадцать ', 'семнадцать ', 'восемнадцать ', 'девятнадцать ');
  D_Ds: array [2..9] of String =
    ('двадцать ', 'тридцать ', 'сорок ', 'пятьдесят ', 'шестьдесят ', 'семьдесят ',
    'восемьдесят ', 'девяносто ');
  U_Hd: array [1..9] of String =
    ('сто ', 'двести ', 'триста ', 'четыреста ', 'пятьсот ', 'шестьсот ', 'семьсот ',
    'восемьсот ', 'девятьсот ');
  M_Tr: array[1..6, 0..3] of String =
    (('тыс. ', 'тысяча ', 'тысячи ', 'тысяч '),
    ('млн. ', 'миллион ', 'миллиона ', 'миллионов '),
    ('млрд. ', 'миллиард ', 'миллиарда ', 'миллиардов '),
    ('трлн. ', 'триллион ', 'триллиона ', 'триллионов '),
    ('квадр. ', 'квадриллион ', 'квадриллиона ', 'квадриллионов '),
    ('квинт. ', 'квинтиллион ', 'квинтиллиона ', 'квинтиллионов '));
var
  V1: int64;
  VArr: array[0..6] of integer;
  I, E, D, H, Cnt: integer;
begin
  Result := 3;
  if N <> 0 then
  begin
    if N < 0 then
    begin
      if N <> $8000000000000000 then
      begin
        N := -N;
        S := 'минус ';
      end
      else
      begin                                 { -9.223.372.036.854.775.808 }
        if FmtFlags and nsShort = 0 then
          S := 'минус девять квинтиллионов двести двадцать три квадриллиона' +
            ' триста семьдесят два триллиона тридцать шесть миллиардов' +
            ' восемьсот пятьдесят четыре миллиона семьсот семьдесят пять' +
            ' тысяч восемьсот восемь '
        else
          S := 'минус девять квинт. двести двадцать три квадр. триста' +
            ' семьдесят два трлн. тридцать шесть млрд. восемьсот пятьдесят' +
            ' четыре млн. семьсот семьдесят пять тыс. восемьсот восемь ';
        Exit;
      end;
    end
    else
      S := '';
    Cnt := 0;
    repeat
      V1 := N div 1000;
      VArr[Cnt] := N - (V1 * 1000);
      N := V1;
      Inc(Cnt);
    until V1 = 0;
    for I := Cnt - 1 downto 0 do
    begin
      H := VArr[I];
      Result := 3;
      if H <> 0 then
      begin
        E := ModDiv10(H);
        D := ModDiv10(H);
        if D <> 1 then
        begin
          if E = 1 then
            Result := 1
          else if (E >= 2) and (E <= 4) then
            Result := 2;
          if (H <> 0) and (D <> 0) then
            S := S + U_Hd[H] + D_Ds[D]
          else if H <> 0 then
            S := S + U_Hd[H]
          else if D <> 0 then
            S := S + D_Ds[D];
          if E <> 0 then
            if I = 0 then
              case FmtFlags and 3 of
                1: S := S + M_Ed[E];
                2: S := S + W_Ed[E];
                3: S := S + S_Ed[E];
                else
                  S := S + '#### ';
              end
            else if I = 1 then
              S := S + W_Ed[E]
            else
              S := S + M_Ed[E];
        end
        else
        if H = 0 then
          S := S + E_Ds[E]
        else
          S := S + U_Hd[H] + E_Ds[E];
        if I <> 0 then
        begin
          if FmtFlags and nsShort = 0 then
            S := S + M_Tr[I, Result]
          else
            S := S + M_Tr[I, 0];
        end;
      end;
    end;
  end
  else
    S := 'ноль ';
end;

function Q_NumToRub(V: currency; RubFormat, CopFormat: longword): String;
var
  V1: int64;
  S1, S2, S3, S4: String;
  Cp, I: integer;
  Negative: boolean;
begin
  if V >= 0 then
    Negative := False
  else
  begin
    Negative := True;
    V := -V;
  end;
  if RubFormat <> nrNone then
  begin
    if CopFormat <> nrNone then
    begin
      V1 := Trunc(V);
      Cp := Round(Frac(V) * 100);
      if V1 <> 0 then
      begin
        if RubFormat and 1 = 0 then
        begin
          if RubFormat and 2 <> 0 then
          begin
            case Q_NumToStr(V1, S1, nsMale or (RubFormat and 4)) of
              1: S2 := 'рубль ';
              2: S2 := 'рубля ';
              3: S2 := 'рублей ';
            end;
          end
          else
          begin
            S1 := IntToStr(V1);
            I := V1 mod 100;
            if (I < 10) or (I > 20) then
            begin
              case I mod 10 of
                1: S2 := ' рубль ';
                2, 3, 4: S2 := ' рубля ';
                else
                  S2 := ' рублей ';
              end;
            end
            else
              S2 := ' рублей ';
          end;
        end
        else
        begin
          if RubFormat and 2 <> 0 then
          begin
            Q_NumToStr(V1, S1, nsMale or (RubFormat and 4));
            S2 := 'руб. ';
          end
          else
          begin
            S1 := IntToStr(V1);
            S2 := ' руб. ';
          end;
        end;
      end
      else
      begin
        S1 := '';
        S2 := '';
      end;
      if CopFormat and 1 = 0 then
      begin
        if CopFormat and 2 <> 0 then
        begin
          case Q_NumToStr(Cp, S3, nsFemale) of
            1: S4 := 'копейка';
            2: S4 := 'копейки';
            3: S4 := 'копеек';
          end;
        end
        else
        begin
          S3 := Q_UIntToStrL(Cp, 2);
          I := Cp mod 100;
          if (I < 10) or (I > 20) then
          begin
            case I mod 10 of
              1: S4 := ' копейка';
              2, 3, 4: S4 := ' копейки';
              else
                S4 := ' копеек';
            end;
          end
          else
            S4 := ' копеек';
        end;
      end
      else
      begin
        if CopFormat and 2 <> 0 then
        begin
          Q_NumToStr(Cp, S3, nsFemale);
          S4 := 'коп.';
        end
        else
        begin
          S3 := Q_UIntToStrL(Cp, 2);
          S4 := ' коп.';
        end;
      end;
      if not Negative then
      begin
        Result := S1 + S2 + S3 + S4;
        Result[1] := ToUpperChars[byte(Result[1])];
      end
      else
      begin
        Result := '(' + S1 + S2 + S3 + S4 + ')';
        Result[2] := ToUpperChars[byte(Result[2])];
      end;
    end
    else
    begin
      V1 := Round(V);
      if V1 <> 0 then
      begin
        if RubFormat and 1 = 0 then
        begin
          if RubFormat and 2 <> 0 then
          begin
            case Q_NumToStr(V1, S1, nsMale or (RubFormat and 4)) of
              1: S2 := 'рубль';
              2: S2 := 'рубля';
              3: S2 := 'рублей';
            end;
          end
          else
          begin
            S1 := IntToStr(V1);
            I := V1 mod 100;
            if (I < 10) or (I > 20) then
            begin
              case I mod 10 of
                1: S2 := ' рубль';
                2, 3, 4: S2 := ' рубля';
                else
                  S2 := ' рублей';
              end;
            end
            else
              S2 := ' рублей';
          end;
        end
        else
        begin
          if RubFormat and 2 <> 0 then
          begin
            Q_NumToStr(V1, S1, nsMale or (RubFormat and 4));
            S2 := 'руб.';
          end
          else
          begin
            S1 := IntToStr(V1);
            S2 := ' руб.';
          end;
        end;
        S1[1] := ToUpperChars[byte(S1[1])];
        if not Negative then
          Result := S1 + S2
        else
          Result := '(' + S1 + S2 + ')';
      end
      else
        Result := '';
    end;
  end
  else if CopFormat <> nrNone then
  begin
    V1 := Round(V * 100);
    if CopFormat and 1 = 0 then
    begin
      if CopFormat and 2 <> 0 then
      begin
        case Q_NumToStr(V1, S1, nsFemale or (CopFormat and 4)) of
          1: S2 := 'копейка';
          2: S2 := 'копейки';
          3: S2 := 'копеек';
        end;
      end
      else
      begin
        S1 := IntToStr(V1);
        I := V1 mod 100;
        if (I < 10) or (I > 20) then
        begin
          case I mod 10 of
            1: S2 := ' копейка';
            2, 3, 4: S2 := ' копейки';
            else
              S2 := ' копеек';
          end;
        end
        else
          S2 := ' копеек';
      end;
    end
    else
    begin
      if CopFormat and 2 <> 0 then
      begin
        Q_NumToStr(V1, S1, nsFemale or (CopFormat and 4));
        S2 := 'коп.';
      end
      else
      begin
        S1 := IntToStr(V1);
        S2 := ' коп.';
      end;
    end;
    S1[1] := ToUpperChars[byte(S1[1])];
    if not Negative then
      Result := S1 + S2
    else
      Result := '(' + S1 + S2 + ')';
  end
  else if not Negative then
    Result := FormatFloat('0.00', V)
  else
    Result := '(' + FormatFloat('0.00', V) + ')';
end;


{ Функции для работы с датами. }

function Q_GetDateStr(Date: TDateTime): String;
var
  Y, M, D: word;
begin
  DecodeDate(Date, Y, M, D);
  Result := Q_UIntToStr(D) + ' ' + Q_MonthsLo[M] + ' ' + Q_UIntToStr(Y) + ' г.';
end;

function Q_GetMonthStr(Date: TDateTime): String;
var
  Y, M, D: word;
begin
  DecodeDate(Date, Y, M, D);
  Result := Q_MonthsUp[M] + ' ' + Q_UIntToStr(Y) + ' г.';
end;


{ Функции для работы с бинарными строками. }

procedure Q_ZeroMem(P: Pointer; L: cardinal);
begin
 FillChar(P^, L, #0);
end;
(*
{$IFDEF CPU32}
procedure Q_ZeroMem(P: Pointer; L: Cardinal);
asm
        CMP     EDX,32
        JA      @@nx
        XOR     ECX,ECX
        CALL    Q_TinyFill
        RET
@@nx:   PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;
{$ELSE}
procedure Q_ZeroMem(P: Pointer; L: cardinal);
begin
 FillChar(P^, L, #0);
end;
{ Q_ZeroMem обнуляет область памяти, указываемую параметром P. Число байт
  задается параметром L. }
var
  I: integer;
begin
  try
    for I := 0 to L - 1 do
      TbArray(P^)[I] := 0;
  except
    ;
  end;
end;
{$ENDIF}
*)

{$IFDEF CPU32}
procedure Q_OnesMem(P: Pointer; L: Cardinal);
asm
        CMP     EDX,32
        JA      @@nx
        MOV     ECX,$FFFFFFFF
        CALL    Q_TinyFill
        RET
@@nx:   PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        DEC     EAX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;
{$ELSE}

procedure Q_OnesMem(P: Pointer; L: cardinal);
begin
  ShowMessage('Q_OnesMem TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_FillChar(P: Pointer; L: Cardinal; Ch: AnsiChar); overload;
asm
        PUSH    EDI
        MOV     EDI,EAX
        MOVZX   EAX,CL
        CMP     EDX,16
        JB      @@tl
        MOV     ECX,EDI
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EAX
        SHL     EAX,8
        ADD     EAX,ECX
        MOV     ECX,EAX
        SHL     EAX,16
        ADD     EAX,ECX
        MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
@@tl:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
@@tu15: MOV     [EDI+14],AL
@@tu14: MOV     [EDI+13],AL
@@tu13: MOV     [EDI+12],AL
@@tu12: MOV     [EDI+11],AL
@@tu11: MOV     [EDI+10],AL
@@tu10: MOV     [EDI+09],AL
@@tu09: MOV     [EDI+08],AL
@@tu08: MOV     [EDI+07],AL
@@tu07: MOV     [EDI+06],AL
@@tu06: MOV     [EDI+05],AL
@@tu05: MOV     [EDI+04],AL
@@tu04: MOV     [EDI+03],AL
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;
{$ELSE}

procedure Q_FillChar(P: Pointer; L: cardinal; Ch: ansichar); overload;
begin
  ShowMessage('Q_FillChar TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_FillChar(P: Pointer; L: Cardinal; Ch: Byte); overload;
asm
        PUSH    EDI
        MOV     EDI,EAX
        MOVZX   EAX,CL
        CMP     EDX,16
        JB      @@tl
        MOV     ECX,EDI
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EAX
        SHL     EAX,8
        ADD     EAX,ECX
        MOV     ECX,EAX
        SHL     EAX,16
        ADD     EAX,ECX
        MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
@@tl:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
@@tu15: MOV     [EDI+14],AL
@@tu14: MOV     [EDI+13],AL
@@tu13: MOV     [EDI+12],AL
@@tu12: MOV     [EDI+11],AL
@@tu11: MOV     [EDI+10],AL
@@tu10: MOV     [EDI+09],AL
@@tu09: MOV     [EDI+08],AL
@@tu08: MOV     [EDI+07],AL
@@tu07: MOV     [EDI+06],AL
@@tu06: MOV     [EDI+05],AL
@@tu05: MOV     [EDI+04],AL
@@tu04: MOV     [EDI+03],AL
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;
{$ELSE}

procedure Q_FillChar(P: Pointer; L: cardinal; Ch: byte); overload;
begin
  ShowMessage('Q_FillChar TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_FillLong(Value: LongWord; P: Pointer; Count: Cardinal);
asm
        CMP     ECX,32
        JBE     @@xx
        XCHG    EDI,EDX
        REP     STOSD
        MOV     EDI,EDX
        RET
@@xx:   JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16, @@w17, @@w18, @@w19
        DD      @@w20, @@w21, @@w22, @@w23
        DD      @@w24, @@w25, @@w26, @@w27
        DD      @@w28, @@w29, @@w30, @@w31
        DD      @@w32
@@w32:  MOV     [EDX+124],EAX
@@w31:  MOV     [EDX+120],EAX
@@w30:  MOV     [EDX+116],EAX
@@w29:  MOV     [EDX+112],EAX
@@w28:  MOV     [EDX+108],EAX
@@w27:  MOV     [EDX+104],EAX
@@w26:  MOV     [EDX+100],EAX
@@w25:  MOV     [EDX+96],EAX
@@w24:  MOV     [EDX+92],EAX
@@w23:  MOV     [EDX+88],EAX
@@w22:  MOV     [EDX+84],EAX
@@w21:  MOV     [EDX+80],EAX
@@w20:  MOV     [EDX+76],EAX
@@w19:  MOV     [EDX+72],EAX
@@w18:  MOV     [EDX+68],EAX
@@w17:  MOV     [EDX+64],EAX
@@w16:  MOV     [EDX+60],EAX
@@w15:  MOV     [EDX+56],EAX
@@w14:  MOV     [EDX+52],EAX
@@w13:  MOV     [EDX+48],EAX
@@w12:  MOV     [EDX+44],EAX
@@w11:  MOV     [EDX+40],EAX
@@w10:  MOV     [EDX+36],EAX
@@w09:  MOV     [EDX+32],EAX
@@w08:  MOV     [EDX+28],EAX
@@w07:  MOV     [EDX+24],EAX
@@w06:  MOV     [EDX+20],EAX
@@w05:  MOV     [EDX+16],EAX
@@w04:  MOV     [EDX+12],EAX
@@w03:  MOV     [EDX+8],EAX
@@w02:  MOV     [EDX+4],EAX
@@w01:  MOV     [EDX],EAX
@@w00:
end;
{$ELSE}

procedure Q_FillLong(Value: longword; P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_FillLong TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_TinyFill(P: Pointer; L: Cardinal; Value: LongWord);
asm
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
        DD      @@tu16, @@tu17, @@tu18, @@tu19
        DD      @@tu20, @@tu21, @@tu22, @@tu23
        DD      @@tu24, @@tu25, @@tu26, @@tu27
        DD      @@tu28, @@tu29, @@tu30, @@tu31
        DD      @@tu32
@@tu00: RET
@@tu01: MOV     BYTE PTR [EAX],CL
        RET
@@tu02: MOV     WORD PTR [EAX],CX
        RET
@@tu03: MOV     WORD PTR [EAX],CX
        MOV     BYTE PTR [EAX+2],CL
        RET
@@tu04: MOV     DWORD PTR [EAX],ECX
        RET
@@tu05: MOV     DWORD PTR [EAX],ECX
        MOV     BYTE PTR [EAX+4],CL
        RET
@@tu06: MOV     DWORD PTR [EAX],ECX
        MOV     WORD PTR [EAX+4],CX
        RET
@@tu07: MOV     DWORD PTR [EAX],ECX
        MOV     WORD PTR [EAX+4],CX
        MOV     BYTE PTR [EAX+6],CL
        RET
@@tu08: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        RET
@@tu09: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     BYTE PTR [EAX+8],CL
        RET
@@tu10: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     WORD PTR [EAX+8],CX
        RET
@@tu11: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     WORD PTR [EAX+8],CX
        MOV     BYTE PTR [EAX+10],CL
        RET
@@tu12: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        RET
@@tu13: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     BYTE PTR [EAX+12],CL
        RET
@@tu14: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     WORD PTR [EAX+12],CX
        RET
@@tu15: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     WORD PTR [EAX+12],CX
        MOV     BYTE PTR [EAX+14],CL
        RET
@@tu16: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        RET
@@tu17: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     BYTE PTR [EAX+16],CL
        RET
@@tu18: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     WORD PTR [EAX+16],CX
        RET
@@tu19: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     WORD PTR [EAX+16],CX
        MOV     BYTE PTR [EAX+18],CL
        RET
@@tu20: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        RET
@@tu21: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     BYTE PTR [EAX+20],CL
        RET
@@tu22: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     WORD PTR [EAX+20],CX
        RET
@@tu23: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     WORD PTR [EAX+20],CX
        MOV     BYTE PTR [EAX+22],CL
        RET
@@tu24: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        RET
@@tu25: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     BYTE PTR [EAX+24],CL
        RET
@@tu26: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     WORD PTR [EAX+24],CX
        RET
@@tu27: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     WORD PTR [EAX+24],CX
        MOV     BYTE PTR [EAX+26],CL
        RET
@@tu28: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        RET
@@tu29: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     BYTE PTR [EAX+28],CL
        RET
@@tu30: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     WORD PTR [EAX+28],CX
        RET
@@tu31: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     WORD PTR [EAX+28],CX
        MOV     BYTE PTR [EAX+30],CL
        RET
@@tu32: MOV     DWORD PTR [EAX],ECX
        MOV     DWORD PTR [EAX+4],ECX
        MOV     DWORD PTR [EAX+8],ECX
        MOV     DWORD PTR [EAX+12],ECX
        MOV     DWORD PTR [EAX+16],ECX
        MOV     DWORD PTR [EAX+20],ECX
        MOV     DWORD PTR [EAX+24],ECX
        MOV     DWORD PTR [EAX+28],ECX
end;
{$ELSE}

procedure Q_TinyFill(P: Pointer; L: cardinal; Value: longword);
begin
  ShowMessage('Q_TinyFill TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_FillRandom(P: Pointer; L: Cardinal; Seed: LongWord);
asm
        PUSH    ESI
        DEC     EDX
        JS      @@qt
        MOV     ESI,$8088405
        PUSH    EBX
@@lp:   IMUL    ECX,ESI
        INC     ECX
        MOV     EBX,ECX
        SHR     EBX,24
        MOV     BYTE PTR [EAX+EDX],BL
        DEC     EDX
        JNS     @@lp
        POP     EBX
@@qt:   POP     ESI
end;
{$ELSE}

procedure Q_FillRandom(P: Pointer; L: cardinal; Seed: longword);
begin
  ShowMessage('Q_FillRandom TODO');
end;

{$ENDIF}

procedure IntFill16(P: Pointer; V: longword);
asm
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     [EAX+16],EDX
         MOV     [EAX+20],EDX
         MOV     [EAX+24],EDX
         MOV     [EAX+28],EDX
         MOV     [EAX+32],EDX
         MOV     [EAX+36],EDX
         MOV     [EAX+40],EDX
         MOV     [EAX+44],EDX
         MOV     [EAX+48],EDX
         MOV     [EAX+52],EDX
         MOV     [EAX+56],EDX
         MOV     [EAX+60],EDX
end;

procedure IntFill32(P: Pointer; V: longword);
asm
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     [EAX+16],EDX
         MOV     [EAX+20],EDX
         MOV     [EAX+24],EDX
         MOV     [EAX+28],EDX
         MOV     [EAX+32],EDX
         MOV     [EAX+36],EDX
         MOV     [EAX+40],EDX
         MOV     [EAX+44],EDX
         MOV     [EAX+48],EDX
         MOV     [EAX+52],EDX
         MOV     [EAX+56],EDX
         MOV     [EAX+60],EDX
         MOV     [EAX+64],EDX
         MOV     [EAX+68],EDX
         MOV     [EAX+72],EDX
         MOV     [EAX+76],EDX
         MOV     [EAX+80],EDX
         MOV     [EAX+84],EDX
         MOV     [EAX+88],EDX
         MOV     [EAX+92],EDX
         MOV     [EAX+96],EDX
         MOV     [EAX+100],EDX
         MOV     [EAX+104],EDX
         MOV     [EAX+108],EDX
         MOV     [EAX+112],EDX
         MOV     [EAX+116],EDX
         MOV     [EAX+120],EDX
         MOV     [EAX+124],EDX
end;

procedure IntCopy16;
asm
         MOV     EAX,[ESI]
         MOV     [EDI],EAX
         MOV     EAX,[ESI+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[ESI+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[ESI+12]
         MOV     [EDI+12],EAX
         MOV     EAX,[ESI+16]
         MOV     [EDI+16],EAX
         MOV     EAX,[ESI+20]
         MOV     [EDI+20],EAX
         MOV     EAX,[ESI+24]
         MOV     [EDI+24],EAX
         MOV     EAX,[ESI+28]
         MOV     [EDI+28],EAX
         MOV     EAX,[ESI+32]
         MOV     [EDI+32],EAX
         MOV     EAX,[ESI+36]
         MOV     [EDI+36],EAX
         MOV     EAX,[ESI+40]
         MOV     [EDI+40],EAX
         MOV     EAX,[ESI+44]
         MOV     [EDI+44],EAX
         MOV     EAX,[ESI+48]
         MOV     [EDI+48],EAX
         MOV     EAX,[ESI+52]
         MOV     [EDI+52],EAX
         MOV     EAX,[ESI+56]
         MOV     [EDI+56],EAX
         MOV     EAX,[ESI+60]
         MOV     [EDI+60],EAX
end;

procedure Q_CopyMem(Source, Dest: Pointer; L: Cardinal);
begin
 Move(Source^, Dest^, L);
end;
(*
{$IFDEF CPU32}
procedure Q_CopyMem(Source, Dest: Pointer; L: Cardinal);
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     EDX,ECX
        MOV     ESI,EAX
        TEST    EDI,3
        JNE     @@cl
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,16
        JBE     @@cw0
@@lp0:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp0
@@cw0:  JMP     DWORD PTR @@wV[ECX*4]
@@cl:   MOV     EAX,EDI
        MOV     EDX,3
        SUB     ECX,4
        JB      @@bc
        AND     EAX,3
        ADD     ECX,EAX
        JMP     DWORD PTR @@lV[EAX*4-4]
@@bc:   JMP     DWORD PTR @@tV[ECX*4+16]
@@lV:   DD      @@l1, @@l2, @@l3
@@l1:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
        MOV     AL,[ESI+2]
        SHR     ECX,2
        MOV     [EDI+2],AL
        ADD     ESI,3
        ADD     EDI,3
        CMP     ECX,16
        JBE     @@cw1
@@lp1:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp1
@@cw1:  JMP     DWORD PTR @@wV[ECX*4]
@@l2:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        MOV     AL,[ESI+1]
        SHR     ECX,2
        MOV     [EDI+1],AL
        ADD     ESI,2
        ADD     EDI,2
        CMP     ECX,16
        JBE     @@cw2
@@lp2:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp2
@@cw2:  JMP     DWORD PTR @@wV[ECX*4]
@@l3:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     [EDI],AL
        INC     ESI
        SHR     ECX,2
        INC     EDI
        CMP     ECX,16
        JBE     @@cw3
@@lp3:  CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp3
@@cw3:  JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
        DD      @@w8, @@w9, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16
@@w16:  MOV     EAX,[ESI+ECX*4-64]
        MOV     [EDI+ECX*4-64],EAX
@@w15:  MOV     EAX,[ESI+ECX*4-60]
        MOV     [EDI+ECX*4-60],EAX
@@w14:  MOV     EAX,[ESI+ECX*4-56]
        MOV     [EDI+ECX*4-56],EAX
@@w13:  MOV     EAX,[ESI+ECX*4-52]
        MOV     [EDI+ECX*4-52],EAX
@@w12:  MOV     EAX,[ESI+ECX*4-48]
        MOV     [EDI+ECX*4-48],EAX
@@w11:  MOV     EAX,[ESI+ECX*4-44]
        MOV     [EDI+ECX*4-44],EAX
@@w10:  MOV     EAX,[ESI+ECX*4-40]
        MOV     [EDI+ECX*4-40],EAX
@@w9:   MOV     EAX,[ESI+ECX*4-36]
        MOV     [EDI+ECX*4-36],EAX
@@w8:   MOV     EAX,[ESI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        MOV     [EDI+ECX*4-20],EAX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        SHL     ECX,2
        ADD     ESI,ECX
        ADD     EDI,ECX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0, @@t1, @@t2, @@t3
@@t3:   MOV     AL,[ESI+2]
        MOV     [EDI+2],AL
@@t2:   MOV     AL,[ESI+1]
        MOV     [EDI+1],AL
@@t1:   MOV     AL,[ESI]
        MOV     [EDI],AL
@@t0:   POP     ESI
        POP     EDI
end;
{$ELSE}
{ Q_CopyMem копирует L байт из области памяти, указываемой параметром
  Source, в область памяти, указываемую параметром Dest. Области памяти
  не должны перекрываться. Q_CopyMem работает значительно быстрее, чем
  стандартная процедура Move и, даже, быстрее, чем Q_MoveMem. }

procedure Q_CopyMem(Source, Dest: Pointer; L: cardinal);
begin
 Move(Source^, Dest^, L);
end;
{$ENDIF}
*)


procedure Q_CopyLongs(Source, Dest: Pointer; Count: cardinal);
begin
 Move(Source^, Dest^, Count * 4);
end;
(*
{$IFDEF CPU32}
procedure Q_CopyLongs(Source, Dest: Pointer; Count: Cardinal);
asm
        CMP     ECX,16
        JBE     @@xx
        PUSH    ESI
        XCHG    EDI,EDX
        MOV     ESI,EAX
@@lp:   CALL    IntCopy16
        ADD     ESI,64
        SUB     ECX,16
        ADD     EDI,64
        CMP     ECX,16
        JA      @@lp
        MOV     EAX,ESI
        XCHG    EDI,EDX
        POP     ESI
@@xx:   JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w00, @@w01, @@w02, @@w03
        DD      @@w04, @@w05, @@w06, @@w07
        DD      @@w08, @@w09, @@w10, @@w11
        DD      @@w12, @@w13, @@w14, @@w15
        DD      @@w16
@@w16:  MOV     ECX,[EAX+60]
        MOV     [EDX+60],ECX
@@w15:  MOV     ECX,[EAX+56]
        MOV     [EDX+56],ECX
@@w14:  MOV     ECX,[EAX+52]
        MOV     [EDX+52],ECX
@@w13:  MOV     ECX,[EAX+48]
        MOV     [EDX+48],ECX
@@w12:  MOV     ECX,[EAX+44]
        MOV     [EDX+44],ECX
@@w11:  MOV     ECX,[EAX+40]
        MOV     [EDX+40],ECX
@@w10:  MOV     ECX,[EAX+36]
        MOV     [EDX+36],ECX
@@w09:  MOV     ECX,[EAX+32]
        MOV     [EDX+32],ECX
@@w08:  MOV     ECX,[EAX+28]
        MOV     [EDX+28],ECX
@@w07:  MOV     ECX,[EAX+24]
        MOV     [EDX+24],ECX
@@w06:  MOV     ECX,[EAX+20]
        MOV     [EDX+20],ECX
@@w05:  MOV     ECX,[EAX+16]
        MOV     [EDX+16],ECX
@@w04:  MOV     ECX,[EAX+12]
        MOV     [EDX+12],ECX
@@w03:  MOV     ECX,[EAX+8]
        MOV     [EDX+8],ECX
@@w02:  MOV     ECX,[EAX+4]
        MOV     [EDX+4],ECX
@@w01:  MOV     ECX,[EAX]
        MOV     [EDX],ECX
@@w00:
end;
{$ELSE}

procedure Q_CopyLongs(Source, Dest: Pointer; Count: cardinal);
begin
 Move(Source^, Dest^, Count * 4);
end;
{$ENDIF}
*)


{$IFDEF CPU32}
procedure Q_TinyCopy(Source, Dest: Pointer; L: Cardinal);
asm
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
        DD      @@tu04, @@tu05, @@tu06, @@tu07
        DD      @@tu08, @@tu09, @@tu10, @@tu11
        DD      @@tu12, @@tu13, @@tu14, @@tu15
        DD      @@tu16, @@tu17, @@tu18, @@tu19
        DD      @@tu20, @@tu21, @@tu22, @@tu23
        DD      @@tu24, @@tu25, @@tu26, @@tu27
        DD      @@tu28, @@tu29, @@tu30, @@tu31
        DD      @@tu32
@@tu00: RET
@@tu01: MOV     CL,BYTE PTR [EAX]
        MOV     BYTE PTR [EDX],CL
        RET
@@tu02: MOV     CX,WORD PTR [EAX]
        MOV     WORD PTR [EDX],CX
        RET
@@tu03: MOV     CX,WORD PTR [EAX]
        MOV     WORD PTR [EDX],CX
        MOV     CL,BYTE PTR [EAX+2]
        MOV     BYTE PTR [EDX+2],CL
        RET
@@tu04: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        RET
@@tu05: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     CL,BYTE PTR [EAX+4]
        MOV     BYTE PTR [EDX+4],CL
        RET
@@tu06: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     CX,WORD PTR [EAX+4]
        MOV     WORD PTR [EDX+4],CX
        RET
@@tu07: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     CX,WORD PTR [EAX+4]
        MOV     WORD PTR [EDX+4],CX
        MOV     CL,BYTE PTR [EAX+6]
        MOV     BYTE PTR [EDX+6],CL
        RET
@@tu08: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        RET
@@tu09: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     CL,BYTE PTR [EAX+8]
        MOV     BYTE PTR [EDX+8],CL
        RET
@@tu10: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     CX,WORD PTR [EAX+8]
        MOV     WORD PTR [EDX+8],CX
        RET
@@tu11: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     CX,WORD PTR [EAX+8]
        MOV     WORD PTR [EDX+8],CX
        MOV     CL,BYTE PTR [EAX+10]
        MOV     BYTE PTR [EDX+10],CL
        RET
@@tu12: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        RET
@@tu13: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     CL,BYTE PTR [EAX+12]
        MOV     BYTE PTR [EDX+12],CL
        RET
@@tu14: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     CX,WORD PTR [EAX+12]
        MOV     WORD PTR [EDX+12],CX
        RET
@@tu15: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     CX,WORD PTR [EAX+12]
        MOV     WORD PTR [EDX+12],CX
        MOV     CL,BYTE PTR [EAX+14]
        MOV     BYTE PTR [EDX+14],CL
        RET
@@tu16: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        RET
@@tu17: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     CL,BYTE PTR [EAX+16]
        MOV     BYTE PTR [EDX+16],CL
        RET
@@tu18: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     CX,WORD PTR [EAX+16]
        MOV     WORD PTR [EDX+16],CX
        RET
@@tu19: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     CX,WORD PTR [EAX+16]
        MOV     WORD PTR [EDX+16],CX
        MOV     CL,BYTE PTR [EAX+18]
        MOV     BYTE PTR [EDX+18],CL
        RET
@@tu20: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        RET
@@tu21: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     CL,BYTE PTR [EAX+20]
        MOV     BYTE PTR [EDX+20],CL
        RET
@@tu22: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     CX,WORD PTR [EAX+20]
        MOV     WORD PTR [EDX+20],CX
        RET
@@tu23: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     CX,WORD PTR [EAX+20]
        MOV     WORD PTR [EDX+20],CX
        MOV     CL,BYTE PTR [EAX+22]
        MOV     BYTE PTR [EDX+22],CL
        RET
@@tu24: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        RET
@@tu25: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     CL,BYTE PTR [EAX+24]
        MOV     BYTE PTR [EDX+24],CL
        RET
@@tu26: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     CX,WORD PTR [EAX+24]
        MOV     WORD PTR [EDX+24],CX
        RET
@@tu27: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     CX,WORD PTR [EAX+24]
        MOV     WORD PTR [EDX+24],CX
        MOV     CL,BYTE PTR [EAX+26]
        MOV     BYTE PTR [EDX+26],CL
        RET
@@tu28: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     ECX,DWORD PTR [EAX+24]
        MOV     DWORD PTR [EDX+24],ECX
        RET
@@tu29: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     ECX,DWORD PTR [EAX+24]
        MOV     DWORD PTR [EDX+24],ECX
        MOV     CL,BYTE PTR [EAX+28]
        MOV     BYTE PTR [EDX+28],CL
        RET
@@tu30: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     ECX,DWORD PTR [EAX+24]
        MOV     DWORD PTR [EDX+24],ECX
        MOV     CX,WORD PTR [EAX+28]
        MOV     WORD PTR [EDX+28],CX
        RET
@@tu31: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     ECX,DWORD PTR [EAX+24]
        MOV     DWORD PTR [EDX+24],ECX
        MOV     CX,WORD PTR [EAX+28]
        MOV     WORD PTR [EDX+28],CX
        MOV     CL,BYTE PTR [EAX+30]
        MOV     BYTE PTR [EDX+30],CL
        RET
@@tu32: MOV     ECX,DWORD PTR [EAX]
        MOV     DWORD PTR [EDX],ECX
        MOV     ECX,DWORD PTR [EAX+4]
        MOV     DWORD PTR [EDX+4],ECX
        MOV     ECX,DWORD PTR [EAX+8]
        MOV     DWORD PTR [EDX+8],ECX
        MOV     ECX,DWORD PTR [EAX+12]
        MOV     DWORD PTR [EDX+12],ECX
        MOV     ECX,DWORD PTR [EAX+16]
        MOV     DWORD PTR [EDX+16],ECX
        MOV     ECX,DWORD PTR [EAX+20]
        MOV     DWORD PTR [EDX+20],ECX
        MOV     ECX,DWORD PTR [EAX+24]
        MOV     DWORD PTR [EDX+24],ECX
        MOV     ECX,DWORD PTR [EAX+28]
        MOV     DWORD PTR [EDX+28],ECX
end;
{$ELSE}

procedure Q_TinyCopy(Source, Dest: Pointer; L: cardinal);
begin
  ShowMessage('Q_TinyCopy TODO');
end;

{$ENDIF}

{ Q_MoveMem копирует L байт из Source в Dest. Она работает даже в случае}
procedure Q_MoveMem(Source, Dest: Pointer; L: Cardinal);
begin
  try
    move(Source^, Dest^,L);
  except
    ;
  end;
end;


{ Q_MoveLongs копирует Count элементов массива типа LongWord (или другого 4-bytes }
procedure Q_MoveLongs(Source, Dest: Pointer; Count: Cardinal);
begin
  try
    move(Source^, Dest^,Count*4);
  except
    ;
  end;
end;

{ Q_MoveWords копирует Count элементов массива типа Word или Smallint}
procedure Q_MoveWords(Source, Dest: Pointer; Count: Cardinal);
begin
  try
    move(Source^, Dest^,Count*2);
  except
    ;
  end;
end;

{$IFDEF CPU32}
procedure Q_MoveBytes(Source, Dest: Pointer; L: Cardinal);
asm
        CMP     EDX,EAX
        JA      @@bm
        JE      @@qt
        XCHG    ESI,EAX
        XCHG    EDI,EDX
        REP     MOVSB
        MOV     ESI,EAX
        MOV     EDI,EDX
        RET
@@bm:   PUSH    ESI
        PUSH    EDI
        STD
        LEA     ESI,[EAX+ECX-1]
        LEA     EDI,[EDX+ECX-1]
        REP     MOVSB
        CLD
        POP     EDI
        POP     ESI
@@qt:
end;
{$ELSE}

procedure Q_MoveBytes(Source, Dest: Pointer; L: cardinal);
begin
 try
  move(Source^, Dest^,L);
 except
  ;
 end;
end;

{$ENDIF}

procedure IntSwap8;
asm
         MOV     EAX,[ESI]
         MOV     EBX,[EDI]
         MOV     [EDI],EAX
         MOV     [ESI],EBX
         MOV     EAX,[ESI+4]
         MOV     EBX,[EDI+4]
         MOV     [EDI+4],EAX
         MOV     [ESI+4],EBX
         MOV     EAX,[ESI+8]
         MOV     EBX,[EDI+8]
         MOV     [EDI+8],EAX
         MOV     [ESI+8],EBX
         MOV     EAX,[ESI+12]
         MOV     EBX,[EDI+12]
         MOV     [EDI+12],EAX
         MOV     [ESI+12],EBX
         MOV     EAX,[ESI+16]
         MOV     EBX,[EDI+16]
         MOV     [EDI+16],EAX
         MOV     [ESI+16],EBX
         MOV     EAX,[ESI+20]
         MOV     EBX,[EDI+20]
         MOV     [EDI+20],EAX
         MOV     [ESI+20],EBX
         MOV     EAX,[ESI+24]
         MOV     EBX,[EDI+24]
         MOV     [EDI+24],EAX
         MOV     [ESI+24],EBX
         MOV     EAX,[ESI+28]
         MOV     EBX,[EDI+28]
         MOV     [EDI+28],EAX
         MOV     [ESI+28],EBX
end;

{$IFDEF CPU32}
procedure Q_SwapMem(P1, P2: Pointer; L: Cardinal);
asm
        PUSH    EBX
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     EDX,ECX
        MOV     ESI,EAX
        TEST    EDI,3
        JNE     @@cl
        SHR     ECX,2
        AND     EDX,3
        CMP     ECX,8
        JBE     @@cw0
@@lp0:  CALL    IntSwap8
        ADD     ESI,32
        SUB     ECX,8
        ADD     EDI,32
        CMP     ECX,8
        JA      @@lp0
@@cw0:  JMP     DWORD PTR @@wV[ECX*4]
@@cl:   MOV     EAX,EDI
        MOV     EDX,3
        SUB     ECX,4
        JB      @@bc
        AND     EAX,3
        ADD     ECX,EAX
        JMP     DWORD PTR @@lV[EAX*4-4]
@@bc:   JMP     DWORD PTR @@tV[ECX*4+16]
@@lV:   DD      @@l1,@@l2,@@l3
@@l1:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     BL,[EDI]
        MOV     [EDI],AL
        MOV     [ESI],BL
        MOV     AL,[ESI+1]
        MOV     BL,[EDI+1]
        MOV     [EDI+1],AL
        MOV     [ESI+1],BL
        MOV     AL,[ESI+2]
        MOV     BL,[EDI+2]
        MOV     [EDI+2],AL
        SHR     ECX,2
        MOV     [ESI+2],BL
        ADD     ESI,3
        ADD     EDI,3
        CMP     ECX,8
        JBE     @@cw1
@@lp1:  CALL    IntSwap8
        ADD     ESI,32
        SUB     ECX,8
        ADD     EDI,32
        CMP     ECX,8
        JA      @@lp1
@@cw1:  JMP     DWORD PTR @@wV[ECX*4]
@@l2:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     BL,[EDI]
        MOV     [EDI],AL
        MOV     [ESI],BL
        MOV     AL,[ESI+1]
        MOV     BL,[EDI+1]
        MOV     [EDI+1],AL
        SHR     ECX,2
        MOV     [ESI+1],BL
        ADD     ESI,2
        ADD     EDI,2
        CMP     ECX,8
        JBE     @@cw2
@@lp2:  CALL    IntSwap8
        ADD     ESI,32
        SUB     ECX,8
        ADD     EDI,32
        CMP     ECX,8
        JA      @@lp2
@@cw2:  JMP     DWORD PTR @@wV[ECX*4]
@@l3:   AND     EDX,ECX
        MOV     AL,[ESI]
        MOV     BL,[EDI]
        MOV     [EDI],AL
        MOV     [ESI],BL
        INC     ESI
        SHR     ECX,2
        INC     EDI
        CMP     ECX,8
        JBE     @@cw3
@@lp3:  CALL    IntSwap8
        ADD     ESI,32
        SUB     ECX,8
        ADD     EDI,32
        CMP     ECX,8
        JA      @@lp3
@@cw3:  JMP     DWORD PTR @@wV[ECX*4]
@@wV:   DD      @@w0, @@w1, @@w2, @@w3
        DD      @@w4, @@w5, @@w6, @@w7
        DD      @@w8
@@w8:   MOV     EAX,[ESI+ECX*4-32]
        MOV     EBX,[EDI+ECX*4-32]
        MOV     [EDI+ECX*4-32],EAX
        MOV     [ESI+ECX*4-32],EBX
@@w7:   MOV     EAX,[ESI+ECX*4-28]
        MOV     EBX,[EDI+ECX*4-28]
        MOV     [EDI+ECX*4-28],EAX
        MOV     [ESI+ECX*4-28],EBX
@@w6:   MOV     EAX,[ESI+ECX*4-24]
        MOV     EBX,[EDI+ECX*4-24]
        MOV     [EDI+ECX*4-24],EAX
        MOV     [ESI+ECX*4-24],EBX
@@w5:   MOV     EAX,[ESI+ECX*4-20]
        MOV     EBX,[EDI+ECX*4-20]
        MOV     [EDI+ECX*4-20],EAX
        MOV     [ESI+ECX*4-20],EBX
@@w4:   MOV     EAX,[ESI+ECX*4-16]
        MOV     EBX,[EDI+ECX*4-16]
        MOV     [EDI+ECX*4-16],EAX
        MOV     [ESI+ECX*4-16],EBX
@@w3:   MOV     EAX,[ESI+ECX*4-12]
        MOV     EBX,[EDI+ECX*4-12]
        MOV     [EDI+ECX*4-12],EAX
        MOV     [ESI+ECX*4-12],EBX
@@w2:   MOV     EAX,[ESI+ECX*4-8]
        MOV     EBX,[EDI+ECX*4-8]
        MOV     [EDI+ECX*4-8],EAX
        MOV     [ESI+ECX*4-8],EBX
@@w1:   MOV     EAX,[ESI+ECX*4-4]
        MOV     EBX,[EDI+ECX*4-4]
        MOV     [EDI+ECX*4-4],EAX
        MOV     [ESI+ECX*4-4],EBX
        SHL     ECX,2
        ADD     ESI,ECX
        ADD     EDI,ECX
@@w0:   JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
@@t3:   MOV     AL,[ESI+2]
        MOV     BL,[EDI+2]
        MOV     [EDI+2],AL
        MOV     [ESI+2],BL
@@t2:   MOV     AL,[ESI+1]
        MOV     BL,[EDI+1]
        MOV     [EDI+1],AL
        MOV     [ESI+1],BL
@@t1:   MOV     AL,[ESI]
        MOV     BL,[EDI]
        MOV     [EDI],AL
        MOV     [ESI],BL
@@t0:   POP     ESI
        POP     EDI
        POP     EBX
end;
{$ELSE}

procedure Q_SwapMem(P1, P2: Pointer; L: cardinal);
begin
  ShowMessage('Q_SwapMem TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_SwapLongs(P1, P2: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        CMP     ECX,8
        JBE     @@xx
        PUSH    ESI
@@lp:   MOV     EBX,[EDX]
        MOV     ESI,[EAX]
        MOV     [EAX],EBX
        MOV     [EDX],ESI
        MOV     EBX,[EDX+4]
        MOV     ESI,[EAX+4]
        MOV     [EAX+4],EBX
        MOV     [EDX+4],ESI
        MOV     EBX,[EDX+8]
        MOV     ESI,[EAX+8]
        MOV     [EAX+8],EBX
        MOV     [EDX+8],ESI
        MOV     EBX,[EDX+12]
        MOV     ESI,[EAX+12]
        MOV     [EAX+12],EBX
        MOV     [EDX+12],ESI
        MOV     EBX,[EDX+16]
        MOV     ESI,[EAX+16]
        MOV     [EAX+16],EBX
        MOV     [EDX+16],ESI
        MOV     EBX,[EDX+20]
        MOV     ESI,[EAX+20]
        MOV     [EAX+20],EBX
        MOV     [EDX+20],ESI
        MOV     EBX,[EDX+24]
        MOV     ESI,[EAX+24]
        MOV     [EAX+24],EBX
        MOV     [EDX+24],ESI
        MOV     EBX,[EDX+28]
        MOV     ESI,[EAX+28]
        MOV     [EAX+28],EBX
        MOV     [EDX+28],ESI
        ADD     EAX,32
        ADD     EDX,32
        SUB     ECX,8
        JA      @@lp
        POP     ESI
@@xx:   JMP     DWORD PTR @@wV[ECX*4+32]
@@wV:   DD      @@w00,@@w01,@@w02,@@w03
        DD      @@w04,@@w05,@@w06,@@w07
        DD      @@w08
@@w08:  MOV     ECX,[EAX+28]
        MOV     EBX,[EDX+28]
        MOV     [EDX+28],ECX
        MOV     [EAX+28],EBX
@@w07:  MOV     ECX,[EAX+24]
        MOV     EBX,[EDX+24]
        MOV     [EDX+24],ECX
        MOV     [EAX+24],EBX
@@w06:  MOV     ECX,[EAX+20]
        MOV     EBX,[EDX+20]
        MOV     [EDX+20],ECX
        MOV     [EAX+20],EBX
@@w05:  MOV     ECX,[EAX+16]
        MOV     EBX,[EDX+16]
        MOV     [EDX+16],ECX
        MOV     [EAX+16],EBX
@@w04:  MOV     ECX,[EAX+12]
        MOV     EBX,[EDX+12]
        MOV     [EDX+12],ECX
        MOV     [EAX+12],EBX
@@w03:  MOV     ECX,[EAX+8]
        MOV     EBX,[EDX+8]
        MOV     [EDX+8],ECX
        MOV     [EAX+8],EBX
@@w02:  MOV     ECX,[EAX+4]
        MOV     EBX,[EDX+4]
        MOV     [EDX+4],ECX
        MOV     [EAX+4],EBX
@@w01:  MOV     ECX,[EAX]
        MOV     EBX,[EDX]
        MOV     [EDX],ECX
        MOV     [EAX],EBX
@@w00:  POP     EBX
end;
{$ELSE}

procedure Q_SwapLongs(P1, P2: Pointer; Count: cardinal);
begin
  ShowMessage('Q_SwapLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CompareMem(P1, P2: Pointer; L: Cardinal): Boolean;
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,ECX
        SHR     ECX,4
        JE      @@nx
@@lp:   MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq0
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq0
        MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq0
        MOV     EBX,[EAX+12]
        CMP     EBX,[EDX+12]
        JNE     @@zq0
        ADD     EAX,16
        ADD     EDX,16
        DEC     ECX
        JNE     @@lp
@@nx:   AND     ESI,$F
        JMP     DWORD PTR @@tV[ESI*4]
@@tV:   DD      @@eq,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
        DD      @@t8,@@t9,@@t10,@@t11
        DD      @@t12,@@t13,@@t14,@@t15
@@zq0:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@t15:  MOV     BL,BYTE PTR [EAX+14]
        XOR     BL,BYTE PTR [EDX+14]
        JNE     @@zq1
@@t14:  MOV     BL,BYTE PTR [EAX+13]
        XOR     BL,BYTE PTR [EDX+13]
        JNE     @@zq1
@@t13:  MOV     BL,BYTE PTR [EAX+12]
        XOR     BL,BYTE PTR [EDX+12]
        JNE     @@zq1
@@t12:  MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq1
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
@@eq:   POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@t11:  MOV     BL,BYTE PTR [EAX+10]
        XOR     BL,BYTE PTR [EDX+10]
        JNE     @@zq1
@@t10:  MOV     BL,BYTE PTR [EAX+9]
        XOR     BL,BYTE PTR [EDX+9]
        JNE     @@zq1
@@t9:   MOV     BL,BYTE PTR [EAX+8]
        XOR     BL,BYTE PTR [EDX+8]
        JNE     @@zq1
@@t8:   MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq1:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@t7:   MOV     BL,BYTE PTR [EAX+6]
        XOR     BL,BYTE PTR [EDX+6]
        JNE     @@zq2
@@t6:   MOV     BL,BYTE PTR [EAX+5]
        XOR     BL,BYTE PTR [EDX+5]
        JNE     @@zq2
@@t5:   MOV     BL,BYTE PTR [EAX+4]
        XOR     BL,BYTE PTR [EDX+4]
        JNE     @@zq2
@@t4:   MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq2
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@t3:   MOV     BL,BYTE PTR [EAX+2]
        XOR     BL,BYTE PTR [EDX+2]
        JNE     @@zq2
@@t2:   MOV     BL,BYTE PTR [EAX+1]
        XOR     BL,BYTE PTR [EDX+1]
        JNE     @@zq2
@@t1:   MOV     BL,BYTE PTR [EAX]
        XOR     BL,BYTE PTR [EDX]
        JNE     @@zq2
        POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq2:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
end;
{$ELSE}

function Q_CompareMem(P1, P2: Pointer; L: cardinal): boolean;
begin
  ShowMessage('Q_CompareMemm TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CompLongs(P1, P2: Pointer; Count: Cardinal): Boolean;
asm
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,ECX
        AND     ECX,$7
        SHR     ESI,3
        JE      @@nx
@@lp1:  MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq1
        MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq1
        MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq1
        MOV     EBX,[EAX+12]
        CMP     EBX,[EDX+12]
        JNE     @@zq1
        MOV     EBX,[EAX+16]
        CMP     EBX,[EDX+16]
        JNE     @@zq1
        MOV     EBX,[EAX+20]
        CMP     EBX,[EDX+20]
        JNE     @@zq1
        MOV     EBX,[EAX+24]
        CMP     EBX,[EDX+24]
        JNE     @@zq1
        MOV     EBX,[EAX+28]
        CMP     EBX,[EDX+28]
        JNE     @@zq1
        ADD     EAX,32
        ADD     EDX,32
        DEC     ESI
        JNE     @@lp1
@@nx:   JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@tu0, @@tu1, @@tu2, @@tu3
        DD      @@tu4, @@tu5, @@tu6, @@tu7
@@zq1:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
        RET
@@tu7:  MOV     EBX,[EAX+24]
        CMP     EBX,[EDX+24]
        JNE     @@zq2
@@tu6:  MOV     EBX,[EAX+20]
        CMP     EBX,[EDX+20]
        JNE     @@zq2
@@tu5:  MOV     EBX,[EAX+16]
        CMP     EBX,[EDX+16]
        JNE     @@zq2
@@tu4:  MOV     EBX,[EAX+12]
        CMP     EBX,[EDX+12]
        JNE     @@zq2
@@tu3:  MOV     EBX,[EAX+8]
        CMP     EBX,[EDX+8]
        JNE     @@zq2
@@tu2:  MOV     EBX,[EAX+4]
        CMP     EBX,[EDX+4]
        JNE     @@zq2
@@tu1:  MOV     EBX,[EAX]
        CMP     EBX,[EDX]
        JNE     @@zq2
@@tu0:  POP     EBX
        POP     ESI
        MOV     EAX,1
        RET
@@zq2:  POP     EBX
        POP     ESI
        XOR     EAX,EAX
end;
{$ELSE}

function Q_CompLongs(P1, P2: Pointer; Count: cardinal): boolean;
begin
  ShowMessage('Q_CompLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CompMemS(P1, P2: Pointer; L: Cardinal): Integer;
asm
        PUSH    EBX
        CMP     EAX,EDX
        JE      @@zq
@@lp:   DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX]
        MOV     BH,BYTE PTR [EDX]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+1]
        MOV     BH,BYTE PTR [EDX+1]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+2]
        MOV     BH,BYTE PTR [EDX+2]
        CMP     BL,BH
        JNE     @@ne
        DEC     ECX
        JS      @@zq
        MOV     BL,BYTE PTR [EAX+3]
        MOV     BH,BYTE PTR [EDX+3]
        ADD     EAX,4
        ADD     EDX,4
        CMP     BL,BH
        JE      @@lp
@@ne:   MOVZX   EAX,BL
        MOVZX   EDX,BH
        SUB     EAX,EDX
        POP     EBX
        RET
@@zq:   XOR     EAX,EAX
        POP     EBX
end;
{$ELSE}

function Q_CompMemS(P1, P2: Pointer; L: cardinal): integer;
begin
  ShowMessage('Q_CompMemS TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanInteger(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}

function Q_ScanInteger(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanInteger TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanLongWord(N: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        TEST    ECX,ECX
        JE      @@m1
        PUSH    EDI
        MOV     EDI,EDX
        REPNE   SCASD
        JNE     @@m2
        MOV     EAX,EDI
        SUB     EAX,EDX
        POP     EDI
        SHR     EAX,2
        DEC     EAX
        RET
@@m2:   POP     EDI
@@m1:   MOV     EAX,$FFFFFFFF
end;
{$ELSE}

function Q_ScanLongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanLongWord TODO');
end;

{$ENDIF}

function Q_ScanPointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): integer;
var
 I: cardinal;
begin
 Result := -1;
 if ((ArrPtr = nil) or (Count = 0)) then
  exit;
 for I := 0 to Count - 1 do
  if (TpArray(ArrPtr^)[I] = P) then
  begin
   Result := I;
   exit;
  end;
end;

function Q_ScanWord(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
var
 I: cardinal;
begin
 Result := -1;
 if ((ArrPtr = nil) or (Count = 0)) then
  exit;
 for I := 0 to Count - 1 do
  if (TWArray(ArrPtr^)[I] = N) then
  begin
   Result := I;
   exit;
  end;
end;


function Q_ScanByte(N: Integer; ArrPtr: Pointer; L: Cardinal): Integer;
var
  I, R: integer;
begin
  R := -1;
  try
    for I := 0 to L - 1 do
      if TBArray(ArrPtr^)[I] = N then
      begin
        R := I;
        break;
      end;
  except
    R := -1;
  end;
  Result := R;
end;

{$IFDEF CPU32}
function Q_ScanGE_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     EAX,[EDX]
        JLE     @@qt0
        CMP     EAX,[EDX+4]
        JLE     @@qt1
        CMP     EAX,[EDX+8]
        JLE     @@qt2
        CMP     EAX,[EDX+12]
        JLE     @@qt3
        CMP     EAX,[EDX+16]
        JLE     @@qt4
        CMP     EAX,[EDX+20]
        JLE     @@qt5
        CMP     EAX,[EDX+24]
        JLE     @@qt6
        CMP     EAX,[EDX+28]
        JLE     @@qt7
        ADD     EDX,32
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,2
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,4
        JMP     @@qt0
@@qt2:  ADD     EDX,8
        JMP     @@qt0
@@qt3:  ADD     EDX,12
        JMP     @@qt0
@@qt4:  ADD     EDX,16
        JMP     @@qt0
@@qt5:  ADD     EDX,20
        JMP     @@qt0
@@qt6:  ADD     EDX,24
        JMP     @@qt0
@@qt7:  ADD     EDX,28
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     EAX,[EDX+EBX*4-28]
        JLE     @@xx7
@@t6:   CMP     EAX,[EDX+EBX*4-24]
        JLE     @@xx6
@@t5:   CMP     EAX,[EDX+EBX*4-20]
        JLE     @@xx5
@@t4:   CMP     EAX,[EDX+EBX*4-16]
        JLE     @@xx4
@@t3:   CMP     EAX,[EDX+EBX*4-12]
        JLE     @@xx3
@@t2:   CMP     EAX,[EDX+EBX*4-8]
        JLE     @@xx2
@@t1:   CMP     EAX,[EDX+EBX*4-4]
        JLE     @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*4-28]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*4-24]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*4-20]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*4-16]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*4-12]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*4-8]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*4-4]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,2
end;
{$ELSE}

function Q_ScanGE_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanGE_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanGE_LongWord(N: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     EAX,[EDX]
        JBE     @@qt0
        CMP     EAX,[EDX+4]
        JBE     @@qt1
        CMP     EAX,[EDX+8]
        JBE     @@qt2
        CMP     EAX,[EDX+12]
        JBE     @@qt3
        CMP     EAX,[EDX+16]
        JBE     @@qt4
        CMP     EAX,[EDX+20]
        JBE     @@qt5
        CMP     EAX,[EDX+24]
        JBE     @@qt6
        CMP     EAX,[EDX+28]
        JBE     @@qt7
        ADD     EDX,32
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,2
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,4
        JMP     @@qt0
@@qt2:  ADD     EDX,8
        JMP     @@qt0
@@qt3:  ADD     EDX,12
        JMP     @@qt0
@@qt4:  ADD     EDX,16
        JMP     @@qt0
@@qt5:  ADD     EDX,20
        JMP     @@qt0
@@qt6:  ADD     EDX,24
        JMP     @@qt0
@@qt7:  ADD     EDX,28
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     EAX,[EDX+EBX*4-28]
        JBE     @@xx7
@@t6:   CMP     EAX,[EDX+EBX*4-24]
        JBE     @@xx6
@@t5:   CMP     EAX,[EDX+EBX*4-20]
        JBE     @@xx5
@@t4:   CMP     EAX,[EDX+EBX*4-16]
        JBE     @@xx4
@@t3:   CMP     EAX,[EDX+EBX*4-12]
        JBE     @@xx3
@@t2:   CMP     EAX,[EDX+EBX*4-8]
        JBE     @@xx2
@@t1:   CMP     EAX,[EDX+EBX*4-4]
        JBE     @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*4-28]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*4-24]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*4-20]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*4-16]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*4-12]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*4-8]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*4-4]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,2
end;
{$ELSE}

function Q_ScanGE_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanGE_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanGE_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     AX,[EDX]
        JBE     @@qt0
        CMP     AX,[EDX+2]
        JBE     @@qt1
        CMP     AX,[EDX+4]
        JBE     @@qt2
        CMP     AX,[EDX+6]
        JBE     @@qt3
        CMP     AX,[EDX+8]
        JBE     @@qt4
        CMP     AX,[EDX+10]
        JBE     @@qt5
        CMP     AX,[EDX+12]
        JBE     @@qt6
        CMP     AX,[EDX+14]
        JBE     @@qt7
        ADD     EDX,16
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,1
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,2
        JMP     @@qt0
@@qt2:  ADD     EDX,4
        JMP     @@qt0
@@qt3:  ADD     EDX,6
        JMP     @@qt0
@@qt4:  ADD     EDX,8
        JMP     @@qt0
@@qt5:  ADD     EDX,10
        JMP     @@qt0
@@qt6:  ADD     EDX,12
        JMP     @@qt0
@@qt7:  ADD     EDX,14
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     AX,[EDX+EBX*2-14]
        JBE     @@xx7
@@t6:   CMP     AX,[EDX+EBX*2-12]
        JBE     @@xx6
@@t5:   CMP     AX,[EDX+EBX*2-10]
        JBE     @@xx5
@@t4:   CMP     AX,[EDX+EBX*2-8]
        JBE     @@xx4
@@t3:   CMP     AX,[EDX+EBX*2-6]
        JBE     @@xx3
@@t2:   CMP     AX,[EDX+EBX*2-4]
        JBE     @@xx2
@@t1:   CMP     AX,[EDX+EBX*2-2]
        JBE     @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*2-14]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*2-12]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*2-10]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*2-8]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*2-6]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*2-4]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*2-2]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,1
end;
{$ELSE}

function Q_ScanGE_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanGE_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanLesser_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     EAX,[EDX]
        JG      @@qt0
        CMP     EAX,[EDX+4]
        JG      @@qt1
        CMP     EAX,[EDX+8]
        JG      @@qt2
        CMP     EAX,[EDX+12]
        JG      @@qt3
        CMP     EAX,[EDX+16]
        JG      @@qt4
        CMP     EAX,[EDX+20]
        JG      @@qt5
        CMP     EAX,[EDX+24]
        JG      @@qt6
        CMP     EAX,[EDX+28]
        JG      @@qt7
        ADD     EDX,32
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,2
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,4
        JMP     @@qt0
@@qt2:  ADD     EDX,8
        JMP     @@qt0
@@qt3:  ADD     EDX,12
        JMP     @@qt0
@@qt4:  ADD     EDX,16
        JMP     @@qt0
@@qt5:  ADD     EDX,20
        JMP     @@qt0
@@qt6:  ADD     EDX,24
        JMP     @@qt0
@@qt7:  ADD     EDX,28
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     EAX,[EDX+EBX*4-28]
        JG      @@xx7
@@t6:   CMP     EAX,[EDX+EBX*4-24]
        JG      @@xx6
@@t5:   CMP     EAX,[EDX+EBX*4-20]
        JG      @@xx5
@@t4:   CMP     EAX,[EDX+EBX*4-16]
        JG      @@xx4
@@t3:   CMP     EAX,[EDX+EBX*4-12]
        JG      @@xx3
@@t2:   CMP     EAX,[EDX+EBX*4-8]
        JG      @@xx2
@@t1:   CMP     EAX,[EDX+EBX*4-4]
        JG      @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*4-28]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*4-24]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*4-20]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*4-16]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*4-12]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*4-8]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*4-4]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,2
end;
{$ELSE}

function Q_ScanLesser_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanLesser_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanLesser_LongWord(N: LongWord; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     EAX,[EDX]
        JA      @@qt0
        CMP     EAX,[EDX+4]
        JA      @@qt1
        CMP     EAX,[EDX+8]
        JA      @@qt2
        CMP     EAX,[EDX+12]
        JA      @@qt3
        CMP     EAX,[EDX+16]
        JA      @@qt4
        CMP     EAX,[EDX+20]
        JA      @@qt5
        CMP     EAX,[EDX+24]
        JA      @@qt6
        CMP     EAX,[EDX+28]
        JA      @@qt7
        ADD     EDX,32
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,2
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,4
        JMP     @@qt0
@@qt2:  ADD     EDX,8
        JMP     @@qt0
@@qt3:  ADD     EDX,12
        JMP     @@qt0
@@qt4:  ADD     EDX,16
        JMP     @@qt0
@@qt5:  ADD     EDX,20
        JMP     @@qt0
@@qt6:  ADD     EDX,24
        JMP     @@qt0
@@qt7:  ADD     EDX,28
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     EAX,[EDX+EBX*4-28]
        JA      @@xx7
@@t6:   CMP     EAX,[EDX+EBX*4-24]
        JA      @@xx6
@@t5:   CMP     EAX,[EDX+EBX*4-20]
        JA      @@xx5
@@t4:   CMP     EAX,[EDX+EBX*4-16]
        JA      @@xx4
@@t3:   CMP     EAX,[EDX+EBX*4-12]
        JA      @@xx3
@@t2:   CMP     EAX,[EDX+EBX*4-8]
        JA      @@xx2
@@t1:   CMP     EAX,[EDX+EBX*4-4]
        JA      @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*4-28]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*4-24]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*4-20]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*4-16]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*4-12]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*4-8]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*4-4]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,2
end;
{$ELSE}

function Q_ScanLesser_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanLesser_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ScanLesser_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Integer;
asm
        PUSH    EBX
        PUSH    EDX
        MOV     EBX,ECX
        SHR     ECX,3
        JE      @@nx
@@lp:   CMP     AX,[EDX]
        JA      @@qt0
        CMP     AX,[EDX+2]
        JA      @@qt1
        CMP     AX,[EDX+4]
        JA      @@qt2
        CMP     AX,[EDX+6]
        JA      @@qt3
        CMP     AX,[EDX+8]
        JA      @@qt4
        CMP     AX,[EDX+10]
        JA      @@qt5
        CMP     AX,[EDX+12]
        JA      @@qt6
        CMP     AX,[EDX+14]
        JA      @@qt7
        ADD     EDX,16
        DEC     ECX
        JNE     @@lp
@@nx:   AND     EBX,7
        JMP     DWORD PTR @@tV[EBX*4]
@@qt0:  POP     ECX
        SUB     EDX,ECX
        SHR     EDX,1
        POP     EBX
        MOV     EAX,EDX
        RET
@@qt1:  ADD     EDX,2
        JMP     @@qt0
@@qt2:  ADD     EDX,4
        JMP     @@qt0
@@qt3:  ADD     EDX,6
        JMP     @@qt0
@@qt4:  ADD     EDX,8
        JMP     @@qt0
@@qt5:  ADD     EDX,10
        JMP     @@qt0
@@qt6:  ADD     EDX,12
        JMP     @@qt0
@@qt7:  ADD     EDX,14
        JMP     @@qt0
@@tV:   DD      @@t0,@@t1,@@t2,@@t3
        DD      @@t4,@@t5,@@t6,@@t7
@@t7:   CMP     AX,[EDX+EBX*2-14]
        JA      @@xx7
@@t6:   CMP     AX,[EDX+EBX*2-12]
        JA      @@xx6
@@t5:   CMP     AX,[EDX+EBX*2-10]
        JA      @@xx5
@@t4:   CMP     AX,[EDX+EBX*2-8]
        JA      @@xx4
@@t3:   CMP     AX,[EDX+EBX*2-6]
        JA      @@xx3
@@t2:   CMP     AX,[EDX+EBX*2-4]
        JA      @@xx2
@@t1:   CMP     AX,[EDX+EBX*2-2]
        JA      @@xx1
@@t0:   MOV     EAX,$FFFFFFFF
        POP     ECX
        POP     EBX
        RET
@@xx7:  LEA     EAX,[EDX+EBX*2-14]
        JMP     @@tt
@@xx6:  LEA     EAX,[EDX+EBX*2-12]
        JMP     @@tt
@@xx5:  LEA     EAX,[EDX+EBX*2-10]
        JMP     @@tt
@@xx4:  LEA     EAX,[EDX+EBX*2-8]
        JMP     @@tt
@@xx3:  LEA     EAX,[EDX+EBX*2-6]
        JMP     @@tt
@@xx2:  LEA     EAX,[EDX+EBX*2-4]
        JMP     @@tt
@@xx1:  LEA     EAX,[EDX+EBX*2-2]
@@tt:   POP     ECX
        SUB     EAX,ECX
        POP     EBX
        SHR     EAX,1
end;
{$ELSE}

function Q_ScanLesser_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_ScanLesser_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountInteger(N: Integer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        DEC     ECX
        JS      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   CMP     EBX,DWORD PTR [EDX+ECX*4]
        JE      @@fn
@@nx:   DEC     ECX
        JNS     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        JMP     @@nx
@@qt:   XOR     EAX,EAX
end;
{$ELSE}

function Q_CountInteger(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_CountInteger TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountLongWord(N: LongWord; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        DEC     ECX
        JS      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   CMP     EBX,DWORD PTR [EDX+ECX*4]
        JE      @@fn
@@nx:   DEC     ECX
        JNS     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        JMP     @@nx
@@qt:   XOR     EAX,EAX
end;
{$ELSE}

function Q_CountLongWord(N: longword; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_CountLongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountPointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        DEC     ECX
        JS      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   CMP     EBX,DWORD PTR [EDX+ECX*4]
        JE      @@fn
@@nx:   DEC     ECX
        JNS     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        JMP     @@nx
@@qt:   XOR     EAX,EAX
end;
{$ELSE}

function Q_CountPointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_CountPointer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountWord(N: Integer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        DEC     ECX
        JS      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   CMP     BX,WORD PTR [EDX+ECX*2]
        JE      @@fn
@@nx:   DEC     ECX
        JNS     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        JMP     @@nx
@@qt:   XOR     EAX,EAX
end;
{$ELSE}

function Q_CountWord(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_CountWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountByte(N: Integer; ArrPtr: Pointer; L: Cardinal): Cardinal;
asm
        DEC     ECX
        JS      @@qt
        PUSH    EBX
        MOV     EBX,EAX
        XOR     EAX,EAX
@@lp:   CMP     BL,BYTE PTR [EDX+ECX]
        JE      @@fn
@@nx:   DEC     ECX
        JNS     @@lp
        POP     EBX
        RET
@@fn:   INC     EAX
        JMP     @@nx
@@qt:   XOR     EAX,EAX
end;
{$ELSE}

function Q_CountByte(N: integer; ArrPtr: Pointer; L: cardinal): cardinal;
begin
  ShowMessage('Q_CountByte TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ReverseLongArr(P: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        LEA     EDI,[EAX+EDX*4-4]
@@lp:   CMP     EAX,EDI
        JGE     @@qt
        MOV     ECX,DWORD PTR [EAX]
        MOV     EDX,DWORD PTR [EDI]
        MOV     DWORD PTR [EDI],ECX
        MOV     DWORD PTR [EAX],EDX
        ADD     EAX,4
        SUB     EDI,4
        JMP     @@lp
@@qt:   POP     EDI
end;
{$ELSE}

procedure Q_ReverseLongArr(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_ReverseLongAr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ReverseWordArr(P: Pointer; Count: Cardinal);
asm
        PUSH    EDI
        LEA     EDI,[EAX+EDX*2-2]
@@lp:   CMP     EAX,EDI
        JGE     @@qt
        MOV     CX,WORD PTR [EAX]
        MOV     DX,WORD PTR [EDI]
        MOV     WORD PTR [EDI],CX
        MOV     WORD PTR [EAX],DX
        ADD     EAX,2
        SUB     EDI,2
        JMP     @@lp
@@qt:   POP     EDI
end;
{$ELSE}

procedure Q_ReverseWordArr(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_ReverseWordArr TODO');
end;

{$ENDIF}

procedure Q_ReverseByteArr(P: Pointer; L: cardinal);
asm
         LEA     ECX,[EAX+EDX-1]
         @@lp:
         CMP     EAX,ECX
         JGE     @@qt
         MOV     DH,BYTE PTR [EAX]
         MOV     DL,BYTE PTR [ECX]
         MOV     BYTE PTR [ECX],DH
         MOV     BYTE PTR [EAX],DL
         INC     EAX
         DEC     ECX
         JMP     @@lp
         @@qt:
end;

function Q_BSwap(D: longword): longword;
asm
         BSWAP   EAX
end;

{$IFDEF CPU32}
procedure Q_BSwapLongs(P: Pointer; Count: Cardinal);
asm
        PUSH    EBX
        MOV     ECX,EDX
        SHR     EDX,3
        JE      @@nx
@@lp:   MOV     EBX,[EAX]
        BSWAP   EBX
        MOV     [EAX],EBX
        MOV     EBX,[EAX+4]
        BSWAP   EBX
        MOV     [EAX+4],EBX
        MOV     EBX,[EAX+8]
        BSWAP   EBX
        MOV     [EAX+8],EBX
        MOV     EBX,[EAX+12]
        BSWAP   EBX
        MOV     [EAX+12],EBX
        MOV     EBX,[EAX+16]
        BSWAP   EBX
        MOV     [EAX+16],EBX
        MOV     EBX,[EAX+20]
        BSWAP   EBX
        MOV     [EAX+20],EBX
        MOV     EBX,[EAX+24]
        BSWAP   EBX
        MOV     [EAX+24],EBX
        MOV     EBX,[EAX+28]
        BSWAP   EBX
        MOV     [EAX+28],EBX
        ADD     EAX,32
        DEC     EDX
        JNE     @@lp
@@nx:   AND     ECX,7
        JMP     DWORD PTR @@tV[ECX*4]
@@tV:   DD      @@tu0, @@tu1, @@tu2, @@tu3
        DD      @@tu4, @@tu5, @@tu6, @@tu7
@@tu7:  MOV     EBX,[EAX+24]
        BSWAP   EBX
        MOV     [EAX+24],EBX
@@tu6:  MOV     EBX,[EAX+20]
        BSWAP   EBX
        MOV     [EAX+20],EBX
@@tu5:  MOV     EBX,[EAX+16]
        BSWAP   EBX
        MOV     [EAX+16],EBX
@@tu4:  MOV     EBX,[EAX+12]
        BSWAP   EBX
        MOV     [EAX+12],EBX
@@tu3:  MOV     EBX,[EAX+8]
        BSWAP   EBX
        MOV     [EAX+8],EBX
@@tu2:  MOV     EBX,[EAX+4]
        BSWAP   EBX
        MOV     [EAX+4],EBX
@@tu1:  MOV     EBX,[EAX]
        BSWAP   EBX
        MOV     [EAX],EBX
@@tu0:  POP     EBX
end;
{$ELSE}

procedure Q_BSwapLongs(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_BSwapLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_Exchange(var A,B);
asm
        PUSH    EBX
        MOV     ECX,[EDX]
        MOV     EBX,[EAX]
        MOV     [EAX],ECX
        MOV     [EDX],EBX
        POP     EBX
end;
{$ELSE}

procedure Q_Exchange(var A, B);
begin
  ShowMessage('Q_Exchange TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ExchangeWords(var A,B);
asm
        PUSH    EBX
        MOV     CX,[EDX]
        MOV     BX,[EAX]
        MOV     [EAX],CX
        MOV     [EDX],BX
        POP     EBX
end;
{$ELSE}

procedure Q_ExchangeWords(var A, B);
begin
  ShowMessage('Q_ExchangeWords TODO');
end;

{$ENDIF}

procedure Q_ExchangeBytes(var A, B);
asm
         MOV     CL,[EDX]
         MOV     CH,[EAX]
         MOV     [EAX],CL
         MOV     [EDX],CH
end;

{$IFDEF CPU32}
function Q_RemValue_Integer(N: Integer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
	PUSH	EBX
	PUSH	EDX
        DEC     ECX
        JS      @@qt
@@lp1:  CMP     EAX,[EDX]
        JE      @@nx
        ADD     EDX,4
        DEC     ECX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EDX+4]
        DEC     ECX
        JS      @@qt
@@lp2:  CMP     EAX,[EDI]
        JE      @@sk
        MOV     EBX,[EDI]
        MOV     [EDX],EBX
        ADD     EDX,4
@@sk:   ADD     EDI,4
        DEC     ECX
        JNS     @@lp2
@@qt:   POP	EBX
	SUB	EDX,EBX
	SHR	EDX,2
	MOV	EAX,EDX
	POP	EBX
        POP     EDI
end;
{$ELSE}

function Q_RemValue_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemValue_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemValue_LongWord(N: LongWord; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
	       PUSH	EBX
	       PUSH	EDX
        DEC     ECX
        JS      @@qt
@@lp1:  CMP     EAX,[EDX]
        JE      @@nx
        ADD     EDX,4
        DEC     ECX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EDX+4]
        DEC     ECX
        JS      @@qt
@@lp2:  CMP     EAX,[EDI]
        JE      @@sk
        MOV     EBX,[EDI]
        MOV     [EDX],EBX
        ADD     EDX,4
@@sk:   ADD     EDI,4
        DEC     ECX
        JNS     @@lp2
@@qt:   POP	EBX
	SUB	EDX,EBX
	SHR	EDX,2
	MOV	EAX,EDX
	POP	EBX
        POP     EDI
end;
{$ELSE}

function Q_RemValue_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemValue_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemValue_Pointer(P: Pointer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
       	PUSH	EBX
	       PUSH	EDX
        DEC     ECX
        JS      @@qt
@@lp1:  CMP     EAX,[EDX]
        JE      @@nx
        ADD     EDX,4
        DEC     ECX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EDX+4]
        DEC     ECX
        JS      @@qt
@@lp2:  CMP     EAX,[EDI]
        JE      @@sk
        MOV     EBX,[EDI]
        MOV     [EDX],EBX
        ADD     EDX,4
@@sk:   ADD     EDI,4
        DEC     ECX
        JNS     @@lp2
@@qt:   POP	EBX
	SUB	EDX,EBX
	SHR	EDX,2
	MOV	EAX,EDX
	POP	EBX
        POP     EDI
end;
{$ELSE}

function Q_RemValue_Pointer(P: Pointer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemValue_Pointer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemValue_Word(N: Integer; ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
	       PUSH	EBX
	       PUSH	EDX
        DEC     ECX
        JS      @@qt
@@lp1:  CMP     AX,[EDX]
        JE      @@nx
        ADD     EDX,2
        DEC     ECX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EDX+2]
        DEC     ECX
        JS      @@qt
@@lp2:  CMP     AX,[EDI]
        JE      @@sk
        MOV     BX,[EDI]
        MOV     [EDX],BX
        ADD     EDX,2
@@sk:   ADD     EDI,2
        DEC     ECX
        JNS     @@lp2
@@qt:   POP	EBX
	SUB	EDX,EBX
	SHR	EDX,1
	MOV	EAX,EDX
	POP	EBX
        POP     EDI
end;
{$ELSE}

function Q_RemValue_Word(N: integer; ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemValue_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemValue_Byte(N: Integer; ArrPtr: Pointer; L: Cardinal): Cardinal;
asm
        PUSH    EDI
	       PUSH	   EBX
	       PUSH	   EDX
        DEC     ECX
        JS      @@qt
@@lp1:  CMP     AL,[EDX]
        JE      @@nx
        INC     EDX
        DEC     ECX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EDX+1]
        DEC     ECX
        JS      @@qt
@@lp2:  CMP     AL,[EDI]
        JE      @@sk
        MOV     BL,[EDI]
        MOV     [EDX],BL
        INC     EDX
@@sk:   INC     EDI
        DEC     ECX
        JNS     @@lp2
@@qt:   POP	EBX
	SUB	EDX,EBX
	MOV	EAX,EDX
	POP	EBX
        POP     EDI
end;
{$ELSE}

function Q_RemValue_Byte(N: integer; ArrPtr: Pointer; L: cardinal): cardinal;
begin
  ShowMessage('Q_RemValue_Byte TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemDuplicates_Int32(ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
	PUSH	EAX
        DEC     EDX
        JS      @@qt
        MOV     ECX,[EAX]
        ADD     EAX,4
        DEC     EDX
        JS      @@qt
@@lp1:  MOV     EDI,[EAX]
        CMP     ECX,EDI
        JE      @@nx
        MOV     ECX,EDI
        ADD     EAX,4
        DEC     EDX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EAX+4]
        DEC     EDX
        JS      @@qt
@@lp2:  CMP     ECX,[EDI]
        JE      @@sk
        MOV     ECX,[EDI]
        MOV     [EAX],ECX
        ADD     EAX,4
@@sk:   ADD     EDI,4
        DEC     EDX
        JNS     @@lp2
@@qt:   POP	ECX
	SUB	EAX,ECX
	SHR	EAX,2
        POP     EDI
end;
{$ELSE}

function Q_RemDuplicates_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemDuplicates_Int32 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemDuplicates_Int16(ArrPtr: Pointer; Count: Cardinal): Cardinal;
asm
        PUSH    EDI
       	PUSH	EAX
        DEC     EDX
        JS      @@qt
        MOV     CX,[EAX]
        ADD     EAX,2
        DEC     EDX
        JS      @@qt
@@lp1:  MOV     DI,[EAX]
        CMP     CX,DI
        JE      @@nx
        MOV     CX,DI
        ADD     EAX,2
        DEC     EDX
        JNS     @@lp1
        JMP     @@qt
@@nx:   LEA     EDI,[EAX+2]
        DEC     EDX
        JS      @@qt
@@lp2:  CMP     CX,[EDI]
        JE      @@sk
        MOV     CX,[EDI]
        MOV     [EAX],CX
        ADD     EAX,2
@@sk:   ADD     EDI,2
        DEC     EDX
        JNS     @@lp2
@@qt:   POP	ECX
	SUB	EAX,ECX
	SHR	EAX,1
        POP     EDI
end;
{$ELSE}

function Q_RemDuplicates_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_RemDuplicates_Int16 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RemDuplicates_Byte(ArrPtr: Pointer; L: cardinal): cardinal;
asm
         PUSH    EBX
         PUSH    EAX
         DEC     EDX
         JS      @@qt
         MOV     CL,[EAX]
         INC     EAX
         DEC     EDX
         JS      @@qt
         @@lp1:
         MOV     BL,[EAX]
         CMP     CL,BL
         JE      @@nx
         MOV     CL,BL
         INC     EAX
         DEC     EDX
         JNS     @@lp1
         JMP     @@qt
         @@nx:
         LEA     EBX,[EAX+1]
         DEC     EDX
         JS      @@qt
         @@lp2:
         CMP     CL,[EBX]
         JE      @@sk
         MOV     CL,[EBX]
         MOV     [EAX],CL
         INC     EAX
         @@sk:
         INC     EBX
         DEC     EDX
         JNS     @@lp2
         @@qt:
         POP     ECX
         SUB     EAX,ECX
         POP     EBX
end;
{$ELSE}

function Q_RemDuplicates_Byte(ArrPtr: Pointer; L: cardinal): cardinal;
begin
  ShowMessage('Q_RemDuplicates_Byte TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
asm
         PUSH    ESI
         PUSH    EAX
         DEC     EDX
         JS      @@qt
         MOV     ECX,[EAX]
         LEA     ESI,[EAX+4]
         DEC     EDX
         JS      @@qt
         @@lp1:
         CMP     ECX,[ESI]
         JE      @@nx
         MOV     ECX,[ESI]
         ADD     ESI,4
         DEC     EDX
         JNS     @@lp1
         JMP     @@qt
         @@nx:
         MOV     [EAX],ECX
         ADD     ESI,4
         ADD     EAX,4
         DEC     EDX
         JS      @@qt
         @@lp2:
         CMP     ECX,[ESI]
         JE      @@sk
         @@xx:
         MOV     ECX,[ESI]
         ADD     ESI,4
         DEC     EDX
         JS      @@qt
         CMP     ECX,[ESI]
         JNE     @@xx
         MOV     [EAX],ECX
         ADD     ESI,4
         ADD     EAX,4
         DEC     EDX
         JNS     @@lp2
         JMP     @@qt
         @@sk:
         ADD     ESI,4
         DEC     EDX
         JNS     @@lp2
         @@qt:
         POP     ECX
         SUB     EAX,ECX
         SHR     EAX,2
         POP     ESI
end;
{$ELSE}

function Q_ANDSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_ANDSetInPlace_Int32 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
asm
         PUSH    ESI
         PUSH    EAX
         DEC     EDX
         JS      @@qt
         MOV     CX,[EAX]
         LEA     ESI,[EAX+2]
         DEC     EDX
         JS      @@qt
         @@lp1:
         CMP     CX,[ESI]
         JE      @@nx
         MOV     CX,[ESI]
         ADD     ESI,2
         DEC     EDX
         JNS     @@lp1
         JMP     @@qt
         @@nx:
         MOV     [EAX],CX
         ADD     ESI,2
         ADD     EAX,2
         DEC     EDX
         JS      @@qt
         @@lp2:
         CMP     CX,[ESI]
         JE      @@sk
         @@xx:
         MOV     CX,[ESI]
         ADD     ESI,2
         DEC     EDX
         JS      @@qt
         CMP     CX,[ESI]
         JNE     @@xx
         MOV     [EAX],CX
         ADD     ESI,2
         ADD     EAX,2
         DEC     EDX
         JNS     @@lp2
         JMP     @@qt
         @@sk:
         ADD     ESI,2
         DEC     EDX
         JNS     @@lp2
         @@qt:
         POP     ECX
         SUB     EAX,ECX
         SHR     EAX,1
         POP     ESI
end;
{$ELSE}

function Q_ANDSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_ANDSetInPlace_Int16 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_XORSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EAX
         DEC     EDX
         JS      @@qt
         MOV     ECX,[EAX]
         ADD     EAX,4
         DEC     EDX
         JS      @@qt
         @@lp1:
         MOV     EDI,[EAX]
         CMP     ECX,EDI
         JE      @@nx
         MOV     ECX,EDI
         ADD     EAX,4
         DEC     EDX
         JNS     @@lp1
         JMP     @@qt
         @@nx:
         LEA     EDI,[EAX-4]
         LEA     ESI,[EAX+4]
         MOV     EAX,EDI
         DEC     EDX
         JS      @@qt
         @@lp2:
         CMP     ECX,[ESI]
         JE      @@sk
         MOV     EDI,EAX
         MOV     ECX,[ESI]
         MOV     [EAX],ECX
         ADD     EAX,4
         ADD     ESI,4
         DEC     EDX
         JNS     @@lp2
         JMP     @@qt
         @@sk:
         MOV     EAX,EDI
         ADD     ESI,4
         DEC     EDX
         JNS     @@lp2
         @@qt:
         POP     ECX
         SUB     EAX,ECX
         SHR     EAX,2
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_XORSetInPlace_Int32(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_XORSetInPlace_Int32 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_XORSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EAX
         DEC     EDX
         JS      @@qt
         MOV     CX,[EAX]
         ADD     EAX,2
         DEC     EDX
         JS      @@qt
         @@lp1:
         MOV     DI,[EAX]
         CMP     CX,DI
         JE      @@nx
         MOV     CX,DI
         ADD     EAX,2
         DEC     EDX
         JNS     @@lp1
         JMP     @@qt
         @@nx:
         LEA     EDI,[EAX-2]
         LEA     ESI,[EAX+2]
         MOV     EAX,EDI
         DEC     EDX
         JS      @@qt
         @@lp2:
         CMP     CX,[ESI]
         JE      @@sk
         MOV     EDI,EAX
         MOV     CX,[ESI]
         MOV     [EAX],CX
         ADD     EAX,2
         ADD     ESI,2
         DEC     EDX
         JNS     @@lp2
         JMP     @@qt
         @@sk:
         MOV     EAX,EDI
         ADD     ESI,2
         DEC     EDX
         JNS     @@lp2
         @@qt:
         POP     ECX
         SUB     EAX,ECX
         SHR     EAX,1
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_XORSetInPlace_Int16(ArrPtr: Pointer; Count: cardinal): cardinal;
begin
  ShowMessage('Q_XORSetInPlace_Int16 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntSortIntegers(ArrPtr: Pointer; Count: cardinal);
asm
         PUSH    EDI
         MOV     EDI,EDX
         PUSH    EBX
         @@lp0:
         LEA     ECX,[EAX+EDI]
         SHR     ECX,1
         AND     ECX,$FFFFFFFC
         MOV     EBX,EAX
         MOV     ESI,[ECX]
         MOV     EDX,EDI
         @@lp1:
         CMP     ESI,[EBX]
         JNG     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNG     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNG     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNG     @@lp2
         ADD     EBX,4
         JMP     @@lp1
         @@lp2:
         CMP     ESI,[EDX]
         JNL     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNL     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNL     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNL     @@nxA
         SUB     EDX,4
         JMP     @@lp2
         @@nxA:
         CMP     EBX,EDX
         JG      @@nxB
         MOV     ECX,[EBX]
         MOV     EBP,[EDX]
         MOV     [EDX],ECX
         MOV     [EBX],EBP
         ADD     EBX,4
         SUB     EDX,4
         CMP     EBX,EDX
         JNG     @@lp1
         @@nxB:
         CMP     EAX,EDX
         JNL     @@nxC
         CALL    IntSortIntegers
         @@nxC:
         MOV     EAX,EBX
         CMP     EBX,EDI
         JL      @@lp0
         POP     EBX
         POP     EDI
end;
{$ELSE}

procedure IntSortIntegers(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('IntSortInteger TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_Sort_Integer(ArrPtr: Pointer; Count: cardinal);
asm
         TEST    EDX,$FFFFFFFE
         JE      @@qt
         PUSH    EBP
         PUSH    ESI
         LEA     EDX,[EAX+EDX*4-4]
         CALL    IntSortIntegers
         POP     ESI
         POP     EBP
         @@qt:
end;
{$ELSE}

procedure Q_Sort_Integer(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('Q_Sort_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntSortLongWords(ArrPtr: Pointer; Count: cardinal);
asm
         PUSH    EDI
         MOV     EDI,EDX
         PUSH    EBX
         @@lp0:
         LEA     ECX,[EAX+EDI]
         SHR     ECX,1
         AND     ECX,$FFFFFFFC
         MOV     EBX,EAX
         MOV     ESI,[ECX]
         MOV     EDX,EDI
         @@lp1:
         CMP     ESI,[EBX]
         JNA     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNA     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNA     @@lp2
         ADD     EBX,4
         CMP     ESI,[EBX]
         JNA     @@lp2
         ADD     EBX,4
         JMP     @@lp1
         @@lp2:
         CMP     ESI,[EDX]
         JNB     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNB     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNB     @@nxA
         SUB     EDX,4
         CMP     ESI,[EDX]
         JNB     @@nxA
         SUB     EDX,4
         JMP     @@lp2
         @@nxA:
         CMP     EBX,EDX
         JG      @@nxB
         MOV     ECX,[EBX]
         MOV     EBP,[EDX]
         MOV     [EDX],ECX
         MOV     [EBX],EBP
         ADD     EBX,4
         SUB     EDX,4
         CMP     EBX,EDX
         JNG     @@lp1
         @@nxB:
         CMP     EAX,EDX
         JNL     @@nxC
         CALL    IntSortLongWords
         @@nxC:
         MOV     EAX,EBX
         CMP     EBX,EDI
         JL      @@lp0
         POP     EBX
         POP     EDI
end;
{$ELSE}

procedure IntSortLongWords(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('IntSortLongWords TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_Sort_LongWord(ArrPtr: Pointer; Count: cardinal);
asm
         TEST    EDX,$FFFFFFFE
         JE      @@qt
         PUSH    EBP
         PUSH    ESI
         LEA     EDX,[EAX+EDX*4-4]
         CALL    IntSortLongWords
         POP     ESI
         POP     EBP
         @@qt:
end;
{$ELSE}

procedure Q_Sort_LongWord(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('Q_Sort_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntSortWords(ArrPtr: Pointer; Count: cardinal);
asm
         PUSH    EDI
         MOV     EDI,EDX
         PUSH    EBX
         @@lp0:
         LEA     ECX,[EAX+EDI]
         SHR     ECX,1
         AND     ECX,$FFFFFFFE
         MOV     EBX,EAX
         MOV     SI,[ECX]
         MOV     EDX,EDI
         @@lp1:
         CMP     SI,[EBX]
         JNA     @@lp2
         ADD     EBX,2
         CMP     SI,[EBX]
         JNA     @@lp2
         ADD     EBX,2
         CMP     SI,[EBX]
         JNA     @@lp2
         ADD     EBX,2
         CMP     SI,[EBX]
         JNA     @@lp2
         ADD     EBX,2
         JMP     @@lp1
         @@lp2:
         CMP     SI,[EDX]
         JNB     @@nxA
         SUB     EDX,2
         CMP     SI,[EDX]
         JNB     @@nxA
         SUB     EDX,2
         CMP     SI,[EDX]
         JNB     @@nxA
         SUB     EDX,2
         CMP     SI,[EDX]
         JNB     @@nxA
         SUB     EDX,2
         JMP     @@lp2
         @@nxA:
         CMP     EBX,EDX
         JG      @@nxB
         MOV     CX,[EBX]
         MOV     BP,[EDX]
         MOV     [EDX],CX
         MOV     [EBX],BP
         ADD     EBX,2
         SUB     EDX,2
         CMP     EBX,EDX
         JNG     @@lp1
         @@nxB:
         CMP     EAX,EDX
         JNL     @@nxC
         CALL    IntSortWords
         @@nxC:
         MOV     EAX,EBX
         CMP     EBX,EDI
         JL      @@lp0
         POP     EBX
         POP     EDI
end;
{$ELSE}

procedure IntSortWords(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('IntSortWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_Sort_Word(ArrPtr: Pointer; Count: cardinal);
asm
         TEST    EDX,$FFFFFFFE
         JE      @@qt
         PUSH    EBP
         PUSH    ESI
         LEA     EDX,[EAX+EDX*2-2]
         CALL    IntSortWords
         POP     ESI
         POP     EBP
         @@qt:
end;
{$ELSE}

procedure Q_Sort_Word(ArrPtr: Pointer; Count: cardinal);
begin
  ShowMessage('Q_Sort_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchUnique_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         DEC     ECX
         JS      @@zq
         PUSH    ESI
         PUSH    EBX
         XOR     ESI,ESI
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JL      @@mm
         JE      @@qt
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@nx
         @@mm:
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@nx:
         POP     EBX
         POP     ESI
         @@zq:
         MOV     EAX,$FFFFFFFF
         RET
         @@qt:
         MOV     EAX,EBX
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_SearchUnique_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchUnique_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchUnique_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
asm
         DEC     ECX
         JS      @@zq
         PUSH    ESI
         PUSH    EBX
         XOR     ESI,ESI
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JB      @@mm
         JE      @@qt
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@nx
         @@mm:
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@nx:
         POP     EBX
         POP     ESI
         @@zq:
         MOV     EAX,$FFFFFFFF
         RET
         @@qt:
         MOV     EAX,EBX
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_SearchUnique_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchUnique_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchUnique_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         DEC     ECX
         JS      @@zq
         PUSH    ESI
         PUSH    EBX
         XOR     ESI,ESI
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     AX,[EDX+EBX*2]
         JB      @@mm
         JE      @@qt
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@nx
         @@mm:
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@nx:
         POP     EBX
         POP     ESI
         @@zq:
         MOV     EAX,$FFFFFFFF
         RET
         @@qt:
         MOV     EAX,EBX
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_SearchUnique_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchUnique_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirst_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JG      @@aa
         JE      @@ee
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@qt
         @@ee:
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirst_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirst_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirst_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JA      @@aa
         JE      @@ee
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@qt
         @@ee:
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirst_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirst_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirst_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     AX,[EDX+EBX*2]
         JA      @@aa
         JE      @@ee
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         JMP     @@qt
         @@ee:
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirst_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirst_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirstGE_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JG      @@aa
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirstGE_Integer(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirstGE_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirstGE_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     EAX,[EDX+EBX*4]
         JA      @@aa
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirstGE_LongWord(N: longword; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirstGE_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SearchFirstGE_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,$FFFFFFFF
         XOR     ESI,ESI
         PUSH    EBX
         DEC     ECX
         JS      @@qt
         @@lp:
         LEA     EBX,[ECX+ESI]
         SHR     EBX,1
         CMP     AX,[EDX+EBX*2]
         JA      @@aa
         MOV     EDI,EBX
         LEA     ECX,[EBX-1]
         CMP     ESI,ECX
         JLE     @@lp
         JMP     @@qt
         @@aa:
         LEA     ESI,[EBX+1]
         CMP     ECX,ESI
         JGE     @@lp
         @@qt:
         POP     EBX
         MOV     EAX,EDI
         POP     ESI
         POP     EDI
end;
{$ELSE}

function Q_SearchFirstGE_Word(N: integer; ArrPtr: Pointer; Count: cardinal): integer;
begin
  ShowMessage('Q_SearchFirstGE_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@qt
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JL      @@bb
         JG      @@aa
         MOV     [EDI],ESI
         ADD     EDI,4
         JMP     @@lp
         @@bb:
         DEC     EDX
         JS      @@qt
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@qt1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JL      @@bb1
         JG      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         DEC     EDX
         JS      @@qt1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDSet_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@qt
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JB      @@bb
         JA      @@aa
         MOV     [EDI],ESI
         ADD     EDI,4
         JMP     @@lp
         @@bb:
         DEC     EDX
         JS      @@qt
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@qt1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JB      @@bb1
         JA      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         DEC     EDX
         JS      @@qt1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDSet_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@qt
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx:
         CMP     SI,BP
         JB      @@bb
         JA      @@aa
         MOV     [EDI],SI
         ADD     EDI,2
         JMP     @@lp
         @@bb:
         DEC     EDX
         JS      @@qt
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@qt
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,1
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@qt1
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx1:
         CMP     SI,BP
         JB      @@bb1
         JA      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         DEC     EDX
         JS      @@qt1
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@qt1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDSet_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JL      @@bb
         JG      @@aa
         MOV     [EDI],ESI
         ADD     EDI,4
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@BX
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@BX:
         MOV     [EDI],EBP
         ADD     EDI,4
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@BX
         @@aa:
         MOV     [EDI],EBP
         ADD     EDI,4
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JL      @@bb1
         JG      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ORSet_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JB      @@bb
         JA      @@aa
         MOV     [EDI],ESI
         ADD     EDI,4
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@BX
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@BX:
         MOV     [EDI],EBP
         ADD     EDI,4
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@BX
         @@aa:
         MOV     [EDI],EBP
         ADD     EDI,4
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JB      @@bb1
         JA      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ORSet_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx:
         CMP     SI,BP
         JB      @@bb
         JA      @@aa
         MOV     [EDI],SI
         ADD     EDI,2
         JMP     @@lp
         @@bb:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@BX
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx
         @@BX:
         MOV     [EDI],BP
         ADD     EDI,2
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@BX
         @@aa:
         MOV     [EDI],BP
         ADD     EDI,2
         DEC     EBX
         JS      @@AX
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx
         @@AX:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,1
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx1:
         CMP     SI,BP
         JB      @@bb1
         JA      @@aa1
         INC     EDI
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ORSet_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_XORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JL      @@bb
         JG      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@BX
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@BX:
         MOV     [EDI],EBP
         ADD     EDI,4
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@BX
         @@aa:
         MOV     [EDI],EBP
         ADD     EDI,4
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JL      @@bb1
         JG      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_XORSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_XORSet_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_XORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JB      @@bb
         JA      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@BX
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@BX:
         MOV     [EDI],EBP
         ADD     EDI,4
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@BX
         @@aa:
         MOV     [EDI],EBP
         ADD     EDI,4
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JB      @@bb1
         JA      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_XORSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_XORSet_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_XORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@mm
         DEC     EBX
         JS      @@nn
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx:
         CMP     SI,BP
         JB      @@bb
         JA      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@BX
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx
         @@BX:
         MOV     [EDI],BP
         ADD     EDI,2
         @@mm:
         DEC     EBX
         JS      @@qt
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@BX
         @@aa:
         MOV     [EDI],BP
         ADD     EDI,2
         DEC     EBX
         JS      @@AX
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx
         @@AX:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,1
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@MM1
         DEC     EBX
         JS      @@nn1
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx1:
         CMP     SI,BP
         JB      @@bb1
         JA      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@bx1
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx1
         @@bx1:
         INC     EDI
         @@MM1:
         DEC     EBX
         JS      @@qt1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@bx1
         @@aa1:
         INC     EDI
         DEC     EBX
         JS      @@ax1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_XORSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_XORSet_Word TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDNOTSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JL      @@bb
         JG      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JL      @@bb1
         JG      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDNOTSet_Integer(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDNOTSet_Integer TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDNOTSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@nn
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx:
         CMP     ESI,EBP
         JB      @@bb
         JA      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@AX
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx
         @@AX:
         MOV     [EDI],ESI
         ADD     EDI,4
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,2
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@nn1
         MOV     ESI,[EAX]
         MOV     EBP,[ECX]
         ADD     EAX,4
         ADD     ECX,4
         @@nx1:
         CMP     ESI,EBP
         JB      @@bb1
         JA      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@ax1
         MOV     EBP,[ECX]
         ADD     ECX,4
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     ESI,[EAX]
         ADD     EAX,4
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDNOTSet_LongWord(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDNOTSet_LongWord TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_ANDNOTSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
asm
         PUSH    ESI
         PUSH    EBX
         PUSH    EDI
         PUSH    EBP
         MOV     EDI,[ESP+24]
         MOV     EBX,[ESP+28]
         TEST    EDI,EDI
         JE      @@lp1
         @@lp:
         DEC     EDX
         JS      @@qt
         DEC     EBX
         JS      @@nn
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx:
         CMP     SI,BP
         JB      @@bb
         JA      @@aa
         JMP     @@lp
         @@bb:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@qt
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx
         @@aa:
         DEC     EBX
         JS      @@AX
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx
         @@AX:
         MOV     [EDI],SI
         ADD     EDI,2
         DEC     EDX
         JS      @@qt
         @@nn:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@AX
         @@qt:
         SUB     EDI,[ESP+24]
         SHR     EDI,1
         JMP     @@qt1
         @@lp1:
         DEC     EDX
         JS      @@qt1
         DEC     EBX
         JS      @@nn1
         MOV     SI,[EAX]
         MOV     BP,[ECX]
         ADD     EAX,2
         ADD     ECX,2
         @@nx1:
         CMP     SI,BP
         JB      @@bb1
         JA      @@aa1
         JMP     @@lp1
         @@bb1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@nx1
         @@aa1:
         DEC     EBX
         JS      @@ax1
         MOV     BP,[ECX]
         ADD     ECX,2
         JMP     @@nx1
         @@ax1:
         INC     EDI
         DEC     EDX
         JS      @@qt1
         @@nn1:
         MOV     SI,[EAX]
         ADD     EAX,2
         JMP     @@ax1
         @@qt1:
         MOV     EAX,EDI
         POP     EBP
         POP     EDI
         POP     EBX
         POP     ESI
end;
{$ELSE}

function Q_ANDNOTSet_Word(P1: Pointer; Count1: cardinal; P2: Pointer; Count2: cardinal; OutPlace: Pointer): cardinal;
begin
  ShowMessage('Q_ANDNOTSet_Word TODO');
end;

{$ENDIF}

function Q_BitTest32(D: longword; Index: cardinal): boolean;
asm
         MOV     CL,DL
         SHR     EAX,CL
         AND     EAX,1
end;

const
  BitMasks: array[0..31] of longword =
    ($00000001, $00000002, $00000004, $00000008, $00000010, $00000020, $00000040, $00000080,
    $00000100, $00000200, $00000400, $00000800, $00001000, $00002000, $00004000, $00008000,
    $00010000, $00020000, $00040000, $00080000, $00100000, $00200000, $00400000, $00800000,
    $01000000, $02000000, $04000000, $08000000, $10000000, $20000000, $40000000, $80000000);

function Q_BitSet32(D: longword; Index: cardinal): longword;
asm
         OR      EAX,DWORD PTR [EDX*4+BitMasks]
end;

function Q_BitReset32(D: longword; Index: cardinal): longword;
asm
         MOV     ECX,DWORD PTR [EDX*4+BitMasks]
         NOT     ECX
         AND     EAX,ECX
end;

function Q_BitToggle32(D: longword; Index: cardinal): longword;
asm
         XOR     EAX,DWORD PTR [EDX*4+BitMasks]
end;

{$IFDEF CPU32}
function Q_CountOfSetBits32(D: longword): cardinal;
asm
         PUSH    EBX
         MOVZX   EDX,AL
         MOVZX   ECX,AH
         SHR     EAX,16
         MOVZX   EBX,AH
         AND     EAX,$FF
         MOVZX   EAX,BYTE PTR [EAX+BitTable]
         ADD     AL,BYTE PTR [EBX+BitTable]
         ADD     AL,BYTE PTR [ECX+BitTable]
         ADD     AL,BYTE PTR [EDX+BitTable]
         POP     EBX
end;
{$ELSE}

function Q_CountOfSetBits32(D: longword): cardinal;
begin
  ShowMessage('Q_CountOfSetBits32 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountOfFreeBits32(D: longword): cardinal;
asm
         PUSH    EBX
         MOVZX   EDX,AL
         MOVZX   ECX,AH
         SHR     EAX,16
         MOVZX   EBX,AH
         AND     EAX,$FF
         MOV     BL,BYTE PTR [EBX+BitTable]
         ADD     BL,BYTE PTR [EAX+BitTable]
         MOV     EAX,32
         ADD     BL,BYTE PTR [ECX+BitTable]
         ADD     BL,BYTE PTR [EDX+BitTable]
         SUB     AL,BL
         POP     EBX
end;
{$ELSE}

function Q_CountOfFreeBits32(D: longword): cardinal;
begin
  ShowMessage('Q_CountOfFreeBits32 TODO');
end;

{$ENDIF}

function Q_SetBitScanForward32(D: longword; FirstBit: integer): integer;
asm
         MOV     ECX,EDX
         MOV     EDX,$FFFFFFFF
         SHL     EDX,CL
         AND     EDX,EAX
         JE      @@zq
         BSF     EAX,EDX
         RET
         @@zq:
         MOV     EAX,$FFFFFFFF
end;

function Q_FreeBitScanForward32(D: longword; FirstBit: integer): integer;
asm
         MOV     ECX,EDX
         MOV     EDX,$FFFFFFFF
         NOT     EAX
         SHL     EDX,CL
         AND     EDX,EAX
         JE      @@zq
         BSF     EAX,EDX
         RET
         @@zq:
         MOV     EAX,$FFFFFFFF
end;

function Q_SetBitScanReverse32(D: longword; LastBit: integer): integer;
asm
         LEA     ECX,[EDX-31]
         MOV     EDX,$FFFFFFFF
         NEG     ECX
         SHR     EDX,CL
         AND     EDX,EAX
         JE      @@zq
         BSR     EAX,EDX
         RET
         @@zq:
         MOV     EAX,$FFFFFFFF
end;

function Q_FreeBitScanReverse32(D: longword; LastBit: integer): integer;
asm
         LEA     ECX,[EDX-31]
         MOV     EDX,$FFFFFFFF
         NEG     ECX
         NOT     EAX
         SHR     EDX,CL
         AND     EDX,EAX
         JE      @@zq
         BSR     EAX,EDX
         RET
         @@zq:
         MOV     EAX,$FFFFFFFF
end;

function Q_BitTest(P: Pointer; Index: integer): boolean;
asm
         BT      [EAX],EDX
         SETC    AL
end;

function Q_BitSet(P: Pointer; Index: integer): boolean;
asm
         BTS     [EAX],EDX
         SETC    AL
end;

function Q_BitReset(P: Pointer; Index: integer): boolean;
asm
         BTR     [EAX],EDX
         SETC    AL
end;

function Q_BitToggle(P: Pointer; Index: integer): boolean;
asm
         BTC     [EAX],EDX
         SETC    AL
end;

{$IFDEF CPU32}
procedure Q_SetBits(P: Pointer; FirstBit, LastBit: integer);
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EBX
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         SUB     ESI,EDX
         JE      @@xx
         OR      [EAX+EDX*4],EBX
         INC     EDX
         DEC     ESI
         JE      @@ne
         MOV     EBX,$FFFFFFFF
         @@lp:
         MOV     [EAX+EDX*4],EBX
         INC     EDX
         DEC     ESI
         JNE     @@lp
         @@xx:
         AND     EDI,EBX
         @@ne:
         OR      [EAX+EDX*4],EDI
         POP     EBX
         POP     ESI
         POP     EDI
         RET
         @@ut:
         SUB     ECX,EDX
         JS      @@qt
         @@uk:
         BTS     [EAX],EDX
         INC     EDX
         DEC     ECX
         JNS     @@uk
         @@qt:
         POP     EBX
         POP     ESI
         POP     EDI
end;
{$ELSE}

procedure Q_SetBits(P: Pointer; FirstBit, LastBit: integer);
begin
  ShowMessage('Q_SetBits TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ResetBits(P: Pointer; FirstBit, LastBit: integer);
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EBX
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         NOT     EDI
         NOT     EBX
         SUB     ESI,EDX
         JE      @@xx
         AND     [EAX+EDX*4],EBX
         INC     EDX
         DEC     ESI
         JE      @@ne
         XOR     EBX,EBX
         @@lp:
         MOV     [EAX+EDX*4],EBX
         INC     EDX
         DEC     ESI
         JNE     @@lp
         @@xx:
         OR      EDI,EBX
         @@ne:
         AND     [EAX+EDX*4],EDI
         POP     EBX
         POP     ESI
         POP     EDI
         RET
         @@ut:
         SUB     ECX,EDX
         JS      @@qt
         @@uk:
         BTR     [EAX],EDX
         INC     EDX
         DEC     ECX
         JNS     @@uk
         @@qt:
         POP     EBX
         POP     ESI
         POP     EDI
end;
{$ELSE}

procedure Q_ResetBits(P: Pointer; FirstBit, LastBit: integer);
begin
  ShowMessage('Q_ResetBits TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ToggleBits(P: Pointer; FirstBit, LastBit: integer);
asm
         PUSH    EDI
         PUSH    ESI
         PUSH    EBX
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         SUB     ESI,EDX
         JE      @@xx
         XOR     [EAX+EDX*4],EBX
         INC     EDX
         DEC     ESI
         JE      @@ne
         MOV     EBX,$FFFFFFFF
         @@lp:
         NOT     DWORD PTR [EAX+EDX*4]
         INC     EDX
         DEC     ESI
         JNE     @@lp
         @@xx:
         AND     EDI,EBX
         @@ne:
         XOR     [EAX+EDX*4],EDI
         POP     EBX
         POP     ESI
         POP     EDI
         RET
         @@ut:
         SUB     ECX,EDX
         JS      @@qt
         @@uk:
         BTC     [EAX],EDX
         INC     EDX
         DEC     ECX
         JNS     @@uk
         @@qt:
         POP     EBX
         POP     ESI
         POP     EDI
end;
{$ELSE}

procedure Q_ToggleBits(P: Pointer; FirstBit, LastBit: integer);
begin
  ShowMessage('Q_ToggleBits TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountOfSetBits(P: Pointer; L: cardinal): cardinal;
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,EAX
         XOR     EAX,EAX
         SUB     EDX,2
         JS      @@nx
         @@lp:
         MOVZX   ECX,BYTE PTR [EBX+EDX]
         MOVZX   ESI,BYTE PTR [EBX+EDX+1]
         MOVZX   ECX,BYTE PTR [ECX+BitTable]
         ADD     EAX,ECX
         MOVZX   ESI,BYTE PTR [ESI+BitTable]
         ADD     EAX,ESI
         SUB     EDX,2
         JNS     @@lp
         @@nx:
         INC     EDX
         JZ      @@qt2
         POP     ESI
         POP     EBX
         RET
         @@qt2:
         MOVZX   ECX,BYTE PTR [EBX]
         MOVZX   ECX,BYTE PTR [ECX+BitTable]
         ADD     EAX,ECX
         POP     ESI
         POP     EBX
end;
{$ELSE}

function Q_CountOfSetBits(P: Pointer; L: cardinal): cardinal;
begin
  ShowMessage('Q_CountOfSetBits TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_CountOfFreeBits(P: Pointer; L: cardinal): cardinal;
asm
         PUSH    EDX
         CALL    Q_CountOfSetBits
         NEG     EAX
         POP     EDX
         LEA     EAX,[EAX+EDX*8]
end;
{$ELSE}

function Q_CountOfFreeBits(P: Pointer; L: cardinal): cardinal;
begin
  ShowMessage('Q_CountOfFreeBits TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SetBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         AND     EBX,[EAX+EDX*4]
         SUB     ESI,EDX
         JE      @@nq
         TEST    EBX,EBX
         JNE     @@ne
         INC     EDX
         DEC     ESI
         JE      @@xx
         @@lp:
         OR      EBX,[EAX+EDX*4]
         JNE     @@ne
         INC     EDX
         DEC     ESI
         JNE     @@lp
         @@xx:
         MOV     EBX,[EAX+EDX*4]
         @@nq:
         AND     EBX,EDI
         JE      @@zq
         @@ne:
         BSF     ECX,EBX
         @@qt:
         SHL     EDX,5
         LEA     EAX,[ECX+EDX]
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@ut:
         SUB     ECX,EDX
         JS      @@zq
         @@uk:
         BT      [EAX],EDX
         JC      @@iq
         INC     EDX
         DEC     ECX
         JNS     @@uk
         @@zq:
         MOV     EAX,$FFFFFFFF
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@iq:
         MOV     EAX,EDX
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

function Q_SetBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;
begin
  ShowMessage('Q_SetBitScanForward TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_FreeBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         MOV     ECX,[EAX+EDX*4]
         NOT     ECX
         AND     EBX,ECX
         SUB     ESI,EDX
         JE      @@nq
         TEST    EBX,EBX
         JNE     @@ne
         INC     EDX
         DEC     ESI
         JE      @@xx
         @@lp:
         MOV     EBX,[EAX+EDX*4]
         NOT     EBX
         TEST    EBX,EBX
         JNE     @@ne
         INC     EDX
         DEC     ESI
         JNE     @@lp
         @@xx:
         MOV     EBX,[EAX+EDX*4]
         NOT     EBX
         @@nq:
         AND     EBX,EDI
         JE      @@zq
         @@ne:
         BSF     ECX,EBX
         @@qt:
         SHL     EDX,5
         LEA     EAX,[ECX+EDX]
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@ut:
         SUB     ECX,EDX
         JS      @@zq
         @@uk:
         BT      [EAX],EDX
         JNC     @@iq
         INC     EDX
         DEC     ECX
         JNS     @@uk
         @@zq:
         MOV     EAX,$FFFFFFFF
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@iq:
         MOV     EAX,EDX
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

function Q_FreeBitScanForward(P: Pointer; FirstBit, LastBit: integer): integer;
begin
  ShowMessage('Q_FreeBitScanForward TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_SetBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         AND     EDI,[EAX+ESI*4]
         SUB     EDX,ESI
         JE      @@nq
         TEST    EDI,EDI
         JNE     @@ne
         NEG     EDX
         DEC     ESI
         DEC     EDX
         JE      @@xx
         @@lp:
         OR      EDI,[EAX+ESI*4]
         JNE     @@ne
         DEC     ESI
         DEC     EDX
         JNE     @@lp
         @@xx:
         MOV     EDI,[EAX+ESI*4]
         @@nq:
         AND     EDI,EBX
         JE      @@zq
         @@ne:
         BSR     ECX,EDI
         @@qt:
         SHL     ESI,5
         LEA     EAX,[ECX+ESI]
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@ut:
         SUB     EDX,ECX
         JG      @@zq
         @@uk:
         BT      [EAX],ECX
         JC      @@iq
         DEC     ECX
         INC     EDX
         JNG     @@uk
         @@zq:
         MOV     EAX,$FFFFFFFF
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@iq:
         MOV     EAX,ECX
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

function Q_SetBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;
begin
  ShowMessage('Q_SetBitScanReverse TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_FreeBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EDX+8]
         CMP     ECX,ESI
         JL      @@ut
         MOV     EBX,$FFFFFFFF
         MOV     ESI,ECX
         MOV     EDI,$0000001F
         AND     ECX,EDI
         AND     ESI,$FFFFFFE0
         SUB     EDI,ECX
         SHR     ESI,5
         MOV     ECX,EDI
         MOV     EDI,EBX
         SHR     EDI,CL
         MOV     ECX,EDX
         AND     EDX,$FFFFFFE0
         AND     ECX,$0000001F
         SHR     EDX,5
         SHL     EBX,CL
         MOV     ECX,[EAX+ESI*4]
         NOT     ECX
         AND     EDI,ECX
         SUB     EDX,ESI
         JE      @@nq
         TEST    EDI,EDI
         JNE     @@ne
         NEG     EDX
         DEC     ESI
         DEC     EDX
         JE      @@xx
         @@lp:
         MOV     EDI,[EAX+ESI*4]
         NOT     EDI
         TEST    EDI,EDI
         JNE     @@ne
         DEC     ESI
         DEC     EDX
         JNE     @@lp
         @@xx:
         MOV     EDI,[EAX+ESI*4]
         NOT     EDI
         @@nq:
         AND     EDI,EBX
         JE      @@zq
         @@ne:
         BSR     ECX,EDI
         @@qt:
         SHL     ESI,5
         LEA     EAX,[ECX+ESI]
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@ut:
         SUB     EDX,ECX
         JG      @@zq
         @@uk:
         BT      [EAX],ECX
         JNC     @@iq
         DEC     ECX
         INC     EDX
         JNG     @@uk
         @@zq:
         MOV     EAX,$FFFFFFFF
         POP     EDI
         POP     ESI
         POP     EBX
         RET
         @@iq:
         MOV     EAX,ECX
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

function Q_FreeBitScanReverse(P: Pointer; FirstBit, LastBit: integer): integer;
begin
  ShowMessage('Q_FreeBitScanReverse TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_NOTByteArr(P: Pointer; L: cardinal);
asm
         MOV     ECX,EDX
         AND     EDX,15
         SHR     ECX,4
         JE      @@nx
         @@lp:
         NOT     DWORD PTR [EAX]
         NOT     DWORD PTR [EAX+4]
         NOT     DWORD PTR [EAX+8]
         NOT     DWORD PTR [EAX+12]
         ADD     EAX,16
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EDX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         DD      @@ku08, @@ku09, @@ku10, @@ku11
         DD      @@ku12, @@ku13, @@ku14, @@ku15
         @@ku15:
         NOT     BYTE PTR [EAX+14]
         @@ku14:
         NOT     BYTE PTR [EAX+13]
         @@ku13:
         NOT     BYTE PTR [EAX+12]
         @@ku12:
         NOT     DWORD PTR [EAX+8]
         NOT     DWORD PTR [EAX+4]
         NOT     DWORD PTR [EAX]
         RET
         @@ku11:
         NOT     BYTE PTR [EAX+10]
         @@ku10:
         NOT     BYTE PTR [EAX+9]
         @@ku09:
         NOT     BYTE PTR [EAX+8]
         @@ku08:
         NOT     DWORD PTR [EAX+4]
         NOT     DWORD PTR [EAX]
         RET
         @@ku07:
         NOT     BYTE PTR [EAX+6]
         @@ku06:
         NOT     BYTE PTR [EAX+5]
         @@ku05:
         NOT     BYTE PTR [EAX+4]
         @@ku04:
         NOT     DWORD PTR [EAX]
         RET
         @@ku03:
         NOT     BYTE PTR [EAX+2]
         @@ku02:
         NOT     BYTE PTR [EAX+1]
         @@ku01:
         NOT     BYTE PTR [EAX]
         @@ku00:
end;
{$ELSE}

procedure Q_NOTByteArr(P: Pointer; L: cardinal);
begin
  ShowMessage('Q_NOTByteArr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_XORByData(Dest, Source: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    ESI
         PUSH    EDI
         MOV     ESI,EDX
         MOV     EDI,EAX
         MOV     EDX,ECX
         AND     ECX,15
         SHR     EDX,4
         JE      @@nx
         @@lp:
         MOV     EAX,[ESI]
         XOR     [EDI],EAX
         MOV     EAX,[ESI+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[ESI+8]
         XOR     [EDI+8],EAX
         MOV     EAX,[ESI+12]
         XOR     [EDI+12],EAX
         ADD     ESI,16
         ADD     EDI,16
         DEC     EDX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@t00, @@t01, @@t02, @@t03
         DD      @@t04, @@t05, @@t06, @@t07
         DD      @@t08, @@t09, @@t10, @@t11
         DD      @@t12, @@t13, @@t14, @@t15
         @@t15:
         MOV     AL,BYTE PTR [ESI+14]
         XOR     BYTE PTR [EDI+14],AL
         @@t14:
         MOV     AL,BYTE PTR [ESI+13]
         XOR     BYTE PTR [EDI+13],AL
         @@t13:
         MOV     AL,BYTE PTR [ESI+12]
         XOR     BYTE PTR [EDI+12],AL
         @@t12:
         MOV     EAX,[ESI+8]
         XOR     [EDI+8],EAX
         MOV     EAX,[ESI+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[ESI]
         XOR     [EDI],EAX
         @@t00:
         POP     EDI
         POP     ESI
         @@qt:
         RET
         @@t11:
         MOV     AL,BYTE PTR [ESI+10]
         XOR     BYTE PTR [EDI+10],AL
         @@t10:
         MOV     AL,BYTE PTR [ESI+9]
         XOR     BYTE PTR [EDI+9],AL
         @@t09:
         MOV     AL,BYTE PTR [ESI+8]
         XOR     BYTE PTR [EDI+8],AL
         @@t08:
         MOV     EAX,[ESI+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[ESI]
         XOR     [EDI],EAX
         POP     EDI
         POP     ESI
         RET
         @@t07:
         MOV     AL,BYTE PTR [ESI+6]
         XOR     BYTE PTR [EDI+6],AL
         @@t06:
         MOV     AL,BYTE PTR [ESI+5]
         XOR     BYTE PTR [EDI+5],AL
         @@t05:
         MOV     AL,BYTE PTR [ESI+4]
         XOR     BYTE PTR [EDI+4],AL
         @@t04:
         MOV     EAX,[ESI]
         XOR     [EDI],EAX
         POP     EDI
         POP     ESI
         RET
         @@t03:
         MOV     AL,BYTE PTR [ESI+2]
         XOR     BYTE PTR [EDI+2],AL
         @@t02:
         MOV     AL,BYTE PTR [ESI+1]
         XOR     BYTE PTR [EDI+1],AL
         @@t01:
         MOV     AL,BYTE PTR [ESI]
         XOR     BYTE PTR [EDI],AL
         POP     EDI
         POP     ESI
end;
{$ELSE}

procedure Q_XORByData(Dest, Source: Pointer; L: cardinal);
begin
  ShowMessage('Q_XORByData TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ANDLongs(Dest, Source: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,ECX
         AND     EBX,7
         SHR     ECX,3
         JE      @@nx
         @@lp:
         MOV     ESI,[EDX]
         AND     [EAX],ESI
         MOV     ESI,[EDX+4]
         AND     [EAX+4],ESI
         MOV     ESI,[EDX+8]
         AND     [EAX+8],ESI
         MOV     ESI,[EDX+12]
         AND     [EAX+12],ESI
         MOV     ESI,[EDX+16]
         AND     [EAX+16],ESI
         MOV     ESI,[EDX+20]
         AND     [EAX+20],ESI
         MOV     ESI,[EDX+24]
         AND     [EAX+24],ESI
         MOV     ESI,[EDX+28]
         AND     [EAX+28],ESI
         ADD     EDX,32
         ADD     EAX,32
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EBX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         @@ku07:
         MOV     ESI,[EDX+24]
         AND     [EAX+24],ESI
         @@ku06:
         MOV     ESI,[EDX+20]
         AND     [EAX+20],ESI
         @@ku05:
         MOV     ESI,[EDX+16]
         AND     [EAX+16],ESI
         @@ku04:
         MOV     ESI,[EDX+12]
         AND     [EAX+12],ESI
         @@ku03:
         MOV     ESI,[EDX+8]
         AND     [EAX+8],ESI
         @@ku02:
         MOV     ESI,[EDX+4]
         AND     [EAX+4],ESI
         @@ku01:
         MOV     ESI,[EDX]
         AND     [EAX],ESI
         @@ku00:
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_ANDLongs(Dest, Source: Pointer; Count: cardinal);
begin
  ShowMessage('Q_ANDLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ORLongs(Dest, Source: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,ECX
         AND     EBX,7
         SHR     ECX,3
         JE      @@nx
         @@lp:
         MOV     ESI,[EDX]
         OR      [EAX],ESI
         MOV     ESI,[EDX+4]
         OR      [EAX+4],ESI
         MOV     ESI,[EDX+8]
         OR      [EAX+8],ESI
         MOV     ESI,[EDX+12]
         OR      [EAX+12],ESI
         MOV     ESI,[EDX+16]
         OR      [EAX+16],ESI
         MOV     ESI,[EDX+20]
         OR      [EAX+20],ESI
         MOV     ESI,[EDX+24]
         OR      [EAX+24],ESI
         MOV     ESI,[EDX+28]
         OR      [EAX+28],ESI
         ADD     EDX,32
         ADD     EAX,32
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EBX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         @@ku07:
         MOV     ESI,[EDX+24]
         OR      [EAX+24],ESI
         @@ku06:
         MOV     ESI,[EDX+20]
         OR      [EAX+20],ESI
         @@ku05:
         MOV     ESI,[EDX+16]
         OR      [EAX+16],ESI
         @@ku04:
         MOV     ESI,[EDX+12]
         OR      [EAX+12],ESI
         @@ku03:
         MOV     ESI,[EDX+8]
         OR      [EAX+8],ESI
         @@ku02:
         MOV     ESI,[EDX+4]
         OR      [EAX+4],ESI
         @@ku01:
         MOV     ESI,[EDX]
         OR      [EAX],ESI
         @@ku00:
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_ORLongs(Dest, Source: Pointer; Count: cardinal);
begin
  ShowMessage('Q_ORLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_XORLongs(Dest, Source: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,ECX
         AND     EBX,7
         SHR     ECX,3
         JE      @@nx
         @@lp:
         MOV     ESI,[EDX]
         XOR     [EAX],ESI
         MOV     ESI,[EDX+4]
         XOR     [EAX+4],ESI
         MOV     ESI,[EDX+8]
         XOR     [EAX+8],ESI
         MOV     ESI,[EDX+12]
         XOR     [EAX+12],ESI
         MOV     ESI,[EDX+16]
         XOR     [EAX+16],ESI
         MOV     ESI,[EDX+20]
         XOR     [EAX+20],ESI
         MOV     ESI,[EDX+24]
         XOR     [EAX+24],ESI
         MOV     ESI,[EDX+28]
         XOR     [EAX+28],ESI
         ADD     EDX,32
         ADD     EAX,32
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EBX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         @@ku07:
         MOV     ESI,[EDX+24]
         XOR     [EAX+24],ESI
         @@ku06:
         MOV     ESI,[EDX+20]
         XOR     [EAX+20],ESI
         @@ku05:
         MOV     ESI,[EDX+16]
         XOR     [EAX+16],ESI
         @@ku04:
         MOV     ESI,[EDX+12]
         XOR     [EAX+12],ESI
         @@ku03:
         MOV     ESI,[EDX+8]
         XOR     [EAX+8],ESI
         @@ku02:
         MOV     ESI,[EDX+4]
         XOR     [EAX+4],ESI
         @@ku01:
         MOV     ESI,[EDX]
         XOR     [EAX],ESI
         @@ku00:
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_XORLongs(Dest, Source: Pointer; Count: cardinal);
begin
  ShowMessage('Q_XORLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_NOTLongArr(P: Pointer; Count: cardinal);
asm
         MOV     ECX,EDX
         AND     EDX,15
         SHR     ECX,4
         JE      @@nx
         @@lp:
         NOT     DWORD PTR [EAX]
         NOT     DWORD PTR [EAX+4]
         NOT     DWORD PTR [EAX+8]
         NOT     DWORD PTR [EAX+12]
         NOT     DWORD PTR [EAX+16]
         NOT     DWORD PTR [EAX+20]
         NOT     DWORD PTR [EAX+24]
         NOT     DWORD PTR [EAX+28]
         NOT     DWORD PTR [EAX+32]
         NOT     DWORD PTR [EAX+36]
         NOT     DWORD PTR [EAX+40]
         NOT     DWORD PTR [EAX+44]
         NOT     DWORD PTR [EAX+48]
         NOT     DWORD PTR [EAX+52]
         NOT     DWORD PTR [EAX+56]
         NOT     DWORD PTR [EAX+60]
         ADD     EAX,64
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EDX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         DD      @@ku08, @@ku09, @@ku10, @@ku11
         DD      @@ku12, @@ku13, @@ku14, @@ku15
         @@ku15:
         NOT     DWORD PTR [EAX+56]
         @@ku14:
         NOT     DWORD PTR [EAX+52]
         @@ku13:
         NOT     DWORD PTR [EAX+48]
         @@ku12:
         NOT     DWORD PTR [EAX+44]
         @@ku11:
         NOT     DWORD PTR [EAX+40]
         @@ku10:
         NOT     DWORD PTR [EAX+36]
         @@ku09:
         NOT     DWORD PTR [EAX+32]
         @@ku08:
         NOT     DWORD PTR [EAX+28]
         @@ku07:
         NOT     DWORD PTR [EAX+24]
         @@ku06:
         NOT     DWORD PTR [EAX+20]
         @@ku05:
         NOT     DWORD PTR [EAX+16]
         @@ku04:
         NOT     DWORD PTR [EAX+12]
         @@ku03:
         NOT     DWORD PTR [EAX+8]
         @@ku02:
         NOT     DWORD PTR [EAX+4]
         @@ku01:
         NOT     DWORD PTR [EAX]
         @@ku00:
end;
{$ELSE}

procedure Q_NOTLongArr(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_NOTLongArr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_ANDNOTLongs(Dest, Source: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,ECX
         AND     EBX,7
         SHR     ECX,3
         JE      @@nx
         @@lp:
         MOV     ESI,[EDX]
         NOT     ESI
         AND     [EAX],ESI
         MOV     ESI,[EDX+4]
         NOT     ESI
         AND     [EAX+4],ESI
         MOV     ESI,[EDX+8]
         NOT     ESI
         AND     [EAX+8],ESI
         MOV     ESI,[EDX+12]
         NOT     ESI
         AND     [EAX+12],ESI
         MOV     ESI,[EDX+16]
         NOT     ESI
         AND     [EAX+16],ESI
         MOV     ESI,[EDX+20]
         NOT     ESI
         AND     [EAX+20],ESI
         MOV     ESI,[EDX+24]
         NOT     ESI
         AND     [EAX+24],ESI
         MOV     ESI,[EDX+28]
         NOT     ESI
         AND     [EAX+28],ESI
         ADD     EDX,32
         ADD     EAX,32
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EBX*4]
         @@kV:
         DD      @@ku00, @@ku01, @@ku02, @@ku03
         DD      @@ku04, @@ku05, @@ku06, @@ku07
         @@ku07:
         MOV     ESI,[EDX+24]
         NOT     ESI
         AND     [EAX+24],ESI
         @@ku06:
         MOV     ESI,[EDX+20]
         NOT     ESI
         AND     [EAX+20],ESI
         @@ku05:
         MOV     ESI,[EDX+16]
         NOT     ESI
         AND     [EAX+16],ESI
         @@ku04:
         MOV     ESI,[EDX+12]
         NOT     ESI
         AND     [EAX+12],ESI
         @@ku03:
         MOV     ESI,[EDX+8]
         NOT     ESI
         AND     [EAX+8],ESI
         @@ku02:
         MOV     ESI,[EDX+4]
         NOT     ESI
         AND     [EAX+4],ESI
         @@ku01:
         MOV     ESI,[EDX]
         NOT     ESI
         AND     [EAX],ESI
         @@ku00:
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_ANDNOTLongs(Dest, Source: Pointer; Count: cardinal);
begin
  ShowMessage('Q_ANDNOTLongs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_LShift1Longs(P: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         LEA     EBX,[EAX+EDX*4-8]
         DEC     EDX
         JS      @@qt
         MOV     ESI,[EBX+4]
         MOV     ECX,EDX
         AND     EDX,3
         SHL     ESI,1
         SHR     ECX,2
         JE      @@nx
         @@lp:
         MOV     EAX,[EBX]
         SHL     EAX,1
         ADC     ESI,0
         MOV     [EBX+4],ESI
         MOV     ESI,[EBX-4]
         SHL     ESI,1
         ADC     EAX,0
         MOV     [EBX],EAX
         MOV     EAX,[EBX-8]
         SHL     EAX,1
         ADC     ESI,0
         MOV     [EBX-4],ESI
         MOV     ESI,[EBX-12]
         SHL     ESI,1
         ADC     EAX,0
         MOV     [EBX-8],EAX
         SUB     EBX,16
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EDX*4]
         @@kV:
         DD      @@mv0, @@mv1, @@mv2, @@mv3
         @@mv3:
         MOV     EAX,[EBX]
         SHL     EAX,1
         ADC     ESI,0
         MOV     [EBX+4],ESI
         MOV     ESI,[EBX-4]
         SHL     ESI,1
         ADC     EAX,0
         MOV     [EBX],EAX
         SHL     DWORD PTR [EBX-8],1
         ADC     ESI,0
         MOV     [EBX-4],ESI
         @@qt:
         POP     ESI
         POP     EBX
         RET
         @@mv2:
         MOV     EAX,[EBX]
         SHL     EAX,1
         ADC     ESI,0
         MOV     [EBX+4],ESI
         SHL     DWORD PTR [EBX-4],1
         ADC     EAX,0
         MOV     [EBX],EAX
         POP     ESI
         POP     EBX
         RET
         @@mv1:
         SHL     DWORD PTR [EBX],1
         ADC     ESI,0
         @@mv0:
         MOV     [EBX+4],ESI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_LShift1Longs(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_LShift1Longs TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RShift1Longs(P: Pointer; Count: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         LEA     EAX,[EAX+EDX*4-4]
         XOR     EBX,EBX
         MOV     ECX,EDX
         AND     EDX,3
         SHR     ECX,2
         JE      @@nx
         @@lp:
         MOV     ESI,[EAX]
         SHR     EBX,1
         RCR     ESI,1
         MOV     [EAX],ESI
         MOV     ESI,[EAX-4]
         RCR     ESI,1
         MOV     [EAX-4],ESI
         MOV     ESI,[EAX-8]
         RCR     ESI,1
         MOV     [EAX-8],ESI
         MOV     ESI,[EAX-12]
         RCR     ESI,1
         MOV     [EAX-12],ESI
         ADC     EBX,0
         SUB     EAX,16
         DEC     ECX
         JNE     @@lp
         @@nx:
         JMP     DWORD PTR @@kV[EDX*4]
         @@kV:
         DD      @@mv0, @@mv1, @@mv2, @@mv3
         @@mv0:
         POP     ESI
         POP     EBX
         RET
         @@mv1:
         MOV     ESI,[EAX]
         SHR     EBX,1
         RCR     ESI,1
         MOV     [EAX],ESI
         POP     ESI
         POP     EBX
         RET
         @@mv2:
         MOV     ESI,[EAX]
         SHR     EBX,1
         RCR     ESI,1
         MOV     [EAX],ESI
         MOV     ESI,[EAX-4]
         RCR     ESI,1
         MOV     [EAX-4],ESI
         POP     ESI
         POP     EBX
         RET
         @@mv3:
         MOV     ESI,[EAX]
         SHR     EBX,1
         RCR     ESI,1
         MOV     [EAX],ESI
         MOV     ESI,[EAX-4]
         RCR     ESI,1
         MOV     [EAX-4],ESI
         MOV     ESI,[EAX-8]
         RCR     ESI,1
         MOV     [EAX-8],ESI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RShift1Longs(P: Pointer; Count: cardinal);
begin
  ShowMessage('Q_RShift1Longs TODO');
end;

{$ENDIF}

const
  RevBits: array[0..255] of byte =
    ($00, $80, $40, $C0, $20, $A0, $60, $E0, $10, $90, $50, $D0, $30, $B0, $70, $F0,
    $08, $88, $48, $C8, $28, $A8, $68, $E8, $18, $98, $58, $D8, $38, $B8, $78, $F8,
    $04, $84, $44, $C4, $24, $A4, $64, $E4, $14, $94, $54, $D4, $34, $B4, $74, $F4,
    $0C, $8C, $4C, $CC, $2C, $AC, $6C, $EC, $1C, $9C, $5C, $DC, $3C, $BC, $7C, $FC,
    $02, $82, $42, $C2, $22, $A2, $62, $E2, $12, $92, $52, $D2, $32, $B2, $72, $F2,
    $0A, $8A, $4A, $CA, $2A, $AA, $6A, $EA, $1A, $9A, $5A, $DA, $3A, $BA, $7A, $FA,
    $06, $86, $46, $C6, $26, $A6, $66, $E6, $16, $96, $56, $D6, $36, $B6, $76, $F6,
    $0E, $8E, $4E, $CE, $2E, $AE, $6E, $EE, $1E, $9E, $5E, $DE, $3E, $BE, $7E, $FE,
    $01, $81, $41, $C1, $21, $A1, $61, $E1, $11, $91, $51, $D1, $31, $B1, $71, $F1,
    $09, $89, $49, $C9, $29, $A9, $69, $E9, $19, $99, $59, $D9, $39, $B9, $79, $F9,
    $05, $85, $45, $C5, $25, $A5, $65, $E5, $15, $95, $55, $D5, $35, $B5, $75, $F5,
    $0D, $8D, $4D, $CD, $2D, $AD, $6D, $ED, $1D, $9D, $5D, $DD, $3D, $BD, $7D, $FD,
    $03, $83, $43, $C3, $23, $A3, $63, $E3, $13, $93, $53, $D3, $33, $B3, $73, $F3,
    $0B, $8B, $4B, $CB, $2B, $AB, $6B, $EB, $1B, $9B, $5B, $DB, $3B, $BB, $7B, $FB,
    $07, $87, $47, $C7, $27, $A7, $67, $E7, $17, $97, $57, $D7, $37, $B7, $77, $F7,
    $0F, $8F, $4F, $CF, $2F, $AF, $6F, $EF, $1F, $9F, $5F, $DF, $3F, $BF, $7F, $FF);

{$IFDEF CPU32}
procedure Q_ReverseBits(P: Pointer; BitCount: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,EDX
         PUSH    EDI
         SHR     EBX,3
         AND     EDX,$7
         JE      @@nx1
         INC     EBX
         MOV     ECX,$8
         MOV     EDI,EAX
         PUSH    EAX
         SUB     ECX,EDX
         XOR     EDX,EDX
         PUSH    EBX
         @@lp1:
         MOVZX   EAX,BYTE PTR [EDI]
         SHL     EAX,CL
         OR      EAX,EDX
         MOV     BYTE PTR [EDI],AL
         MOVZX   EDX,AH
         INC     EDI
         DEC     EBX
         JNE     @@lp1
         POP     EBX
         POP     EAX
         @@nx1:
         LEA     ECX,[EAX+EBX-1]
         @@lp2:
         CMP     EAX,ECX
         JGE     @@qt
         MOVZX   ESI,BYTE PTR [EAX]
         MOVZX   EDI,BYTE PTR [ECX]
         MOV     DH,BYTE PTR [ESI+RevBits]
         MOV     BYTE PTR [ECX],DH
         MOV     DL,BYTE PTR [EDI+RevBits]
         MOV     BYTE PTR [EAX],DL
         INC     EAX
         DEC     ECX
         JMP     @@lp2
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_ReverseBits(P: Pointer; BitCount: cardinal);
begin
  ShowMessage('Q_ReverseBits TODO');
end;

{$ENDIF}

function Q_Lrot32(D: longword; Shift: byte): longword;
asm
         MOV     CL,DL
         ROL     EAX,CL
end;

function Q_Rrot32(D: longword; Shift: byte): longword;
asm
         MOV     CL,DL
         ROR     EAX,CL
end;

function Q_Lrot16(W: word; Shift: byte): word;
asm
         MOV     CL,DL
         ROL     AX,CL
end;

function Q_Rrot16(W: word; Shift: byte): word;
asm
         MOV     CL,DL
         ROR     AX,CL
end;

function Q_Lrot8(B, Shift: byte): byte;
asm
         MOV     CL,DL
         ROL     AL,CL
end;

function Q_Rrot8(B, Shift: byte): byte;
asm
         MOV     CL,DL
         ROR     AL,CL
end;

procedure Q_RotateLongsLeft(P: Pointer; Count: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROL     DWORD PTR [EAX+EDX*4],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_RotateLongsRight(P: Pointer; Count: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROR     DWORD PTR [EAX+EDX*4],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_RotateWordsLeft(P: Pointer; Count: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROL     WORD PTR [EAX+EDX*2],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_RotateWordsRight(P: Pointer; Count: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROR     WORD PTR [EAX+EDX*2],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_RotateBytesLeft(P: Pointer; L: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROL     BYTE PTR [EAX+EDX],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_RotateBytesRight(P: Pointer; L: cardinal; Shift: byte);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         ROR     BYTE PTR [EAX+EDX],CL
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

{$IFDEF CPU32}
procedure IntRotateBitsLeft(P: Pointer; L: cardinal; Shift: byte);
asm
         TEST    EDX,EDX
         JE      @@qt
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EDI
         MOV     EBX,EDX
         MOV     EDI,EAX
         MOVZX   EDX,BYTE PTR [EDI+EBX-1]
         SHL     EDX,CL
         MOV     AL,DH
         @@lp:
         MOVZX   EDX,BYTE PTR [EDI]
         SHL     EDX,CL
         OR      DL,AL
         MOV     AL,DH
         MOV     BYTE PTR [EDI],DL
         INC     EDI
         DEC     EBX
         JNE     @@lp
         POP     EDI
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure IntRotateBitsLeft(P: Pointer; L: cardinal; Shift: byte);
begin
  ShowMessage('IntRotateBitsLeft TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntRotateBitsRight(P: Pointer; L: cardinal; Shift: byte);
asm
         TEST    EDX,EDX
         JE      @@qt
         TEST    ECX,ECX
         JE      @@qt
         DEC     EDX
         JE      @@ob
         PUSH    EDI
         PUSH    EBX
         MOV     EDI,EAX
         MOV     EBX,EDX
         XOR     EAX,EAX
         MOV     AH,BYTE PTR [EDI]
         SHR     EAX,CL
         MOV     BYTE PTR [EDI],AH
         MOV     DL,AL
         @@lp:
         XOR     EAX,EAX
         MOV     AH,BYTE PTR [EDI+EBX]
         SHR     EAX,CL
         OR      AH,DL
         MOV     DL,AL
         MOV     BYTE PTR [EDI+EBX],AH
         DEC     EBX
         JNE     @@lp
         OR      DL,BYTE PTR [EDI]
         MOV     BYTE PTR [EDI],DL
         POP     EBX
         POP     EDI
         RET
         @@ob:
         ROR     BYTE PTR [EAX],CL
         @@qt:
end;
{$ELSE}

procedure IntRotateBitsRight(P: Pointer; L: cardinal; Shift: byte);
begin
  ShowMessage('IntRotateBitsRight TODO');
end;

{$ENDIF}

procedure IntBtRtLeft(P: Pointer; L, Shift: integer);
begin
  if Shift <= 4 then
    IntShortRtRight(P, Shift, L)
  else if Shift <= 256 then
    IntMediumRtRight(P, Shift, L)
  else
    IntLongRotateStr(P, L - Shift, L);
end;

procedure IntBtRtRight(P: Pointer; L, Shift: integer);
begin
  if Shift <= 4 then
    IntShortRtLeft(P, Shift, L)
  else if Shift <= 256 then
    IntMediumRtLeft(P, Shift, L)
  else
    IntLongRotateStr(P, Shift, L);
end;

procedure Q_RotateBitsLeft(P: Pointer; L: cardinal; Shift: integer);
var
  BL, SS: integer;
begin
  if integer(L) > 0 then
  begin
    BL := L shl 3;
    Shift := Shift mod BL;
    if Shift < 0 then
      Inc(Shift, BL);
    SS := Shift shr 3;
    if SS > 0 then
    begin
      if SS <= integer(L) shr 1 then
        IntBtRtLeft(P, L, SS)
      else
        IntBtRtRight(P, L, integer(L) - SS);
    end;
    IntRotateBitsLeft(P, L, Shift and 7);
  end;
end;

procedure Q_RotateBitsRight(P: Pointer; L: cardinal; Shift: integer);
var
  BL, SS: integer;
begin
  if integer(L) <> 0 then
  begin
    BL := L shl 3;
    Shift := Shift mod BL;
    if Shift < 0 then
      Inc(Shift, BL);
    SS := Shift shr 3;
    if SS > 0 then
    begin
      if SS <= integer(L) shr 1 then
        IntBtRtRight(P, L, SS)
      else
        IntBtRtLeft(P, L, integer(L) - SS);
    end;
    IntRotateBitsRight(P, L, Shift and 7);
  end;
end;


{ Криптографические функции. }

{$IFDEF CPU32}
procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: ansichar); overload;
asm
         PUSH    EBX
         MOV     EBX,EAX
         MOVZX   EAX,CL
         @@lp1:
         TEST    EBX,3
         JE      @@nx1
         DEC     EDX
         JS      @@qt
         XOR     BYTE PTR [EBX],CL
         INC     EBX
         JMP     @@lp1
         @@nx1:
         MOV     ECX,EAX
         SHL     EAX,8
         ADD     EAX,ECX
         MOV     ECX,EAX
         SHL     EAX,16
         ADD     EAX,ECX
         MOV     ECX,EDX
         AND     EDX,7
         SHR     ECX,3
         JE      @@nx2
         @@lp2:
         XOR     [EBX],EAX
         XOR     [EBX+4],EAX
         ADD     EBX,8
         DEC     ECX
         JNE     @@lp2
         @@nx2:
         DEC     EDX
         JS      @@qt
         XOR     BYTE PTR [EBX+EDX],AL
         JMP     @@nx2
         @@qt:
         POP     EBX
end;
{$ELSE}

procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: ansichar); overload;
begin
  ShowMessage('Q_XORByChar TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: byte); overload;
asm
         PUSH    EBX
         MOV     EBX,EAX
         MOVZX   EAX,CL
         @@lp1:
         TEST    EBX,3
         JE      @@nx1
         DEC     EDX
         JS      @@qt
         XOR     BYTE PTR [EBX],CL
         INC     EBX
         JMP     @@lp1
         @@nx1:
         MOV     ECX,EAX
         SHL     EAX,8
         ADD     EAX,ECX
         MOV     ECX,EAX
         SHL     EAX,16
         ADD     EAX,ECX
         MOV     ECX,EDX
         AND     EDX,7
         SHR     ECX,3
         JE      @@nx2
         @@lp2:
         XOR     [EBX],EAX
         XOR     [EBX+4],EAX
         ADD     EBX,8
         DEC     ECX
         JNE     @@lp2
         @@nx2:
         DEC     EDX
         JS      @@qt
         XOR     BYTE PTR [EBX+EDX],AL
         JMP     @@nx2
         @@qt:
         POP     EBX
end;
{$ELSE}

procedure Q_XORByChar(P: Pointer; L: cardinal; Ch: byte); overload;
begin
  ShowMessage('Q_XORByChar TODO');
end;

{$ENDIF}

procedure Q_XORByLong(P: Pointer; Count: cardinal; D: longword);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         XOR     DWORD PTR [EAX+EDX*4],ECX
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

procedure Q_XORByWord(P: Pointer; Count: cardinal; W: word);
asm
         DEC     EDX
         JS      @@qt
         @@lp:
         XOR     WORD PTR [EAX+EDX*2],CX
         DEC     EDX
         JNS     @@lp
         @@qt:
end;

{$IFDEF CPU32}
procedure Q_XORByStr(P: Pointer; L: cardinal; const Key: String);
asm
         TEST    EDX,EDX
         JE      @@qt
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,[ECX-4]
         TEST    EBX,EBX
         JE      @@qt1
         LEA     EDI,[EAX-1]
         LEA     ESI,[ECX-1]
         @@lp1:
         CMP     EDX,EBX
         JL      @@ls
         MOV     ECX,EBX
         @@lp2:
         MOV     AL,BYTE PTR [ESI+ECX]
         XOR     BYTE PTR [EDI+ECX],AL
         DEC     ECX
         JNE     @@lp2
         ADD     EDI,EBX
         SUB     EDX,EBX
         JNE     @@lp1
         @@qt1:
         POP     EDI
         POP     ESI
         POP     EBX
         @@qt:
         RET
         @@ls:
         MOV     ECX,EDX
         MOV     EBX,EDX
         JMP     @@lp2
end;
{$ELSE}

procedure Q_XORByStr(P: Pointer; L: cardinal; const Key: String);
begin
  ShowMessage('Q_XORByStr TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_XORByRandom(P: Pointer; L: cardinal; Seed: longword);
asm
         PUSH    ESI
         DEC     EDX
         JS      @@qt
         MOV     ESI,$8088405
         PUSH    EBX
         @@lp:
         IMUL    ECX,ESI
         INC     ECX
         MOV     EBX,ECX
         SHR     EBX,24
         XOR     BYTE PTR [EAX+EDX],BL
         DEC     EDX
         JNS     @@lp
         POP     EBX
         @@qt:
         POP     ESI
end;
{$ELSE}

procedure Q_XORByRandom(P: Pointer; L: cardinal; Seed: longword);
begin
  ShowMessage('Q_XORByRandom TODO');
end;

{$ENDIF}

type
  PRC4Data = ^TRC4Data;

  TRC4Data = record
    State: array[0..255] of byte;
    X, Y: byte;
  end;

{$IFDEF CPU32}
procedure IntRC4Init(PSt, Key: Pointer; KeyLen: cardinal);
asm
         PUSH    EBX
         PUSH    EDI
         MOV     EBX,$03020100
         PUSH    ESI
         MOV     EDI,EAX
         MOV     ESI,8
         @@lp1:
         MOV     [EAX],EBX
         ADD     EBX,$04040404
         MOV     [EAX+4],EBX
         ADD     EBX,$04040404
         MOV     [EAX+8],EBX
         ADD     EBX,$04040404
         MOV     [EAX+12],EBX
         ADD     EBX,$04040404
         MOV     [EAX+16],EBX
         ADD     EBX,$04040404
         MOV     [EAX+20],EBX
         ADD     EBX,$04040404
         MOV     [EAX+24],EBX
         ADD     EBX,$04040404
         MOV     [EAX+28],EBX
         ADD     EBX,$04040404
         ADD     EAX,32
         DEC     ESI
         JNE     @@lp1
         DEC     ECX
         JS      @@qt
         PUSH    EBP
         XOR     EAX,EAX
         MOV     EBP,$100
         PUSH    EDX
         PUSH    ECX
         @@lp2:
         MOV     BL,BYTE PTR [EDI+ESI]
         ADD     AL,BYTE PTR [EDX]
         ADD     AL,BL
         MOVZX   EAX,AL
         MOV     BH,BYTE PTR [EDI+EAX]
         MOV     BYTE PTR [EDI+EAX],BL
         MOV     BYTE PTR [EDI+ESI],BH
         INC     EDX
         DEC     ECX
         JS      @@me
         INC     ESI
         DEC     EBP
         JNE     @@lp2
         @@nx:
         MOV     [ESP],EBP
         POP     ECX
         POP     ECX
         POP     EBP
         @@qt:
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@me:
         MOV     ECX,[ESP]
         MOV     EDX,[ESP+4]
         INC     ESI
         DEC     EBP
         JNE     @@lp2
         JMP     @@nx
end;
{$ELSE}

procedure IntRC4Init(PSt, Key: Pointer; KeyLen: cardinal);
begin
  ShowMessage('IntRC4Init TODO');
end;

{$ENDIF}

procedure Q_RC4Init(var ID: TRC4ID; Key: Pointer; KeyLen: cardinal);
begin
  GetMem(PRC4Data(ID), SizeOf(TRC4Data));
  with PRC4Data(ID)^ do
  begin
    IntRC4Init(@State, Key, KeyLen);
    X := 0;
    Y := 0;
  end;
end;

{$IFDEF CPU32}
procedure Q_RC4Apply(ID: TRC4ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EDI
         LEA     ESI,[EDX-1]
         PUSH    EAX
         XOR     EBX,EBX
         MOV     BL,BYTE PTR [EAX+256]
         MOV     EDI,EAX
         XOR     EDX,EDX
         MOV     DL,BYTE PTR [EAX+257]
         @@lp:
         INC     EBX
         AND     EBX,$FF
         MOVZX   EAX,BYTE PTR [EDI+EBX]
         ADD     EDX,EAX
         AND     EDX,$FF
         MOV     AH,BYTE PTR [EDI+EDX]
         MOV     BYTE PTR [EDI+EDX],AL
         ADD     AL,AH
         INC     ESI
         MOV     BYTE PTR [EDI+EBX],AH
         MOVZX   EAX,AL
         MOV     AL,BYTE PTR [EDI+EAX]
         XOR     BYTE PTR [ESI],AL
         DEC     ECX
         JNE     @@lp
         POP     EAX
         MOV     [EAX+256],BL
         MOV     [EAX+257],DL
         POP     EDI
         @@qt:
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RC4Apply(ID: TRC4ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC4Apply TODO');
end;

{$ENDIF}

procedure IntRC4Clear(ID: TRC4ID);
asm
         XOR     EDX,EDX
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         MOV     WORD PTR [EAX+128],DX
end;

procedure Q_RC4Done(ID: TRC4ID);
begin
  IntRC4Clear(ID);
  FreeMem(PRC4Data(ID));
end;

function Q_RC4SelfTest: boolean;
const
  PlainText: String = 'DCEE4CF92C';
  UserKey: String = '618A63D2FB';
  CipherText: String = 'F13829C9DE';
var
  ID: TRC4ID;
  S, K: String;
begin
  S := Q_CodesToStr(PlainText);
  K := Q_CodesToStr(UserKey);
  Q_RC4Init(ID, Pointer(K), Length(K));
  Q_RC4Apply(ID, Pointer(S), Length(S));
  Q_RC4Done(ID);
  if not Q_SameStr(Q_StrToCodes(S), CipherText) then
  begin
    Result := False;
    Exit;
  end;
  Q_RC4Init(ID, Pointer(K), Length(K));
  Q_RC4Apply(ID, Pointer(S), Length(S));
  Q_RC4Done(ID);
  Result := Q_SameStr(Q_StrToCodes(S), PlainText);
end;

type
  PRC6Data = ^TRC6Data;

  TRC6Data = record
    Vec: TRC6InitVector;
    KeyData: array[0..43] of longword;
  end;

const
  RC6_IndShift: array[0..43] of longword =
    (4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100,
    104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144, 148, 152, 156, 160, 164, 168, 172, 0);

{$IFDEF CPU32}
procedure IntRC6Init(ID: TRC6ID; Key: Pointer; KeyLen: cardinal);
asm
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         XOR     EBP,EBP
         PUSH    EDI
         MOV     [EAX],EBP
         MOV     [EAX+4],EBP
         MOV     [EAX+8],EBP
         MOV     [EAX+12],EBP
         LEA     EBX,[EAX+16]
         TEST    ECX,ECX
         JE      @@mz
         SUB     ESP,$100
         MOV     ESI,ECX
         MOV     EBP,ECX
         MOV     EDI,ESP
         SHR     ESI,2
         MOV     EAX,ESI
         JE      @@nnx
         @@ff:
         MOV     ECX,[EDX+ESI*4-4]
         MOV     [EDI+ESI*4-4],ECX
         DEC     ESI
         JNE     @@ff
         @@nnx:
         AND     EBP,3
         XOR     ECX,ECX
         JMP     DWORD PTR @@tV[EBP*4]
         @@tV:
         DD      @@pe, @@t1, @@t2, @@t3
         @@t3:
         MOVZX   ECX,BYTE PTR [EDX+EAX*4+2]
         @@t2:
         SHL     ECX,8
         MOVZX   EBP,BYTE PTR [EDX+EAX*4+1]
         OR      ECX,EBP
         @@t1:
         SHL     ECX,8
         MOVZX   EBP,BYTE PTR [EDX+EAX*4]
         OR      ECX,EBP
         MOV     [EDI+EAX*4],ECX
         INC     EAX
         @@pe:
         MOV     ESI,EBX
         MOV     ECX,11
         MOV     EDX,$B7E15163
         @@lp1:
         MOV     [ESI],EDX
         ADD     EDX,$9E3779B9
         MOV     [ESI+4],EDX
         ADD     EDX,$9E3779B9
         MOV     [ESI+8],EDX
         ADD     EDX,$9E3779B9
         MOV     [ESI+12],EDX
         ADD     EDX,$9E3779B9
         ADD     ESI,16
         DEC     ECX
         JNE     @@lp1
         CMP     EAX,44
         JA      @@me
         MOV     EBP,132
         SHL     EAX,2
         @@nx:
         ADD     EAX,EDI
         PUSH    EAX
         XOR     EAX,EAX
         PUSH    EAX
         PUSH    EAX
         MOV     ESI,ESP
         @@lp2:
         MOV     ECX,[EBX+EAX]
         ADD     ECX,[ESI]
         ADD     ECX,[ESI+4]
         ROL     ECX,3
         MOV     [ESI+4],ECX
         MOV     [EBX+EAX],ECX
         ADD     ECX,[ESI]
         MOV     EDX,ECX
         ADD     EDX,[EDI]
         ROL     EDX,CL
         MOV     [EDI],EDX
         MOV     [ESI],EDX
         MOV     EAX,DWORD PTR [EAX+RC6_IndShift]
         ADD     EDI,4
         CMP     EDI,[ESI+8]
         JE      @@jx
         @@nj:
         DEC     EBP
         JNE     @@lp2
         MOV     EAX,ESP
         XOR     EDX,EDX
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         ADD     EAX,12
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         ADD     ESP,$10C
         @@k2:
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         RET
         @@me:
         MOV     EBP,EAX
         ADD     EBP,EAX
         ADD     EBP,EAX
         JMP     @@nx
         @@jx:
         LEA     EDI,[ESP+12]
         JMP     @@nj
         @@mz:
         MOV     ECX,11
         MOV     EDX,$B7E15163
         @@lz:
         MOV     [EBX],EDX
         ADD     EDX,$9E3779B9
         MOV     [EBX+4],EDX
         ADD     EDX,$9E3779B9
         MOV     [EBX+8],EDX
         ADD     EDX,$9E3779B9
         MOV     [EBX+12],EDX
         ADD     EDX,$9E3779B9
         ADD     EBX,16
         DEC     ECX
         JNE     @@lz
         JMP     @@k2
end;
{$ELSE}

procedure IntRC6Init(ID: TRC6ID; Key: Pointer; KeyLen: cardinal);
begin
  ShowMessage('IntRC6Init TODO');
end;

{$ENDIF}

procedure Q_RC6Init(var ID: TRC6ID; Key: Pointer; KeyLen: cardinal);
begin
  GetMem(PRC6Data(ID), SizeOf(TRC6Data));
  if KeyLen <= 255 then
    IntRC6Init(ID, Key, KeyLen)
  else
    IntRC6Init(ID, Key, 255);
end;

{$IFDEF CPU32}
procedure IntRC6EncryptECB(ID: TRC6ID; P: Pointer);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         LEA     EBX,[EAX+24]
         PUSH    EBP
         MOV     ESI,[EDX]
         PUSH    EDX
         MOV     EDI,[EDX+4]
         MOV     EBP,[EDX+12]
         ADD     EDI,[EBX-8]
         ADD     EBP,[EBX-4]
         MOV     EDX,[EDX+8]
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         ROL     EAX,5
         XOR     ESI,EAX
         IMUL    ECX,EBP
         ROL     ECX,5
         XOR     EDX,ECX
         ROL     ESI,CL
         MOV     ECX,EAX
         ROL     EDX,CL
         ADD     ESI,[EBX]
         ADD     EDX,[EBX+4]
         LEA     ECX,[ESI+ESI+1]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         ROL     EAX,5
         XOR     EDI,EAX
         IMUL    ECX,ESI
         ROL     ECX,5
         XOR     EBP,ECX
         ROL     EDI,CL
         MOV     ECX,EAX
         ROL     EBP,CL
         ADD     EDI,[EBX+8]
         ADD     EBP,[EBX+12]
         LEA     ECX,[EDI+EDI+1]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         XOR     EDX,EAX
         IMUL    ECX,EDI
         ROL     ECX,5
         XOR     ESI,ECX
         ROL     EDX,CL
         MOV     ECX,EAX
         ROL     ESI,CL
         ADD     EDX,[EBX+16]
         ADD     ESI,[EBX+20]
         LEA     ECX,[EDX+EDX+1]
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         XOR     EBP,EAX
         IMUL    ECX,EDX
         ROL     ECX,5
         XOR     EDI,ECX
         ROL     EBP,CL
         MOV     ECX,EAX
         ROL     EDI,CL
         ADD     EBP,[EBX+24]
         ADD     EDI,[EBX+28]
         LEA     ECX,[EBP+EBP+1]
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         ROL     EAX,5
         XOR     ESI,EAX
         IMUL    ECX,EBP
         ROL     ECX,5
         XOR     EDX,ECX
         ROL     ESI,CL
         ADD     ESI,[EBX+32]
         MOV     ECX,EAX
         ROL     EDX,CL
         ADD     EDX,[EBX+36]
         LEA     ECX,[ESI+ESI+1]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         ROL     EAX,5
         XOR     EDI,EAX
         IMUL    ECX,ESI
         ROL     ECX,5
         XOR     EBP,ECX
         ROL     EDI,CL
         MOV     ECX,EAX
         ROL     EBP,CL
         ADD     EDI,[EBX+40]
         ADD     EBP,[EBX+44]
         LEA     ECX,[EDI+EDI+1]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         XOR     EDX,EAX
         IMUL    ECX,EDI
         ROL     ECX,5
         XOR     ESI,ECX
         ROL     EDX,CL
         MOV     ECX,EAX
         ROL     ESI,CL
         ADD     EDX,[EBX+48]
         ADD     ESI,[EBX+52]
         LEA     ECX,[EDX+EDX+1]
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         XOR     EBP,EAX
         IMUL    ECX,EDX
         ROL     ECX,5
         XOR     EDI,ECX
         ROL     EBP,CL
         MOV     ECX,EAX
         ROL     EDI,CL
         ADD     EBP,[EBX+56]
         ADD     EDI,[EBX+60]
         LEA     ECX,[EBP+EBP+1]
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         ROL     EAX,5
         XOR     ESI,EAX
         IMUL    ECX,EBP
         ROL     ECX,5
         XOR     EDX,ECX
         ROL     ESI,CL
         MOV     ECX,EAX
         ROL     EDX,CL
         ADD     ESI,[EBX+64]
         ADD     EDX,[EBX+68]
         LEA     ECX,[ESI+ESI+1]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         ROL     EAX,5
         XOR     EDI,EAX
         IMUL    ECX,ESI
         ROL     ECX,5
         XOR     EBP,ECX
         ROL     EDI,CL
         MOV     ECX,EAX
         ROL     EBP,CL
         ADD     EDI,[EBX+72]
         ADD     EBP,[EBX+76]
         LEA     ECX,[EDI+EDI+1]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         XOR     EDX,EAX
         IMUL    ECX,EDI
         ROL     ECX,5
         XOR     ESI,ECX
         ROL     EDX,CL
         MOV     ECX,EAX
         ROL     ESI,CL
         ADD     EDX,[EBX+80]
         ADD     ESI,[EBX+84]
         LEA     ECX,[EDX+EDX+1]
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         XOR     EBP,EAX
         IMUL    ECX,EDX
         ROL     ECX,5
         XOR     EDI,ECX
         ROL     EBP,CL
         MOV     ECX,EAX
         ROL     EDI,CL
         ADD     EBP,[EBX+88]
         ADD     EDI,[EBX+92]
         LEA     ECX,[EBP+EBP+1]
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         ROL     EAX,5
         XOR     ESI,EAX
         IMUL    ECX,EBP
         ROL     ECX,5
         XOR     EDX,ECX
         ROL     ESI,CL
         MOV     ECX,EAX
         ROL     EDX,CL
         ADD     ESI,[EBX+96]
         ADD     EDX,[EBX+100]
         LEA     ECX,[ESI+ESI+1]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         ROL     EAX,5
         XOR     EDI,EAX
         IMUL    ECX,ESI
         ROL     ECX,5
         XOR     EBP,ECX
         ROL     EDI,CL
         MOV     ECX,EAX
         ROL     EBP,CL
         ADD     EDI,[EBX+104]
         ADD     EBP,[EBX+108]
         LEA     ECX,[EDI+EDI+1]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         XOR     EDX,EAX
         IMUL    ECX,EDI
         ROL     ECX,5
         XOR     ESI,ECX
         ROL     EDX,CL
         MOV     ECX,EAX
         ROL     ESI,CL
         ADD     EDX,[EBX+112]
         ADD     ESI,[EBX+116]
         LEA     ECX,[EDX+EDX+1]
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         XOR     EBP,EAX
         IMUL    ECX,EDX
         ROL     ECX,5
         XOR     EDI,ECX
         ROL     EBP,CL
         MOV     ECX,EAX
         ROL     EDI,CL
         ADD     EBP,[EBX+120]
         ADD     EDI,[EBX+124]
         LEA     ECX,[EBP+EBP+1]
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         ROL     EAX,5
         XOR     ESI,EAX
         IMUL    ECX,EBP
         ROL     ECX,5
         XOR     EDX,ECX
         ROL     ESI,CL
         MOV     ECX,EAX
         ROL     EDX,CL
         ADD     ESI,[EBX+128]
         ADD     EDX,[EBX+132]
         LEA     ECX,[ESI+ESI+1]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         ROL     EAX,5
         XOR     EDI,EAX
         IMUL    ECX,ESI
         ROL     ECX,5
         XOR     EBP,ECX
         ROL     EDI,CL
         MOV     ECX,EAX
         ROL     EBP,CL
         ADD     EDI,[EBX+136]
         ADD     EBP,[EBX+140]
         LEA     ECX,[EDI+EDI+1]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         XOR     EDX,EAX
         IMUL    ECX,EDI
         ROL     ECX,5
         XOR     ESI,ECX
         ROL     EDX,CL
         MOV     ECX,EAX
         ROL     ESI,CL
         ADD     EDX,[EBX+144]
         ADD     ESI,[EBX+148]
         LEA     ECX,[EDX+EDX+1]
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         XOR     EBP,EAX
         IMUL    ECX,EDX
         ROL     ECX,5
         XOR     EDI,ECX
         ROL     EBP,CL
         MOV     ECX,EAX
         ROL     EDI,CL
         ADD     EBP,[EBX+152]
         ADD     EDI,[EBX+156]
         POP     ECX
         ADD     ESI,[EBX+160]
         ADD     EDX,[EBX+164]
         MOV     [ECX+12],EBP
         MOV     [ECX],ESI
         POP     EBP
         MOV     [ECX+4],EDI
         MOV     [ECX+8],EDX
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure IntRC6EncryptECB(ID: TRC6ID; P: Pointer);
begin
  ShowMessage('IntRC6EncryptEC TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntRC6DecryptECB(ID: TRC6ID; P: Pointer);
asm
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         LEA     EBX,[EAX+24]
         MOV     ESI,[EDX+12]
         PUSH    EDI
         MOV     EBP,[EDX+8]
         MOV     EDI,[EDX]
         PUSH    EDX
         SUB     EBP,[EBX+164]
         SUB     EDI,[EBX+160]
         PUSH    ECX
         MOV     EDX,[EDX+4]
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         LEA     ECX,[EDI+EDI+1]
         IMUL    ECX,EDI
         SUB     EDX,[EBX+156]
         ROL     EAX,5
         ROL     ECX,5
         SUB     ESI,[EBX+152]
         ROR     EDX,CL
         XCHG    EAX,ECX
         ROR     ESI,CL
         XOR     EDX,ECX
         XOR     ESI,EAX
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         LEA     ECX,[ESI+ESI+1]
         SUB     EDI,[EBX+148]
         IMUL    ECX,ESI
         ROL     EAX,5
         ROL     ECX,5
         SUB     EBP,[EBX+144]
         ROR     EDI,CL
         XCHG    EAX,ECX
         ROR     EBP,CL
         XOR     EDI,ECX
         XOR     EBP,EAX
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         SUB     ESI,[EBX+140]
         IMUL    ECX,EBP
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDX,[EBX+136]
         ROR     ESI,CL
         XCHG    EAX,ECX
         ROR     EDX,CL
         XOR     ESI,ECX
         XOR     EDX,EAX
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         LEA     ECX,[EDX+EDX+1]
         SUB     EBP,[EBX+132]
         IMUL    ECX,EDX
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDI,[EBX+128]
         ROR     EBP,CL
         XCHG    EAX,ECX
         ROR     EDI,CL
         XOR     EBP,ECX
         XOR     EDI,EAX
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         LEA     ECX,[EDI+EDI+1]
         SUB     EDX,[EBX+124]
         IMUL    ECX,EDI
         ROL     EAX,5
         ROL     ECX,5
         SUB     ESI,[EBX+120]
         ROR     EDX,CL
         XCHG    EAX,ECX
         ROR     ESI,CL
         XOR     EDX,ECX
         XOR     ESI,EAX
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         LEA     ECX,[ESI+ESI+1]
         SUB     EDI,[EBX+116]
         IMUL    ECX,ESI
         ROL     EAX,5
         ROL     ECX,5
         SUB     EBP,[EBX+112]
         ROR     EDI,CL
         XCHG    EAX,ECX
         ROR     EBP,CL
         XOR     EDI,ECX
         XOR     EBP,EAX
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         SUB     ESI,[EBX+108]
         IMUL    ECX,EBP
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDX,[EBX+104]
         ROR     ESI,CL
         XCHG    EAX,ECX
         ROR     EDX,CL
         XOR     ESI,ECX
         XOR     EDX,EAX
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         LEA     ECX,[EDX+EDX+1]
         SUB     EBP,[EBX+100]
         IMUL    ECX,EDX
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDI,[EBX+96]
         ROR     EBP,CL
         XCHG    EAX,ECX
         ROR     EDI,CL
         XOR     EBP,ECX
         XOR     EDI,EAX
         SUB     EDX,[EBX+92]
         SUB     ESI,[EBX+88]
         LEA     ECX,[EDI+EDI+1]
         IMUL    ECX,EDI
         ROL     ECX,5
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         ROL     EAX,5
         MOV     [ESP],ECX
         ROR     EDX,CL
         XOR     EDX,EAX
         MOV     ECX,EAX
         ROR     ESI,CL
         XOR     ESI,[ESP]
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         LEA     ECX,[ESI+ESI+1]
         SUB     EDI,[EBX+84]
         IMUL    ECX,ESI
         ROL     EAX,5
         ROL     ECX,5
         SUB     EBP,[EBX+80]
         ROR     EDI,CL
         XCHG    EAX,ECX
         ROR     EBP,CL
         XOR     EDI,ECX
         XOR     EBP,EAX
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         SUB     ESI,[EBX+76]
         IMUL    ECX,EBP
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDX,[EBX+72]
         ROR     ESI,CL
         XCHG    EAX,ECX
         ROR     EDX,CL
         XOR     ESI,ECX
         XOR     EDX,EAX
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         LEA     ECX,[EDX+EDX+1]
         SUB     EBP,[EBX+68]
         IMUL    ECX,EDX
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDI,[EBX+64]
         ROR     EBP,CL
         XCHG    EAX,ECX
         ROR     EDI,CL
         XOR     EBP,ECX
         XOR     EDI,EAX
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         LEA     ECX,[EDI+EDI+1]
         SUB     EDX,[EBX+60]
         IMUL    ECX,EDI
         ROL     EAX,5
         ROL     ECX,5
         SUB     ESI,[EBX+56]
         ROR     EDX,CL
         XCHG    EAX,ECX
         ROR     ESI,CL
         XOR     EDX,ECX
         XOR     ESI,EAX
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         LEA     ECX,[ESI+ESI+1]
         SUB     EDI,[EBX+52]
         IMUL    ECX,ESI
         ROL     EAX,5
         ROL     ECX,5
         SUB     EBP,[EBX+48]
         ROR     EDI,CL
         XCHG    EAX,ECX
         ROR     EBP,CL
         XOR     EDI,ECX
         XOR     EBP,EAX
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         SUB     ESI,[EBX+44]
         IMUL    ECX,EBP
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDX,[EBX+40]
         ROR     ESI,CL
         XCHG    EAX,ECX
         ROR     EDX,CL
         XOR     ESI,ECX
         XOR     EDX,EAX
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         LEA     ECX,[EDX+EDX+1]
         SUB     EBP,[EBX+36]
         IMUL    ECX,EDX
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDI,[EBX+32]
         ROR     EBP,CL
         XCHG    EAX,ECX
         ROR     EDI,CL
         XOR     EBP,ECX
         XOR     EDI,EAX
         LEA     EAX,[EBP+EBP+1]
         IMUL    EAX,EBP
         LEA     ECX,[EDI+EDI+1]
         SUB     EDX,[EBX+28]
         IMUL    ECX,EDI
         ROL     EAX,5
         ROL     ECX,5
         SUB     ESI,[EBX+24]
         ROR     EDX,CL
         XCHG    EAX,ECX
         ROR     ESI,CL
         XOR     EDX,ECX
         XOR     ESI,EAX
         LEA     EAX,[EDX+EDX+1]
         IMUL    EAX,EDX
         LEA     ECX,[ESI+ESI+1]
         SUB     EDI,[EBX+20]
         IMUL    ECX,ESI
         ROL     EAX,5
         ROL     ECX,5
         SUB     EBP,[EBX+16]
         ROR     EDI,CL
         XCHG    EAX,ECX
         ROR     EBP,CL
         XOR     EDI,ECX
         XOR     EBP,EAX
         LEA     EAX,[EDI+EDI+1]
         IMUL    EAX,EDI
         LEA     ECX,[EBP+EBP+1]
         SUB     ESI,[EBX+12]
         IMUL    ECX,EBP
         ROL     EAX,5
         ROL     ECX,5
         SUB     EDX,[EBX+8]
         ROR     ESI,CL
         XCHG    EAX,ECX
         ROR     EDX,CL
         XOR     ESI,ECX
         XOR     EDX,EAX
         SUB     EBP,[EBX+4]
         SUB     EDI,[EBX]
         LEA     ECX,[EDX+EDX+1]
         IMUL    ECX,EDX
         ROL     ECX,5
         LEA     EAX,[ESI+ESI+1]
         IMUL    EAX,ESI
         ROL     EAX,5
         MOV     [ESP],ECX
         ROR     EBP,CL
         XOR     EBP,EAX
         MOV     ECX,EAX
         ROR     EDI,CL
         POP     EAX
         XOR     EDI,EAX
         SUB     ESI,[EBX-4]
         SUB     EDX,[EBX-8]
         POP     ECX
         MOV     [ECX],EDI
         MOV     [ECX+4],EDX
         POP     EDI
         MOV     [ECX+12],ESI
         MOV     [ECX+8],EBP
         POP     ESI
         POP     EBP
         POP     EBX
end;
{$ELSE}

procedure IntRC6DecryptECB(ID: TRC6ID; P: Pointer);
begin
  ShowMessage('IntRC6DecryptEC TODO');
end;

{$ENDIF}

procedure Q_RC6SetOrdinaryVector(ID: TRC6ID);
asm
         XOR     EDX,EDX
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     EDX,EAX
         CALL    IntRC6EncryptECB
end;

procedure Q_RC6SetInitVector(ID: TRC6ID; const IV: TRC6InitVector);
asm
         MOV     ECX,[EDX]
         MOV     [EAX],ECX
         MOV     ECX,[EDX+4]
         MOV     [EAX+4],ECX
         MOV     ECX,[EDX+8]
         MOV     [EAX+8],ECX
         MOV     ECX,[EDX+12]
         MOV     [EAX+12],ECX
end;

{$IFDEF CPU32}
procedure Q_RC6EncryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,[EDI]
         XOR     [EBX],EAX
         MOV     EAX,[EDI+4]
         XOR     [EBX+4],EAX
         MOV     EAX,[EDI+8]
         XOR     [EBX+8],EAX
         MOV     EAX,[EDI+12]
         XOR     [EBX+12],EAX
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     EAX,[EBX]
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         XOR     AL,[EDI+2]
         MOV     [EBX+2],AL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         XOR     AL,[EDI+1]
         MOV     [EBX+1],AL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         XOR     AL,[EDI]
         MOV     [EBX],AL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RC6EncryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6EncryptCBC TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6DecryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         PUSH    ECX
         SHR     EBP,4
         JE      @@nx
         @@lp1:
         MOV     EAX,[EDI]
         MOV     [ESI],EAX
         MOV     EAX,[EDI+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EDI+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EDI+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntRC6DecryptECB
         MOV     EAX,[EBX]
         XOR     [EDI],EAX
         MOV     EAX,[EBX+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         XOR     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         XOR     [EDI+12],EAX
         MOV     EAX,[ESI]
         MOV     [EBX],EAX
         MOV     EAX,[ESI+4]
         MOV     [EBX+4],EAX
         MOV     EAX,[ESI+8]
         MOV     [EBX+8],EAX
         MOV     EAX,[ESI+12]
         MOV     [EBX+12],EAX
         ADD     EDI,$10
         DEC     EBP
         JNE     @@lp1
         @@nx:
         XOR     EDX,EDX
         POP     EBP
         MOV     [ESI],EDX
         MOV     [ESI+4],EDX
         MOV     [ESI+8],EDX
         MOV     [ESI+12],EDX
         ADD     ESP,$10
         AND     EBP,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     ECX,EBP
         SHR     EBP,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     EBP
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         MOV     DL,[EDI+2]
         XOR     AL,DL
         MOV     [EBX+2],DL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         MOV     DL,[EDI+1]
         XOR     AL,DL
         MOV     [EBX+1],DL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         MOV     DL,[EDI]
         XOR     AL,DL
         MOV     [EBX],DL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
end;
{$ELSE}

procedure Q_RC6DecryptCBC(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6DecryptCBC TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6EncryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         XOR     EAX,[EDI+4]
         MOV     [EBX+4],EAX
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         XOR     EAX,[EDI+8]
         MOV     [EBX+8],EAX
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         XOR     EAX,[EDI+12]
         MOV     [EBX+12],EAX
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         XOR     AL,[EDI+2]
         MOV     [EBX+2],AL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         XOR     AL,[EDI+1]
         MOV     [EBX+1],AL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         XOR     AL,[EDI]
         MOV     [EBX],AL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RC6EncryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6EncryptCFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6DecryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         MOV     EDX,[EDI+4]
         XOR     EAX,EDX
         MOV     [EBX+4],EDX
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     EDX,[EDI+8]
         XOR     EAX,EDX
         MOV     [EBX+8],EDX
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     EDX,[EDI+12]
         XOR     EAX,EDX
         MOV     [EBX+12],EDX
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         MOV     DL,[EDI+2]
         XOR     AL,DL
         MOV     [EBX+2],DL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         MOV     DL,[EDI+1]
         XOR     AL,DL
         MOV     [EBX+1],DL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         MOV     DL,[EDI]
         XOR     AL,DL
         MOV     [EBX],DL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RC6DecryptCFB128(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6DecryptCFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6EncryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntRC6EncryptECB
         MOV     DL,[EDI]
         XOR     DL,[ESI]
         MOV     [EDI],DL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_RC6EncryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6EncryptCFB TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6DecryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntRC6EncryptECB
         MOV     DL,[EDI]
         MOV     AL,[ESI]
         XOR     AL,DL
         MOV     [EDI],AL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_RC6DecryptCFB(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6DecryptCFB TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6ApplyOFB128(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     EAX,[EDI]
         XOR     EAX,[EBX]
         MOV     [EDI],EAX
         MOV     EAX,[EDI+4]
         XOR     EAX,[EBX+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI+8]
         XOR     EAX,[EBX+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI+12]
         XOR     EAX,[EBX+12]
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntRC6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EDI]
         XOR     EAX,[EBX]
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EDI+2]
         XOR     AL,[EBX+2]
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EDI+1]
         XOR     AL,[EBX+1]
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EDI]
         XOR     AL,[EBX]
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_RC6ApplyOFB128(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6ApplyOFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_RC6ApplyOFB(ID: TRC6ID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntRC6EncryptECB
         MOV     AL,[EDI]
         MOV     DL,[ESI]
         XOR     AL,DL
         MOV     [EDI],AL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_RC6ApplyOFB(ID: TRC6ID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RC6ApplyOFB TODO');
end;

{$ENDIF}

procedure IntRC6Clear(ID: TRC6ID);
asm
         XOR     EDX,EDX
         CALL    IntFill16
         ADD     EAX,64
         CALL    IntFill32
end;

procedure Q_RC6Done(ID: TRC6ID);
begin
  IntRC6Clear(ID);
  FreeMem(PRC6Data(ID));
end;

function Q_RC6SelfTest: boolean;
const
  PlainTexts: array[0..1] of String =
    ('00000000000000000000000000000000',
    '02132435465768798A9BACBDCEDFE0F1');
  UserKeys: array[0..5] of String =
    ('00000000000000000000000000000000',
    '0123456789ABCDEF0112233445566778',
    '000000000000000000000000000000000000000000000000',
    '0123456789ABCDEF0112233445566778899AABBCCDDEEFF0',
    '0000000000000000000000000000000000000000000000000000000000000000',
    '0123456789ABCDEF0112233445566778899AABBCCDDEEFF01032547698BADCFE');
  CipherTexts: array[0..5] of String =
    ('8FC3A53656B1F778C129DF4E9848A41E',
    '524E192F4715C6231F51F6367EA43F18',
    '6CD61BCB190B30384E8A3F168690AE82',
    '688329D019E505041E52E92AF95291D4',
    '8F5FBD0510D15FA893FA3FDA6E857EC2',
    'C8241816F0D7E48920AD16A1674E5D48');
var
  ID: TRC6ID;
  K, S: String;
  I: integer;
begin
  for I := 0 to 5 do
  begin
    K := Q_CodesToStr(UserKeys[I]);
    SetString(K, pansichar(K), Length(K));
    Q_RC6Init(ID, Pointer(K), Length(K));
    S := Q_CodesToStr(PlainTexts[I and 1]);
    SetString(S, pansichar(S), Length(S));
    IntRC6EncryptECB(ID, Pointer(S));
    if not Q_SameStr(Q_StrToCodes(S), CipherTexts[I]) then
    begin
      Q_RC6Done(ID);
      Result := False;
      Exit;
    end;
    IntRC6DecryptECB(ID, Pointer(S));
    Q_RC6Done(ID);
    if not Q_SameStr(Q_StrToCodes(S), PlainTexts[I and 1]) then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

const
  CAST_S1_SBox: array[0..255] of longword =
    ($30FB40D4, $9FA0FF0B, $6BECCD2F, $3F258C7A, $1E213F2F, $9C004DD3, $6003E540, $CF9FC949,
    $BFD4AF27, $88BBBDB5, $E2034090, $98D09675, $6E63A0E0, $15C361D2, $C2E7661D, $22D4FF8E,
    $28683B6F, $C07FD059, $FF2379C8, $775F50E2, $43C340D3, $DF2F8656, $887CA41A, $A2D2BD2D,
    $A1C9E0D6, $346C4819, $61B76D87, $22540F2F, $2ABE32E1, $AA54166B, $22568E3A, $A2D341D0,
    $66DB40C8, $A784392F, $004DFF2F, $2DB9D2DE, $97943FAC, $4A97C1D8, $527644B7, $B5F437A7,
    $B82CBAEF, $D751D159, $6FF7F0ED, $5A097A1F, $827B68D0, $90ECF52E, $22B0C054, $BC8E5935,
    $4B6D2F7F, $50BB64A2, $D2664910, $BEE5812D, $B7332290, $E93B159F, $B48EE411, $4BFF345D,
    $FD45C240, $AD31973F, $C4F6D02E, $55FC8165, $D5B1CAAD, $A1AC2DAE, $A2D4B76D, $C19B0C50,
    $882240F2, $0C6E4F38, $A4E4BFD7, $4F5BA272, $564C1D2F, $C59C5319, $B949E354, $B04669FE,
    $B1B6AB8A, $C71358DD, $6385C545, $110F935D, $57538AD5, $6A390493, $E63D37E0, $2A54F6B3,
    $3A787D5F, $6276A0B5, $19A6FCDF, $7A42206A, $29F9D4D5, $F61B1891, $BB72275E, $AA508167,
    $38901091, $C6B505EB, $84C7CB8C, $2AD75A0F, $874A1427, $A2D1936B, $2AD286AF, $AA56D291,
    $D7894360, $425C750D, $93B39E26, $187184C9, $6C00B32D, $73E2BB14, $A0BEBC3C, $54623779,
    $64459EAB, $3F328B82, $7718CF82, $59A2CEA6, $04EE002E, $89FE78E6, $3FAB0950, $325FF6C2,
    $81383F05, $6963C5C8, $76CB5AD6, $D49974C9, $CA180DCF, $380782D5, $C7FA5CF6, $8AC31511,
    $35E79E13, $47DA91D0, $F40F9086, $A7E2419E, $31366241, $051EF495, $AA573B04, $4A805D8D,
    $548300D0, $00322A3C, $BF64CDDF, $BA57A68E, $75C6372B, $50AFD341, $A7C13275, $915A0BF5,
    $6B54BFAB, $2B0B1426, $AB4CC9D7, $449CCD82, $F7FBF265, $AB85C5F3, $1B55DB94, $AAD4E324,
    $CFA4BD3F, $2DEAA3E2, $9E204D02, $C8BD25AC, $EADF55B3, $D5BD9E98, $E31231B2, $2AD5AD6C,
    $954329DE, $ADBE4528, $D8710F69, $AA51C90F, $AA786BF6, $22513F1E, $AA51A79B, $2AD344CC,
    $7B5A41F0, $D37CFBAD, $1B069505, $41ECE491, $B4C332E6, $032268D4, $C9600ACC, $CE387E6D,
    $BF6BB16C, $6A70FB78, $0D03D9C9, $D4DF39DE, $E01063DA, $4736F464, $5AD328D8, $B347CC96,
    $75BB0FC3, $98511BFB, $4FFBCC35, $B58BCF6A, $E11F0ABC, $BFC5FE4A, $A70AEC10, $AC39570A,
    $3F04442F, $6188B153, $E0397A2E, $5727CB79, $9CEB418F, $1CACD68D, $2AD37C96, $0175CB9D,
    $C69DFF09, $C75B65F0, $D9DB40D8, $EC0E7779, $4744EAD4, $B11C3274, $DD24CB9E, $7E1C54BD,
    $F01144F9, $D2240EB1, $9675B3FD, $A3AC3755, $D47C27AF, $51C85F4D, $56907596, $A5BB15E6,
    $580304F0, $CA042CF1, $011A37EA, $8DBFAADB, $35BA3E4A, $3526FFA0, $C37B4D09, $BC306ED9,
    $98A52666, $5648F725, $FF5E569D, $0CED63D0, $7C63B2CF, $700B45E1, $D5EA50F1, $85A92872,
    $AF1FBDA7, $D4234870, $A7870BF3, $2D3B4D79, $42E04198, $0CD0EDE7, $26470DB8, $F881814C,
    $474D6AD7, $7C0C5E5C, $D1231959, $381B7298, $F5D2F4DB, $AB838653, $6E2F1E23, $83719C9E,
    $BD91E046, $9A56456E, $DC39200C, $20C8C571, $962BDA1C, $E1E696FF, $B141AB08, $7CCA89B9,
    $1A69E783, $02CC4843, $A2F7C579, $429EF47D, $427B169C, $5AC9F049, $DD8F0F00, $5C8165BF);

  CAST_S2_SBox: array[0..255] of longword =
    ($1F201094, $EF0BA75B, $69E3CF7E, $393F4380, $FE61CF7A, $EEC5207A, $55889C94, $72FC0651,
    $ADA7EF79, $4E1D7235, $D55A63CE, $DE0436BA, $99C430EF, $5F0C0794, $18DCDB7D, $A1D6EFF3,
    $A0B52F7B, $59E83605, $EE15B094, $E9FFD909, $DC440086, $EF944459, $BA83CCB3, $E0C3CDFB,
    $D1DA4181, $3B092AB1, $F997F1C1, $A5E6CF7B, $01420DDB, $E4E7EF5B, $25A1FF41, $E180F806,
    $1FC41080, $179BEE7A, $D37AC6A9, $FE5830A4, $98DE8B7F, $77E83F4E, $79929269, $24FA9F7B,
    $E113C85B, $ACC40083, $D7503525, $F7EA615F, $62143154, $0D554B63, $5D681121, $C866C359,
    $3D63CF73, $CEE234C0, $D4D87E87, $5C672B21, $071F6181, $39F7627F, $361E3084, $E4EB573B,
    $602F64A4, $D63ACD9C, $1BBC4635, $9E81032D, $2701F50C, $99847AB4, $A0E3DF79, $BA6CF38C,
    $10843094, $2537A95E, $F46F6FFE, $A1FF3B1F, $208CFB6A, $8F458C74, $D9E0A227, $4EC73A34,
    $FC884F69, $3E4DE8DF, $EF0E0088, $3559648D, $8A45388C, $1D804366, $721D9BFD, $A58684BB,
    $E8256333, $844E8212, $128D8098, $FED33FB4, $CE280AE1, $27E19BA5, $D5A6C252, $E49754BD,
    $C5D655DD, $EB667064, $77840B4D, $A1B6A801, $84DB26A9, $E0B56714, $21F043B7, $E5D05860,
    $54F03084, $066FF472, $A31AA153, $DADC4755, $B5625DBF, $68561BE6, $83CA6B94, $2D6ED23B,
    $ECCF01DB, $A6D3D0BA, $B6803D5C, $AF77A709, $33B4A34C, $397BC8D6, $5EE22B95, $5F0E5304,
    $81ED6F61, $20E74364, $B45E1378, $DE18639B, $881CA122, $B96726D1, $8049A7E8, $22B7DA7B,
    $5E552D25, $5272D237, $79D2951C, $C60D894C, $488CB402, $1BA4FE5B, $A4B09F6B, $1CA815CF,
    $A20C3005, $8871DF63, $B9DE2FCB, $0CC6C9E9, $0BEEFF53, $E3214517, $B4542835, $9F63293C,
    $EE41E729, $6E1D2D7C, $50045286, $1E6685F3, $F33401C6, $30A22C95, $31A70850, $60930F13,
    $73F98417, $A1269859, $EC645C44, $52C877A9, $CDFF33A6, $A02B1741, $7CBAD9A2, $2180036F,
    $50D99C08, $CB3F4861, $C26BD765, $64A3F6AB, $80342676, $25A75E7B, $E4E6D1FC, $20C710E6,
    $CDF0B680, $17844D3B, $31EEF84D, $7E0824E4, $2CCB49EB, $846A3BAE, $8FF77888, $EE5D60F6,
    $7AF75673, $2FDD5CDB, $A11631C1, $30F66F43, $B3FAEC54, $157FD7FA, $EF8579CC, $D152DE58,
    $DB2FFD5E, $8F32CE19, $306AF97A, $02F03EF8, $99319AD5, $C242FA0F, $A7E3EBB0, $C68E4906,
    $B8DA230C, $80823028, $DCDEF3C8, $D35FB171, $088A1BC8, $BEC0C560, $61A3C9E8, $BCA8F54D,
    $C72FEFFA, $22822E99, $82C570B4, $D8D94E89, $8B1C34BC, $301E16E6, $273BE979, $B0FFEAA6,
    $61D9B8C6, $00B24869, $B7FFCE3F, $08DC283B, $43DAF65A, $F7E19798, $7619B72F, $8F1C9BA4,
    $DC8637A0, $16A7D3B1, $9FC393B7, $A7136EEB, $C6BCC63E, $1A513742, $EF6828BC, $520365D6,
    $2D6A77AB, $3527ED4B, $821FD216, $095C6E2E, $DB92F2FB, $5EEA29CB, $145892F5, $91584F7F,
    $5483697B, $2667A8CC, $85196048, $8C4BACEA, $833860D4, $0D23E0F9, $6C387E8A, $0AE6D249,
    $B284600C, $D835731D, $DCB1C647, $AC4C56EA, $3EBD81B3, $230EABB0, $6438BC87, $F0B5B1FA,
    $8F5EA2B3, $FC184642, $0A036B7A, $4FB089BD, $649DA589, $A345415E, $5C038323, $3E5D3BB9,
    $43D79572, $7E6DD07C, $06DFDF1E, $6C6CC4EF, $7160A539, $73BFBE70, $83877605, $4523ECF1);

  CAST_S3_SBox: array[0..255] of longword =
    ($8DEFC240, $25FA5D9F, $EB903DBF, $E810C907, $47607FFF, $369FE44B, $8C1FC644, $AECECA90,
    $BEB1F9BF, $EEFBCAEA, $E8CF1950, $51DF07AE, $920E8806, $F0AD0548, $E13C8D83, $927010D5,
    $11107D9F, $07647DB9, $B2E3E4D4, $3D4F285E, $B9AFA820, $FADE82E0, $A067268B, $8272792E,
    $553FB2C0, $489AE22B, $D4EF9794, $125E3FBC, $21FFFCEE, $825B1BFD, $9255C5ED, $1257A240,
    $4E1A8302, $BAE07FFF, $528246E7, $8E57140E, $3373F7BF, $8C9F8188, $A6FC4EE8, $C982B5A5,
    $A8C01DB7, $579FC264, $67094F31, $F2BD3F5F, $40FFF7C1, $1FB78DFC, $8E6BD2C1, $437BE59B,
    $99B03DBF, $B5DBC64B, $638DC0E6, $55819D99, $A197C81C, $4A012D6E, $C5884A28, $CCC36F71,
    $B843C213, $6C0743F1, $8309893C, $0FEDDD5F, $2F7FE850, $D7C07F7E, $02507FBF, $5AFB9A04,
    $A747D2D0, $1651192E, $AF70BF3E, $58C31380, $5F98302E, $727CC3C4, $0A0FB402, $0F7FEF82,
    $8C96FDAD, $5D2C2AAE, $8EE99A49, $50DA88B8, $8427F4A0, $1EAC5790, $796FB449, $8252DC15,
    $EFBD7D9B, $A672597D, $ADA840D8, $45F54504, $FA5D7403, $E83EC305, $4F91751A, $925669C2,
    $23EFE941, $A903F12E, $60270DF2, $0276E4B6, $94FD6574, $927985B2, $8276DBCB, $02778176,
    $F8AF918D, $4E48F79E, $8F616DDF, $E29D840E, $842F7D83, $340CE5C8, $96BBB682, $93B4B148,
    $EF303CAB, $984FAF28, $779FAF9B, $92DC560D, $224D1E20, $8437AA88, $7D29DC96, $2756D3DC,
    $8B907CEE, $B51FD240, $E7C07CE3, $E566B4A1, $C3E9615E, $3CF8209D, $6094D1E3, $CD9CA341,
    $5C76460E, $00EA983B, $D4D67881, $FD47572C, $F76CEDD9, $BDA8229C, $127DADAA, $438A074E,
    $1F97C090, $081BDB8A, $93A07EBE, $B938CA15, $97B03CFF, $3DC2C0F8, $8D1AB2EC, $64380E51,
    $68CC7BFB, $D90F2788, $12490181, $5DE5FFD4, $DD7EF86A, $76A2E214, $B9A40368, $925D958F,
    $4B39FFFA, $BA39AEE9, $A4FFD30B, $FAF7933B, $6D498623, $193CBCFA, $27627545, $825CF47A,
    $61BD8BA0, $D11E42D1, $CEAD04F4, $127EA392, $10428DB7, $8272A972, $9270C4A8, $127DE50B,
    $285BA1C8, $3C62F44F, $35C0EAA5, $E805D231, $428929FB, $B4FCDF82, $4FB66A53, $0E7DC15B,
    $1F081FAB, $108618AE, $FCFD086D, $F9FF2889, $694BCC11, $236A5CAE, $12DECA4D, $2C3F8CC5,
    $D2D02DFE, $F8EF5896, $E4CF52DA, $95155B67, $494A488C, $B9B6A80C, $5C8F82BC, $89D36B45,
    $3A609437, $EC00C9A9, $44715253, $0A874B49, $D773BC40, $7C34671C, $02717EF6, $4FEB5536,
    $A2D02FFF, $D2BF60C4, $D43F03C0, $50B4EF6D, $07478CD1, $006E1888, $A2E53F55, $B9E6D4BC,
    $A2048016, $97573833, $D7207D67, $DE0F8F3D, $72F87B33, $ABCC4F33, $7688C55D, $7B00A6B0,
    $947B0001, $570075D2, $F9BB88F8, $8942019E, $4264A5FF, $856302E0, $72DBD92B, $EE971B69,
    $6EA22FDE, $5F08AE2B, $AF7A616D, $E5C98767, $CF1FEBD2, $61EFC8C2, $F1AC2571, $CC8239C2,
    $67214CB8, $B1E583D1, $B7DC3E62, $7F10BDCE, $F90A5C38, $0FF0443D, $606E6DC6, $60543A49,
    $5727C148, $2BE98A1D, $8AB41738, $20E1BE24, $AF96DA0F, $68458425, $99833BE5, $600D457D,
    $282F9350, $8334B362, $D91D1120, $2B6D8DA0, $642B1E31, $9C305A00, $52BCE688, $1B03588A,
    $F7BAEFD5, $4142ED9C, $A4315C11, $83323EC5, $DFEF4636, $A133C501, $E9D3531C, $EE353783);

  CAST_S4_SBox: array[0..255] of longword =
    ($9DB30420, $1FB6E9DE, $A7BE7BEF, $D273A298, $4A4F7BDB, $64AD8C57, $85510443, $FA020ED1,
    $7E287AFF, $E60FB663, $095F35A1, $79EBF120, $FD059D43, $6497B7B1, $F3641F63, $241E4ADF,
    $28147F5F, $4FA2B8CD, $C9430040, $0CC32220, $FDD30B30, $C0A5374F, $1D2D00D9, $24147B15,
    $EE4D111A, $0FCA5167, $71FF904C, $2D195FFE, $1A05645F, $0C13FEFE, $081B08CA, $05170121,
    $80530100, $E83E5EFE, $AC9AF4F8, $7FE72701, $D2B8EE5F, $06DF4261, $BB9E9B8A, $7293EA25,
    $CE84FFDF, $F5718801, $3DD64B04, $A26F263B, $7ED48400, $547EEBE6, $446D4CA0, $6CF3D6F5,
    $2649ABDF, $AEA0C7F5, $36338CC1, $503F7E93, $D3772061, $11B638E1, $72500E03, $F80EB2BB,
    $ABE0502E, $EC8D77DE, $57971E81, $E14F6746, $C9335400, $6920318F, $081DBB99, $FFC304A5,
    $4D351805, $7F3D5CE3, $A6C866C6, $5D5BCCA9, $DAEC6FEA, $9F926F91, $9F46222F, $3991467D,
    $A5BF6D8E, $1143C44F, $43958302, $D0214EEB, $022083B8, $3FB6180C, $18F8931E, $281658E6,
    $26486E3E, $8BD78A70, $7477E4C1, $B506E07C, $F32D0A25, $79098B02, $E4EABB81, $28123B23,
    $69DEAD38, $1574CA16, $DF871B62, $211C40B7, $A51A9EF9, $0014377B, $041E8AC8, $09114003,
    $BD59E4D2, $E3D156D5, $4FE876D5, $2F91A340, $557BE8DE, $00EAE4A7, $0CE5C2EC, $4DB4BBA6,
    $E756BDFF, $DD3369AC, $EC17B035, $06572327, $99AFC8B0, $56C8C391, $6B65811C, $5E146119,
    $6E85CB75, $BE07C002, $C2325577, $893FF4EC, $5BBFC92D, $D0EC3B25, $B7801AB7, $8D6D3B24,
    $20C763EF, $C366A5FC, $9C382880, $0ACE3205, $AAC9548A, $ECA1D7C7, $041AFA32, $1D16625A,
    $6701902C, $9B757A54, $31D477F7, $9126B031, $36CC6FDB, $C70B8B46, $D9E66A48, $56E55A79,
    $026A4CEB, $52437EFF, $2F8F76B4, $0DF980A5, $8674CDE3, $EDDA04EB, $17A9BE04, $2C18F4DF,
    $B7747F9D, $AB2AF7B4, $EFC34D20, $2E096B7C, $1741A254, $E5B6A035, $213D42F6, $2C1C7C26,
    $61C2F50F, $6552DAF9, $D2C231F8, $25130F69, $D8167FA2, $0418F2C8, $001A96A6, $0D1526AB,
    $63315C21, $5E0A72EC, $49BAFEFD, $187908D9, $8D0DBD86, $311170A7, $3E9B640C, $CC3E10D7,
    $D5CAD3B6, $0CAEC388, $F73001E1, $6C728AFF, $71EAE2A1, $1F9AF36E, $CFCBD12F, $C1DE8417,
    $AC07BE6B, $CB44A1D8, $8B9B0F56, $013988C3, $B1C52FCA, $B4BE31CD, $D8782806, $12A3A4E2,
    $6F7DE532, $58FD7EB6, $D01EE900, $24ADFFC2, $F4990FC5, $9711AAC5, $001D7B95, $82E5E7D2,
    $109873F6, $00613096, $C32D9521, $ADA121FF, $29908415, $7FBB977F, $AF9EB3DB, $29C9ED2A,
    $5CE2A465, $A730F32C, $D0AA3FE8, $8A5CC091, $D49E2CE7, $0CE454A9, $D60ACD86, $015F1919,
    $77079103, $DEA03AF6, $78A8565E, $DEE356DF, $21F05CBE, $8B75E387, $B3C50651, $B8A5C3EF,
    $D8EEB6D2, $E523BE77, $C2154529, $2F69EFDF, $AFE67AFB, $F470C4B2, $F3E0EB5B, $D6CC9876,
    $39E4460C, $1FDA8538, $1987832F, $CA007367, $A99144F8, $296B299E, $492FC295, $9266BEAB,
    $B5676E69, $9BD3DDDA, $DF7E052F, $DB25701C, $1B5E51EE, $F65324E6, $6AFCE36C, $0316CC04,
    $8644213E, $B7DC59D0, $7965291F, $CCD6FD43, $41823979, $932BCDF6, $B657C34D, $4EDFD282,
    $7AE5290C, $3CB9536B, $851E20FE, $9833557E, $13ECF0B0, $D3FFB372, $3F85C5C1, $0AEF7ED2);

procedure CAST_Qi(BETA, KrKm: Pointer);
asm
         MOV     EAX,[EDI+12]
         MOV     ECX,[ESI]
         MOV     EDX,[ESI+4]
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[ESI+8]
         XOR     EAX,[EDI+8]
         MOV     EDX,[ESI+12]
         MOV     [EDI+8],EAX
         XOR     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         SUB     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         ADD     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         XOR     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[ESI+16]
         XOR     EAX,[EDI+4]
         MOV     EDX,[ESI+20]
         MOV     [EDI+4],EAX
         SUB     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         ADD     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         XOR     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         SUB     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[ESI+24]
         XOR     EAX,[EDI]
         MOV     EDX,[ESI+28]
         MOV     [EDI],EAX
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         XOR     [EDI+12],EAX
end;

procedure CAST_QBARi(BETA, KrKm: Pointer);
asm
         MOV     EAX,[EDI]
         MOV     EDX,[ESI+28]
         MOV     ECX,[ESI+24]
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     EDX,[ESI+20]
         XOR     [EDI+12],EAX
         MOV     EAX,[EDI+4]
         MOV     ECX,[ESI+16]
         SUB     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         ADD     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         XOR     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         SUB     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     EDX,[ESI+12]
         XOR     [EDI],EAX
         MOV     EAX,[EDI+8]
         MOV     ECX,[ESI+8]
         XOR     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         SUB     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         ADD     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         XOR     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     EDX,[ESI+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[EDI+12]
         MOV     ECX,[ESI]
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         XOR     [EDI+8],EAX
end;

procedure CAST_Wi(KAPPA, TmTrAdr: Pointer);
asm
         MOV     EAX,[EDI+64]
         MOV     EDX,[EDI+68]
         MOV     [EDI],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+4],ECX
         ADD     EDX,17
         MOV     [EDI+8],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+12],ECX
         ADD     EDX,17
         MOV     [EDI+16],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+20],ECX
         ADD     EDX,17
         MOV     [EDI+24],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+28],ECX
         ADD     EDX,17
         MOV     [EDI+32],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+36],ECX
         ADD     EDX,17
         MOV     [EDI+40],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+44],ECX
         ADD     EDX,17
         MOV     [EDI+48],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+52],ECX
         ADD     EDX,17
         MOV     [EDI+56],EAX
         LEA     ECX,[EDX+16]
         ADD     EAX,$6ED9EBA1
         MOV     [EDI+60],ECX
         ADD     EDX,17
         MOV     [EDI+64],EAX
         MOV     [EDI+68],EDX
         MOV     EAX,[ESI+28]
         MOV     EDX,[EDI]
         MOV     ECX,[EDI+4]
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+12]
         XOR     EAX,[ESI+24]
         MOV     EDX,[EDI+8]
         MOV     [ESI+24],EAX
         XOR     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         SUB     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         ADD     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         XOR     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+20]
         XOR     EAX,[ESI+20]
         MOV     EDX,[EDI+16]
         MOV     [ESI+20],EAX
         SUB     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         ADD     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         XOR     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         SUB     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+28]
         XOR     EAX,[ESI+16]
         MOV     EDX,[EDI+24]
         MOV     [ESI+16],EAX
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+36]
         XOR     EAX,[ESI+12]
         MOV     EDX,[EDI+32]
         MOV     [ESI+12],EAX
         XOR     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         SUB     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         ADD     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         XOR     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+44]
         XOR     EAX,[ESI+8]
         MOV     EDX,[EDI+40]
         MOV     [ESI+8],EAX
         SUB     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         ADD     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         XOR     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         SUB     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+52]
         XOR     EAX,[ESI+4]
         MOV     EDX,[EDI+48]
         MOV     [ESI+4],EAX
         ADD     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         XOR     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         SUB     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         ADD     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         MOV     ECX,[EDI+60]
         XOR     EAX,[ESI]
         MOV     EDX,[EDI+56]
         MOV     [ESI],EAX
         XOR     EDX,EAX
         ROL     EDX,CL
         MOVZX   ECX,DH
         MOV     EAX,DWORD PTR [ECX*4+CAST_S1_SBox]
         MOVZX   ECX,DL
         SHR     EDX,16
         SUB     EAX,DWORD PTR [ECX*4+CAST_S2_SBox]
         MOVZX   ECX,DH
         MOVZX   EDX,DL
         ADD     EAX,DWORD PTR [ECX*4+CAST_S3_SBox]
         XOR     EAX,DWORD PTR [EDX*4+CAST_S4_SBox]
         XOR     [ESI+28],EAX
end;

type
  PCAST6Data = ^TCAST6Data;

  TCAST6Data = record
    Vec: TCAST6InitVector;
    KeyData: array[0..95] of longword;
  end;

{$IFDEF CPU32}
procedure IntCAST6KeySchedule(ID: TCASTID; Key: Pointer; KeyLen: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         XOR     EBX,EBX
         PUSH    EBP
         MOV     [EAX],EBX
         SUB     ESP,$20
         MOV     [EAX+4],EBX
         MOV     ESI,ESP
         MOV     [EAX+8],EBX
         MOV     [EAX+12],EBX
         MOV     [ESI],EBX
         MOV     [ESI+4],EBX
         MOV     [ESI+8],EBX
         MOV     [ESI+12],EBX
         MOV     [ESI+16],EBX
         MOV     [ESI+20],EBX
         MOV     [ESI+24],EBX
         MOV     [ESI+28],EBX
         LEA     EBX,[EAX+16]
         MOV     EDI,ECX
         SHR     ECX,2
         MOV     EBP,ECX
         JE      @@nu1
         @@m1:
         MOV     EAX,[EDX+ECX*4-4]
         BSWAP   EAX
         MOV     [ESI+ECX*4-4],EAX
         DEC     ECX
         JNE     @@m1
         @@nu1:
         AND     EDI,3
         XOR     EAX,EAX
         JMP     DWORD PTR @@DtV[EDI*4]
         @@DtV:
         DD      @@Dt0,@@Dt1,@@Dt2,@@Dt3
         @@Dt3:
         MOVZX   EAX,BYTE PTR [EDX+EBP*4+2]
         ROR     EAX,8
         @@Dt2:
         MOVZX   EDI,BYTE PTR [EDX+EBP*4+1]
         OR      EAX,EDI
         ROR     EAX,8
         @@Dt1:
         MOVZX   EDI,BYTE PTR [EDX+EBP*4]
         OR      EAX,EDI
         ROR     EAX,8
         MOV     [ESI+EBP*4],EAX
         @@Dt0:
         SUB     ESP,$48
         MOV     EDI,ESP
         MOV     EAX,$5A827999
         MOV     ECX,19
         MOV     [EDI+64],EAX
         MOV     [EDI+68],ECX
         MOV     EBP,12
         @@lp:
         CALL    CAST_Wi
         CALL    CAST_Wi
         MOV     EAX,[ESI]
         ADD     EAX,16
         MOV     [EBX],EAX
         MOV     EAX,[ESI+28]
         MOV     [EBX+4],EAX
         MOV     EAX,[ESI+8]
         ADD     EAX,16
         MOV     [EBX+8],EAX
         MOV     EAX,[ESI+20]
         MOV     [EBX+12],EAX
         MOV     EAX,[ESI+16]
         ADD     EAX,16
         MOV     [EBX+16],EAX
         MOV     EAX,[ESI+12]
         MOV     [EBX+20],EAX
         MOV     EAX,[ESI+24]
         ADD     EAX,16
         MOV     [EBX+24],EAX
         MOV     EAX,[ESI+4]
         MOV     [EBX+28],EAX
         ADD     EBX,32
         DEC     EBP
         JNE     @@lp
         XOR     EDX,EDX
         MOV     [EDI],EDX
         MOV     [EDI+4],EDX
         MOV     [EDI+8],EDX
         MOV     [EDI+12],EDX
         MOV     [EDI+16],EDX
         MOV     [EDI+20],EDX
         MOV     [EDI+24],EDX
         MOV     [EDI+28],EDX
         MOV     [EDI+32],EDX
         MOV     [EDI+36],EDX
         LEA     EAX,[EDI+40]
         CALL    IntFill16
         ADD     ESP,$68
         POP     EBP
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure IntCAST6KeySchedule(ID: TCASTID; Key: Pointer; KeyLen: cardinal);
begin
  ShowMessage('IntCAST6KeySchedule TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6Init(var ID: TCASTID; Key: Pointer; KeyLen: cardinal);
begin
  GetMem(PCAST6Data(ID), SizeOf(TCAST6Data));
  if KeyLen <= 32 then
    IntCAST6KeySchedule(ID, Key, KeyLen)
  else
    IntCAST6KeySchedule(ID, Key, 32);
end;
{$ELSE}

procedure Q_CAST6Init(var ID: TCASTID; Key: Pointer; KeyLen: cardinal);
begin
  ShowMessage('Q_CAST6Init TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntCAST6EncryptECB(ID: TCASTID; P: Pointer);
asm
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EAX+16]
         MOV     EDI,EDX
         MOV     EAX,[EDX]
         BSWAP   EAX
         MOV     [EDX],EAX
         MOV     EAX,[EDX+4]
         BSWAP   EAX
         MOV     [EDX+4],EAX
         MOV     EAX,[EDX+8]
         BSWAP   EAX
         MOV     [EDX+8],EAX
         MOV     EAX,[EDX+12]
         BSWAP   EAX
         MOV     [EDX+12],EAX
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_Qi
         ADD     ESI,32
         CALL    CAST_QBARi
         ADD     ESI,32
         CALL    CAST_QBARi
         ADD     ESI,32
         CALL    CAST_QBARi
         ADD     ESI,32
         CALL    CAST_QBARi
         ADD     ESI,32
         CALL    CAST_QBARi
         ADD     ESI,32
         CALL    CAST_QBARi
         MOV     EAX,[EDI]
         BSWAP   EAX
         MOV     [EDI],EAX
         MOV     EAX,[EDI+4]
         BSWAP   EAX
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI+8]
         BSWAP   EAX
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI+12]
         BSWAP   EAX
         MOV     [EDI+12],EAX
         POP     EDI
         POP     ESI
end;
{$ELSE}

procedure IntCAST6EncryptECB(ID: TCASTID; P: Pointer);
begin
  ShowMessage('IntCAST6EncryptEC TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure IntCAST6DecryptECB(ID: TCASTID; P: Pointer);
asm
         PUSH    ESI
         PUSH    EDI
         LEA     ESI,[EAX+368]
         MOV     EDI,EDX
         MOV     EAX,[EDX]
         BSWAP   EAX
         MOV     [EDX],EAX
         MOV     EAX,[EDX+4]
         BSWAP   EAX
         MOV     [EDX+4],EAX
         MOV     EAX,[EDX+8]
         BSWAP   EAX
         MOV     [EDX+8],EAX
         MOV     EAX,[EDX+12]
         BSWAP   EAX
         MOV     [EDX+12],EAX
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_Qi
         SUB     ESI,32
         CALL    CAST_QBARi
         SUB     ESI,32
         CALL    CAST_QBARi
         SUB     ESI,32
         CALL    CAST_QBARi
         SUB     ESI,32
         CALL    CAST_QBARi
         SUB     ESI,32
         CALL    CAST_QBARi
         SUB     ESI,32
         CALL    CAST_QBARi
         MOV     EAX,[EDI]
         BSWAP   EAX
         MOV     [EDI],EAX
         MOV     EAX,[EDI+4]
         BSWAP   EAX
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI+8]
         BSWAP   EAX
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI+12]
         BSWAP   EAX
         MOV     [EDI+12],EAX
         POP     EDI
         POP     ESI
end;
{$ELSE}

procedure IntCAST6DecryptECB(ID: TCASTID; P: Pointer);
begin
  ShowMessage('IntCAST6DecryptEC TODO');
end;

{$ENDIF}

procedure Q_CAST6SetOrdinaryVector(ID: TCASTID);
asm
         XOR     EDX,EDX
         MOV     [EAX],EDX
         MOV     [EAX+4],EDX
         MOV     [EAX+8],EDX
         MOV     [EAX+12],EDX
         MOV     EDX,EAX
         CALL    IntCAST6EncryptECB
end;

procedure Q_CAST6SetInitVector(ID: TCASTID; const IV: TCAST6InitVector);
asm
         MOV     ECX,[EDX]
         MOV     [EAX],ECX
         MOV     ECX,[EDX+4]
         MOV     [EAX+4],ECX
         MOV     ECX,[EDX+8]
         MOV     [EAX+8],ECX
         MOV     ECX,[EDX+12]
         MOV     [EAX+12],ECX
end;

{$IFDEF CPU32}
procedure Q_CAST6EncryptCBC(ID: TCASTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,[EDI]
         XOR     [EBX],EAX
         MOV     EAX,[EDI+4]
         XOR     [EBX+4],EAX
         MOV     EAX,[EDI+8]
         XOR     [EBX+8],EAX
         MOV     EAX,[EDI+12]
         XOR     [EBX+12],EAX
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     EAX,[EBX]
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         XOR     AL,[EDI+2]
         MOV     [EBX+2],AL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         XOR     AL,[EDI+1]
         MOV     [EBX+1],AL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         XOR     AL,[EDI]
         MOV     [EBX],AL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_CAST6EncryptCBC(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6EncryptCBC TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6DecryptCBC(ID: TCASTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         PUSH    ECX
         SHR     EBP,4
         JE      @@nx
         @@lp1:
         MOV     EAX,[EDI]
         MOV     [ESI],EAX
         MOV     EAX,[EDI+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EDI+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EDI+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntCAST6DecryptECB
         MOV     EAX,[EBX]
         XOR     [EDI],EAX
         MOV     EAX,[EBX+4]
         XOR     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         XOR     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         XOR     [EDI+12],EAX
         MOV     EAX,[ESI]
         MOV     [EBX],EAX
         MOV     EAX,[ESI+4]
         MOV     [EBX+4],EAX
         MOV     EAX,[ESI+8]
         MOV     [EBX+8],EAX
         MOV     EAX,[ESI+12]
         MOV     [EBX+12],EAX
         ADD     EDI,$10
         DEC     EBP
         JNE     @@lp1
         @@nx:
         XOR     EDX,EDX
         POP     EBP
         MOV     [ESI],EDX
         MOV     [ESI+4],EDX
         MOV     [ESI+8],EDX
         MOV     [ESI+12],EDX
         ADD     ESP,$10
         AND     EBP,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     ECX,EBP
         SHR     EBP,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     EBP
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         MOV     DL,[EDI+2]
         XOR     AL,DL
         MOV     [EBX+2],DL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         MOV     DL,[EDI+1]
         XOR     AL,DL
         MOV     [EBX+1],DL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         MOV     DL,[EDI]
         XOR     AL,DL
         MOV     [EBX],DL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
end;
{$ELSE}

procedure Q_CAST6DecryptCBC(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6DecryptCBV TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6EncryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         XOR     EAX,[EDI+4]
         MOV     [EBX+4],EAX
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         XOR     EAX,[EDI+8]
         MOV     [EBX+8],EAX
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         XOR     EAX,[EDI+12]
         MOV     [EBX+12],EAX
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         XOR     EAX,[EDI]
         MOV     [EBX],EAX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         XOR     AL,[EDI+2]
         MOV     [EBX+2],AL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         XOR     AL,[EDI+1]
         MOV     [EBX+1],AL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         XOR     AL,[EDI]
         MOV     [EBX],AL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_CAST6EncryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6EncryptCFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6DecryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         MOV     EAX,[EBX+4]
         MOV     EDX,[EDI+4]
         XOR     EAX,EDX
         MOV     [EBX+4],EDX
         MOV     [EDI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     EDX,[EDI+8]
         XOR     EAX,EDX
         MOV     [EBX+8],EDX
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     EDX,[EDI+12]
         XOR     EAX,EDX
         MOV     [EBX+12],EDX
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EBX]
         MOV     EDX,[EDI]
         XOR     EAX,EDX
         MOV     [EBX],EDX
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EBX+2]
         MOV     DL,[EDI+2]
         XOR     AL,DL
         MOV     [EBX+2],DL
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EBX+1]
         MOV     DL,[EDI+1]
         XOR     AL,DL
         MOV     [EBX+1],DL
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EBX]
         MOV     DL,[EDI]
         XOR     AL,DL
         MOV     [EBX],DL
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_CAST6DecryptCFB128(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6DecryptCFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6EncryptCFB(ID: TCASTID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntCAST6EncryptECB
         MOV     DL,[EDI]
         XOR     DL,[ESI]
         MOV     [EDI],DL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_CAST6EncryptCFB(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6EncryptCFB TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6DecryptCFB(ID: TCASTID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntCAST6EncryptECB
         MOV     DL,[EDI]
         MOV     AL,[ESI]
         XOR     AL,DL
         MOV     [EDI],AL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_CAST6DecryptCFB(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6DecryptCFB TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6ApplyOFB128(ID: TCASTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    ESI
         PUSH    EDI
         MOV     EBX,EAX
         MOV     ESI,ECX
         PUSH    ECX
         MOV     EDI,EDX
         SHR     ESI,4
         JE      @@nx
         @@lp1:
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     EAX,[EDI]
         XOR     EAX,[EBX]
         MOV     [EDI],EAX
         MOV     EAX,[EDI+4]
         XOR     EAX,[EBX+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI+8]
         XOR     EAX,[EBX+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI+12]
         XOR     EAX,[EBX+12]
         MOV     [EDI+12],EAX
         ADD     EDI,$10
         DEC     ESI
         JNE     @@lp1
         @@nx:
         POP     ESI
         AND     ESI,$F
         JE      @@qt
         MOV     EAX,EBX
         MOV     EDX,EBX
         CALL    IntCAST6EncryptECB
         MOV     ECX,ESI
         SHR     ESI,2
         JE      @@uu
         @@lp2:
         MOV     EAX,[EDI]
         XOR     EAX,[EBX]
         MOV     [EDI],EAX
         ADD     EBX,4
         ADD     EDI,4
         DEC     ESI
         JNE     @@lp2
         @@uu:
         AND     ECX,3
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         @@t3:
         MOV     AL,[EDI+2]
         XOR     AL,[EBX+2]
         MOV     [EDI+2],AL
         @@t2:
         MOV     AL,[EDI+1]
         XOR     AL,[EBX+1]
         MOV     [EDI+1],AL
         @@t1:
         MOV     AL,[EDI]
         XOR     AL,[EBX]
         MOV     [EDI],AL
         @@qt:
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure Q_CAST6ApplyOFB128(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6ApplyOFB128 TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_CAST6ApplyOFB(ID: TCASTID; P: Pointer; L: cardinal);
asm
         TEST    ECX,ECX
         JE      @@qt
         PUSH    EBX
         PUSH    EBP
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         MOV     EBP,ECX
         SUB     ESP,$10
         MOV     EDI,EDX
         MOV     ESI,ESP
         @@lp:
         MOV     EAX,[EBX]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+4]
         MOV     [ESI+4],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI+8],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+12],EAX
         MOV     EAX,EBX
         MOV     EDX,ESI
         CALL    IntCAST6EncryptECB
         MOV     AL,[EDI]
         MOV     DL,[ESI]
         XOR     AL,DL
         MOV     [EDI],AL
         MOV     AL,[EBX+1]
         MOV     [EBX],AL
         MOV     AL,[EBX+2]
         MOV     [EBX+1],AL
         MOV     AL,[EBX+3]
         MOV     [EBX+2],AL
         MOV     AL,[EBX+4]
         MOV     [EBX+3],AL
         MOV     AL,[EBX+5]
         MOV     [EBX+4],AL
         MOV     AL,[EBX+6]
         MOV     [EBX+5],AL
         MOV     AL,[EBX+7]
         MOV     [EBX+6],AL
         MOV     AL,[EBX+8]
         MOV     [EBX+7],AL
         MOV     AL,[EBX+9]
         MOV     [EBX+8],AL
         MOV     AL,[EBX+10]
         MOV     [EBX+9],AL
         MOV     AL,[EBX+11]
         MOV     [EBX+10],AL
         MOV     AL,[EBX+12]
         MOV     [EBX+11],AL
         MOV     AL,[EBX+13]
         MOV     [EBX+12],AL
         MOV     AL,[EBX+14]
         MOV     [EBX+13],AL
         MOV     AL,[EBX+15]
         MOV     [EBX+14],AL
         MOV     [EBX+15],DL
         INC     EDI
         DEC     EBP
         JNE     @@lp
         MOV     [ESI],EBP
         MOV     [ESI+4],EBP
         MOV     [ESI+8],EBP
         MOV     [ESI+12],EBP
         ADD     ESP,$10
         POP     EDI
         POP     ESI
         POP     EBP
         POP     EBX
         @@qt:
end;
{$ELSE}

procedure Q_CAST6ApplyOFB(ID: TCASTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_CAST6ApplyOFB TODO');
end;

{$ENDIF}

procedure IntCAST6Clear(ID: TCASTID);
asm
         XOR     EDX,EDX
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         MOV     [EAX+128],EDX
         MOV     [EAX+132],EDX
         MOV     [EAX+136],EDX
         MOV     [EAX+140],EDX
end;

procedure Q_CAST6Done(ID: TCASTID);
begin
  IntCAST6Clear(ID);
  FreeMem(PCAST6Data(ID));
end;

function Q_CAST6SelfTest: boolean;
const
  PlainText: String = '00000000000000000000000000000000';
var
  ID: TCASTID;
  K, S, S1: String;
begin
  S1 := Q_CodesToStr(PlainText);
  K := Q_CodesToStr('2342BB9EFA38542C0AF75647F29F615D');
  Q_CAST6Init(ID, Pointer(K), Length(K));
  IntCAST6EncryptECB(ID, Pointer(S1));
  S := Q_StrToCodes(S1);
  if not Q_SameStr(S, 'C842A08972B43D20836C91D1B7530F6B') then
  begin
    Q_CAST6Done(ID);
    Result := False;
    Exit;
  end;
  IntCAST6DecryptECB(ID, Pointer(S1));
  Q_CAST6Done(ID);
  S := Q_StrToCodes(S1);
  if not Q_SameStr(S, PlainText) then
  begin
    Result := False;
    Exit;
  end;
  K := Q_CodesToStr('2342BB9EFA38542CBED0AC83940AC298BAC77A7717942863');
  Q_CAST6Init(ID, Pointer(K), Length(K));
  IntCAST6EncryptECB(ID, Pointer(S1));
  S := Q_StrToCodes(S1);
  if not Q_SameStr(S, '1B386C0210DCADCBDD0E41AA08A7A7E8') then
  begin
    Q_CAST6Done(ID);
    Result := False;
    Exit;
  end;
  IntCAST6DecryptECB(ID, Pointer(S1));
  Q_CAST6Done(ID);
  S := Q_StrToCodes(S1);
  if not Q_SameStr(S, PlainText) then
  begin
    Result := False;
    Exit;
  end;
  K := Q_CodesToStr('2342BB9EFA38542CBED0AC83940AC2988D7C47CE264908461CC1B5137AE6B604');
  Q_CAST6Init(ID, Pointer(K), Length(K));
  IntCAST6EncryptECB(ID, Pointer(S1));
  S := Q_StrToCodes(S1);
  if not Q_SameStr(S, '4F6A2038286897B9C9870136553317FA') then
  begin
    Q_CAST6Done(ID);
    Result := False;
    Exit;
  end;
  IntCAST6DecryptECB(ID, Pointer(S1));
  Q_CAST6Done(ID);
  S := Q_StrToCodes(S1);
  Result := Q_SameStr(S, PlainText);
end;

type
  PSHA1Data = ^TSHA1Data;

  TSHA1Data = record
    Buffer: array[0..63] of byte;
    LHi, LLo, Index: longword;
    Hash: TSHA1Digest;
    Tmp: array[0..79] of longword;
  end;

{$IFDEF CPU32}
procedure IntSHA1Compress(ID: TSHAID);
asm
         PUSH    EBX
         PUSH    ESI
         XOR     ECX,ECX
         PUSH    EDI
         MOV     [EAX+72],ECX
         PUSH    EBP
         LEA     ESI,[EAX].TSHA1Data.Tmp
         MOV     EBX,[EAX]
         BSWAP   EBX
         MOV     [ESI],EBX
         MOV     EBX,[EAX+4]
         BSWAP   EBX
         MOV     [ESI+4],EBX
         MOV     EBX,[EAX+8]
         BSWAP   EBX
         MOV     [ESI+8],EBX
         MOV     EBX,[EAX+12]
         BSWAP   EBX
         MOV     [ESI+12],EBX
         MOV     EBX,[EAX+16]
         BSWAP   EBX
         MOV     [ESI+16],EBX
         MOV     EBX,[EAX+20]
         BSWAP   EBX
         MOV     [ESI+20],EBX
         MOV     EBX,[EAX+24]
         BSWAP   EBX
         MOV     [ESI+24],EBX
         MOV     EBX,[EAX+28]
         BSWAP   EBX
         MOV     [ESI+28],EBX
         MOV     EBX,[EAX+32]
         BSWAP   EBX
         MOV     [ESI+32],EBX
         MOV     EBX,[EAX+36]
         BSWAP   EBX
         MOV     [ESI+36],EBX
         MOV     EBX,[EAX+40]
         BSWAP   EBX
         MOV     [ESI+40],EBX
         MOV     EBX,[EAX+44]
         BSWAP   EBX
         MOV     [ESI+44],EBX
         MOV     EBX,[EAX+48]
         BSWAP   EBX
         MOV     [ESI+48],EBX
         MOV     EBX,[EAX+52]
         BSWAP   EBX
         MOV     [ESI+52],EBX
         MOV     EBX,[EAX+56]
         BSWAP   EBX
         MOV     [ESI+56],EBX
         MOV     EBX,[EAX+60]
         BSWAP   EBX
         LEA     EDI,[ESI+64]
         MOV     [ESI+60],EBX
         PUSH    EAX
         LEA     EDX,[EAX].TSHA1Data.Hash
         MOV     ECX,16
         @@lp0:
         MOV     EAX,[EDI-64]
         MOV     EBX,[EDI-56]
         XOR     EAX,[EDI-32]
         XOR     EBX,[EDI-12]
         XOR     EAX,EBX
         ROL     EAX,1
         MOV     [EDI],EAX
         MOV     EAX,[EDI-60]
         MOV     EBX,[EDI-52]
         XOR     EAX,[EDI-28]
         XOR     EBX,[EDI-8]
         XOR     EAX,EBX
         ROL     EAX,1
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI-56]
         XOR     EAX,[EDI-24]
         MOV     EBX,[EDI-48]
         XOR     EBX,[EDI-4]
         XOR     EAX,EBX
         ROL     EAX,1
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI-52]
         MOV     EBX,[EDI-44]
         XOR     EAX,[EDI-20]
         XOR     EBX,[EDI]
         XOR     EAX,EBX
         ROL     EAX,1
         MOV     [EDI+12],EAX
         ADD     EDI,16
         DEC     ECX
         JNE     @@lp0
         MOV     ECX,5
         MOV     EAX,[EDX]
         PUSH    ECX
         MOV     EDI,[EDX+4]
         MOV     EBX,[EDX+8]
         MOV     EBP,[EDX+12]
         MOV     ECX,[EDX+16]
         MOV     EDX,EAX
         @@lp1:
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBX
         XOR     ECX,EBP
         ADD     EAX,[ESI]
         AND     ECX,EDI
         XOR     ECX,EBP
         ADD     ECX,$5A827999
         ADD     EAX,ECX
         MOV     ECX,EBP
         ROR     EDI,2
         MOV     EBP,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDI
         XOR     ECX,EBX
         AND     ECX,EDX
         ADD     EAX,[ESI+4]
         XOR     ECX,EBX
         ROR     EDX,2
         ADD     ECX,$5A827999
         ADD     EAX,ECX
         MOV     ECX,EBX
         MOV     EBX,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDX
         ADD     EAX,[ESI+8]
         XOR     ECX,EDI
         AND     ECX,EBP
         ROR     EBP,2
         XOR     ECX,EDI
         ADD     ECX,$5A827999
         ADD     EAX,ECX
         MOV     ECX,EDI
         MOV     EDI,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBP
         ADD     EAX,[ESI+12]
         XOR     ECX,EDX
         AND     ECX,EBX
         XOR     ECX,EDX
         ADD     ECX,$5A827999
         ROR     EBX,2
         ADD     EAX,ECX
         MOV     ECX,EDX
         MOV     EDX,EAX
         ADD     ESI,16
         DEC     DWORD PTR [ESP]
         JNE     @@lp1
         MOV     DWORD PTR [ESP],5
         @@lp2:
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDI
         ADD     EAX,[ESI]
         XOR     ECX,EBX
         XOR     ECX,EBP
         ADD     ECX,$6ED9EBA1
         ADD     EAX,ECX
         MOV     ECX,EBP
         ROR     EDI,2
         MOV     EBP,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDX
         XOR     ECX,EDI
         XOR     ECX,EBX
         ADD     ECX,$6ED9EBA1
         ROR     EDX,2
         ADD     EAX,[ESI+4]
         ADD     EAX,ECX
         MOV     ECX,EBX
         MOV     EBX,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBP
         XOR     ECX,EDX
         ROR     EBP,2
         XOR     ECX,EDI
         ADD     EAX,[ESI+8]
         ADD     ECX,$6ED9EBA1
         ADD     EAX,ECX
         MOV     ECX,EDI
         MOV     EDI,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBX
         XOR     ECX,EBP
         XOR     ECX,EDX
         ADD     EAX,[ESI+12]
         ADD     ECX,$6ED9EBA1
         ADD     EAX,ECX
         MOV     ECX,EDX
         ROR     EBX,2
         MOV     EDX,EAX
         ADD     ESI,16
         DEC     DWORD PTR [ESP]
         JNE     @@lp2
         MOV     DWORD PTR [ESP],5
         PUSH    ECX
         @@lp3:
         MOV     EAX,EDI
         MOV     ECX,EDI
         AND     EAX,EBX
         OR      ECX,EBX
         AND     ECX,EBP
         OR      EAX,ECX
         MOV     ECX,EDX
         ADD     EAX,[ESI]
         ROL     ECX,5
         ADD     EAX,$8F1BBCDC
         ADD     ECX,[ESP]
         ADD     EAX,ECX
         ROR     EDI,2
         MOV     [ESP],EBP
         MOV     EBP,EAX
         MOV     EAX,EDX
         MOV     ECX,EDX
         AND     EAX,EDI
         OR      ECX,EDI
         AND     ECX,EBX
         OR      EAX,ECX
         MOV     ECX,EBP
         ADD     EAX,[ESI+4]
         ROL     ECX,5
         ADD     EAX,$8F1BBCDC
         ADD     ECX,[ESP]
         ADD     EAX,ECX
         ROR     EDX,2
         MOV     [ESP],EBX
         MOV     EBX,EAX
         MOV     EAX,EBP
         MOV     ECX,EBP
         AND     EAX,EDX
         OR      ECX,EDX
         AND     ECX,EDI
         OR      EAX,ECX
         MOV     ECX,EBX
         ADD     EAX,[ESI+8]
         ROL     ECX,5
         ADD     EAX,$8F1BBCDC
         ADD     ECX,[ESP]
         ADD     EAX,ECX
         ROR     EBP,2
         MOV     [ESP],EDI
         MOV     EDI,EAX
         MOV     EAX,EBX
         MOV     ECX,EBX
         AND     EAX,EBP
         OR      ECX,EBP
         AND     ECX,EDX
         OR      EAX,ECX
         MOV     ECX,EDI
         ADD     EAX,[ESI+12]
         ROL     ECX,5
         ADD     EAX,$8F1BBCDC
         ADD     ECX,[ESP]
         ADD     EAX,ECX
         ROR     EBX,2
         MOV     [ESP],EDX
         MOV     EDX,EAX
         ADD     ESI,16
         DEC     DWORD PTR [ESP+4]
         JNE     @@lp3
         POP     ECX
         MOV     DWORD PTR [ESP],5
         @@lp4:
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDI
         XOR     ECX,EBX
         XOR     ECX,EBP
         ROR     EDI,2
         ADD     EAX,[ESI]
         ADD     ECX,$CA62C1D6
         ADD     EAX,ECX
         MOV     ECX,EBP
         MOV     EBP,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EDX
         ADD     EAX,[ESI+4]
         XOR     ECX,EDI
         XOR     ECX,EBX
         ADD     ECX,$CA62C1D6
         ADD     EAX,ECX
         MOV     ECX,EBX
         ROR     EDX,2
         MOV     EBX,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBP
         ADD     EAX,[ESI+8]
         XOR     ECX,EDX
         XOR     ECX,EDI
         ROR     EBP,2
         ADD     ECX,$CA62C1D6
         ADD     EAX,ECX
         MOV     ECX,EDI
         MOV     EDI,EAX
         ROL     EAX,5
         ADD     EAX,ECX
         MOV     ECX,EBX
         ADD     EAX,[ESI+12]
         XOR     ECX,EBP
         XOR     ECX,EDX
         ADD     ECX,$CA62C1D6
         ADD     EAX,ECX
         MOV     ECX,EDX
         ROR     EBX,2
         MOV     EDX,EAX
         ADD     ESI,16
         DEC     DWORD PTR [ESP]
         JNE     @@lp4
         POP     EAX
         POP     EAX
         ADD     [EAX+76],EDX
         ADD     [EAX+80],EDI
         ADD     [EAX+84],EBX
         ADD     [EAX+88],EBP
         ADD     [EAX+92],ECX
         POP     EBP
         POP     EDI
         XOR     EDX,EDX
         CALL    IntFill16
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure IntSHA1Compress(ID: TSHAID);
begin
  ShowMessage('IntSHA1Compress TODO');
end;

{$ENDIF}

procedure IntSHA1Clear(ID: TSHAID);
asm
         XOR     EDX,EDX
         MOV     [EAX+64],EDX
         MOV     [EAX+68],EDX
         MOV     [EAX+72],EDX
         MOV     [EAX+76],EDX
         MOV     [EAX+80],EDX
         MOV     [EAX+84],EDX
         MOV     [EAX+88],EDX
         MOV     [EAX+92],EDX
         LEA     EAX,[EAX].TSHA1Data.Tmp
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill16
end;

procedure IntSHA1Init(ID: TSHAID);
begin
  with PSHA1Data(ID)^ do
  begin
    Hash[0] := $67452301;
    Hash[1] := $EFCDAB89;
    Hash[2] := $98BADCFE;
    Hash[3] := $10325476;
    Hash[4] := $C3D2E1F0;
  end;
end;

procedure Q_SHA1Init(var ID: TSHAID);
begin
  GetMem(PSHA1Data(ID), SizeOf(TSHA1Data));
  IntFill16(Pointer(ID), 0);
  with PSHA1Data(ID)^ do
  begin
    LHi := 0;
    LLo := 0;
    Index := 0;
  end;
  IntSHA1Init(ID);
end;

procedure Q_SHA1Update(ID: TSHAID; P: Pointer; L: cardinal);
var
  N: longword;
begin
  with PSHA1Data(ID)^ do
  begin
    N := L shl 3;
    Inc(LLo, N);
    if LLo < N then
      Inc(LHi);
    Inc(LHi, L shr 29);
    while L <> 0 do
    begin
      N := SizeOf(Buffer) - Index;
      if N <= L then
      begin
        Q_CopyMem(P, @Buffer[Index], N);
        Inc(pbyte(P), N);
        Dec(L, N);
        IntSHA1Compress(ID);
      end
      else
      begin
        Q_CopyMem(P, @Buffer[Index], L);
        Inc(Index, L);
        Exit;
      end;
    end;
  end;
end;

procedure IntSHA1Final(ID: TSHAID; var Digest: TSHA1Digest);
var
  U: longword;
begin
  with PSHA1Data(ID)^ do
  begin
    Buffer[Index] := $80;
    if Index >= 56 then
      IntSHA1Compress(ID);
    U := LHi;
    asm
             MOV     EAX,U
             BSWAP   EAX
             MOV     U,EAX
    end;
    PLong(@Buffer[56])^ := U;
    U := LLo;
    asm
             MOV     EAX,U
             BSWAP   EAX
             MOV     U,EAX
    end;
    PLong(@Buffer[60])^ := U;
    IntSHA1Compress(ID);
    Digest[0] := Hash[0];
    Digest[1] := Hash[1];
    Digest[2] := Hash[2];
    Digest[3] := Hash[3];
    Digest[4] := Hash[4];
  end;
end;

procedure Q_SHA1Final(ID: TSHAID; var Digest: TSHA1Digest);
begin
  IntSHA1Final(ID, Digest);
  IntSHA1Clear(ID);
  FreeMem(PSHA1Data(ID));
end;

procedure Q_SHA1(const S: String; var Digest: TSHA1Digest);
var
  ID: TSHAID;
begin
  Q_SHA1Init(ID);
  Q_SHA1Update(ID, Pointer(S), Length(S));
  Q_SHA1Final(ID, Digest);
end;

procedure Q_SHA1(P: Pointer; L: cardinal; var Digest: TSHA1Digest);
var
  ID: TSHAID;
begin
  Q_SHA1Init(ID);
  Q_SHA1Update(ID, P, L);
  Q_SHA1Final(ID, Digest);
end;

procedure Q_SHA1(const SourceDigest: TSHA1Digest; var Digest: TSHA1Digest);
var
  ID: TSHAID;
begin
  Q_SHA1Init(ID);
  Q_SHA1Update(ID, @SourceDigest, SizeOf(TSHA1Digest));
  Q_SHA1Final(ID, Digest);
end;

procedure Q_SHA1(const SourceDigest: TMixDigest; var Digest: TSHA1Digest);
var
  ID: TSHAID;
begin
  Q_SHA1Init(ID);
  Q_SHA1Update(ID, @SourceDigest, SizeOf(TMixDigest));
  Q_SHA1Final(ID, Digest);
end;

function Q_SHA1SelfTest: boolean;
var
  ID: TSHAID;
  Dig: TSHA1Digest;
  S: String;
begin
  Q_SHA1('abc', Dig);
  if not ((Dig[0] = $A9993E36) and (Dig[1] = $4706816A) and (Dig[2] = $BA3E2571) and (Dig[3] = $7850C26C) and (Dig[4] = $9CD0D89D)) then
  begin
    Result := False;
    Exit;
  end;
  S := StringOfChar('a', 200000);
  Q_SHA1Init(ID);
  Q_SHA1Update(ID, Pointer(S), 200000);
  Q_SHA1Update(ID, Pointer(S), 200000);
  Q_SHA1Update(ID, Pointer(S), 200000);
  Q_SHA1Update(ID, Pointer(S), 200000);
  Q_SHA1Update(ID, Pointer(S), 200000);
  Q_SHA1Final(ID, Dig);
  if not ((Dig[0] = $34AA973C) and (Dig[1] = $D4C4DAA4) and (Dig[2] = $F61EEB2B) and (Dig[3] = $DBAD2731) and (Dig[4] = $6534016F)) then
  begin
    Result := False;
    Exit;
  end;
  Q_SHA1Init(ID);
  S := 'abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq';
  Q_SHA1Update(ID, Pointer(S), Length(S));
  Q_SHA1Final(ID, Dig);
  Result := (Dig[0] = $84983E44) and (Dig[1] = $1C3BD26E) and (Dig[2] = $BAAE4AA1) and (Dig[3] = $F95129E5) and (Dig[4] = $E54670F1);
end;

const
  MixBufferSize = 8193;

type
  PMixData = ^TMixData;

  TMixData = record
    Dig1, Dig2: TSHA1Digest;
    DigPass: TSHA1Digest;
    Place: array[0..11] of longword;
    SHAID: TSHAID;
    CASTID: TCASTID;
    Index: cardinal;
    Hash: TMixDigest;
    Buffer: array[0..MixBufferSize - 1] of byte;
  end;

procedure IntMixCompress(ID: TMixID);
var
  BO, BI: cardinal;
begin
  with PMixData(ID)^ do
  begin
    if Index <> 1 then
    begin
      BO := (Index + 2) div 3;
      BI := Index - (BO shl 1);
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer, BO + BI);
      IntSHA1Final(SHAID, Dig1);
      Place[0] := Hash[5] xor Dig1[0];
      Place[2] := Hash[6] xor Dig1[1];
      Place[4] := Hash[7] xor Dig1[2];
      Place[6] := Hash[8] xor Dig1[3];
      Place[8] := Hash[9] xor Dig1[4];
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer[BO], BO + BI);
      IntSHA1Final(SHAID, Dig2);
      Place[1] := Hash[0] xor Dig2[0];
      Place[3] := Hash[1] xor Dig2[1];
      Place[5] := Hash[2] xor Dig2[2];
      Place[7] := Hash[3] xor Dig2[3];
      Place[9] := Hash[4] xor Dig2[4];
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer[BO + BI], BO);
      Q_SHA1Update(SHAID, @Buffer, BO);
      IntSHA1Final(SHAID, DigPass);
    end
    else
    begin
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer, 1);
      IntSHA1Final(SHAID, Dig1);
      Place[0] := Hash[5] xor Dig1[0];
      Place[2] := Hash[6] xor Dig1[1];
      Place[4] := Hash[7] xor Dig1[2];
      Place[6] := Hash[8] xor Dig1[3];
      Place[8] := Hash[9] xor Dig1[4];
      Buffer[0] := not Buffer[0];
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer, 1);
      IntSHA1Final(SHAID, Dig2);
      Place[1] := Hash[0] xor Dig2[0];
      Place[3] := Hash[1] xor Dig2[1];
      Place[5] := Hash[2] xor Dig2[2];
      Place[7] := Hash[3] xor Dig2[3];
      Place[9] := Hash[4] xor Dig2[4];
      Buffer[0] := Buffer[0] xor $AA;
      IntSHA1Init(SHAID);
      Q_SHA1Update(SHAID, @Buffer, 1);
      IntSHA1Final(SHAID, DigPass);
    end;
    IntCAST6KeySchedule(CASTID, @DigPass, SizeOf(DigPass));
    IntCAST6EncryptECB(CASTID, @Place);
    IntCAST6EncryptECB(CASTID, @Place[2]);
    IntCAST6EncryptECB(CASTID, @Place[4]);
    IntCAST6EncryptECB(CASTID, @Place[6]);
    Place[10] := Place[0];
    Place[11] := Place[1];
    IntCAST6EncryptECB(CASTID, @Place[8]);
    Place[0] := Place[10];
    Place[1] := Place[11];
    IntCAST6EncryptECB(CASTID, @Place);
    IntCAST6EncryptECB(CASTID, @Place[2]);
    IntCAST6EncryptECB(CASTID, @Place[4]);
    IntCAST6EncryptECB(CASTID, @Place[6]);
    Place[10] := Place[0];
    Place[11] := Place[1];
    IntCAST6EncryptECB(CASTID, @Place[8]);
    Place[0] := Place[10];
    Place[1] := Place[11];
    IntCAST6EncryptECB(CASTID, @Place);
    IntCAST6EncryptECB(CASTID, @Place[2]);
    IntCAST6EncryptECB(CASTID, @Place[4]);
    IntCAST6EncryptECB(CASTID, @Place[6]);
    Place[10] := Place[0];
    Place[11] := Place[1];
    IntCAST6EncryptECB(CASTID, @Place[8]);
    Place[0] := Place[10];
    Place[1] := Place[11];
    IntCAST6EncryptECB(CASTID, @Place);
    IntCAST6EncryptECB(CASTID, @Place[2]);
    IntCAST6EncryptECB(CASTID, @Place[4]);
    IntCAST6EncryptECB(CASTID, @Place[6]);
    Place[10] := Place[0];
    Place[11] := Place[1];
    IntCAST6EncryptECB(CASTID, @Place[8]);
    Place[0] := Place[10];
    Place[1] := Place[11];
    Q_XORByRandom(@Place, 40, Dig1[0]);
    Q_XORByRandom(@Place, 40, Dig1[1]);
    Q_XORByRandom(@Place, 40, Dig1[2]);
    Q_XORByRandom(@Place, 40, Dig1[3]);
    Q_XORByRandom(@Place, 40, Dig1[4]);
    Q_XORByRandom(@Place, 40, Dig2[0]);
    Q_XORByRandom(@Place, 40, Dig2[1]);
    Q_XORByRandom(@Place, 40, Dig2[2]);
    Q_XORByRandom(@Place, 40, Dig2[3]);
    Q_XORByRandom(@Place, 40, Dig2[4]);
    Inc(Hash[0], Place[0]);
    Inc(Hash[1], Place[1]);
    Inc(Hash[2], Place[2]);
    Inc(Hash[3], Place[3]);
    Inc(Hash[4], Place[4]);
    Inc(Hash[5], Place[5]);
    Inc(Hash[6], Place[6]);
    Inc(Hash[7], Place[7]);
    Inc(Hash[8], Place[8]);
    Inc(Hash[9], Place[9]);
    Index := 0;
  end;
end;

procedure Q_MixHashInit(var ID: TMixID);
begin
  GetMem(PMixData(ID), SizeOf(TMixData));
  with PMixData(ID)^ do
  begin
    Q_SHA1Init(SHAID);
    GetMem(PCAST6Data(CASTID), SizeOf(TCAST6Data));
    Index := 0;
    Hash[0] := $A6A163F4;
    Hash[1] := $3E4A378C;
    Hash[2] := $FEDA4FF3;
    Hash[3] := $D5D632CB;
    Hash[4] := $2A6DFD49;
    Hash[5] := $06153197;
    Hash[6] := $92ED05D1;
    Hash[7] := $50FB311D;
    Hash[8] := $193FEEC4;
    Hash[9] := $870D7415;
  end;
end;

procedure Q_MixHashUpdate(ID: TMixID; P: Pointer; L: cardinal);
var
  N: longword;
begin
  with PMixData(ID)^ do
    while L <> 0 do
    begin
      N := MixBufferSize - Index;
      if N <= L then
      begin
        Q_CopyMem(P, @Buffer[Index], N);
        Inc(pbyte(P), N);
        Index := MixBufferSize;
        IntMixCompress(ID);
        Dec(L, N);
      end
      else
      begin
        Q_CopyMem(P, @Buffer[Index], L);
        Inc(Index, L);
        Exit;
      end;
    end;
end;

procedure Q_MixHashFinal(ID: TMixID; var Digest: TMixDigest);
begin
  with PMixData(ID)^ do
  begin
    if Index <> 0 then
      IntMixCompress(ID);
    Digest[0] := Hash[0];
    Digest[1] := Hash[1];
    Digest[2] := Hash[2];
    Digest[3] := Hash[3];
    Digest[4] := Hash[4];
    Digest[5] := Hash[5];
    Digest[6] := Hash[6];
    Digest[7] := Hash[7];
    Digest[8] := Hash[8];
    Digest[9] := Hash[9];
    IntSHA1Clear(SHAID);
    FreeMem(PSHA1Data(SHAID));
    IntCAST6Clear(CASTID);
    FreeMem(PCAST6Data(CASTID));
  end;
  Q_ZeroMem(PMixData(ID), SizeOf(TMixData));
  FreeMem(PMixData(ID));
end;

procedure Q_MixHash(const S: String; var Digest: TMixDigest);
var
  ID: TMixID;
begin
  Q_MixHashInit(ID);
  Q_MixHashUpdate(ID, Pointer(S), Length(S));
  Q_MixHashFinal(ID, Digest);
end;

procedure Q_MixHash(P: Pointer; L: cardinal; var Digest: TMixDigest);
var
  ID: TMixID;
begin
  Q_MixHashInit(ID);
  Q_MixHashUpdate(ID, P, L);
  Q_MixHashFinal(ID, Digest);
end;

procedure Q_MixHash(const SourceDigest: TMixDigest; var Digest: TMixDigest);
var
  ID: TMixID;
begin
  Q_MixHashInit(ID);
  Q_MixHashUpdate(ID, @SourceDigest, SizeOf(TMixDigest));
  Q_MixHashFinal(ID, Digest);
end;

function Q_MixHashSelfTest: boolean;
var
  ID: TMixID;
  Dig: TMixDigest;
  S: String;
begin
  Q_MixHash('abc', Dig);
  if not ((Dig[0] = $13E03225) and (Dig[1] = $C0FCE942) and (Dig[2] = $B2941408) and (Dig[3] = $FEBF7552) and
    (Dig[4] = $13F6E6D9) and (Dig[5] = $5144238D) and (Dig[6] = $700CFDDC) and (Dig[7] = $CA0599D2) and (Dig[8] = $53436365) and
    (Dig[9] = $F2FB6032)) then
  begin
    Result := False;
    Exit;
  end;
  Q_MixHash('a', Dig);
  if not ((Dig[0] = $A7C1F85E) and (Dig[1] = $2B6FD0D0) and (Dig[2] = $74FB63D2) and (Dig[3] = $FD422D6B) and
    (Dig[4] = $3E16DEC2) and (Dig[5] = $A563C5E7) and (Dig[6] = $46FABC5A) and (Dig[7] = $6DD22B0F) and (Dig[8] = $98F8DAFE) and
    (Dig[9] = $0690D2FF)) then
  begin
    Result := False;
    Exit;
  end;
  S := StringOfChar('a', 200000);
  Q_MixHashInit(ID);
  Q_MixHashUpdate(ID, Pointer(S), 200000);
  Q_MixHashUpdate(ID, Pointer(S), 200000);
  Q_MixHashUpdate(ID, Pointer(S), 200000);
  Q_MixHashUpdate(ID, Pointer(S), 200000);
  Q_MixHashUpdate(ID, Pointer(S), 200000);
  Q_MixHashFinal(ID, Dig);
  if not ((Dig[0] = $30B87BD5) and (Dig[1] = $39F6CC0A) and (Dig[2] = $63237276) and (Dig[3] = $B4E2D835) and
    (Dig[4] = $29BC7CA2) and (Dig[5] = $1D667478) and (Dig[6] = $785C95BD) and (Dig[7] = $A1E4240F) and (Dig[8] = $04B11FA9) and
    (Dig[9] = $C8CEDEDD)) then
  begin
    Result := False;
    Exit;
  end;
  Q_MixHashInit(ID);
  Q_FillRandom(Pointer(S), MixBufferSize, $1DC72E0B);
  Q_MixHashUpdate(ID, Pointer(S), MixBufferSize);
  Q_MixHashFinal(ID, Dig);
  Result :=
    (Dig[0] = $316E05FC) and (Dig[1] = $8EFA384E) and (Dig[2] = $8466B62B) and (Dig[3] = $75623B64) and (Dig[4] = $86A49C3F) and
    (Dig[5] = $02A61F92) and (Dig[6] = $12EF2262) and (Dig[7] = $C194B090) and (Dig[8] = $2672360A) and (Dig[9] = $B7CE0A39);
end;

type
  PRandData = ^TRandData;

  TRandData = record
    MT: TRandVector;
    Index: integer;
    SHAID: TSHAID;
    Ps: integer;
  end;

{$IFDEF CPU32}
procedure IntRandInit(P: Pointer; Seed: longword; Count: cardinal);
asm
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,EAX
         MOV     EAX,EDX
         MOV     ESI,69069
         @@lp:
         MOV     [EDI],EAX
         MUL     ESI
         MOV     [EDI+4],EAX
         MUL     ESI
         MOV     [EDI+8],EAX
         MUL     ESI
         MOV     [EDI+12],EAX
         MUL     ESI
         MOV     [EDI+16],EAX
         MUL     ESI
         MOV     [EDI+20],EAX
         MUL     ESI
         MOV     [EDI+24],EAX
         MUL     ESI
         MOV     [EDI+28],EAX
         MUL     ESI
         ADD     EDI,32
         DEC     ECX
         JNE     @@lp
         POP     ESI
         POP     EDI
end;
{$ELSE}

procedure IntRandInit(P: Pointer; Seed: longword; Count: cardinal);
begin
  ShowMessage('IntRandInit TODO');
end;

{$ENDIF}

procedure Q_RandInit(var ID: TMTID; Seed: longword); overload;
begin
  GetMem(PRandData(ID), SizeOf(TRandData));
  with PRandData(ID)^ do
  begin
    IntRandInit(@MT, Seed, 78);
    Index := 624;
    SHAID := TSHAID(nil);
    Ps := -1;
  end;
end;

procedure Q_RandInit(var ID: TMTID; const InitVector: TRandVector); overload;
begin
  GetMem(PRandData(ID), SizeOf(TRandData));
  with PRandData(ID)^ do
  begin
    Q_CopyLongs(@InitVector, @MT, 624);
    Index := 624;
    SHAID := TSHAID(nil);
    Ps := -1;
  end;
end;

{$IFDEF CPU32}
procedure IntCAST6RandEncrypt(ID: TCASTID; P: Pointer);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         PUSH    EDX
         MOV     EDI,EDX
         MOV     ESI,62
         @@lp:
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntCAST6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+8]
         CALL    IntCAST6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+16]
         CALL    IntCAST6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+24]
         CALL    IntCAST6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+32]
         CALL    IntCAST6EncryptECB
         ADD     EDI,40
         DEC     ESI
         JNE     @@lp
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntCAST6EncryptECB
         POP     ESI
         LEA     EDX,[ESP-16]
         MOV     ESP,EDX
         MOV     EAX,[EDI+8]
         MOV     [EDX],EAX
         MOV     EAX,[EDI+12]
         MOV     [EDX+4],EAX
         MOV     EAX,[ESI]
         MOV     [EDX+8],EAX
         MOV     EAX,[ESI+4]
         MOV     [EDX+12],EAX
         MOV     EAX,EBX
         MOV     EBX,EDX
         CALL    IntCAST6EncryptECB
         MOV     EAX,[EBX]
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+4]
         MOV     [EDI+12],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+4],EAX
         XOR     EAX,EAX
         MOV     [EBX],EAX
         MOV     [EBX+4],EAX
         MOV     [EBX+8],EAX
         MOV     [EBX+12],EAX
         ADD     ESP,16
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure IntCAST6RandEncrypt(ID: TCASTID; P: Pointer);
begin
  ShowMessage('IntCAST6RandEncrypt TODO');
end;

{$ENDIF}

procedure Q_RandCAST6Update(ID: TMTID; const S: String); overload;
var
  L: longword;
  CsID: TCASTID;
  P: pbyte;
begin
  L := Length(S);
  if L <> 0 then
  begin
    P := Pointer(S);
    GetMem(PCAST6Data(CsID), SizeOf(TCAST6Data));
    while L > 32 do
    begin
      IntCAST6KeySchedule(CsID, P, 32);
      IntCAST6RandEncrypt(CsID, PRandData(ID));
      Inc(P, 32);
      Dec(L, 32);
    end;
    IntCAST6KeySchedule(CsID, P, L);
    with PRandData(ID)^ do
    begin
      IntCAST6RandEncrypt(CsID, @MT);
      Index := 624;
      Ps := -1;
    end;
    Q_CAST6Done(CsID);
  end;
end;

procedure Q_RandCAST6Update(ID: TMTID; P: Pointer; L: cardinal); overload;
var
  CsID: TCASTID;
begin
  if L <> 0 then
  begin
    GetMem(PCAST6Data(CsID), SizeOf(TCAST6Data));
    while L > 32 do
    begin
      IntCAST6KeySchedule(CsID, P, 32);
      IntCAST6RandEncrypt(CsID, PRandData(ID));
      Inc(pbyte(P), 32);
      Dec(L, 32);
    end;
    IntCAST6KeySchedule(CsID, P, L);
    with PRandData(ID)^ do
    begin
      IntCAST6RandEncrypt(CsID, @MT);
      Index := 624;
      Ps := -1;
    end;
    Q_CAST6Done(CsID);
  end;
end;

procedure Q_RandCAST6Update(ID: TMTID; const Digest: TSHA1Digest); overload;
var
  CsID: TCASTID;
begin
  Q_CAST6Init(CsID, @Digest, SizeOf(TSHA1Digest));
  with PRandData(ID)^ do
  begin
    IntCAST6RandEncrypt(CsID, @MT);
    Index := 624;
    Ps := -1;
  end;
  Q_CAST6Done(CsID);
end;

{$IFDEF CPU32}
procedure IntRC6RandEncrypt(ID: TRC6ID; P: Pointer);
asm
         PUSH    EBX
         PUSH    ESI
         MOV     EBX,EAX
         PUSH    EDI
         PUSH    EDX
         MOV     EDI,EDX
         MOV     ESI,62
         @@lp:
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntRC6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+8]
         CALL    IntRC6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+16]
         CALL    IntRC6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+24]
         CALL    IntRC6EncryptECB
         MOV     EAX,EBX
         LEA     EDX,[EDI+32]
         CALL    IntRC6EncryptECB
         ADD     EDI,40
         DEC     ESI
         JNE     @@lp
         MOV     EAX,EBX
         MOV     EDX,EDI
         CALL    IntRC6EncryptECB
         POP     ESI
         LEA     EDX,[ESP-16]
         MOV     ESP,EDX
         MOV     EAX,[EDI+8]
         MOV     [EDX],EAX
         MOV     EAX,[EDI+12]
         MOV     [EDX+4],EAX
         MOV     EAX,[ESI]
         MOV     [EDX+8],EAX
         MOV     EAX,[ESI+4]
         MOV     [EDX+12],EAX
         MOV     EAX,EBX
         MOV     EBX,EDX
         CALL    IntRC6EncryptECB
         MOV     EAX,[EBX]
         MOV     [EDI+8],EAX
         MOV     EAX,[EBX+4]
         MOV     [EDI+12],EAX
         MOV     EAX,[EBX+8]
         MOV     [ESI],EAX
         MOV     EAX,[EBX+12]
         MOV     [ESI+4],EAX
         XOR     EAX,EAX
         MOV     [EBX],EAX
         MOV     [EBX+4],EAX
         MOV     [EBX+8],EAX
         MOV     [EBX+12],EAX
         ADD     ESP,16
         POP     EDI
         POP     ESI
         POP     EBX
end;
{$ELSE}

procedure IntRC6RandEncrypt(ID: TRC6ID; P: Pointer);
begin
  ShowMessage('IntRC6RandEncrypt TODO');
end;

{$ENDIF}

procedure Q_RandRC6Update(ID: TMTID; const S: String); overload;
var
  L: longword;
  RcID: TRC6ID;
  P: pbyte;
begin
  L := Length(S);
  if L <> 0 then
  begin
    P := Pointer(S);
    GetMem(PRC6Data(RcID), SizeOf(TRC6Data));
    while L > 48 do
    begin
      IntRC6Init(RcID, P, 48);
      IntRC6RandEncrypt(RcID, PRandData(ID));
      Inc(P, 48);
      Dec(L, 48);
    end;
    IntRC6Init(RcID, P, L);
    with PRandData(ID)^ do
    begin
      IntRC6RandEncrypt(RcID, @MT);
      Index := 624;
      Ps := -1;
    end;
    Q_RC6Done(RcID);
  end;
end;

procedure Q_RandRC6Update(ID: TMTID; P: Pointer; L: cardinal); overload;
var
  RcID: TRC6ID;
begin
  if L <> 0 then
  begin
    GetMem(PRC6Data(RcID), SizeOf(TRC6Data));
    while L > 48 do
    begin
      IntRC6Init(RcID, P, 48);
      IntRC6RandEncrypt(RcID, PRandData(ID));
      Q_RC6Done(RcID);
      Inc(pbyte(P), 48);
      Dec(L, 48);
    end;
    IntRC6Init(RcID, P, L);
    with PRandData(ID)^ do
    begin
      IntRC6RandEncrypt(RcID, @MT);
      Index := 624;
      Ps := -1;
    end;
    Q_RC6Done(RcID);
  end;
end;

procedure Q_RandRC6Update(ID: TMTID; const Digest: TSHA1Digest); overload;
var
  RcID: TRC6ID;
begin
  Q_RC6Init(RcID, @Digest, SizeOf(TSHA1Digest));
  with PRandData(ID)^ do
  begin
    IntRC6RandEncrypt(RcID, @MT);
    Index := 624;
    Ps := -1;
  end;
  Q_RC6Done(RcID);
end;

procedure Q_RandRC6Update(ID: TMTID; const Digest: TMixDigest); overload;
var
  RcID: TRC6ID;
begin
  Q_RC6Init(RcID, @Digest, SizeOf(TMixDigest));
  with PRandData(ID)^ do
  begin
    IntRC6RandEncrypt(RcID, @MT);
    Index := 624;
    Ps := -1;
  end;
  Q_RC6Done(RcID);
end;

procedure Q_RandGetVector(ID: TMTID; var Vector: TRandVector);
begin
  with PRandData(ID)^ do
  begin
    Q_CopyLongs(@MT, @Vector, 624);
    Index := 624;
    Ps := -1;
  end;
end;

procedure Q_RandSetVector(ID: TMTID; const Vector: TRandVector);
begin
  with PRandData(ID)^ do
  begin
    Q_CopyLongs(@Vector, @MT, 624);
    Index := 624;
    Ps := -1;
  end;
end;

{$IFDEF CPU32}
function Q_RandNext(ID: TMTID): longword;
asm
         MOV     ECX,[EAX].TRandData.Index
         CMP     ECX,624
         JE      @@mk
         @@nx:
         MOV     EDX,[EAX+ECX*4]
         INC     ECX
         MOV     [EAX].TRandData.Index,ECX
         MOV     EAX,EDX
         SHR     EDX,11
         XOR     EAX,EDX
         MOV     EDX,EAX
         SHL     EAX,7
         AND     EAX,$9D2C5680
         XOR     EDX,EAX
         MOV     EAX,EDX
         SHL     EDX,15
         AND     EDX,$EFC60000
         XOR     EDX,EAX
         MOV     EAX,EDX
         SHR     EDX,18
         XOR     EAX,EDX
         RET
         @@ku:
         DD      0,$9908B0DF
         @@mk:
         PUSH    EDI
         PUSH    ESI
         PUSH    EBX
         MOV     EDI,EAX
         MOV     ECX,227
         PUSH    EAX
         @@lp1:
         MOV     EAX,[EDI]
         MOV     EDX,[EDI+4]
         AND     EAX,$80000000
         AND     EDX,$7FFFFFFF
         OR      EAX,EDX
         MOV     EDX,EAX
         MOV     EBX,[EDI+1588]
         SHR     EAX,1
         AND     EDX,1
         XOR     EBX,EAX
         XOR     EBX,DWORD PTR @@ku[EDX*4]
         MOV     [EDI],EBX
         ADD     EDI,4
         DEC     ECX
         JNE     @@lp1
         MOV     ECX,198
         MOV     EAX,[EDI]
         @@lp2:
         MOV     EDX,[EDI+4]
         MOV     ESI,EDX
         AND     EDX,$7FFFFFFF
         AND     EAX,$80000000
         OR      EAX,EDX
         MOV     EBX,[EDI-908]
         MOV     EDX,EAX
         AND     EDX,1
         SHR     EAX,1
         XOR     EBX,EAX
         XOR     EBX,DWORD PTR @@ku[EDX*4]
         MOV     [EDI],EBX
         MOV     EDX,[EDI+8]
         MOV     EAX,EDX
         AND     EDX,$7FFFFFFF
         AND     ESI,$80000000
         OR      ESI,EDX
         MOV     EBX,[EDI-904]
         MOV     EDX,ESI
         AND     EDX,1
         SHR     ESI,1
         XOR     EBX,ESI
         XOR     EBX,DWORD PTR @@ku[EDX*4]
         MOV     [EDI+4],EBX
         ADD     EDI,8
         DEC     ECX
         JNE     @@lp2
         AND     EAX,$80000000
         POP     EDI
         MOV     EDX,[EDI]
         AND     EDX,$7FFFFFFF
         OR      EAX,EDX
         MOV     EBX,[EDI+1584]
         MOV     EDX,EAX
         AND     EDX,1
         SHR     EAX,1
         XOR     EBX,EAX
         XOR     EBX,DWORD PTR @@ku[EDX*4]
         MOV     [EDI+2492],EBX
         MOV     EAX,EDI
         POP     EBX
         POP     ESI
         POP     EDI
         JMP     @@nx
end;
{$ELSE}

function Q_RandNext(ID: TMTID): longword;
begin
  ShowMessage('Q_RandNext TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RandUniform(ID: TMTID): double;
const
  InvMax: double = 1 / $4000000000000000;
asm
         PUSH    EAX
         CALL    Q_RandNext
         AND     EAX,$3FFFFFFF
         MOV     EDX,[ESP]
         MOV     [ESP],EAX
         MOV     EAX,EDX
         CALL    Q_RandNext
         PUSH    EAX
         FILD    QWORD PTR [ESP]
         ADD     ESP,8
         FMUL    InvMax
end;
{$ELSE}

function Q_RandUniform(ID: TMTID): double;
begin
  ShowMessage('Q_RandUniform TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
function Q_RandUInt32(ID: TMTID; Range: cardinal): cardinal;
asm
         PUSH    EDX
         CALL    Q_RandNext
         POP     EDX
         MUL     EDX
         MOV     EAX,EDX
end;
{$ELSE}

function Q_RandUInt32(ID: TMTID; Range: cardinal): cardinal;
begin
  ShowMessage('Q_RandUInt32 TODO');
end;

{$ENDIF}

function Q_RandUInt64(ID: TMTID; Range: int64): int64;
var
  X: array[0..1] of longword;
  C: comp absolute X;
begin
  X[0] := Q_RandNext(ID);
  X[1] := Q_RandNext(ID) and $7FFFFFFF;
  Result := Round(C - Int(C / Range) * Range);
end;

{$IFDEF CPU32}
function Q_RandGauss(ID: TMTID; ExtraNumber: Pointer): double;
const
  InvMax: double = 1 / $2000000000000000;
  XX1: double = 1;
  XX2: double = -2;
asm
         PUSH    EBX
         PUSH    EDI
         PUSH    ESI
         LEA     EDI,[ESP-24]
         SUB     ESP,32
         AND     EDI,$FFFFFFF8
         PUSH    EDX
         MOV     EBX,EAX
         @@lp:
         MOV     EAX,EBX
         CALL    Q_RandNext
         AND     EAX,$3FFFFFFF
         MOV     ESI,EAX
         MOV     EAX,EBX
         CALL    Q_RandNext
         PUSH    ESI
         PUSH    EAX
         FILD    QWORD PTR [ESP]
         FMUL    InvMax
         FSUB    XX1
         FST     QWORD PTR [EDI+8]
         MOV     EAX,EBX
         FMUL    ST(0),ST(0)
         CALL    Q_RandNext
         AND     EAX,$3FFFFFFF
         MOV     ESI,EAX
         MOV     EAX,EBX
         CALL    Q_RandNext
         MOV     [ESP],EAX
         MOV     [ESP+4],ESI
         FILD    QWORD PTR [ESP]
         FMUL    InvMax
         FSUB    XX1
         ADD     ESP,8
         FST     QWORD PTR [EDI+16]
         FMUL    ST(0),ST(0)
         FADDP
         FCOM    XX1
         FSTSW   AX
         FSTP    QWORD PTR [EDI]
         SAHF
         JNB     @@lp
         FLDLN2
         FLD     QWORD PTR [EDI]
         FYL2X
         FMUL    XX2
         FDIV    QWORD PTR [EDI]
         POP     EDX
         FSQRT
         TEST    EDX,EDX
         JE      @@qt
         FLD     ST(0)
         FMUL    QWORD PTR [EDI+16]
         FSTP    QWORD PTR [EDX]
         @@qt:
         FMUL    QWORD PTR [EDI+8]
         ADD     ESP,32
         POP     ESI
         POP     EDI
         POP     EBX
end;
{$ELSE}

function Q_RandGauss(ID: TMTID; ExtraNumber: Pointer): double;
begin
  ShowMessage('Q_RandGauss TODO');
end;

{$ENDIF}

function Q_SecureRandNext(ID: TMTID): longword;
begin
  with PRandData(ID)^ do
  begin
    if Ps >= 0 then
    begin
      with PSHA1Data(SHAID)^ do
        Result := Hash[Ps];
      Dec(Ps);
    end
    else
    begin
      if Pointer(SHAID) <> nil then
        IntSHA1Init(SHAID)
      else
        Q_SHA1Init(SHAID);
      with PSHA1Data(SHAID)^ do
      begin
        PLong(@Buffer[0])^ := Q_RandNext(ID);
        PLong(@Buffer[4])^ := Q_RandNext(ID);
        PLong(@Buffer[8])^ := Q_RandNext(ID);
        PLong(@Buffer[12])^ := Q_RandNext(ID);
        PLong(@Buffer[16])^ := Q_RandNext(ID);
        PLong(@Buffer[20])^ := Q_RandNext(ID);
        PLong(@Buffer[24])^ := Q_RandNext(ID);
        PLong(@Buffer[28])^ := Q_RandNext(ID);
        PLong(@Buffer[32])^ := Q_RandNext(ID);
        PLong(@Buffer[36])^ := Q_RandNext(ID);
        PLong(@Buffer[40])^ := Q_RandNext(ID);
        PLong(@Buffer[44])^ := Q_RandNext(ID);
        PLong(@Buffer[48])^ := Q_RandNext(ID);
        PLong(@Buffer[52])^ := Q_RandNext(ID);
        Buffer[55] := $80;
        Buffer[62] := $01;
        Buffer[63] := $B8;
        IntSHA1Compress(SHAID);
        Result := Hash[4];
      end;
      Ps := 3;
    end;
  end;
end;

{$IFDEF CPU32}
procedure Q_RandFill(ID: TMTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,ECX
         AND     ECX,7
         MOV     ESI,EAX
         MOV     EBX,EDX
         PUSH    ECX
         SHR     EDI,3
         JE      @@nx
         @@lp:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         ADD     EBX,4
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         ADD     EBX,4
         DEC     EDI
         JNE     @@lp
         @@nx:
         POP     ECX
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         DD      @@t4, @@t5, @@t6, @@t7
         @@t1:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     BYTE PTR [EBX],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t2:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     WORD PTR [EBX],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t3:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     WORD PTR [EBX],AX
         SHR     EAX,16
         MOV     BYTE PTR [EBX+2],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t4:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t5:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     BYTE PTR [EBX+4],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t6:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     WORD PTR [EBX+4],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t7:
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_RandNext
         MOV     WORD PTR [EBX+4],AX
         SHR     EAX,16
         MOV     BYTE PTR [EBX+6],AL
         @@qt:
         POP     ESI
         POP     EDI
         POP     EBX
end;
{$ELSE}

procedure Q_RandFill(ID: TMTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_RandFill TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_SecureRandFill(ID: TMTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,ECX
         MOV     EBX,EDX
         AND     ECX,7
         MOV     ESI,EAX
         PUSH    ECX
         SHR     EDI,3
         JE      @@nx
         @@lp:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         ADD     EBX,4
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         ADD     EBX,4
         DEC     EDI
         JNE     @@lp
         @@nx:
         POP     ECX
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         DD      @@t4, @@t5, @@t6, @@t7
         @@t1:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     BYTE PTR [EBX],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t2:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     WORD PTR [EBX],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t3:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     WORD PTR [EBX],AX
         SHR     EAX,16
         MOV     BYTE PTR [EBX+2],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t4:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t5:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     BYTE PTR [EBX+4],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t6:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     WORD PTR [EBX+4],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t7:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         MOV     WORD PTR [EBX+4],AX
         SHR     EAX,16
         MOV     BYTE PTR [EBX+6],AL
         @@qt:
         POP     ESI
         POP     EDI
         POP     EBX
end;
{$ELSE}

procedure Q_SecureRandFill(ID: TMTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_SecureRandFill TODO');
end;

{$ENDIF}

{$IFDEF CPU32}
procedure Q_SecureRandXOR(ID: TMTID; P: Pointer; L: cardinal);
asm
         PUSH    EBX
         PUSH    EDI
         PUSH    ESI
         MOV     EDI,ECX
         MOV     EBX,EDX
         AND     ECX,7
         MOV     ESI,EAX
         PUSH    ECX
         SHR     EDI,3
         JE      @@nx
         @@lp:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         ADD     EBX,4
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         ADD     EBX,4
         DEC     EDI
         JNE     @@lp
         @@nx:
         POP     ECX
         JMP     DWORD PTR @@tV[ECX*4]
         @@tV:
         DD      @@qt, @@t1, @@t2, @@t3
         DD      @@t4, @@t5, @@t6, @@t7
         @@t1:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     BYTE PTR [EBX],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t2:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     WORD PTR [EBX],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t3:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     WORD PTR [EBX],AX
         SHR     EAX,16
         XOR     BYTE PTR [EBX+2],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t4:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t5:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     BYTE PTR [EBX+4],AL
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t6:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     WORD PTR [EBX+4],AX
         POP     ESI
         POP     EDI
         POP     EBX
         RET
         @@t7:
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     [EBX],EAX
         MOV     EAX,ESI
         CALL    Q_SecureRandNext
         XOR     WORD PTR [EBX+4],AX
         SHR     EAX,16
         XOR     BYTE PTR [EBX+6],AL
         @@qt:
         POP     ESI
         POP     EDI
         POP     EBX
end;
{$ELSE}

procedure Q_SecureRandXOR(ID: TMTID; P: Pointer; L: cardinal);
begin
  ShowMessage('Q_SecureRandXOR TODO');
end;

{$ENDIF}

procedure Q_RandDone(ID: TMTID);
begin
  with PRandData(ID)^ do
    if SHAID <> TSHAID(nil) then
    begin
      IntSHA1Clear(SHAID);
      FreeMem(PSHA1Data(SHAID));
    end;
  Q_ZeroMem(PRandData(ID), SizeOf(TRandData));
  FreeMem(PRandData(ID));
end;

type
  PDH4253Data = ^TDH4253Data;
  TDH4253Data = array[0..265] of longword;

procedure IntDH4253_SPLIT(X, Y: PDH4253Data);
asm
         LEA     ESI,[EAX+532]
         MOV     ECX,33
         MOV     EAX,[ESI-4]
         MOV     EBX,EAX
         AND     EAX,$1FFFFFFF
         MOV     [ESI-4],EAX
         SHR     EBX,29
         @@lp:
         MOV     EAX,[ESI]
         MOV     EDI,EAX
         SHL     EAX,3
         OR      EAX,EBX
         SHR     EDI,29
         MOV     [EDX],EAX
         MOV     EAX,[ESI+4]
         MOV     EBX,EAX
         SHL     EAX,3
         OR      EAX,EDI
         SHR     EBX,29
         MOV     [EDX+4],EAX
         MOV     EAX,[ESI+8]
         MOV     EDI,EAX
         SHL     EAX,3
         OR      EAX,EBX
         SHR     EDI,29
         MOV     [EDX+8],EAX
         MOV     EAX,[ESI+12]
         MOV     EBX,EAX
         SHL     EAX,3
         OR      EAX,EDI
         SHR     EBX,29
         MOV     [EDX+12],EAX
         ADD     ESI,16
         ADD     EDX,16
         DEC     ECX
         JNE     @@lp
         MOV     EAX,[ESI]
         SHL     EAX,3
         OR      EAX,EBX
         MOV     [EDX],EAX
end;

procedure IntDH4253_ADD(X, Y: PDH4253Data);
asm
         MOV     EDI,EAX
         MOV     ESI,EDX
         XOR     EBX,EBX
         MOV     ECX,19
         @@lp1:
         SHR     EBX,1
         MOV     EBP,[EDI]
         ADC     EBP,[ESI]
         MOV     [EDI],EBP
         MOV     EBP,[EDI+4]
         ADC     EBP,[ESI+4]
         MOV     [EDI+4],EBP
         MOV     EBP,[EDI+8]
         ADC     EBP,[ESI+8]
         MOV     [EDI+8],EBP
         MOV     EBP,[EDI+12]
         ADC     EBP,[ESI+12]
         MOV     [EDI+12],EBP
         MOV     EBP,[EDI+16]
         ADC     EBP,[ESI+16]
         MOV     [EDI+16],EBP
         MOV     EBP,[EDI+20]
         ADC     EBP,[ESI+20]
         MOV     [EDI+20],EBP
         MOV     EBP,[EDI+24]
         ADC     EBP,[ESI+24]
         MOV     [EDI+24],EBP
         ADC     EBX,0
         ADD     EDI,28
         ADD     ESI,28
         DEC     ECX
         JNE     @@lp1
         MOV     ESI,[EAX+528]
         TEST    ESI,$20000000
         JNE     @@sb
         XOR     ESI,$1FFFFFFF
         JNE     @@qt
         MOV     ECX,131
         @@lp2:
         MOV     ESI,[EAX+ECX*4]
         XOR     ESI,$FFFFFFFF
         JNE     @@qt
         DEC     ECX
         JNS     @@lp2
         @@sb:
         MOV     ECX,22
         XOR     EDX,EDX
         XOR     EBX,EBX
         NOT     EDX
         @@lp3:
         SHR     EBX,1
         MOV     EBP,[EAX]
         SBB     EBP,EDX
         MOV     [EAX],EBP
         MOV     EBP,[EAX+4]
         SBB     EBP,EDX
         MOV     [EAX+4],EBP
         MOV     EBP,[EAX+8]
         SBB     EBP,EDX
         MOV     [EAX+8],EBP
         MOV     EBP,[EAX+12]
         SBB     EBP,EDX
         MOV     [EAX+12],EBP
         MOV     EBP,[EAX+16]
         SBB     EBP,EDX
         MOV     [EAX+16],EBP
         MOV     EBP,[EAX+20]
         SBB     EBP,EDX
         MOV     [EAX+20],EBP
         ADC     EBX,0
         ADD     EAX,24
         DEC     ECX
         JNE     @@lp3
         MOV     EBP,[EAX]
         SUB     EBP,$1FFFFFFF
         SUB     EBP,EBX
         MOV     [EAX],EBP
         @@qt:
end;

{$IFDEF CPU32}
procedure IntDH4253_MUL(X, Y, Z, T: PDH4253Data);
asm
         PUSH    ESI
         PUSH    EDI
         PUSH    EBX
         PUSH    EBP
         PUSH    EAX
         PUSH    EDX
         MOV     ESI,EDX
         MOV     EDI,ECX
         PUSH    ECX
         MOV     EBP,[EAX]
         MOV     ECX,19
         XOR     EBX,EBX
         @@lp1:
         MOV     EAX,[ESI]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+4]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+4],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+8]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+8],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+12]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+12],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+16]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+16],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+20]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+20],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+24]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+24],EAX
         ADC     EBX,0
         ADD     ESI,28
         ADD     EDI,28
         DEC     ECX
         JNE     @@lp1
         MOV     [EDI],EBX
         LEA     EAX,[EDI+4]
         XOR     EDX,EDX
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         ADD     EAX,128
         CALL    IntFill32
         MOV     [EAX+128],EDX
         MOV     [EAX+132],EDX
         MOV     [EAX+136],EDX
         MOV     [EAX+140],EDX
         PUSH    EDX
         MOV     EAX,132
         PUSH    EAX
         @@lp2:
         MOV     EAX,[ESP+4]
         MOV     EDX,[ESP+16]
         ADD     EAX,4
         MOV     EBP,[EDX+EAX]
         MOV     [ESP+4],EAX
         MOV     ESI,[ESP+12]
         MOV     EDI,[ESP+44]
         MOV     ECX,19
         XOR     EBX,EBX
         @@lp3:
         MOV     EAX,[ESI]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+4]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+4],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+8]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+8],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+12]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+12],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+16]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+16],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+20]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+20],EAX
         ADC     EBX,0
         MOV     EAX,[ESI+24]
         MUL     EBP
         ADD     EAX,EBX
         MOV     EBX,EDX
         MOV     [EDI+24],EAX
         ADC     EBX,0
         ADD     ESI,28
         ADD     EDI,28
         DEC     ECX
         JNE     @@lp3
         MOV     [EDI],EBX
         MOV     ESI,[ESP+44]
         MOV     EDI,[ESP+8]
         XOR     EBX,EBX
         MOV     EAX,[ESP+4]
         MOV     ECX,19
         ADD     EDI,EAX
         @@lp4:
         SHR     EBX,1
         MOV     EAX,[EDI]
         ADC     EAX,[ESI]
         MOV     [EDI],EAX
         MOV     EAX,[EDI+4]
         ADC     EAX,[ESI+4]
         MOV     [EDI+4],EAX
         MOV     EAX,[EDI+8]
         ADC     EAX,[ESI+8]
         MOV     [EDI+8],EAX
         MOV     EAX,[EDI+12]
         ADC     EAX,[ESI+12]
         MOV     [EDI+12],EAX
         MOV     EAX,[EDI+16]
         ADC     EAX,[ESI+16]
         MOV     [EDI+16],EAX
         MOV     EAX,[EDI+20]
         ADC     EAX,[ESI+20]
         MOV     [EDI+20],EAX
         MOV     EAX,[EDI+24]
         ADC     EAX,[ESI+24]
         MOV     [EDI+24],EAX
         ADC     EBX,0
         ADD     ESI,28
         ADD     EDI,28
         DEC     ECX
         JNE     @@lp4
         MOV     EAX,[EDI]
         ADD     EAX,[ESI]
         ADD     EAX,EBX
         MOV     [EDI],EAX
         DEC     DWORD PTR [ESP]
         JNE     @@lp2
         MOV     EAX,[ESP+8]
         MOV     EDX,[ESP+44]
         CALL    IntDH4253_SPLIT
         MOV     EAX,[ESP+8]
         MOV     EDX,[ESP+44]
         CALL    IntDH4253_ADD
         ADD     ESP,20
         POP     EBP
         POP     EBX
         POP     EDI
         POP     ESI
end;
{$ELSE}

procedure IntDH4253_MUL(X, Y, Z, T: PDH4253Data);
begin
  ShowMessage('IntDH4253_MUL TODO');
end;

{$ENDIF}

procedure Q_DHCreatePublicKey(G, PrivateKey: PDHKey4253; PublicKey: PDHKey4253);
type
  PDH4253Arr = ^TDH4253Arr;
  TDH4253Arr = array[0..3] of TDH4253Data;
var
  P: PDH4253Arr;
  PPE, PPY, PPQ, PPD: PDH4253Data;
  I: integer;
begin
  GetMem(P, SizeOf(TDH4253Arr));
  PPE := @P[0];
  PPY := @P[1];
  PPQ := @P[2];
  PPD := @P[3];
  Q_CopyLongs(G, PPQ, 133);
  PPQ^[132] := PPQ^[132] and $1FFFFFFF;
  if PrivateKey^[0] and 1 = 0 then
  begin
    Q_FillLong(0, @PPY^[1], 132);
    PPY^[0] := 1;
  end
  else
    Q_CopyLongs(PPQ, PPY, 133);
  for I := 1 to 4252 do
  begin
    IntDH4253_MUL(PPQ, PPQ, PPE, PPD);
    Q_Exchange(PPQ, PPE);
    if Q_BitTest(PrivateKey, I) then
    begin
      IntDH4253_MUL(PPY, PPQ, PPE, PPD);
      Q_Exchange(PPY, PPE);
    end;
  end;
  Q_CopyLongs(PPY, PublicKey, 133);
  Q_FillLong(0, P, 1064);
  FreeMem(P);
end;

procedure Q_DHGetCipherKey(PublicKey, PrivateKey: PDHKey4253; CipherKey: Pointer; KeySize: integer);
var
  InterKey: TDHKey4253;
  ID: TMTID;
begin
  Q_DHCreatePublicKey(PublicKey, PrivateKey, @InterKey);
  Q_RandInit(ID);
  Q_RandCAST6Update(ID, @InterKey, 532);
  Q_FillLong(0, @InterKey, 133);
  Q_SecureRandFill(ID, CipherKey, KeySize);
  Q_RandDone(ID);
end;

function Q_DHSelfTest: boolean;
type
  TSampleKey = array[0..7] of longword;
const
  S: TSampleKey =
    ($5B7C29C9, $5CA4433F, $B3AF3C32, $4861E34C, $0CCA7650, $A3625CCD, $F40D998A, $0A92E7D1);
var
  A, B, C, Y: TDHKey4253;
  K: TSampleKey;
begin
  Q_FillRandom(@A, 532, $AB3F609D);
  Q_FillRandom(@B, 532, $50D12BE2);
  Q_FillRandom(@C, 532, $E6583F27);
  Q_DHCreatePublicKey(@A, @B, @Y);
  Q_DHGetCipherKey(@Y, @C, @K, 32);
  Result := Q_CompLongs(@K, @S, 8);
end;

{$IFDEF USE_DYNAMIC_TABLES}

initialization
  Int256Chars(@ToUpperChars);
  CharToOemBuff(@ToUpperChars,@ToOemChars,256);
  OemToCharBuff(@ToUpperChars,@ToAnsiChars,256);
  CharUpperBuff(@ToUpperChars,256);
  Int256Chars(@ToLowerChars);
  CharLowerBuff(@ToLowerChars,256);


{$ENDIF}

end.
