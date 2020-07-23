#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

// Prints usage help message and returns 1;
int usage_message(void)
{
    printf("Usage: ./caesar key\n");
}

// Checks if string contains only digits and return bool
bool only_digits(string text)
{
    bool result = true;
    for (int i = 0; i < strlen(text); i++)
    {
        if (!(isdigit(text[i])))
        {
            return false;
        }
    }
    return result;
}

int main(int argc, string argv[])
{
    // Check number of arguements and show usage help if argc <> 2
    if (argc == 2)
    {
        // Check if all arg symbols are digits, if not - usage helper and return 1
        if (!(only_digits(argv[1])))
        {
            usage_message();
            return 1;
        }
        else
        {
            // Convert shift value int
            int k = strtol(argv[1], NULL, 10);

            // Get input text from user
            string text = get_string("plaintext: ");

            // Cipher output (ci = (pi + k) % 26)
            printf("ciphertext: ");
            for (int i = 0; i < strlen(text); i++)
            {
                if isupper(text[i])
                {
                    printf("%c", ((text[i] - 65) + k) % 26 + 65);
                }
                else if islower(text[i])
                {
                    printf("%c", ((text[i] - 97) + k) % 26 + 97);
                }
                else
                {
                    printf("%c", text[i]);
                }
            }
            printf("\n");
            return 0;
        }
    }
    else
    {
        usage_message(); // Prints usage help message
        return 1;
    }
}