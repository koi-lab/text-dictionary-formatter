%{
    #include "language.tab.h"
    
    #include <stido.h>
    #intlude <stdlib.h>
%}

%token PIPE LBRACKET RBRACKET DOT PERIOD COLON MAINLY ADJECTIVAL REGISTER PART_OF_SPEECH ADDITIONAL_INFO DISCIPLINE

%%

start: ;


pronunciation: PIPE TEXT PIPE ;

attribute: usage-info mainly adjectival register discipline ;

usage-info: LBRACKET TEXT RBRACKET 
          | /* empty */ 
          ;

mainly: MAINLY
      | /* empty */
      ;

adjectival: ADJECTIVAL
          | /* empty */
          ;

register: REGISTER 
        | /* empty */ 
        ;

discipline: DISCIPLINE
          | /* empty */ 
          ;

number: NUMBER
      | /* empty */
      ;

rest: ADDITIONAL_INFO_HEADER WILDCARD
    | /* empty */
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
    exit(1);
}

void parse() {
    yyparse();
}
