%{
#include "python.h"
#include <stdio.h>
%}

%%

\"\"\"[^\"]*\"\"\" { return MULTILINESTRING; }
\"([^\\\"\n]|\\.)*\" { return STRING; }
\'([^\\\'\n]|\\.)*\' { return STRING; }

\n { return EOL; }
("    "|\t) { return INDENT; }

True { yylval = 1; return TRUE; }
False { yylval = 0; return FALSE; }
None { return NONE; }
if { return IF; }
else { return ELSE; }
elif { return ELIF; }
print { return PRINT; }

\( { return L_PARANTHESIS; }
\) { return R_PARANTHESIS; }
\{ { return L_CURLY_BRACKET; }
\} { return R_CURLY_BRACKET; }
\[ { return L_SQUARE_BRACKET; }
\] { return R_SQUARE_BRACKET; }
\: { return COLON; }
\, { return COMMA; }

\+ { return PLUS_OPR; }
\- { return MINUS_OPR; }
\* { return MULTIPLY_OPR; }
\/ { return DIVIDE_OPR; }
("**") {return POWER_OPR;}
= { return ASSIGNMENT_OPR; }
("<=") { return LEQ; }
(">=") { return GEQ; }
("==") { return EQ; }
("!=") { return NEQ; }
("<") { return LT; }
(">") { return GT; }
" " ;
and { return AND; }
or { return OR; }
not { return NOT; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

[+-]?[0-9]+ { return INTEGER; }

[+-]?[0-9]*\.[0-9]+ { return FLOAT; }

. { return yytext[0]; }

%%

int yywrap()
{
    return 1;
}