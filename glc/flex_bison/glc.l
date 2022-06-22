%{
#include "glc.tab.h"
#include <string.h>

extern void yyerror(const char * message);

%}

%option noyywrap
%option yylineno



%%
"testToken" {ECHO; return testToken;}

[ \t\r\n]+ {/* ignore,return nothing */ ECHO;}

([a-z]|[A-Z])+ {yyerror("Bad Syntax"); yyterminate();}
\"[^"]*\" { yylval.string = strdup(yytext); ECHO; return STRING; }
%%