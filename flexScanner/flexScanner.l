%x STRING
%x STRING1
%x COMMENT

RESERVED    False|class|from|or|None|continue|global|pass|True|def|if|raise|and|del|import|return|as|elif|in|try|assert|else|is|whileasync|except|lambda|with|await|finally|nonlocal|yield|break|for|not
SYMBOL      :|\(|\)|,
OPERATOR    -|\+|\*|\/|%
COMPARISON  =|>|<|>=|<=|==|&&|\|\||!=

%%
{RESERVED}              printf("(reserved, '%s')\n", yytext);

{OPERATOR}              printf("(operator, '%s')\n", yytext);
{COMPARISON}            printf("(operator, '%s')\n", yytext);

{SYMBOL}                printf("(symbol, '%s')\n", yytext);
[a-zA-Z_]+              printf("(identifier, '%s')\n", yytext);

\"                      BEGIN(STRING);
\'                      BEGIN(STRING1);
#                       BEGIN(COMMENT);

[0-9]+                  printf("(number, '%s')\n", yytext);
[0-9]+[.]+[0-9]         printf("(number, '%s')\n", yytext);

<STRING>[^"]*           printf("(string, '%s')\n", yytext);
<STRING1>[^']*          printf("(string, '%s')\n", yytext);
<STRING,STRING1>["']    BEGIN(INITIAL);

<COMMENT>[^\n]*         BEGIN(INITIAL);

[ \t]+  /* ignore */
[ \t]+$ /* ignore */
\n      /* ignore */
.       printf("Syntax Error");
%%
// Since we can't write comments in the rules section, we will write them here to explain what we have done.
// Lines 1 to 3 are condition declaration. Conditions are used to differentiate the use of different rules.
// Lines 5 through 8 are definition declaration. Its purpose is to make the code in the rules section look more clean.

// Lines 19 through 21 show how conditions are initialized when a pattern is matched.
// When conditions start, such as COMMENT, only those rules that have a <COMMENT> start condition will be run, as in line 30.

// Lines 32 to 34 are used to ignore spaces and newlines.

int yywrap(){}

int main(int argc, char** argv) {
    ++argv, --argc;
    if (argc > 0) {
        FILE *file;
        file = fopen( argv[0], "r" );
        if (file != NULL)
            yyin = fopen( argv[0], "r" );
        else
            printf("file not found, proceed to terminal input.\n");}
    else
        yyin = stdin;

    // Open the file for scanning when the program is executed
    // If no file is found, scanning will continue via terminal input
    yylex();
    }
