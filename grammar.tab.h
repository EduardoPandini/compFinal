/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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

#ifndef YY_YY_GRAMMAR_TAB_H_INCLUDED
# define YY_YY_GRAMMAR_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 27 "grammar.y" /* yacc.c:1909  */

    #include <vector>

#line 48 "grammar.tab.h" /* yacc.c:1909  */

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT = 258,
    FLOAT = 259,
    BOOL = 260,
    T_ARITH_OP = 261,
    T_BOOL_OP = 262,
    T_LOGIC_OPERATOR = 263,
    T_ID = 264,
    T_STRING = 265,
    T_INCREMENT = 266,
    T_SELF_ASSIGN = 267,
    T_INT = 268,
    T_BOOL = 269,
    T_DEFINE = 270,
    T_INCLUDE = 271,
    T_LIBRARY = 272,
    T_PLUS = 273,
    T_MINUS = 274,
    T_MULTIPLY = 275,
    T_DIVIDE = 276,
    T_LEFT = 277,
    T_RIGHT = 278,
    T_NEWLINE = 279,
    T_QUIT = 280,
    T_PRIMITIVO = 281,
    T_RESERVED = 282,
    T_CONST = 283,
    T_SEPARATOR = 284,
    T_EXPR_SEPARATOR = 285,
    T_LEFT_BLOCK = 286,
    T_RIGHT_BLOCK = 287,
    T_LEFT_PARENTHESES = 288,
    T_RIGHT_PARENTHESES = 289,
    T_SWITCH = 290,
    T_FOR = 291,
    T_WHILE = 292,
    T_DO = 293,
    T_PRINT = 294,
    T_CONDICIONAL = 295,
    T_CONT_CONDICIONAL = 296,
    T_ASSIGN = 297,
    T_RETURN = 298,
    T_ARROW_RIGHT = 299,
    T_LEFT_POINTER = 300,
    T_RIGHT_POINTER = 301,
    T_OP_SUM = 302,
    T_OP_SUB = 303,
    T_OP_MUL = 304,
    T_OP_DIV = 305,
    T_MLC_START = 306,
    T_MLC_END = 307,
    T_EMPTY = 308,
    T_TAB = 309,
    T_CARRIER = 310,
    T_UNKNOWN = 311,
    T_COMMENT_C = 312,
    T_SLC = 313
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 31 "grammar.y" /* yacc.c:1909  */

    int ival;
    float fval;
    char * idval;
    char * aopval;
    int bval;

    struct {
        int sType;
    } expr_type;

    struct {
        std::vector<int> *trueList, *falseList;
    } bexpr_type;

    struct {
        std::vector<int> *nextList;
    } stmt_type;
    
    struct {
        int returnMarker;
        std::vector<int> *nextList;
    } ret_stmt_type;
    
    struct {
        int load_var;
        std::vector<int> *returnList;
    } swt_type;
    
    struct {
        int initMarker;
        int endMarker;
        std::vector<int> *nextList;
    } func_stmt_type;
    
    struct {
        int initMarker;
        int midMarker;
        int endMarker;
        std::vector<int> *trueList;
        std::vector<int> *falseList;
    } fcm_stmt_type;

    int sType;

#line 165 "grammar.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_GRAMMAR_TAB_H_INCLUDED  */
