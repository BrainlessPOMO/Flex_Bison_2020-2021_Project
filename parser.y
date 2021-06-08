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
%token THEN
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

program: program line;

line:   if_stmt {;} 
        | elseif_stmt {;} 
        | else_stmt {;} 
        | for_statement {;} 
        | function NEWLINE INDENT {;}
        | function NEWLINE indent2 {;}
        | function NEWLINE {;} 
        | function_call {;} 
        | comments NEWLINE {;} 
        | action {;}
        | print NEWLINE {;}
        | switch  NEWLINE  case NEWLINE {;}
        | dictionaries NEWLINE {;} 
	| calc_assignment NEWLINE {;}
        | NEWLINE {;}    ;
/*--------- BREAK -------------*/
break:BREAK QM NEWLINE ;

/*--------- ACTION & indents -------------*/

indent2: INDENT INDENT;
indent3: INDENT INDENT INDENT;
indent4: INDENT INDENT INDENT INDENT;
indent5: INDENT INDENT INDENT INDENT INDENT;

action: INDENT line 
        | indent2 line 
        | indent3 line 
        | indent4 line 
        | indent5 line ;
/*--------- DATA TYPES -------------*/
data_type: CHAR
        | INTEGER 
        | IDENTIFIER;

/*--------- FUNCTIONS --------------*/
function: FUNCTION IDENTIFIER L_PAR optional_parameters R_PAR ;
end_function: ENDFUNCTION NEWLINE;

function_call: IDENTIFIER L_PAR optional_parameters R_PAR 
	        | IDENTIFIER L_PAR data_type R_PAR
                | IDENTIFIER L_PAR data_type COMMA data_type R_PAR    
                | IDENTIFIER L_PAR data_type COMMA data_type COMMA data_type R_PAR;

/*------------ INSPECTORS -------------*/
inspector:IDENTIFIER operators IDENTIFIER
        |IDENTIFIER operators INTEGER
        |INTEGER operators IDENTIFIER
        |INTEGER operators INTEGER   ;

inspector_gen: inspector | inspector AND_OR_operators;

/*----------- IF & FOR STATEMENTS -------------*/

if_stmt:IF L_PAR inspector_gen R_PAR THEN NEWLINE action  ;
elseif_stmt: ELSEIF L_PAR inspector_gen R_PAR NEWLINE action  ;
else_stmt: ELSE NEWLINE action  ;
end_if_stmt:ENDIF NEWLINE  ;

for_statement: FOR IDENTIFIER COLON ASSIGN INTEGER TO INTEGER STEP INTEGER NEWLINE action;
end_for_statement: ENDFOR NEWLINE;


/*---------- SWITCH / CASE STATEMENT -----------------*/
switch: SWITCH L_PAR LT IDENTIFIER GT R_PAR NEWLINE action;

case: CASE L_PAR LT INTEGER GT R_PAR NEWLINE action;

end_switch: ENDSWITCH NEWLINE;

/*-------------- WHILE ---------------*/
while: WHILE L_PAR inspector_gen R_PAR NEWLINE action  ;
end_wile: ENDWHILE NEWLINE;

/*-------------- OPERATORS ---------------*/
operators:EQ_OP 
      | GE_OP 
      | LE_OP 
      | NE_OP 
      | DEC_OP 
      | INC_OP 
      | LT 
      | GT;

AND_OR_operators:AND_OP
        |OR_OP;

optional_parameters: IDENTIFIER 
        | optional_parameters COMMA IDENTIFIER ;

/*-------------- COMMENTS ---------------*/
comments: COMMENT;

/*-------------- PRINT ---------------*/
print: PRINT L_PAR data_type R_PAR QM;

/*-------------- MAIN ---------------*/
start_main: STARTMAIN NEWLINE action;
end_main: ENDMAIN NEWLINE  ;

/* --- DICTIONARIES --- */
dictionaries: IDENTIFIER ASSIGN L_BRACE dictionary_data R_BRACE 
        | IDENTIFIER ASSIGN IDENTIFIER L_PAR L_BRACK L_PAR dictionary_data R_PAR R_BRACK R_PAR
	 IDENTIFIER ASSIGN IDENTIFIER L_PAR dictionary_data optional_parameters dictionary_data R_PAR ;

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
