%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "headers/errors.h"



extern char Data_Type[50];


typedef struct{
    int integerValue;
    char *stringValue;
    float floatValue;
    char type[10];
}Data;


typedef struct{
    Data *array;
    char *type;
    size_t used;
    size_t size;
}varArray;

/*Implementation of a string tree.*/
struct char_node{
  char val;
  int index;
  int isStart;
  struct char_node **childArray;

};
typedef struct char_node charNode;

charNode *startNode;

/*
void addNode(charNode *currentNode, char val, int isLeaf){

}
*/

Data varData;
varArray variableArray;

//Tree start node

void addTreePath(charNode *startNode, char *name, int index){
  charNode *currentNode = startNode;
  charNode *nextNode;
  for(int i = 0; i < strlen(name); i++){
      for(int j = 0; j < sizeof(currentNode->childArray)/sizeof(charNode*); j++){
        if(currentNode->childArray[j] != 0){ //If the pointer s not null
          if(currentNode->childArray[j]->val == name[i]){ //Follow the name characters down the tree
            nextNode = currentNode->childArray[j];
            currentNode = nextNode;
          }
        }
      for(int k = 0; k < sizeof(currentNode->childArray)/sizeof(charNode*); k++){//Add a node to the next available entry
        if(currentNode->childArray[k] == 0){ //Find the next NULL pointer
          //Initialise new Node
          currentNode->childArray = (charNode**)realloc(currentNode->childArray, (k+1)*sizeof(charNode*)); //Grow the child array by 1
          currentNode->childArray[k] = (charNode*)malloc(sizeof(charNode)); //Initialize child node
          currentNode = currentNode->childArray[k];
          currentNode->val = name[i];
          currentNode->isStart = 0;
          currentNode->index = index;
          currentNode->childArray = (charNode**)malloc(sizeof(charNode*)); //Initialise the child's childArray
          break;
        }
      }
    }
  }
}


int lookup(charNode *startNode, char *name){ //Returns the index of a variable in the variableArray
  charNode *currentNode = startNode;
  charNode *nextNode;
  int found = 0;

  for(int i = 0; i < strlen(name); i++){
    for(int j = 0; j < sizeof(currentNode->childArray)/sizeof(charNode*); j++){
      found = 0;
      if(currentNode->childArray[j] != 0){ //If the pointer s not null
          if(currentNode->childArray[j]->val == name[i]){ //Follow the name characters down the tree
            nextNode = currentNode->childArray[j];
            currentNode = nextNode;
            found = 1;
          }
        }
    }
  }
  if(found){
    return currentNode->index;
  }
  else{
    exit(0);
    return 0;
  }
}

int varArray_init(){
    //variableArray = (varArray*)malloc(sizeof(varArray));
    variableArray.array = (Data*)malloc(sizeof(Data));
    variableArray.used = 1;
    variableArray.size = 1;

    startNode = (charNode*)malloc(sizeof(charNode));
    startNode->isStart = 1;
    startNode->index = 0;
    startNode->childArray = (charNode**)malloc(sizeof(charNode*));
}

void varArray_append(varArray *arr, Data data, char *name){
    if(arr->used == arr->size){
        arr->size++;
        arr->array = (Data*)realloc(arr->array, arr->size * sizeof(Data));
    }
    arr->array[arr->used].integerValue = data.integerValue;
    arr->array[arr->used].floatValue = data.floatValue;
    if(data.stringValue != NULL){
      arr->array[arr->used].stringValue = (char*)malloc(strlen(data.stringValue)*sizeof(char));
      strcpy(arr->array[arr->used++].stringValue, data.stringValue);
    }

    addTreePath(startNode, name, arr->used);
    arr->used++;
    


}
    

    


void varArray_destroy(varArray *arr){
    free(arr->array);
    arr->array = NULL;
    arr->used = 0;
    arr->size = 0;
}


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


