%{
    #include "language.tab.h"
    
    #include <stido.h>
    #intlude <stdlib.h>
%}

%token PIPE LBRACKET RBRACKET DOT PERIOD COLON MAINLY ADJECTIVAL REGISTER PART_OF_SPEECH ADDITIONAL_INFO DISCIPLINE

%%

start: WORD_AND_PRONUNCIATION_GUIDE pronunciation entry REGISTER
;
entry: PART_OF_SPEECH definition entry
        | /*empty*/
;

definition: number definition-with-example-sentences specififc-definition
;
specific-definition: DOT definition-with-example-sentences specific-definition
        | /*empty*/
;
definition-with-example-sentences: attribute TEXT COLON example-sentences
;
example-sentences : COLON TEXT example-sentences-with-pipe PERIOD 
                    | PERIOD
;
example-sentences-with-pipe: PIPE TEXT 
                            |  /*empty*/
;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    exit(1);
}

void parse() {
    yyparse();
}
