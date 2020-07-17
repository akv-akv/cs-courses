#include <stdio.h>
#include <cs50.h>

// Print # i times
int hashes(int i)
{
    for (int n = 0; n <= i; n++)
    {
        printf("#"); //Printing hashes
    }
    return 0;
}

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
        hashes(i);
        
        //Printing spaces
        printf("  ");
        
        //Printing hashes again
        hashes(i);
        
        //Printing new line
        printf("\n"); 
    }
}