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
  char *string;
  int integer;
  double decimal;
}

%error-verbose //Gives a verbose error output
%token <string> STRING;
%token testToken;

%start language

%%


language: | testToken;


%%

void yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
  exit(EXIT_FAILURE);
}

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


