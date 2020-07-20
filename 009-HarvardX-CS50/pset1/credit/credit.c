#include <stdio.h>
#include <math.h>
#include <cs50.h>


int main(void)
{
    long card;
    int size;
    //Card number input
    card = get_long("Number: ");
    size = (int)floor(log10(card)) + 1;


    //Length validation
    if (size == 13 || size == 15 || size == 16)
    {
        // Converting card number to array of int
        int n[size];
        for (int i = 0; i < size; i++)
        {
            n[i] = card % 10;
            card = round(card / 10);
            //printf("%d\n",n[i]);
        }
        // Luhn algorithm
        int sumOdd = 0;
        int sumEven = 0;
        for (int i = 1; i < size; i += 2)
        {
            sumOdd += (n[i] * 2 % 10) + floor(n[i] * 2 / 10);
        }
        for (int i = 0; i < size; i += 2)
        {
            sumEven += n[i];
        }
        //printf("%d\n",sumOdd);
        //printf("%d\n",sumEven);
        int luhn = sumOdd + sumEven;
        printf("Size: %d\n n[size]:%d\n n[size-1] %d\n luhn %d\n", size, n[size - 1], n[size - 2], luhn);
        if ((luhn % 10) == 0)
        {
            if ((size == 15) && (n[size - 1] == 3) && ((n[size - 2] == 4) || (n[size - 2] == 7)))
            {
                printf("AMEX\n");
            }
            else if ((size == 16) && (n[size - 1] == 5) \
    && (n[size - 2] == 1 || n[size - 2] == 2 || \
    n[size - 2] == 3 || n[size - 2] == 4 || n[size - 2] == 5))
            {
                printf("MASTERCARD\n");
            }
            else if (((size == 13) || (size == 16)) && (n[size - 1] == 4))
            {
                printf("VISA\n");
            }
            else
            {
                printf("INVALID\n");
            }
        }
        else
        {
            printf("INVALID\n");
        }
    }
    else
    {
        printf("INVALID\n");
    }
}