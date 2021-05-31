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


%%

/* --------------------------------------- BNF GRAMMAR ---------------------------------------*/

programm: line | programm line |/*word*/

line:     if_stmt {;} | elseif_stmt {;} | else_stmt {;} |for_statement {;} | function NEWLINE INDENT {;}
            | function NEWLINE indent2 {;}| function NEWLINE {;} | function_call {;} | comments NEWLINE {;} | action {;}| print NEWLINE {;}
            | switch  NEWLINE  case NEWLINE {;}
          /*| import_statement NEWLINE {;}*/
            | dictionaries NEWLINE {;} 
	        | calc_assignment NEWLINE {;}
            | NEWLINE {;}

/*--------- ACTION & DATA TYPES -------------*/

indent2:' '' ';
indent3:' '' '' ';
indent4:' '' '' '' ';
indent5:' '' '' '' '' ';

action: INDENT line | indent2 line | indent3 line  /*not sure about this */
                    | indent4 line | indent5 line ;

data_type: CHAR | INTEGER | IDENTIFIER QM  /*mpainei erwtimatiko meta apo tis dilwseis auton se antithesi me python*/;

/*--------- FUNCTIONS --------------*/
function: FUNCTION IDENTIFIER L_PAR optional_parameters R_PAR COLON | RETURN IDENTIFIER QM | ENDFUNCTION;

function_call: IDENTIFIER L_PAR optional_parameters R_PAR 
	                   | IDENTIFIER L_PAR data_type R_PAR
                       | IDENTIFIER L_PAR data_type COMMA data_type R_PAR    
                       | IDENTIFIER L_PAR data_type COMMA data_type COMMA    
                         data_type R_PAR;

/*----------- IF & FOR STATEMENTS -------------*/

if_stmt:IF IDENTIFIER L_PAR operators data_type R_PAR COLON NEWLINE action | elseif_stmt | else_stmt | BREAK QM NEWLINE | ENDIF NEWLINE ;
elseif_stmt: ELSEIF IDENTIFIER L_PAR operators data_type R_PAR COLON NEWLINE action | else_stmt NEWLINE ;
else_stmt: ELSE IDENTIFIER L_PAR operators data_type R_PAR COLON NEWLINE action | BREAK QM NEWLINE | ENDIF NEWLINE;

for_statement: FOR IDENTIFIER TO function_call COLON NEWLINE action ENDFOR NEWLINE /*TO (&STEP) ?*/;

/*---------- SWITCH / CASE STATEMENT -----------------*/
switch: SWITCH IDENTIFIER L_PAR LT operators data_type GT R_PAR COLON NEWLINE action NEWLINE case action NEWLINE;
case: CASE IDENTIFIER  L_PAR LT operators data_type GT R_PAR COLON NEWLINE action BREAK QM NEWLINE ENDSWITCH NEWLINE;

/*-------------- WHILE ---------------*/
while: WHILE IDENTIFIER L_PAR operators data_type R_PAR NEWLINE | if_stmt NEWLINE | ENDWHILE;

/*-------------- OPERATORS ---------------*/
operators: AND_OP | OR_OP | EQ_OP | GE_OP | LE_OP | NE_OP | DEC_OP | INC_OP | LT | GT;

optional_parameters: IDENTIFIER | optional_parameters COMMA IDENTIFIER | COMMA /*?*/;

/*-------------- COMMENTS ---------------*/
comments: COMMENT;

/*-------------- PRINT ---------------*/
print: PRINT L_PAR data_type R_PAR QM;

/*-------------- MAIN ---------------*/
main_func: STARTMAIN | VARS | int_data | data_type | operators | function_call QM | line action ENDMAIN /*poly posibol na nai lathos*/ ;

/* --- DICTIONARIES --- */
dictionaries: IDENTIFIER ASSIGN L_BRACE dictionary_data R_BRACE 
                    | IDENTIFIER ASSIGN IDENTIFIER L_PAR L_BRACK L_PAR dictionary_data R_PAR R_BRACK R_PAR
		| IDENTIFIER ASSIGN IDENTIFIER L_PAR dictionary_data optional_parameters dictionary_data R_PAR ;

dictionary_data: data_type COLON data_type 
                           |data_type COLON data_type COMMA dictionary_data 
                           | data_type COMMA data_type optional_parameters 
                           | IDENTIFIER ASSIGN data_type | /* empty */ ;

/* --- CALCULATE --- */
calc_assignment: IDENTIFIER ASSIGN int_op { Change($1, $3); };
	
int_op: int_data { $$ = $1; }
	| int_op PLUS int_data { $$ = $1 + $3; }
	| int_op MINUS int_data { $$ = $1 - $3; }
	| int_op MUL int_data { $$ = $1 * $3; }
	| int_op DIV int_data { $$ = $1 / $3; } ;

int_data: INTEGER { $$ = $1; } 
               | IDENTIFIER { $$ = Search($1) -> integer_val; };

%%

/* ------------------------------------------------ C FUNCTIONS -------------------------------------------- */

void yyerror(char *message){
	printf("Error: \"%s\"\t in line %d. Token = %s\n", message, line_no, yytext);
	exit(1);
}	

/* ------------------------------------------ MAIN FUNCTION --------------------------------------------- */

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
