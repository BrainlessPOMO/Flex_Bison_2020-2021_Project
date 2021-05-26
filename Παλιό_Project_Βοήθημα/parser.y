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


/* ----------------------------------------------------------------------------------------- TOKENS ------------------------------------------------------------------------------------------------------ */

//starting symbol
%start programm 

%token COMMENT
%token BREAK
%token CONTINUE 
%token IF 
%token ELIF
%token ELSE
%token FOR
%token RETURN
%token BOOLEAN
%token TRUE
%token FALSE
%token NIL 
%token LAMBDA
%token DEF
%token CLASS
%token NEWLINE
%token INDENT
%token RIGHT_ASSIGN
%token LEFT_ASSIGN
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
%token MINUS
%token PLUS
%token MUL
%token DIV
%token LT
%token GT
%token FLOAT
%token CHAR
%token STRING
%token IN
%token PRINT
%token FROM
%token IMPORT
%token AS
%token UNDERSCORE
%token INIT
%token SELF

%token EXIT
%token <name> IDENTIFIER
%token <integer_val> INTEGER
//type for access to $$ 
%type <integer_val> line int_op int_data
%type <name> calc_assignment

%%

/* -------------------------------------------------------------------------------------- BNF GRAMMAR ---------------------------------------------------------------------------------------------------- */

/* --- Starting symbol: programm --- */
programm: line | programm line | /* empty */; 
line:   if_stmt {;}| for_statement {;} | def NEWLINE INDENT {;}| def NEWLINE indent2 {;}
	| def NEWLINE {;} | def_call {;} | comments NEWLINE {;} | action {;} | print NEWLINE {;} | import_statement NEWLINE {;} 
	| class NEWLINE {;} | create_object NEWLINE {;} | dictionaries NEWLINE {;} | lambda_expr NEWLINE {;} | calc_assignment NEWLINE {;}
	| NEWLINE {;} ;

/* --- Indents and Actions --- */
indent2:' '' ';
indent3:' '' '' ';
indent4:' '' '' '' ';
indent5:' '' '' '' '' ';
action: INDENT line | indent2 line | indent3 line | indent4 line | indent5 line | /* empty */ ;

/* --- Data Type --- */
data_type: FLOAT | CHAR | STRING | INTEGER | IDENTIFIER ;

/* --- Statements --- */
if_stmt: IF IDENTIFIER operators data_type COLON NEWLINE action;
for_statement: FOR IDENTIFIER IN def_call COLON NEWLINE action;

/* --- Operators --- */
operators: AND_OP | OR_OP | EQ_OP | GE_OP | LE_OP | NE_OP;
optional_parameters: IDENTIFIER | optional_parameters COMMA IDENTIFIER | COMMA | /* empty */;

/* --- Functions --- */
def: DEF IDENTIFIER L_PAR optional_parameters R_PAR COLON;
def_call: IDENTIFIER L_PAR optional_parameters R_PAR 
	| IDENTIFIER L_PAR data_type R_PAR 
	| IDENTIFIER L_PAR data_type COMMA data_type R_PAR 
	| IDENTIFIER L_PAR data_type COMMA data_type COMMA data_type R_PAR;

/* --- Comments --- */
comments: COMMENT;

/* --- Print --- */
print: PRINT L_PAR data_type R_PAR;

/* --- From-Import --- */
import_statement: FROM IDENTIFIER IMPORT IDENTIFIER AS IDENTIFIER | FROM IDENTIFIER IMPORT IDENTIFIER | FROM IDENTIFIER IMPORT MUL 
		 | IMPORT IDENTIFIER AS IDENTIFIER | IMPORT IDENTIFIER | FROM IDENTIFIER IMPORT IDENTIFIER COMMA IDENTIFIER;

/* --- Class --- */
class: CLASS IDENTIFIER COLON NEWLINE INDENT class_constructor | CLASS IDENTIFIER L_PAR R_PAR COLON NEWLINE INDENT class_constructor;
class_constructor: DEF IDENTIFIER L_PAR constructor_parameters R_PAR COLON NEWLINE constructor_body;
constructor_parameters: SELF | IDENTIFIER | constructor_parameters COMMA IDENTIFIER;
constructor_body: object_creation | constructor_body object_creation;
object_creation: INDENT INDENT SELF DOT IDENTIFIER ASSIGN data_type NEWLINE | /* empty */;

/* --- Create an object and call a Class --- */
create_object: IDENTIFIER ASSIGN class_call;
class_call: IDENTIFIER L_PAR data_type R_PAR | IDENTIFIER L_PAR data_type COMMA data_type R_PAR | IDENTIFIER L_PAR data_type COMMA data_type COMMA data_type R_PAR;  

/* --- Dictionaries --- */
dictionaries: IDENTIFIER ASSIGN L_BRACE dictionary_data R_BRACE | IDENTIFIER ASSIGN IDENTIFIER L_PAR L_BRACK L_PAR dictionary_data R_PAR R_BRACK R_PAR
		| IDENTIFIER ASSIGN IDENTIFIER L_PAR dictionary_data optional_parameters dictionary_data R_PAR ;
dictionary_data: data_type COLON data_type |data_type COLON data_type COMMA dictionary_data | data_type COMMA data_type optional_parameters | IDENTIFIER ASSIGN data_type | /* empty */ ;

/* --- Lambda calculus --- */
lambda_expr: IDENTIFIER ASSIGN LAMBDA IDENTIFIER COLON expressions | LAMBDA IDENTIFIER COLON expressions;
expressions: lambda_expr | term | expressions MINUS term | expressions PLUS term | expressions MUL term | expressions DIV term | def_call;
term:  data_type;
	
/* --- calculation --- */
calc_assignment: IDENTIFIER ASSIGN int_op { Change($1, $3); };
	
int_op: int_data { $$ = $1; }
	| int_op PLUS int_data { $$ = $1 + $3; }
	| int_op MINUS int_data { $$ = $1 - $3; }
	| int_op MUL int_data { $$ = $1 * $3; }
	| int_op DIV int_data { $$ = $1 / $3; } ;

int_data: INTEGER { $$ = $1; }
		| IDENTIFIER { $$ = Search($1) -> integer_val; };

%%

/* ---------------------------------------------------------------------------------------------- C FUNCTIONS -------------------------------------------------------------------------------------------- */

void yyerror(char *message){
	printf("Error: \"%s\"\t in line %d. Token = %s\n", message, line_no, yytext);
	exit(1);
}	

/* --------------------------------------------------------------------------------------------- MAIN FUNCTION ---------------------------------------------------------------------------------------- */

int main(int argc, char *argv[]){

	hashTable = (hash *) calloc(SIZE, sizeof(hash));

    	int flag;

	yyin = fopen(argv[1],"r");
	//yyparse(): reads tokens, executes actions
	flag = yyparse();
	fclose(yyin);

	printf("Parsing finished succesfully!\n\n");
	printf(" __________________________\n");
	Print();
	printf(" __________________________\n");

	return flag;   
}