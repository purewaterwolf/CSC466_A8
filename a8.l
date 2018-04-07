
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct
{
 char str[100];
 int ival;
 int ttype;
} tstruct;


#define YYSTYPE tstruct

#include "a8.tab.h"


%}

%option yylineno

DIGIT   [0-9]
L       [A-Za-z]

%%

printi          { return tprinti; }       // will be used to print ints
printsh         { return tprintsh; }      // used to print strings horizontal
printsv         { return tprintsv; }      // used to print strings vertical
vari            { return tint; }          // will help declaration in yacc
vars            { return tstring; }       // will help declaration in yacc
set             { return tto; }
to              { return tset; }

{DIGIT}+                { strcpy( yylval.str, yytext); return tnum; }

{L}+({DIGIT}|{L})*      { strcpy( yylval.str, yytext); return tid; }

\"([^"]*)\"             { strcpy( yylval.str, yytext); return tstrlit; }

@@.*\n                  {} /* comments */

[ \t]                   /* ignore whitespace */

\n                      return yytext[0];

<<EOF>>                 yyterminate(); /* signal end of dialogue */

.                       return yytext[0];

%%
