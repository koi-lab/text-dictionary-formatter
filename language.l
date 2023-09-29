%{
  #include "language.tab.h"
%}

delim	[\t\n]
ws	{delim}+
letter	[A-Za-z]
digit	[0-9]
id	{letter}({letter}|{digit})*

%%

{ws}	{ /* no action and no return */ }
"|"             { return PIPE; }
"["             { return LSQUAREBRACKET; }
"]"             { return RSQUAREBRACKET; }
"•"             { return DOT; }
"."             { return PERIOD; }
":"             { return COLON; }
"PHRASES"       { return PHRASES; }
"PHRASAL VERBS" { return PHRASAL VERBS; } 
"DERIVATIVES"   { return DERIVATIVES; }
"ORIGIN"        { return ORIGIN; }
"adverb"        { return ADVERB; } 
"verb"          { return VERB; } 
"pronoun"       { return PRONOUN; } 
"noun"          { return NOUN; } 
"adjective"     { return ADJECTIVE; } 
"preposition"   { return PREPOSITION; } 
"conjunction"   { return CONJUNCTION; } 
"exclamation"   { return EXCLAMATION; }
"mainly US", "Music", "Medicine", "Linguistics", "Microbiology", "Biology", "technical", "litarary", "Chemistry", "Mathematics", "Geology", "Prosody", "Heraldry", "humorous", "Theology", "historical", "Philosophy", "&", "Scottish informal", "mainly North American", "North American,", "North American", "Northern English", "mainly British", "British", "Scottish,", "Scottish", "Logic", "Grammar", "informal,", "informal", "formal", "Baseball", "Physics", "Golf", "archaic", "US", "Computing", "Printing", "Law", "Anatomy", "Zoology", "rare", "Architecture", "Electronics", "Military", "Photography", "Geometry", "Psychoanalysis", "Botany", "or dialect", "dialect", "South Asian"
.        

%%

union value install_id(char* s, int n) {
    int id_number = lookup(s);
    if (id_number == -1)
        id_number = insert(s, ID);
    token_value = id_number;

    return (union value) id_number;
}

int yywrap() {
  return 1;
}