#include "cur.h"

void waddstr( win, str )
WINDOW	*win;
char	*str;
{
    while( *str )
	waddch( win, *str++ );
}
