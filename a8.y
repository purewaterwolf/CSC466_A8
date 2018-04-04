%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
 int ival;
 char str[500];
}tstruct ;

#define YYSTYPE  tstruct

int yylex();
void yyerror( char *s );
%}


%token    tprinti
%token    tprintsh
%token    tprintsv
%token    tprintln
%token    tset
%token    tto
%token    tassign
%token    tint
%token    tstring
%token    tstrlit
%token    tid
%token    tnum

%%

program
   :  input     {
                  printf("//------------------\n");
                  printf("#include <stdio.h>\n");
                  printf("int main()\n");
                  printf("{\n");
                  printf("%s", $1.str);
                  printf("return 0;\n");
                  printf("}\n");
                  printf("//------------------\n");
                }
   ;
input
    :  /* empty */
    |  input line
                   {
                     strcpy( $$.str, $1.str);
                     strcat( $$.str, $2.str);
                   }
    ;

line
    : ';'
    |  cmd ';'
                   {
                     strcpy( $$.str, $1.str);
                   }
    ;

cmd
  :  tassign  {printf("assign\n");}
  |  tint tid                                   // vari
       {
           strcpy( $$.str, "int " );
           strcat( $$.str, $2.str );
           strcat( $$.str, ";\n" );
       }
    |  tstring tid                              // vars
       {
           strcpy( $$.str, "char " );
           strcat( $$.str, $2.str );
           strcat( $$.str, "[500];\n" );
       }
    |  tprinti tid                              // printi
       {
           strcpy( $$.str, "printf(\"%d\\n\",");
           strcat( $$.str, $2.str );
           strcat( $$.str, ");\\n" );
       }
    |  tprinti tnum                             // printi
       {
           strcpy( $$.str, "printf("" );");
           strcat( $$.str, $2.str );            // working under the assumption that for an explicit "5", tnum.str contains "5"
           strcat( $$.str, "\n;");
       }
    |  tprintsh tid                             // printsh
       {
           strcpy( $$.str, "printf(\"%s\\n\", " );
           strcat( $$.str, $2.str );
           strcat( $$.str, ");\\n;" );
       }
    |  tprintsv tid                             // printsv
       {
           strcpy( $$.str, "int i = 0;\n" ); // declare i here or at the top of the program
           strcat( $$.str, "while(" );
           strcat( $$.str, $2.str );
           strcat( $$.str, "[i] != '\0')\n" );
           strcat( $$.str, "{\n" );
           strcat( $$.str, "tprintf(\"%c\\n\", " ); // \t should be a tab, or replace with 4 spaces
           strcat( $$.str, $2.str );
           strcat( $$.str, "[i]);\n" );
           strcat( $$.str, "\ti++;\n" );
           strcat( $$.str, "}\n" );
       }
    ;

 ;

%%


int main()
{
  yyparse();
  return 0;
}


void yyerror(char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
}