%{
  #include "language.tab.h"
  #include <stdio.h>
  #include <ctype.h> 
%}

%%


" "                     { }
"|"                     { /* printf("Matched PIPE\n"); */ return PIPE; }
"•"                     { /* printf("Matched DOT\n"); */ return DOT; }
"."                     { /* printf("Matched PERIOD\n"); */ return PERIOD; }
":"                     { /* printf("Matched COLON\n"); */ return COLON; }
[0-9]+                  { /* printf("Matched NUMBER: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return NUMBER; }
"mainly"                { /* printf("Matched MAINLY\n"); */ return MAINLY; }
"(plural"[ ][a-z]+")"   { /* printf("Matched PLURAL_FORM: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return PLURAL_FORM; }
\n                      { return END; }

"British"|"North American"|"Northern English"|"Scottish"|"South Asian"|"US"|"North American English"          { /* printf("Matched ADJECTIVAL: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return ADJECTIVAL; }
"archaic"|"dialect"|"formal"|"historical"|"humorous"|"informal"|"litarary"|"rare"|"technical"                 { /* printf("Matched REGISTER: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return REGISTER; }
"adjective"|"adverb"|"conjunction"|"exclamation"|"noun"|"preposition"|"pronoun"|"verb"                        { /* printf("Matched PART_OF_SPEECH: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return PART_OF_SPEECH; }
("DERIVATIVES"|"ORIGIN"|"PHRASES"|"PHRASAL VERBS"|"USAGE").+                                                  { /* printf("Matched ADDITIONAL_INFO: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return ADDITIONAL_INFO; }

"Anatomy"|"Architecture"|"Baseball"|"Biology"|"Botany"|"Chemistry"|"Computing"|"Electronics"|"Golf"|"Grammar"|"Geology"|"Geometry"|"Heraldry"|"Law"|"Linguistics"|"Logic"|"Mathematics"|"Medicine"|"Microbiology"|"Military"|"Music"|"Philosophy"|"Photography"|"Physics"|"Printing"|"Prosody"|"Psychoanalysis"|"Theology"|"Zoology"            { /* printf("Matched DISCIPLINE: '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return DISCIPLINE; }

\[[a-z ]+\]                                       { /* printf("Matched USAGE_INFO '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return USAGE_INFO; }
[a-z]+[ ][a-z·]*[ ]?"|"[ ][^|]+[ ]"|"             { printf("\nMatched WORD_AND_PRONUNCIATION_GUIDE '%s'\n", yytext); */ yylval.str_value = strdup(yytext); return WORD_AND_PRONUNCIATION_GUIDE; }
[^•|\[\].:\n]+            { if (isdigit(yytext[0])) {
                                yyless(1);   
                                REJECT;      
                            }    

                            if (yytext[0] == ' ') {
                                yyless(1);
                                REJECT;                                
                            }

                            if (strncmp(yytext, "(plural", 7) == 0) {
                              int i = 0;
                              while (1) {
                                if (yytext[i] == ')') {
                                  break;
                                }
                                i++;
                              }

                              yyless(i);
                              REJECT;
                            }

                            const char* strArr1[] = { "DERIVATIVES","ORIGIN","PHRASES","PHRASAL VERBS","USAGE" };
                            for (int i = 0; i < sizeof(strArr1) / sizeof(strArr1[0]); i++) {
                                const char* element = strArr1[i];
                                int elementLength = strlen(element);
                                if (strncmp(yytext, element, elementLength) == 0) {

                                yyless(strlen(yytext));
                                REJECT;
                                /* printf("❗️ Never should run\n") */;
                                }
                            }

                            const char* stringArray[] = {"mainly", "British","North American","USAGE","Northern English","Scottish","South Asian","US","archaic","dialect","formal","historical","humorous","informal","litarary","rare","technical","adjective","adverb","conjunction","exclamation","noun","preposition","pronoun","verb","Anatomy","Architecture","Baseball","Biology","Botany","Chemistry","Computing","Electronics","Golf","Grammar","Geology","Geometry","Heraldry","Law","Linguistics","Logic","Mathematics","Medicine","Microbiology","Military","Music","Philosophy","Photography","Physics","Printing","Prosody","Psychoanalysis","Theology","Zoology"};
                            for (int i = 0; i < sizeof(stringArray) / sizeof(stringArray[0]); i++) {
                                const char* element = stringArray[i];
                                int elementLength = strlen(element);
                                if (strncmp(yytext, element, elementLength) == 0) {

                                yyless(elementLength);
                                REJECT;}
                            }
                            /* printf("Matched TEXT: '%s'\n", yytext); */ 
                            yylval.str_value = strdup(yytext);
                            return TEXT;
                          }


%%

int yywrap() {
  return 1;
}