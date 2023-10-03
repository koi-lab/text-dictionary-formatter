OBJECTS = language.tab.o lex.yy.o
SOURCES = language.tab.c lex.yy.c
EXE = language
CFLAGS += -Wall -g -lm

$(EXE):	$(OBJECTS)
	gcc -o $(EXE) $(OBJECTS) $(CFLAGS)

lex.yy.c: language.l
	flex language.l

language.tab.c language.tab.h: language.y
	bison -d language.y