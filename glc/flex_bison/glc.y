%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylineno;
extern char* yytext;

int yylex();
void yyerror(const char *s);
extern FILE* yyin;
%}

%union {
  int intVal;
  char* dataType;
  char* strVal;
  float floatVal;
  char charVal;
}

%error-verbose //Gives a verbose error output

%token  COMMA   SINGLE_QUOTES   SEMI_COLON   EQUALS 
%token  RCURLY LCURLY RBRAC LBRAC RBRACE LBRACE RANGLE LANGLE

%token <charVal>  CHARACTER_VALUE
%token <intVal>   INTEGER_VALUE
%token <floatVal> FLOAT_VALUE
%token <strVal> STRING_VALUE


%token <intVal> INT
%token <floatVal> FLOAT
%token <strVal> STRING
%token <dataType> DATA_TYPE
%token <strVal> IDENTIFIER   ARRAY_IDENTIFIER
%token <strVal> STRUCT

%type <strVal> DECLARATION
%type <strVal> EXPRESSION
%type <strVal> FUNCTION_DECLARATION

%start language

%%





%%


int main(int argc, char *argv[])
{
  if(argc == 2)
  {
    if(!(yyin = fopen(argv[1],"r")))
    {
      perror(argv[1]);
      return EXIT_FAILURE;
    }
  }
  int rez;
  if(!(rez = yyparse())){
    printf("\nAll Good\n");
    return yyparse();
  }
  else return rez;
}


