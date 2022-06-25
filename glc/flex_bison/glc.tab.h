/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_GLC_TAB_H_INCLUDED
# define YY_YY_GLC_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    COMMA = 258,                   /* COMMA  */
    SINGLE_QUOTE = 259,            /* SINGLE_QUOTE  */
    SEMICOLON = 260,               /* SEMICOLON  */
    DOUBLE_QUOTE = 261,            /* DOUBLE_QUOTE  */
    RCURLY = 262,                  /* RCURLY  */
    LCURLY = 263,                  /* LCURLY  */
    RBRAC = 264,                   /* RBRAC  */
    LBRAC = 265,                   /* LBRAC  */
    RBRACE = 266,                  /* RBRACE  */
    LBRACE = 267,                  /* LBRACE  */
    RANGLE = 268,                  /* RANGLE  */
    LANGLE = 269,                  /* LANGLE  */
    CLASS = 270,                   /* CLASS  */
    CHARACTER_VALUE = 271,         /* CHARACTER_VALUE  */
    INTEGER_VALUE = 272,           /* INTEGER_VALUE  */
    FLOAT_VALUE = 273,             /* FLOAT_VALUE  */
    STRING_VALUE = 274,            /* STRING_VALUE  */
    INT = 275,                     /* INT  */
    FLOAT = 276,                   /* FLOAT  */
    STRING = 277,                  /* STRING  */
    DATA_TYPE = 278,               /* DATA_TYPE  */
    IDENTIFIER = 279,              /* IDENTIFIER  */
    OPERATOR = 280,                /* OPERATOR  */
    EQUALS = 281                   /* EQUALS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 53 "glc.y"

  int intVal;
  char* dataType;
  char* strVal;
  float floatVal;
  char* operator;

#line 98 "glc.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_GLC_TAB_H_INCLUDED  */
