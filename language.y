%{
    #include "language.tab.h"
    
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(char *s);
%}

%token PIPE DOT PERIOD COLON MAINLY ADJECTIVAL REGISTER PART_OF_SPEECH ADDITIONAL_INFO_HEADER DISCIPLINE NUMBER WORD_AND_PRONUNCIATION_GUIDE TEXT WILDCARD END USAGE_INFO
%define parse.error verbose
%%

start: WORD_AND_PRONUNCIATION_GUIDE entry rest END
;
entry: PART_OF_SPEECH definition entry
        | /*empty*/
;

definition: number definition_with_example_sentences specific_definition
;
specific_definition: DOT definition_with_example_sentences specific_definition
        | /*empty*/
;
definition_with_example_sentences: attribute TEXT COLON example_sentences
;
example_sentences: TEXT example_sentences_with_pipe
                    | PERIOD
;
example_sentences_with_pipe: PIPE TEXT example_sentences_with_pipe
                            |  PERIOD
;


attribute: usage_info mainly adjectival register discipline ;

usage_info: USAGE_INFO
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
    | ADDITIONAL_INFO_HEADER TEXT
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

int main() {
    yyparse();
    return 0;
}