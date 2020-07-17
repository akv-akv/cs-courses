#include <stdio.h>
#include <cs50.h>
#include <math.h>

int main(void)
{
    // Getting input from user in dollars with validation
    float dollars;
    do
    {
        dollars = get_float("Change owed: ");
    }
    while (dollars < 0);
    
    // Converting dollars to cents
    int cents = round(dollars * 100);
    
    // Coins counter
    int quaters = floor(cents / 25);
    printf("%d\n", cents);
    cents = cents - 25 * quaters;
    int dimes = floor(cents / 10);
    cents = cents - 10 * dimes;
    int nickels = floor(cents / 5);
    cents = cents - 5 * nickels;
    int pennies = cents;
    int counter = quaters + dimes + nickels + pennies;
    printf("%d\n", counter);
}
