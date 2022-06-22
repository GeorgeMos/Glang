%{
#include "glc.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib>

void yyerror(const char * message);

%}

%option noyywrap



whitespace      [ \t\r\v\f]
linefeed        \n

%%
"void"  |
"int"   |
"char"  |
"float" | 
"int*"      |
"char*"     |
"float*"    |   
"unsigned int"  |
"unsigned char"                                 {yylval.dataType = strdup{yytext}; return DATA_TYPE;}

"'"                                             {return SINGLE_QUOTE;}
"\""                                            {return DOUBLE_QUOTE;}
","                                             {return COMMA;}
";"                                             {return SEMICOLON;}
"}"                                             {return RCURLY;}
"{"                                             {return LCURLY;}
"["                                             {return LBRAC;}
"]"                                             {return RBRAC;}
"("                                             {return LBRACE;}
")"                                             {return RBRACE;}
"="                                             {return EQUALS;}
"<"                                             {return LANGLE;}
">"                                             {return RANGLE;}





[\'][a-zA-Z][\']                                {yylval.charVal = yytext[1]; return CHARACTER_VALUE;}
[-+]?[0-9]+                                     {yylval.intVal = atoi(yytext); return INTEGER_VALUE;}
[-+]?[0-9]*\.?[0-9]+                            {yylval.floatVal = atof(yytext); return FLOAR_VALUE;}
[a-zA-Z][_a-zA-Z0-9]*(\[[0-9]+\])+              {yylval.strVal = strdup{yytext}; return ARRAY_IDENTIFIER;}
[a-zA-Z][_a-zA-Z0-9]*                           {yylval.dataType = strdup{yytext}; return IDENTIFIER;}
\"(\\.|[^"])*\"                                 {yylval.strVal = strdup{yytext}; return STRING_VALUE}

{linefeed}                                      {yylineno++;}
{whitespace}                                    ;
.                                               {InvalidToken();}


%%




void InvalidToken(){
    printf("ERROR ON LINE %d : \n Invalid Token %s\n", yylineno,yytext);
    exit(0);
}

void yyerror(const char *s)
{
  fprintf(stderr,"error: %s on line %d\n", s, yylineno);
  exit(0);
}