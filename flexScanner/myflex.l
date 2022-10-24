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
// declaration of the rules

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
    // open file to scan, if file is not found, will proceed to scan through terminal input

    yylex();
    }
