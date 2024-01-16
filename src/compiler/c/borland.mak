CFLAGS	= -v -O
CC	= bcc
LIB	= comp.lib l.lib curses.lib termlib.lib
BC_OBJ	= c:\bounds\bct4.obj    # Bounds-checker stuff. Set to empty if you
BC_LIB  = c:\bounds\bct.lib	# aren't running bounds checker

.c.obj:
	$(CC) $(CFLAGS) -c $*.c
#----------------------------------------------------------------------

OBJ1   = decl.obj gen.obj lexyy.obj local.obj main.obj op.obj switch.obj
OBJ2   = symtab.obj temp.obj value.obj yyact.obj
TABLES = yyout.obj

#----------------------------------------------------------------------

c.exe:	$(OBJ1) $(OBJ2) $(TABLES)
	rm -e c?0*
	$(CC) $(CFLAGS) @&&!
yyoutab.obj $(OBJ1) $(OBJ2) $(TABLES) $(BC_OBJ) $(LIB) $(BC_LIB)
!
	mv yyoutab.exe c.exe

#----------------------------------------------------------------------
yyout.obj:	yyout.c yyoutab.c
		$(CC) $(CFLAGS) -c yyout.c
		$(CC) $(CFLAGS) -c yyoutab.c

tables:	       			    # tables makes both yyout.c and yyoutab.c
		occs -vlWDSTp c.y
#----------------------------------------------------------------------
yyact.obj:	yyact.c proto.h symtab.h value.h
yyact.c:	c.y
		occs -vWDa c.y

# yyact-l gives you a parser without the #lines in it.

yyact-l:	c.y
		occs -vWDal c.y

lexyy.obj:	lexyy.c symtab.h yyout.h
lexyy.c:	c.lex
		lex -vl c.lex

decl.obj:	decl.c   symtab.h value.h proto.h
gen.obj:	gen.c    		  proto.h
local.obj:	local.c  symtab.h	  proto.h label.h
main.obj:	main.c 			  proto.h
op.obj:		op.c     symtab.h value.h proto.h label.h
switch.obj:	switch.c symtab.h value.h proto.h label.h switch.h
symtab.obj:	symtab.c symtab.h value.h proto.h label.h
temp.obj:	temp.c   symtab.h value.h proto.h
value.obj:	value.c  symtab.h value.h proto.h label.h