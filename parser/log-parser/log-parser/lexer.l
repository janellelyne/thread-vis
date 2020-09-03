%option noyywrap
%{
#include <stdio.h>

#define YY_DECL int yylex()
#define YY_NO_UNISTD_H

#include "parser.h"
%}

%%

[ \t]	; // ignore all whitespace

\n						{return NEWLINE;}
"--"				    {return DOUBLE_DASH;}
"START"					{return CREATED;}
"ACTION"				{return ACTION;}
"WAIT"					{return WAIT;}
"END"					{return DONE;}
"DONE"					{return QUIT;}
\"(\\.|[^"\\])*\"       {yylval.strval=strdup(yytext); return STRINGLIT; }
[a-zA-Z][a-zA-Z0-9: ]+	{yylval.strval=strdup(yytext); return VARIABLE; }
[0-9]+			 		{yylval.fval = atof(yytext); return NUMBER;}
%%