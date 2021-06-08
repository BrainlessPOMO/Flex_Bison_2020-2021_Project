%option noyywrap 

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <regex.h>
    #include "parser.tab.h"

    extern FILE *yyin;
    extern FILE *yyout;
    int line_no = 1;

    //the function of lexer analysis. Return the token
    int yylex();
    //error function 
    void yyerror();
    //print statement function
    void print_return(char *token);

%}

%x ML_COMMENT

alphabet        [a-zA-Z]		
digit           [0-9]
alphanumeric    {alphabet}|{digit}
PRINT           [ -~]
underscore      _
identifier      ({alphabet}|{underscore})+({alphanumeric}|{underscore})*
integer         "0"|[0-9]{digit}*
float_number    "0"|{digit}*"."{digit}+
char            \'{print}\'

%%

"PROGRAM"       {  print_return("PROGRAM"); return PROGRAM}

"//".*          {  print_return("COMMENT"); return COMMENT; }

"BREAK"         {  print_return("BREAK"); return BREAK; }
"VARS"          {  print_return("VARS"); return VARS; }    

"STARTMAIN"     {  print_return("STARTMAIN");  return STARTMAIN; }   
"ENDMAIN"       {  print_return("ENDMAIN"); return ENDMAIN;}

"IF"            {  print_return("IF");  return IF; }
"THEN"          {  print_return("THEN"); return THEN;}
"ELSEIF"        {  print_return("ELSEIF"); return ELSEIF; }
"ELSE"          {  print_return("ELSE"); return ELSE; }
"ENDIF"         {  print_return("ENDIF"); return ENDIF; }

"FOR"           {  print_return("FOR"); return FOR; }
"TO"            {  print_return("TO"); return TO; }
"STEP"          {  print_return("STEP"); return STEP; }
"ENDFOR"        {  print_return("ENDFOR"); return ENDFOR; }

"SWITCH"        {  print_return("SWITCH"); return SWITCH; }
"CASE"          {  print_return("CASE"); return CASE; }
"ENDSWITCH"     {  print_return("ENDSWITCH"); return ENDSWITCH; }

"RETURN"        {  print_return("RETURN"); RETURN; }

"FUNCTION"	    {  print_return("FUN"); return FUN; }
"ENDFUNCTION"   {  print_return("ENDFUNCTION"); return ENDFUNCTION; }

"PRINT"         {  print_return("PRINT"); return PRINT; }

"WHILE"         {  print_return("WHILE"); return WHILE;}
"ENDWHILE"      {  print_return("ENDWHILE"); return ENDWHILE;}

";"             {  print_return("QM"); return QM; }
"\n"            {  line_no++; print_return("NEWLINE"); return NEWLINE; }     
"\t"            {  print_return("INDENT"); return INDENT; }     
       
"+="            {  print_return("ADD_ASSIGN"); return ADD_ASSIGN; }        
"-="            {  print_return("SUB_ASSIGN"); return SUB_ASSIGN; }       
"/="            {  print_return("DIV_ASSIGN"); return DIV_ASSIGN; }       
"%="            {  print_return("MOD_ASSIGN"); return MOD_ASSIGN; }     
"--"            {  print_return("DEC_OP"); return DEC_OP; }      
"++"            {  print_return("INC_OP"); return INC_OP; }        
"AND"           {  print_return("AND_OP"); return AND_OP; }      
"OR"            {  print_return("OR_OP"); return OR_OP; }       
"=="            {  print_return("EQ_OP"); return EQ_OP; }      
">="            {  print_return("GE_OP"); return GE_OP; }      
"<="            {  print_return("LE_OP"); return LE_OP; }      
"!="            {  print_return("NE_OP"); return NE_OP; }     
"{"             {  print_return("L_BRACE"); return L_BRACE; }        
"}"             {  print_return("R_BRACE"); return R_BRACE; }        
","             {  print_return("COMMA"); return COMMA; }       

"="             {  print_return("ASSIGN"); return ASSIGN; }       
"("             {  print_return("L_PAR"); return L_PAR; }        
")"             {  print_return("R_PAR"); return R_PAR;}     
"["             {  print_return("L_BRACK"); return L_BRACK; }        
"]"             {  print_return("R_BRACK"); return R_BRACK;}     
"."             {  print_return("DOT"); return DOT; }        
"_"	            {  print_return("UNDERSCORE"); return UNDERSCORE; }       
"-"             {  print_return("MINUS"); return MINUS; }        
"+"             {  print_return("PLUS"); return PLUS; }       
"*"             {  print_return("MUL"); return MUL; } 
":"             {  print_return("COLON"); return COLON; }

"/"             {  print_return("DIV"); return DIV; }
"<"             {  print_return("LT"); return LT; }
">"             {  print_return("GT"); return GT; }
[ ]	            ; 
. 		        { yyerror("Unkown character"); }

{identifier} 	{ print_return("ID"); strcpy(yylval.name, yytext);  return IDENTIFIER; } 
{integer}       { yylval.integer_val = atoi(yytext); print_return("INTEGER"); return INTEGER; }
{float_number}  { print_return("FLOAT"); return FLOAT; }
{char}	        { print_return("CHAR"); return CHAR; }

%%
void print_return(char *token)
{
	printf("Token: %s\t\t Line: %d\t\t Text: %s\n", token, line_no, yytext);	
}
