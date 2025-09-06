{
From the book Algorithms + Data Structures = Programs, by Niklaus Wirth (1976)

Chapter 5, page 314

Program 5.4 PL/O Parser

OCRed, cleaned, fixed, formatted, converted to modern Free Pascal
and tested by Daniel Toffetti.
Formatted with PTop (https://wiki.freepascal.org/PTop)
}

{$modeSwitch nonlocalgoto+}

program PLO {(input, output)};
{PL/0 compiler, syntax analysis only}

{label 99;}

const norw = 11;  {no. of reserved words}
    txmax = 100;  {length of indentifier table}
    nmax = 14;    {max. no of digits in numbers}
    al = 10;      {length of identifiers}

type symbol =
        (nul, ident, number, plus, minus, times, slash, oddsym,
        eql, neq, lss, leq, gtr, geq, lparen, rparen, comma, semicolon,
        period, becomes, beginsym, endsym, ifsym, thensym,
        whilesym, dosym, callsym, constsym, varsym, procsym);
    alfa = packed array [1..al] of char;
    objkind = (constant, variable, proc);

var ch: char;     {last character read}
    sym: symbol;  {last symbol read}
    id: alfa;     {last identifier read}
    num: integer; {last number read}
    cc: integer;  {character count}
    ll: integer;  {line length}
    kk: integer;
    line: array [1..81] of char;
    a: alfa;
    word: array [1..norw] of alfa;
    wsym: array [1..norw] of symbol;
    ssym: array [char] of symbol;
    table: array [0..txmax] of 
              record
                  name: alfa;
                  kind: objkind
              end ;

    inputFile: Text;
    fileName: string;

procedure cleanExit;
begin
    writeln;
    close(inputFile);
    halt
end {cleanExit} ;

procedure error (n: integer);
begin
    write (' ':cc, '^', n:2);
    case n of 
         1: writeln (' Use = instead of :=.');
         2: writeln (' = must be followed by a number.');
         3: writeln (' Identifier must be followed by =.');
         4: writeln (' "const", "var", "procedure" must be followed by an identifier.');
         5: writeln (' Semicolon or comma missing.');
         6: writeln (' Incorrect symbol after procedure declaration.');
         7: writeln (' Statement expected.');
         8: writeln (' Incorrect symbol after statement part in block.');
         9: writeln (' Period expected.');
        10: writeln (' Semicolon between statements is missing.');
        11: writeln (' Undeclared identifier.');
        12: writeln (' Assignment to constant or procedure is not allowed.');
        13: writeln (' Assignment operator := expected.');
        14: writeln (' "call" must be followed by an identifier.');
        15: writeln (' Call of a constant or a variable is meaningless.');
        16: writeln (' "then" expected.');
        17: writeln (' Semicolon or "end" expected.');
        18: writeln (' "do" expected.');
        19: writeln (' Incorrect symbol following statement.');
        20: writeln (' Relational operator expected.');
        21: writeln (' Expression must not contain a procedure identifier.');
        22: writeln (' Right parenthesis missing.');
        23: writeln (' The preceding factor cannot be followed by this symbol.');
        24: writeln (' An expression cannot begin with this symbol.');
        30: writeln (' This number is too large.');
    end;
    cleanExit() { goto 99 }
end {error};

procedure getsym;

    var i, j, k: integer;

    procedure getch;
    begin
        if cc = ll then
        begin
            if eof(inputFile) then
            begin
                write ('PROGRAM INCOMPLETE');
                cleanExit() { goto 99 }
            end;
            ll := 0;
            cc := 0;
            write(' ');
            while not eoln(inputFile) do
            begin
                ll := ll + 1;
                read(inputFile, ch);
                //write(ch);
                line[ll] := ch
            end;
            writeln;
            ll := ll + 1;
            read(inputFile, line[ll])
        end;
        cc := cc + 1;
        ch := line[cc]
    end {getch};

begin {getsym}
    while (ch = ' ') or (ch = chr(10)) or (ch = chr(13)) do
        getch;
    if ch in ['A'..'Z'] then
    begin {identifier or reserved word}
        k := 0;
        repeat
            if k < al then
            begin
                k := k + 1;
                a[k] := ch
            end;
            getch
        until not(ch in ['A'..'Z', '0'..'9']);
        if k >= kk then
            kk := k
        else
            repeat
                a[kk] := ' ';
                kk := kk - 1
            until kk = k;
        id := a;
        i := 1;
        j := norw;
        repeat
            k := (i + j) div 2;
            if id <= word[k] then
                j := k-1;
            if id >= word[k] then
                i := k+1
        until i > j;
        if i - 1 > j then
            sym := wsym[k]
        else
            sym := ident
    end
    else
    if ch in ['0'..'9'] then
    begin {number}
        k := 0;
        num := 0;
        sym := number;
        repeat
            num := 10 * num + (ord(ch) - ord('0'));
            k := k + 1;
            getch
        until not (ch in ['0'..'9']);
        if k > nmax then
            error(30)
    end
    else
    if ch = ':' then
    begin
        getch;
        if ch = '=' then
        begin
            sym := becomes;
            getch
        end
        else sym := nul;
    end
    else
    begin
        sym := ssym[ch];
        getch
    end;
    // Following output is added for debugging
    write(sym, ' ');
    if sym = ident then
        writeln(id)
    else if sym = number then
        writeln(num)
    else
        writeln
end {getsym} ;

procedure block (tx: integer);

    procedure enter (k: objkind);
    begin {enter objkind into table}
        tx := tx + 1;
        with table[tx] do
        begin
            name := id;
            kind := k;
        end
    end {enter} ;

    function position (id: alfa): integer;
        var i: integer;
    begin { find identifier id in table}
        table[0].name := id;
        i := tx;
        while table[i].name <> id do
            i := i - 1;
        position := i
    end { position} ;

    procedure constdeclaration;
    begin
        if sym = ident then
        begin
            getsym;
            if sym = eql then
            begin
                getsym;
                if sym = number then
                begin
                    enter(constant);
                    getsym
                end
                else
                    error(2)
            end
            else
                error(3)
        end
        else
            error(4)
    end {constdeclaration} ;

    procedure vardeclaration;
    begin
        if sym = ident then
        begin
            enter(variable);
            getsym
        end
        else
            error(4)
    end {vardeclaration} ;

    procedure statement;
        var i: integer;

        procedure expression;

            procedure term;

                procedure factor;
                    var i: integer;
                begin
                    if sym = ident then
                    begin
                        i := position(id);
                        if i = 0 then
                            error (11)
                        else
                            if table[i].kind = proc then
                                error (21);
                        getsym
                    end
                    else
                    if sym = number then
                    begin
                        getsym
                    end
                    else
                    if sym = lparen then
                    begin
                        getsym;
                        expression;
                        if sym = rparen then
                            getsym
                        else
                            error (22)
                    end
                    else
                        error (23)
                end { factor} ;

            begin {term}
                factor;
                while sym in [times, slash] do
                begin
                    getsym;
                    factor
                end
            end {term} ;

        begin {expression}
            if sym in [ plus, minus] then
            begin
                getsym;
                term
            end
            else
                term;
            while sym in [ plus, minus] do
            begin
                getsym;
                term
            end
        end {expression} ;

        procedure condition;
        begin
            if sym = oddsym then
            begin
                getsym;
                expression
            end
            else
            begin
                expression;
                if not (sym in [eql, neq, lss, leq, gtr, geq]) then
                    error (20)
                else
                begin
                    getsym;
                    expression
                end
            end
        end {condition} ;

    begin {statement}
        if sym = ident then
        begin
            i := position(id);
            if i = 0 then
                error (11)
            else
                if table [i] .kind <> variable then
                    error (12);
            getsym;
            if sym = becomes then
                getsym
            else
                error (13);
            expression
        end
        else
        if sym = callsym then
        begin
          getsym;
          if sym <> ident then
              error (14)
          else
            begin
              i := position(id);
              if i = 0 then
                  error (11)
              else
                  if table[i].kind <> proc then
                      error (15);
              getsym
            end
        end
        else
        if sym = ifsym then
        begin
            getsym;
            condition;
            if sym = thensym then
                getsym
            else
                error (16);
            statement;
        end
        else
        if sym = beginsym then
        begin
            getsym;
            statement;
            while sym = semicolon do
            begin
                getsym;
                statement
            end;
            if sym = endsym then
                getsym
            else
                error (17)
        end
        else
        if sym = whilesym then
        begin
            getsym;
            condition;
            if sym = dosym then
                getsym
            else
                error (18);
            statement
        end
    end {statement} ;

begin {block}
    if sym = constsym then
    begin
        getsym;
        constdeclaration;
        while sym = comma do
        begin
            getsym;
            constdeclaration
        end ;
        if sym = semicolon then
            getsym
        else
            error (5)
    end;
    if sym = varsym then
    begin
        getsym;
        vardeclaration;
        while sym = comma do
        begin
            getsym;
            vardeclaration
        end;
        if sym = semicolon then
            getsym
        else
            error (5);
    end;
    while sym = procsym do
    begin
        getsym;
        if sym = ident then
        begin
            enter (proc);
            getsym
        end
        else
            error (4);
        if sym = semicolon then
            getsym
        else
            error (5);
        block (tx);
        if sym = semicolon then
            getsym
        else
            error (5);
    end;
    statement
end {block} ;

begin {main program}
    fileName := ParamStr(1);
    Assign(inputFile, fileName);
    Reset(inputFile);
    writeln('Processing file: ', fileName);
    for ch := 'A' to ';' do
        ssym[ch] := nul;
    word[ 1] := 'BEGIN     ';
    word[ 2] := 'CALL      ';
    word[ 3] := 'CONST     ';
    word[ 4] := 'DO        ';
    word[ 5] := 'END       ';
    word[ 6] := 'IF        ';
    word[ 7] := 'ODD       ';
    word[ 8] := 'PROCEDURE ';
    word[ 9] := 'THEN      ';
    word[10] := 'VAR       ';
    word[11] := 'WHILE     ';
    wsym[ 1] := beginsym;
    wsym[ 2] := callsym;
    wsym[ 3] := constsym;
    wsym[ 4] := dosym;
    wsym[ 5] := endsym;
    wsym[ 6] := ifsym;
    wsym[ 7] := oddsym;
    wsym[ 8] := procsym;
    wsym[ 9] := thensym;
    wsym[10] := varsym;
    wsym[11] := whilesym;
    ssym['+'] := plus;
    ssym['-'] := minus;
    ssym['*'] := times;
    ssym['/'] := slash;
    ssym['('] := lparen;
    ssym[')'] := rparen;
    ssym['='] := eql;
    ssym[','] := comma;
    ssym['.'] := period;
    ssym['#'] := neq;  { non ASCII ≠ "crossed equal symbol" in the book }
    ssym['<'] := lss;
    ssym['>'] := gtr;
    ssym['{'] := leq;  { non ASCII "less than or equal symbol" <=, ≤ in the book }
    ssym['}'] := geq;  { non ASCII "greater than or equal symbol" >=, ≥ in the book }
    ssym[';'] := semicolon;
    { page(output);  standard library feature of old Pascals to clear screen }
    cc := 0;
    ll := 0;
    ch := ' ';
    kk := al;
    getsym;
    block (0);
    if sym <> period then
        error (9);
    {99: writeln;}
    cleanExit()
end.
