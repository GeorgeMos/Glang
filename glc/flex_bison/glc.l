%{
#include "glc.tab.h"
#include <string.h>
extern void yyerror(const char * message);

%}

%option noyywrap
%option yylineno


%%
"testToken" {ECHO; return testToken;}

[\t\r\n]+ {ECHO;}

%%