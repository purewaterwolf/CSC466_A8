#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	//declare 
	int x;
	int y;
	char g[24];  //declare string
	int i;
	
	//assign
	y = 11;     //assign int
	x = 3 * y;  //assign expr
	strcpy(g, "hello world");  //assign string
	
	//prints
	printf ("x= %d\n", x);  //printi
	printf("%s\n",g); //printsh
	
		//printsv
	i=0;
	while (g[i] != '\0')
	{
		printf("%c\n", g[i]);
		i++;
	}
}
