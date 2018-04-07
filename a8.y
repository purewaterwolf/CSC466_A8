%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
 char str[500];
 int ival;
 int ttype;
} tstruct;

#define YYSTYPE tstruct

int yylex();
void yyerror( const char *s );

#include "symtab.c"

%}


%token    tprinti
%token    tprintsh
%token    tprintsv
%token    tint
%token    tstring
%token    tstrlit
%token    tid
%token    tnum
%token    tset
%token    tto

%define parse.error verbose


%%

program
    :  input
        {
        printf("#include <stdio.h>\n");
	printf("#include <string.h>\n");
        printf("int main()\n");
        printf("{\n");
        printf("%s", $1.str);
        printf("return 0;\n");
        printf("}\n");
        }
   ;
input
    : /* empty */
    | input line
        {
        strcpy( $$.str, $1.str );
        strcat( $$.str, $2.str );
        }
    ;
line
    : '\n'
    | statement '\n'
        {
        strcpy( $$.str, $1.str );
        }
    ;
statement
    : declaration
        {
        strcpy( $$.str, $1.str );
        }
    | command
        {
        strcpy( $$.str, $1.str );
        }
    ;
command
    : variable
    | tprinti variable
        {
        strcpy( $$.str, "printf(\"%d\\n\", ");
        strcat( $$.str, $2.str );
        strcat( $$.str, ");\n" );
        }
    | tprintsh variable
        {
        strcpy( $$.str, "printf(\"%s\\n\", " );
        strcat( $$.str, $2.str );
        strcat( $$.str, ");\n" );
        }
    | tprintsv variable
        {
        strcpy( $$.str, "int i = 0;\n" );
        strcat( $$.str, "while(" );
        strcat( $$.str, $2.str );
        strcat( $$.str, "[i] != 0)\n" );
        strcat( $$.str, "{\nprintf(\"%c\\n\", " );
        strcat( $$.str, $2.str );
        strcat( $$.str, "[i]);\n" );
        strcat( $$.str, "i++;\n}\n" );
        }
    ;
declaration
    : tint variable                            
        {
        strcpy( $$.str, "int " );
        strcat( $$.str, $2.str );
        strcat( $$.str, ";\n" );
        }
    | tstring variable                             
        {
        strcpy( $$.str, "char " );
        strcat( $$.str, $2.str );
        strcat( $$.str, "[500];\n" );
        }
    | variable '=' subexp
        {
        if ( $3.ttype == 10 )
                {
                strcpy( $$.str, $1.str );
                strcat( $$.str, " = " );
                strcat( $$.str, $3.str );
                strcat( $$.str, ";\n" );
                }
        if ( $3.ttype == 20 )
                {
                strcpy( $$.str, "strcpy(");
                strcat( $$.str, $1.str );
                strcat( $$.str, ", ");
                strcat( $$.str, $3.str );
                strcat( $$.str, ");\n" );
                }
        }
    | op variable op subexp
        {
        strcpy( $$.str, $2.str );
        strcat( $$.str, " = " );
        strcat( $$.str, $4.str );
        strcat( $$.str, ";\n" );
        }
    ;
subexp
    : variable
    | subexp '+' variable
        {
        strcpy( $$.str, $1.str );
        strcat( $$.str, " + " );
        strcat( $$.str, $3.str );
        }
    | subexp '-' variable
        {
        strcpy( $$.str, $1.str );
        strcat( $$.str, " - " );
        strcat( $$.str, $3.str );
        }
    | subexp '*' variable
        {
        strcpy( $$.str, $1.str );
        strcat( $$.str, " * " );
        strcat( $$.str, $3.str );
        }
    | subexp '/' variable
        {
        strcpy( $$.str, $1.str );
        strcat( $$.str, " / " );
        strcat( $$.str, $3.str );
        }
    ;
op
    : tset
    | tto
    ;
variable
    : tid
        {
        strcpy( $$.str, $1.str );
        }
    | tstrlit
        {
        strcpy( $$.str, $1.str );
        $$.ttype = 20;
        }
    | tnum
        {
        strcpy( $$.str, $1.str );
        $$.ttype = 10;
        }
    ;

%%


int main()
{
  yyparse();
  return 0;
}


void yyerror(const char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
}

