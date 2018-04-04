%{

typedef struct
{
        char thestr[25];
        int ival;
        int ttype;
} tstruct;

#define YYSTYPE tstruct

#include "a8.tab.h"

%}

%option yylineno

DIGIT   [0-9]
UC      [A-Z]
LC      [a-z]
L       [A-Za-z]

%%

printi          {return tprinti;}       // will be used to print ints
printsh         {return tprintsh;}      // used to print strings horizontal
printsv         {return tprintsv;}      // used to print strings vertical
PRINTLN         {return tprintln;}      // might be useless
set             {return tset;}          // used to help assign i.e "set x to 3 * y"
to              {return tto;}           // used to help assign i.e "set x to 3 * y"
"="             {return tassign;}       // used to help assign i.e "g = "hello world""
vari            {return tint;}                  // will help declaration in yacc
vars            {return tstring;}               // will help declaration in yacc


\"([^"]*)\"     {return tstrlit;}
{L}+({DIGIT}|{L})*      {strcpy( yylval.thestr, yytext); return tid;}
{DIGIT}+        {return tnum; }


@@.*\n          {} /* comments */

[ \t]           /* ignore whitespace */

\n              {}

<<EOF>>         yyterminate(); /* signal end of dialogue */

.               return yytext[0];

%%