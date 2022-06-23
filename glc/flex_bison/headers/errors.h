
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char Data_Type[50];

extern int yylineno;
extern void yyerror();


void mainNotFound(){
    yyerror("Main Function Not Found");
}