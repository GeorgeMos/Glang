%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


extern char Data_Type[50];

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;

int yylex();
void yyerror(const char *s);
extern FILE* yyin;

int mainFound = 0;

%}

%union {
  int intVal;
  char* dataType;
  char* strVal;
  float floatVal;
  char charVal;
}

%define parse.lac full
%define parse.error verbose

%token  COMMA   SINGLE_QUOTE   SEMICOLON   EQUALS DOUBLE_QUOTE 
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
//%token <strVal> STRUCT


%type <dataType> DECLARATION
%type <dataType> EXPRESSION
%type <dataType> FUNCTION_DECLARATION

//%start LANGUAGE;

%%

LANGUAGE: DECLARATION | DECLARATION YYEOF;



FUNCTION_DECLARATION: DATA_TYPE IDENTIFIER {if(!strcmp("main", yylval.strVal)){mainFound = 1;}} LBRACE RBRACE LCURLY NUMBER RCURLY SEMICOLON;

DECLARATION: FUNCTION_DECLARATION;

EXPRESSION: DATA_TYPE IDENTIFIER | 
            DATA_TYPE IDENTIFIER EQUALS NUMBER | 
            DATA_TYPE IDENTIFIER COMMA IDENTIFIER;

NUMBER: INTEGER_VALUE;

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
      if(!mainFound){
          yyerror("main() not found");
          return yyparse();
          //exit(0);
      }
      else{
          printf("\nAll Good\n");
          return yyparse();
          //exit(0);
      }
  }
  else return rez;
}


