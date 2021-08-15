/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     COMMENT = 258,
     BREAK = 259,
     VARS = 260,
     QM = 261,
     STARTMAIN = 262,
     ENDMAIN = 263,
     IF = 264,
     THEN = 265,
     ELSEIF = 266,
     ELSE = 267,
     ENDIF = 268,
     FOR = 269,
     TO = 270,
     STEP = 271,
     ENDFOR = 272,
     SWITCH = 273,
     CASE = 274,
     ENDSWITCH = 275,
     RETURN = 276,
     PRINT = 277,
     WHILE = 278,
     ENDWHILE = 279,
     NEWLINE = 280,
     INDENT = 281,
     FUNCTION = 282,
     ENDFUNCTION = 283,
     ADD_ASSIGN = 284,
     SUB_ASSIGN = 285,
     DIV_ASSIGN = 286,
     MOD_ASSIGN = 287,
     DEC_OP = 288,
     INC_OP = 289,
     AND_OP = 290,
     OR_OP = 291,
     EQ_OP = 292,
     GE_OP = 293,
     LE_OP = 294,
     NE_OP = 295,
     L_BRACE = 296,
     R_BRACE = 297,
     COMMA = 298,
     COLON = 299,
     ASSIGN = 300,
     L_PAR = 301,
     R_PAR = 302,
     L_BRACK = 303,
     R_BRACK = 304,
     DOT = 305,
     UNDERSCORE = 306,
     MINUS = 307,
     PLUS = 308,
     MUL = 309,
     DIV = 310,
     LT = 311,
     GT = 312,
     FLOAT = 313,
     CHAR = 314,
     IDENTIFIER = 315,
     INTEGER = 316
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2058 of yacc.c  */
#line 27 "parser.y"

	char name[500];
	int integer_val;


/* Line 2058 of yacc.c  */
#line 124 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
