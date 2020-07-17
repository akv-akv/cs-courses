#include <stdio.h>
#include <cs50.h>

int main(void)
{
    //Height input from user with input validation
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1 || height > 8);
    
    //Initiating new line depending on height
    for (int i = 0; i < height; i++)
    {
        
        //Iterating spaces
        for (int j = height; j > i + 1; j--)
        {
            printf(" "); //Printing spaces
        }
        
        //Iterating hashes
        for (int n = 0; n <= i; n++)
        {
            printf("#"); //Printing hashes
        }
        
        //Printing new line
        printf("\n"); 
    }
}