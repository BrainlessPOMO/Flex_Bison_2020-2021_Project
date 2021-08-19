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

%token PRINT

%token WHILE
%token ENDWHILE

%token NEWLINE
%token INDENT

%token FUNCTION
%token END_FUNCTION

%token ADD_ASSIGN
%token SUB_ASSIGN
%token DIV_ASSIGN

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
%token STRING

%token <name> IDENTIFIER
%token <integer_val> INTEGER


%token PROGRAM

//type for access to $$ 
%type <integer_val> line int_op int_data
%type <name> calc_assignment

%%

program: PROGRAM IDENTIFIER NEWLINE | program NEWLINE line start_main ; 

line:   if_stmt {;} 
        | elseif_stmt {;} 
        | else_stmt {;} 
        | for_statement {;} 
        | function NEWLINE{;} 
        | function_call {;} 
        | comments NEWLINE {;}
        | action {;}
        | variable {;}
        | print NEWLINE {;}
        | break {;}
        | inspector_gen {;}
        | switch case end_switch NEWLINE {;}
        | while NEWLINE {;}
        | dictionaries NEWLINE {;} 
        | dictionary_data NEWLINE {;}
	| calc_assignment NEWLINE {;}
        | NEWLINE {;}  
        ;

break: BREAK QM NEWLINE ;

indent2:' '' ';
indent3:' '' '' ';
indent4:' '' '' '' ';
indent5:' '' '' '' '' ';


action: INDENT
        |INDENT line 
        | indent2 line 
        | indent3 line 
        | indent4 line 
        | indent5 line 
        ;

data_type: CHAR
        | INTEGER 
        | FLOAT
        | IDENTIFIER
        | STRING
        ;

variable: VARS NEWLINE data_type inspector 
        | VARS NEWLINE data_type IDENTIFIER COMMA IDENTIFIER 
        | VARS NEWLINE variable_dictionary
        | variable variable_dictionary
        | variable QM
        | variable NEWLINE variable_dictionary QM
        ;
variable_dictionary: data_type inspector
                     | data_type IDENTIFIER COMMA IDENTIFIER
                     | COMMA array
                     | array
                     | COMMA IDENTIFIER
                     | IDENTIFIER COMMA IDENTIFIER 
                     | variable_dictionary COMMA IDENTIFIER
                     | variable_dictionary COMMA array
                     | NEWLINE
                     | NEWLINE line
                     | variable 
                     ;
return: RETURN INTEGER QM NEWLINE
        | RETURN IDENTIFIER QM NEWLINE
        | RETURN int_op QM NEWLINE
        ;

function: FUNCTION IDENTIFIER L_PAR optional_parameters R_PAR NEWLINE line NEWLINE return
          | FUNCTION IDENTIFIER L_PAR optional_parameters R_PAR NEWLINE line
          | function end_function NEWLINE
          ;

end_function: END_FUNCTION;

function_call: IDENTIFIER L_PAR optional_parameters R_PAR 
	        | IDENTIFIER L_PAR data_type R_PAR
                | IDENTIFIER L_PAR data_type COMMA data_type R_PAR    
                | IDENTIFIER L_PAR data_type COMMA data_type COMMA data_type R_PAR
                ;

inspector:IDENTIFIER operators IDENTIFIER
        |IDENTIFIER operators data_type
        |data_type operators IDENTIFIER
        ;

inspector_gen: inspector 
               | inspector operators 
               | inspector operators inspector 
               | inspector_gen QM
               ; 


if_stmt: IF L_PAR inspector R_PAR THEN NEWLINE line 
        | if_stmt end_if_stmt 
        | if_stmt elseif_stmt 
        | if_stmt elseif_stmt else_stmt 
        ;
elseif_stmt: ELSEIF L_PAR inspector R_PAR NEWLINE line ;
else_stmt: ELSE NEWLINE line;
end_if_stmt: ENDIF;

for_statement: FOR IDENTIFIER COLON ASSIGN INTEGER TO INTEGER STEP INTEGER NEWLINE
               |for_statement line 
               |for_statement line NEWLINE
               |for_statement end_for_statement
               ;
end_for_statement: ENDFOR;

switch: SWITCH L_PAR LT IDENTIFIER GT R_PAR NEWLINE 
        |SWITCH L_PAR LT IDENTIFIER GT R_PAR COMMENT NEWLINE 
        |switch case 
        |switch case end_switch NEWLINE
        ;

case:  CASE L_PAR LT INTEGER GT R_PAR NEWLINE line break;
end_switch: ENDSWITCH;

while: WHILE L_PAR inspector_gen R_PAR NEWLINE line NEWLINE
        |while line
        |while line NEWLINE
        |while end_while 
        ;
end_while: ENDWHILE;

array: IDENTIFIER L_BRACK INTEGER R_BRACK
        | IDENTIFIER L_BRACK IDENTIFIER R_BRACK
        ;
array_value: array ASSIGN INTEGER ;  

operators:EQ_OP 
      | GE_OP 
      | LE_OP 
      | NE_OP 
      | DEC_OP 
      | INC_OP 
      | LT 
      | GT
      |AND_OP
      |OR_OP
      ;


optional_parameters: IDENTIFIER 
                     | data_type IDENTIFIER COMMA data_type IDENTIFIER
                     | IDENTIFIER IDENTIFIER COMMA optional_parameters
                     | IDENTIFIER IDENTIFIER
                     ;

comments: COMMENT | COMMENT NEWLINE | comments line | comments line NEWLINE;

print: PRINT L_PAR data_type R_PAR QM | PRINT L_PAR data_type print_name_var R_PAR QM;
print_name_var: L_BRACK COMMA IDENTIFIER R_BRACK 
                | L_BRACK COMMA array R_BRACK 
                ;

start_main: STARTMAIN line
           | STARTMAIN line NEWLINE
           | start_main end_main
           ;
end_main: ENDMAIN;

dictionaries: IDENTIFIER ASSIGN L_BRACE dictionary_data R_BRACE 
        | IDENTIFIER ASSIGN IDENTIFIER L_PAR L_BRACK L_PAR dictionary_data R_PAR R_BRACK R_PAR
	|IDENTIFIER ASSIGN IDENTIFIER L_PAR dictionary_data optional_parameters dictionary_data R_PAR 
        | array_value QM
        ;

dictionary_data: data_type COLON data_type 
        |data_type COLON data_type COMMA dictionary_data 
        | data_type COMMA data_type optional_parameters 
        | IDENTIFIER ASSIGN data_type QM 
        |/* empty */ 
        ;


calc_assignment: IDENTIFIER ASSIGN int_op { Change($1, $3); };
	
int_op: int_data { $$ = $1; } 
	| int_op PLUS int_data { $$ = $1 + $3; }
	| int_op MINUS int_data { $$ = $1 - $3; }
	| int_op MUL int_data { $$ = $1 * $3; }
	| int_op DIV int_data { $$ = $1 / $3; } 
        | int_op QM 
        ;

int_data: INTEGER { $$ = $1; } 
        | IDENTIFIER { $$ = Search($1) -> integer_val; }
        ;


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
