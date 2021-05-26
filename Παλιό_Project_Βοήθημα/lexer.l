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

alphabet 	[a-zA-Z]		
digit           [0-9]
alphanumeric	{alphabet}|{digit}
print		[ -~]
underscore	_
identifier      ({alphabet}|{underscore})+({alphanumeric}|{underscore})* 
integer         "0"|[0-9]{digit}*
float_number  	"0"|{digit}*"."{digit}+
char		\'{print}\'
string          \".*\" 
%%

"#".*           {  print_return("COMMENT"); return COMMENT; }
"break"         {  print_return("BREAK"); return BREAK; }
"continue"      {  print_return("CONTINUE" ); return CONTINUE; }
"if"            {  print_return("IF"); return IF; }
"elif"		{  print_return("ELIF"); return ELIF; }
"else"          {  print_return("ELSE"); return ELSE; }
"for"           {  print_return("FOR"); return FOR; }
"in"		{  print_return("IN"); return IN; }
"return"        {  print_return("RETURN"); return RETURN; }
"boolean"       {  print_return("BOOLEAN"); return BOOLEAN; }
"true"          {  print_return("TRUE"); return TRUE; }    
"false"         {  print_return("FALSE"); return FALSE; }
"null"          {  print_return("NIL"); return NIL; }
"lambda"	{  print_return("LAMBDA"); return LAMBDA; }
"def"		{  print_return("DEF"); return DEF; }
"class"		{  print_return("CLASS"); return CLASS; }
"print" 	{  print_return("PRINT"); return PRINT; }
"from"		{  print_return("FROM"); return FROM; }
"import"	{  print_return("IMPORT"); return IMPORT; }
"init"		{  print_return("INIT"); return INIT; }
"self"		{  print_return("SELF"); return SELF; }
"as"		{  print_return("AS");	return AS; }
"\n"            {  line_no++; print_return("NEWLINE"); return NEWLINE; }
"\t"            {  print_return("INDENT"); return INDENT; }
">>="           {  print_return("RIGHT_ASSIGN"); return RIGHT_ASSIGN; }
"<<="           {  print_return("LEFT_ASSIGN"); return LEFT_ASSIGN; } 
"+="            {  print_return("ADD_ASSIGN"); return ADD_ASSIGN; }
"-="            {  print_return("SUB_ASSIGN"); return SUB_ASSIGN; }
"/="            {  print_return("DIV_ASSIGN"); return DIV_ASSIGN; }
"%="            {  print_return("MOD_ASSIGN"); return MOD_ASSIGN; }
"--"            {  print_return("DEC_OP"); return DEC_OP; }
"++"            {  print_return("INC_OP"); return INC_OP; }
"&&"            {  print_return("AND_OP"); return AND_OP; }
"||"            {  print_return("OR_OP"); return OR_OP; }
"=="            {  print_return("EQ_OP"); return EQ_OP; }
">="            {  print_return("GE_OP"); return GE_OP; }
"<="            {  print_return("LE_OP"); return LE_OP; }
"!="            {  print_return("NE_OP"); return NE_OP; }
"{"           	{  print_return("L_BRACE"); return L_BRACE; }
"}"           	{  print_return("R_BRACE"); return R_BRACE; }
","             {  print_return("COMMA"); return COMMA; }
":"             {  print_return("COLON"); return COLON; }
"="             {  print_return("ASSIGN"); return ASSIGN; }
"("             {  print_return("L_PAR"); return L_PAR; }
")"             {  print_return("R_PAR"); return R_PAR;}
"["           	{  print_return("L_BRACK"); return L_BRACK; }
"]"           	{  print_return("R_BRACK"); return R_BRACK;}
"."             {  print_return("DOT"); return DOT; }
"_"		{  print_return("UNDERSCORE"); return UNDERSCORE; }
"-"             {  print_return("MINUS"); return MINUS; }
"+"             {  print_return("PLUS"); return PLUS; }
"*"             {  print_return("MUL"); return MUL; }
"/"             {  print_return("DIV"); return DIV; }
"<"             {  print_return("LT"); return LT; }
">"             {  print_return("GT"); return GT; }
[ ]		; 
. 		{ yyerror("Unkown character"); }
{identifier} 	{ print_return("ID"); strcpy(yylval.name, yytext);  return IDENTIFIER; } 
{integer}	{ yylval.integer_val = atoi(yytext); print_return("INTEGER"); return INTEGER; }
{float_number}	{ print_return("FLOAT"); return FLOAT; }
{string}	{ print_return("STRING"); return STRING; }
{char}		{ print_return("CHAR"); return CHAR; }

%%

/* -------------------------------------------------------------------------------------- C FUNCTIONS ---------------------------------------------------------------------------------------------------- */

void print_return(char *token)
{	
	printf("Token: %s\t\t Line: %d\t\t Text: %s\n", token, line_no, yytext);	
}