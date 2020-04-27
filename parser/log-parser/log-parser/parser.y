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
	char * strval;
}

%token<ival> NUMBER
%token<strval> VARIABLE STRINGLIT QUIT CREATED ACTION WAIT DONE
%token NEWLINE DOUBLE_DASH 

%type<ival> expression
%type<fval> mixed_expression
%type<strval> thread_actions thread_action end_parse

%start begin_parse

%%
begin_parse: NUMBER DOUBLE_DASH VARIABLE NEWLINE{
              /* Print out Javascript needed for functions. */
			  printf("\nconfig.options.title.text = '%s';", $3);
			  printf("\n\n// array of functions\n"
					 "var functions = [");
			  } 
			  thread_actions { printf("];\n\n"); }
			  ;
thread_actions: thread_action
		      | thread_actions NEWLINE thread_action
			  ;
thread_action: end_parse 
			 | NUMBER DOUBLE_DASH VARIABLE DOUBLE_DASH VARIABLE DOUBLE_DASH CREATED { printf("function() {newThread('%s', '%s', %d); updateStatus(0);},\n", $3, $5, $1) ;}
             | NUMBER DOUBLE_DASH VARIABLE DOUBLE_DASH VARIABLE DOUBLE_DASH ACTION { printf("function() {performFunction('%s', '%s', %d, 'Action'); updateStatus(0);},\n", $3, $5, $1) ;}
             | NUMBER DOUBLE_DASH VARIABLE DOUBLE_DASH VARIABLE DOUBLE_DASH WAIT { printf("function() {performFunction('%s', '%s', %d, 'Waiting'); updateStatus(0);},\n", $3, $5, $1) ;}
             | NUMBER DOUBLE_DASH VARIABLE DOUBLE_DASH VARIABLE DOUBLE_DASH DONE { printf("function() {performFunction('%s', '%s', %d, 'Ended'); updateStatus(0);},\n", $3, $5, $1) ;}
			 ;
end_parse: 
            | QUIT 
            ;
%%

int main() {
	yyin = stdin;
	FILE *fptr; 
  
    char filename[100], c; 
  
  
    // Open file 
    errno_t err = fopen_s(&fptr, "pre-parse.txt", "r"); 
    if (fptr == NULL) 
    { 
        printf("Cannot open file \n"); 
        exit(0); 
    } 
  
    // Read contents from file 
    c = fgetc(fptr); 
    while (c != EOF) 
    { 
        printf ("%c", c); 
        c = fgetc(fptr); 
    } 
  
    fclose(fptr); 
   
	do {
		yyparse();
	} while(!feof(yyin));

	err = fopen_s(&fptr, "post-parse.txt", "r"); 
    if (fptr == NULL) 
    { 
        printf("Cannot open file \n"); 
        exit(0); 
    } 
  
    // Read contents from file 
    c = fgetc(fptr); 
    while (c != EOF) 
    { 
        printf ("%c", c); 
        c = fgetc(fptr); 
    } 
  
    fclose(fptr); 


	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}