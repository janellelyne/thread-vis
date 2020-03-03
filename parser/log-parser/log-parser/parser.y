%defines "parser.h"
%{

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<ival> expression
%type<fval> mixed_expression

%start begin_parse

%%
begin_parse: {
              /* Print out HTML structure of script file before parsing log file to Javascript. */
			  printf("<!doctype html>\n<html>\n<head>\n");
              printf("<title>Horizontal Bar Chart</title>\n");
			  printf("<script src='https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js' integrity='sha256-R4pqcOYV8lt7snxMQO/HSbVCFRPMdrhAFMH+vr9giYI=' crossorigin='anonymous'></script>\n");
              printf("<script src='https://cdn.jsdelivr.net/npm/moment@2.24.0/moment.min.js'></script>");
			  printf("<script src='js/utils.js'></script>\n");
			  printf("<style>"
			  "\ncanvas{"
				"-moz-user-select: none;"
				"-webkit-user-select: none;"
				"-ms-user-select: none;"
				"}"
			  "</style>\n");
			  printf("</head>\n");
			  printf("<body>"
				     "<div style='width:75%;'>"
					 "<canvas id='canvas'></canvas>"
					 "</div>"
					 "<br><br>"
					 "<button id='randomizeData'>Randomize Data</button>"
					"<button id='addDataset'>Add Dataset</button>"
					"<button id='removeDataset'>Remove Dataset</button>"
				    "<button id='addData'>Add Data</button>"
					"<button id='removeData'>Remove Data</button>");
			  } 
			  /*calculation*/ 
			  {
			  printf("\n</script>");
			  printf("\n</body>");
			  printf("\n</html>");
			  }
calculation: 
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE { printf("\tResult: %i\n", $1); }
    | T_QUIT T_NEWLINE { printf("bye!\n"); exit(0); }
;

mixed_expression: T_FLOAT                 		 { $$ = $1; }
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | T_LEFT mixed_expression T_RIGHT		 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 { $$ = $1 / (float)$3; }
;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}