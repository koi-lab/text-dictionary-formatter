%{
    #include "language.tab.h"
    
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    void yyerror(char *s);

    char* createAnEmptyString() {
        char* s = malloc(sizeof(char));
        *s = '\0';
        return s;
    }

    char* createABigEmptyString() {
        char* s = malloc(2000 * sizeof(char));
        *s = '\0';
        return s;
    }

    void createHTML(char* s) {
        FILE *filePointer = fopen("output.html", "w");
        fprintf(filePointer, "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"UTF-16\"><title>KOI</title>\n</head>\n<body style=\"font-family: arial\">\n\n");
        fprintf(filePointer, s);
        fprintf(filePointer, "\n\n</body></html>\n");
        fclose(filePointer);
    }
%}

%token <str_value> PIPE DOT PERIOD COLON MAINLY ADJECTIVAL REGISTER PART_OF_SPEECH ADDITIONAL_INFO DISCIPLINE NUMBER WORD_AND_PRONUNCIATION_GUIDE TEXT END USAGE_INFO PLURAL_FORM
%type <str_value> start entry definition definitionmore specific_definitions definition_with_example_sentences example_sentences example_sentences_with_pipe plural_form attribute usage_info_with_colon usage_info mainly adjectival register discipline number rest
%define parse.error verbose

%union value {
  char* str_value;
  int int_value;
}

%%

start: WORD_AND_PRONUNCIATION_GUIDE entry rest END { 
    char* word_definition = malloc(100 * sizeof(char));
    char* pronunciation = malloc(100 * sizeof(char));
    
    int wordLength = strchr($1, ' ') - $1;
    strncpy(word_definition, $1, wordLength);
    word_definition[wordLength] = '\0';

    char* p1 = strchr($1, '|');
    char* p2 = strrchr($1, '|');
    int pronunciationLength = p2 - p1 + 1;
    strncpy(pronunciation, p1, pronunciationLength);
    pronunciation[pronunciationLength] = '\0'; 

    char* s = createABigEmptyString(); strcat(s, "<span>"); strcat(s, word_definition); strcat(s, "</span> <span style=\"color: darkgrey\">"); strcat(s, pronunciation); strcat(s, "</span>"); strcat(s, $2); createHTML(s); }
     ;

entry: PART_OF_SPEECH plural_form definition entry { char* s = createABigEmptyString(); strcat(s, "<br><br>"); strcat(s, $1); strcat(s, $2); strcat(s, $3); strcat(s, $4); $$ = s; }
     | /*empty*/ { $$ = ""; }
     ;

definition: number definition_with_example_sentences specific_definitions definitionmore { char* s = createABigEmptyString(); strcat(s, "<br>"); strcat(s, $1); strcat(s, $2); strcat(s, $3); strcat(s, $4); $$ = s; }
          ;

definitionmore: number definition_with_example_sentences specific_definitions definitionmore { char* s = createABigEmptyString(); strcat(s, "<br>"); strcat(s, $1); strcat(s, $2); strcat(s, $3); strcat(s, $4); $$ = s; }
              | /*empty*/ { $$ = ""; }
              ;

specific_definitions: DOT definition_with_example_sentences specific_definitions { char* s = createABigEmptyString(); strcat(s, "<br> • "); strcat(s, $2); strcat(s, $3); $$ = s; }
                   | /*empty*/ { $$ = ""; }
                   ;

definition_with_example_sentences: attribute TEXT COLON example_sentences { char* s = createABigEmptyString(); strcat(s, $1); strcat(s, $2); strcat(s, ": "); strcat(s, $4); $$ = s; }
                                 | attribute TEXT PERIOD { char* s = createABigEmptyString(); strcat(s, $1); strcat(s, $2); strcat(s, "."); $$ = s; }
                                 ;

example_sentences: usage_info_with_colon TEXT example_sentences_with_pipe { char* s = malloc(1000 * sizeof(char)); strcat(s, "<i style=\"color: darkgrey\">"); strcat(s, $1); strcat(s, $2); strcat(s, $3); strcat(s, "</i>"); $$ = s; }
                 | PERIOD { $$ = "."; }
                 ;

example_sentences_with_pipe: PIPE usage_info_with_colon TEXT example_sentences_with_pipe { char* s = createABigEmptyString(); strcat(s, " | "); strcat(s, $2); strcat(s, $3); strcat(s, $4); $$ = s; }
                           | PERIOD { $$ = "."; }
                           ;


plural_form: PLURAL_FORM { char* s = createABigEmptyString(); strcat(s, " "); strcat(s, $1); strcat(s, " "); $$ = s; }
           | /* empty */ { $$ = createAnEmptyString(); }
           ;

attribute: usage_info mainly adjectival register discipline { char* s = createABigEmptyString(); strcat(s, "<i style=\"color: darkgrey\">"); strcat(s, $2); strcat(s, $3); strcat(s, $4); strcat(s, $5); strcat(s, "</i>"); $$ = s; }

usage_info_with_colon: USAGE_INFO COLON { strcat($1, " : "); $$ = strdup($1); }
                     | /* empty */ { $$ = createAnEmptyString(); }
                     ;

usage_info: USAGE_INFO { strcat($1, " "); $$ = strdup($1); }
          | /* empty */ { $$ = createAnEmptyString(); }
          ;

mainly: MAINLY { $$ = "mainly "; }
      | /* empty */ { $$ = createAnEmptyString(); }
      ;

adjectival: ADJECTIVAL { strcat($1, " "); $$ = strdup($1); }
          | /* empty */ { $$ = createAnEmptyString(); }
          ;

register: REGISTER { strcat($1, " "); $$ = strdup($1); }
        | /* empty */ { $$ = createAnEmptyString(); }
        ;

discipline: DISCIPLINE { strcat($1, " "); $$ = strdup($1); }
          | /* empty */ { $$ = createAnEmptyString(); }
          ;

number: NUMBER { strcat($1, " "); $$ = strdup($1); }
      | /* empty */ { $$ = createAnEmptyString(); }
      ;

rest: ADDITIONAL_INFO
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