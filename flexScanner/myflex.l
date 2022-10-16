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

int yywrap(){}
// int main(){

// Explanation:
// yywrap() - wraps the above rule section
/* yyin - takes the file pointer
		which contains the input*/
/* yylex() - this is the main flex function
		which runs the Rule Section*/
// yytext is the text in the buffer

// Uncomment the lines below
// to take input from file
// FILE *fp;
// char filename[50];
// printf("Enter filename:\n");
// scanf("%s",filename);
// fp = fopen(filename,"r");
// yyin = fp;
//
// yylex();


int main(int argc, char** argv) {
    ++argv, --argc;  /* skip over program name */
    if (argc > 0) {
        FILE *file;
        file = fopen( argv[0], "r" );
        if (file != NULL)
            yyin = fopen( argv[0], "r" );
        else
            printf("file not found, proceed to terminal input.\n");}
    else
        yyin = stdin;

    yylex();
    }

// return 0;
// }
