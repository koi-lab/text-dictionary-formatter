%{
  #include "language.tab.h"
  #include <stdio.h>
  #include <ctype.h> 
%}

%%


" "        { }
"|"                 { return PIPE; }
"•"                 { return DOT; }
"."                 { return PERIOD; }
":"                 { return COLON; }
[0-9]+              { printf("Matched NUMBER: %s\n", yytext); return NUMBER; }
"mainly"            { return MAINLY; }
\n                  { return END; }

"British"|"North American"|"Northern English"|"Scottish"|"South Asian"|"US"|"North American English"                      { printf("Matched ADJECTIVAL '%s'\n", yytext); return ADJECTIVAL; }
"archaic"|"dialect"|"formal"|"historical"|"humorous"|"informal"|"litarary"|"rare"|"technical"    { printf("Matched REGISTER '%s'\n", yytext); return REGISTER; }
"adjective"|"adverb"|"conjunction"|"exclamation"|"noun"|"preposition"|"pronoun"|"verb"           { printf("Matched PART_OF_SPEECH '%s'\n", yytext); return PART_OF_SPEECH; }
"DERIVATIVES"|"ORIGIN"|"PHRASES"|"PHRASAL VERBS"                                                 { printf("Matched ADDITIONAL_INFO_HEADER '%s'\n", yytext); return ADDITIONAL_INFO_HEADER; }

"Anatomy"|"Architecture"|"Baseball"|"Biology"|"Botany"|"Chemistry"|"Computing"|"Electronics"|"Golf"|"Grammar"|"Geology"|"Geometry"|"Heraldry"|"Law"|"Linguistics"|"Logic"|"Mathematics"|"Medicine"|"Microbiology"|"Military"|"Music"|"Philosophy"|"Photography"|"Physics"|"Printing"|"Prosody"|"Psychoanalysis"|"Theology"|"Zoology"            { printf("Matched DISCIPLINE: %s\n", yytext); return DISCIPLINE; }

\[.+\]                    { printf("Matched USAGE_INFO '%s'\n", yytext); return USAGE_INFO; }
[a-z]+[ ][a-z·]*[ ]?"|"[ ].+[ ]"|"+[ ]           { /*printf("Matched WORD_AND_PRONUNCIATION_GUIDE '%s'\n", yytext);*/ return WORD_AND_PRONUNCIATION_GUIDE; }
[^•|\[\].:\n]+            { if (isdigit(yytext[0])) {
                                yyless(1);   
                                REJECT;      
                            }                       
                            if (yytext[0] == ' ') {
                                yyless(1);
                                REJECT;                                
                            }
                            const char* stringArray[] = {"British","North American","Northern English","Scottish","South Asian","US","archaic","dialect","formal","historical","humorous","informal","litarary","rare","technical","adjective","adverb","conjunction","exclamation","noun","preposition","pronoun","verb","DERIVATIVES","ORIGIN","PHRASES","PHRASAL VERBS","Anatomy","Architecture","Baseball","Biology","Botany","Chemistry","Computing","Electronics","Golf","Grammar","Geology","Geometry","Heraldry","Law","Linguistics","Logic","Mathematics","Medicine","Microbiology","Military","Music","Philosophy","Photography","Physics","Printing","Prosody","Psychoanalysis","Theology","Zoology"};
                            for (int i = 0; i < sizeof(stringArray) / sizeof(stringArray[0]); i++) {
                                const char* element = stringArray[i];
                                int elementLength = strlen(element);
                                if (strncmp(yytext, element, elementLength) == 0) {

                                yyless(elementLength);
                                yyless(1);
                                REJECT;}
                            }
                            printf("Matched TEXT: %s\n", yytext); 
                            return TEXT;
                        }
.                         { return WILDCARD; }

%%

int yywrap() {
  return 1;
}