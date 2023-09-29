%{
  #include "language.tab.h"
%}

ws    [ \t\n]+

%%

{ws}                { /* do nothing */ }
"|"                 { return PIPE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
"•"                 { return DOT; }
"."                 { return PERIOD; }
":"                 { return COLON; }
"mainly"            { return MAINLY; }

"British"|"North American"|"Northern English"|"Scottish"|"South Asian"|"US"                      { return ADJECTIVAL; }
"archaic"|"dialect"|"formal"|"historical"|"humorous"|"informal"|"litarary"|"rare"|"technical"    { return REGISTER; }
"adjective"|"adverb"|"conjunction"|"exclamation"|"noun"|"preposition"|"pronoun"|"verb"           { return PART_OF_SPEECH; }
"DERIVATIVES"|"ORIGIN"|"PHRASES"|"PHRASAL VERBS"                                                 { return ADDITIONAL_INFO; }

"Anatomy"|"Architecture"|"Baseball"|"Biology"|"Botany"|"Chemistry"|"Computing"|"Electronics"|"Golf"|"Grammar"|"Geology"|"Geometry"|"Heraldry"|"Law"|"Linguistics"|"Logic"|"Mathematics"|"Medicine"|"Microbiology"|"Military"|"Music"|"Philosophy"|"Photography"|"Physics"|"Printing"|"Prosody"|"Psychoanalysis"|"Theology"|"Zoology"            { return DISCIPLINE; }

%%
