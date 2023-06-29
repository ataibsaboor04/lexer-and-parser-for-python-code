%{
#include "lex.yy.c"
#include <stdio.h>
#include <math.h>
#include <string.h>
void yyerror(char *s);
%}


%token 
IDENTIFIER 
INTEGER FLOAT 
STRING MULTILINESTRING 
TRUE FALSE 
NONE 
EOL INDENT 
ASSIGNMENT_OPR 
PLUS_OPR MINUS_OPR MULTIPLY_OPR DIVIDE_OPR POWER_OPR 
L_PARANTHESIS R_PARANTHESIS L_CURLY_BRACKET R_CURLY_BRACKET L_SQUARE_BRACKET R_SQUARE_BRACKET
LEQ GEQ EQ NEQ LT GT
AND OR NOT
IF ELSE ELIF COLON 
COMMA
PRINT

%start begin


%%


begin : valid_statement statement
| statement

statement : EOL valid_statement statement 
| EOL statement
| INDENT statement
| EOL
| INDENT
|

valid_statement : expression 
| if_stmt { printf("Conditional Statement Completed\n"); }
| print_stmt

expression : mathematical_expr { printf("Mathematical Expression\n"); }
| concatenation_expr { printf("Concatenation Expression\n"); }
| assignment_expr { printf("Assignment Expression\n"); }
| relational_expr { printf("Relational Expression\n"); }
| logical_expr { printf("Logical Expression\n"); }
| data

mathematical_expr : mathematical_expr PLUS_OPR mathematical_expr
| mathematical_expr MINUS_OPR mathematical_expr
| mathematical_expr mathematical_expr
| mathematical_expr MULTIPLY_OPR mathematical_expr
| mathematical_expr DIVIDE_OPR mathematical_expr
| mathematical_expr POWER_OPR mathematical_expr
| L_PARANTHESIS mathematical_expr R_PARANTHESIS
| number | IDENTIFIER

concatenation_expr : concatenation_expr PLUS_OPR concatenation_expr
| STRING | MULTILINESTRING | IDENTIFIER

assignment_expr : IDENTIFIER ASSIGNMENT_OPR expression

relational_expr : relational_expr LEQ relational_expr
| relational_expr GEQ relational_expr
| relational_expr EQ relational_expr
| relational_expr NEQ relational_expr
| relational_expr LT relational_expr
| relational_expr GT relational_expr
| L_PARANTHESIS relational_expr R_PARANTHESIS
| data

logical_expr: logical_expr AND logical_expr
| logical_expr OR logical_expr
| NOT logical_expr
| L_PARANTHESIS logical_expr L_PARANTHESIS logical_expr
| relational_expr

if_stmt: IF relational_expr COLON { printf("If Statement\n"); } conditional_space

conditional_space: EOL INDENT indented_block { printf("Indented block\n"); } if_elif_block
| EOL INDENT conditional_space
| EOL conditional_space

if_elif_block: elif_stmt
| else_stmt
| begin

indented_block: valid_statement EOL INDENT indented_block
| valid_statement EOL

else_stmt: ELSE COLON { printf("Else Statement\n"); } EOL INDENT indented_block { printf("Indented block\n"); }

elif_stmt: ELIF relational_expr COLON { printf("Elif Statement\n"); } EOL INDENT indented_block { printf("Indented block\n"); } if_elif_block

print_stmt: PRINT L_PARANTHESIS expression_list R_PARANTHESIS { printf("Print statement\n"); }

expression_list: data
| expression_list COMMA data
|

data : L_PARANTHESIS data R_PARANTHESIS
| immutable
| mutable 
| IDENTIFIER

element: mathematical_expr
| logical_expr
| concatenation_expr

content: element COMMA EOL content 
    | element COMMA content EOL
    | element COMMA content
    | element 

LIST: L_SQUARE_BRACKET content R_SQUARE_BRACKET { printf("List\n"); }
| L_SQUARE_BRACKET R_SQUARE_BRACKET { printf("List\n"); }

SET: L_CURLY_BRACKET content R_CURLY_BRACKET { printf("Set\n"); }

TUPLE: L_PARANTHESIS content R_PARANTHESIS { printf("Tuple\n"); }
| L_PARANTHESIS element COMMA R_PARANTHESIS { printf("Tuple\n"); }
| L_PARANTHESIS R_PARANTHESIS { printf("Tuple\n"); }

immutable : BOOL
| number
| STRING 
| MULTILINESTRING 
| NONE
| TUPLE

mutable : LIST
| SET
| DICTIONARY

dictionarycontent : key COLON value
| dictionarycontent COMMA key COLON value

key : immutable
| IDENTIFIER

value : data

DICTIONARY : L_CURLY_BRACKET dictionarycontent R_CURLY_BRACKET { printf("Dictionary\n"); }
| L_CURLY_BRACKET R_CURLY_BRACKET { printf("Dictionary\n"); }

BOOL : TRUE
| FALSE

number : INTEGER
| FLOAT

%%

void main() 
{
    yyparse();
}

void yyerror(char* s)
{
    fprintf(stderr, "%s\n", s);
}