%{
#ifndef LIBS
#define LIBS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#include "headers/errors.h"
#include "headers/langFunctions.h"
#include "headers/variableStorage.h"




extern char Data_Type[50];

/*External Functions*/
extern int varArray_init();
extern void varArray_append(varArray *arr, Data data, char *name);
extern int lookup(charNode *startNode, char *name);

//Tree start node
charNode *startNode;

Data varData;
varArray variableArray;

//Errors
extern void mainNotFound();

extern void yyerror();
extern int yylex();
extern char* yytext;
extern int yylineno;

int yylex();
void yyerror(const char *s);
extern FILE* yyin;

int mainFound = 0;



%}

%union{
  int intVal;
  char* dataType;
  char* strVal;
  float floatVal;
}

%define parse.lac full
%define parse.error verbose

%token  COMMA   SINGLE_QUOTE   SEMICOLON   EQUALS DOUBLE_QUOTE 
%token  RCURLY LCURLY RBRAC LBRAC RBRACE LBRACE RANGLE LANGLE

%token CLASS

%token <charVal>  CHARACTER_VALUE
%token <intVal>   INTEGER_VALUE
%token <floatVal> FLOAT_VALUE
%token <strVal> STRING_VALUE


%token <intVal> INT
%token <floatVal> FLOAT
%token <strVal> STRING
%token <dataType> DATA_TYPE
%token <strVal> IDENTIFIER
//%token <strVal> CLASS


%type <dataType> DECLARATION
%type <dataType> EXPRESSION
%type <dataType> FUNCTION_DECLARATION
%start START;

%%

START: LANGUAGE | YYEOF;

LANGUAGE: DECLARATION | FUNCTION_CALL | 
          LANGUAGE DECLARATION | LANGUAGE FUNCTION_CALL;


FUNCTION_DECLARATION: EXPRESSION {if(!strcmp("main", yylval.strVal)){mainFound = 1;}} /*Signal that main exists*/
                      LBRACE RBRACE | 
                      FUNCTION_DECLARATION LCURLY RCURLY | 
                      FUNCTION_DECLARATION LCURLY LANGUAGE RCURLY;

FUNCTION_CALL: IDENTIFIER LBRACE RBRACE SEMICOLON | IDENTIFIER LBRACE LIST RBRACE SEMICOLON;


DECLARATION:  EXPRESSION  SEMICOLON | FUNCTION_DECLARATION;

EXPRESSION: DATA_TYPE IDENTIFIER | 
            DATA_TYPE IDENTIFIER EQUALS INTEGER_VALUE {if(!strcmp($1, "int")){varData.integerValue = $4; strcpy(varData.type, $1);} 
                                                                              varArray_append(&variableArray, varData, $2);} |

            DATA_TYPE IDENTIFIER EQUALS STRING_VALUE {if(!strcmp($1, "string")){varData.stringValue = (char*)malloc(strlen($4)*sizeof(char)); strcpy(varData.stringValue, $4); strcpy(varData.type, $1);} 
                                                                                varArray_append(&variableArray, varData, $2);} |

            DATA_TYPE IDENTIFIER EQUALS FLOAT_VALUE {if(!strcmp($1, "float")){varData.floatValue = $4; strcpy(varData.type, $1);} 
                                                                              varArray_append(&variableArray, varData, $2);} | 

            DATA_TYPE ARRAY_IDENTIFIER | 
            DATA_TYPE ARRAY_IDENTIFIER EQUALS LCURLY LIST RCURLY;

ARRAY_IDENTIFIER: /*empty*/ | IDENTIFIER LBRAC RBRAC |
                  IDENTIFIER LBRAC INTEGER_VALUE RBRAC |
                  IDENTIFIER LBRAC STRING_VALUE RBRAC |
                  IDENTIFIER LBRAC FLOAT_VALUE RBRAC |
                  IDENTIFIER LBRAC IDENTIFIER RBRAC;

LIST: IDENTIFIER | LIST COMMA IDENTIFIER;
LIST: INTEGER_VALUE | LIST COMMA INTEGER_VALUE;
LIST: STRING_VALUE | LIST COMMA STRING_VALUE;
LIST: FLOAT_VALUE | LIST COMMA FLOAT_VALUE;


%%


int main(int argc, char *argv[]){
  varArray_init();
  
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
          mainNotFound();
          return yyparse();
          //exit(0);
      }
      else{
          printf("\nAll Good\n");
          return yyparse();
          //exit(0);
      }
      
  }
  else{
    return rez;
  }
}


