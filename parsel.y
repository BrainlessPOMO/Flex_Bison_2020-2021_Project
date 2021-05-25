%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include "print_console.c"

    //pointer to input file of lexer
    extern FILE *yyin; 
    //pointer to output file of lexer
    extern FILE *yyout;
    //line counter
    extern int line_no;
    //reads the input stream generates tokens
    extern int yylex();
    //temporary token save
    extern char* yytext;

    //Function Initilize
    int yylex();
    void yyerror(char *message);

%}

//struct for print_console
%union 
{
	char name[500];
	int integer_val;
}

/* --------------------------------------- TOKENS ---------------------------------------*/
//starting symbol
%start PROGRAM 

%token COMMENT
%token BREAK
%token VARS

%token QM

%token STARTMAIN 
%token ENDMAIN

%token IF 
%token ELSEIF
%token ELSE
%token ENDIF

%token FOR
%token TO
%token STEP
%token ENDFOR

%token SWITCH
%token CASE
%token ENDSWITCH

%token RETURN

%token FUNCTION
%token ENDFUNCTION

%token PRINT

%token WHILE
%token ENDWHILE

%token NEWLINE
%token INDENT

%token ADD_ASSIGN
%token SUB_ASSIGN
%token DIV_ASSIGN
%token MOD_ASSIGN
%token DEC_OP
%token INC_OP
%token AND_OP
%token OR_OP
%token EQ_OP
%token GE_OP
%token LE_OP
%token NE_OP
%token L_BRACE
%token R_BRACE
%token COMMA
%token COLON
%token ASSIGN
%token L_PAR
%token R_PAR
%token L_BRACK
%token R_BRACK
%token DOT
%token UNDERSCORE
%token MINUS
%token PLUS
%token MUL
%token DIV
%token LT
%token GT
%token FLOAT
%token CHAR

%token <name> IDENTIFIER
%token <integer_val> INTEGER

//type for access to $$ 
%type <integer_val> line int_op int_data
%type <name> calc_assignment


/* --------------------------------------- BNF GRAMMAR ---------------------------------------*/
