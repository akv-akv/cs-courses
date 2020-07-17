#include <stdio.h>
#include <math.h>
#include <cs50.h>


int main(void)
{
    long card;
    int size;
    //Card number input
    card = get_long("Number: ");
    size = (int)floor(log10(card))+1;

    //Length validation
    if (size == 13 || size == 15 || size == 16)
    {
        printf("TODO\n");
    }
    else
    {
        printf("INVALID\n");
    }
}