%{
    #include "language.tab.h"
    
    #include <stido.h>
    #intlude <stdlib.h>
%}

%token PIPE LBRACKET RBRACKET DOT PERIOD COLON MAINLY ADJECTIVAL REGISTER PART_OF_SPEECH ADDITIONAL_INFO DISCIPLINE

%%

start: ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    exit(1);
}

void parse() {
    yyparse();
}
