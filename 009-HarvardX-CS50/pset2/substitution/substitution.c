#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

// Prints usage help message and returns 1;
int usage_message(void)
{
    printf("Usage: ./substitution key\n");
    return 1;
}

// Checks if string contains only digits and return bool
bool key_valid(string text)
{
    bool result = true;
    int size = strlen(text);
    if (size != 26)
    {
        return false;
    }
    else
    {
        for (int i = 0; i < strlen(text); i++)
        {
            if (!(isalpha(text[i])))
            {
                return false;
            }
            for (int j = i + 1; j < strlen(text); j++)
            {
                if (text[i] == text[j])
                {
                    return false;
                }
            }
        }
    }
    return result;
}

int main(int argc, string argv[])
{
    // Check number of arguements and show usage help if argc <> 2
    if (argc == 2)
    {
        // Check if key is valid (26 alpha characters)
        if (!(key_valid(argv[1])))
        {
            printf("Key must contain 26 characters.\n");
            return 1;
        }
        else
        {
            // Convert shift value int
            string k = argv[1];

            // Get input text from user
            string text = get_string("plaintext: ");

            // Cipher output
            printf("ciphertext: ");
            for (int i = 0; i < strlen(text); i++)
            {
                // Checking registry of text character and computing same registry character from key chars.
                if isupper(text[i])
                {
                    if isupper(k[text[i] - 65])
                    {
                        printf("%c", k[text[i] - 65]);
                    }
                    else
                    {
                        printf("%c", k[text[i] - 65] - 32);
                    }
                }
                else if islower(text[i])
                {
                    if islower(k[text[i] - 97])
                    {
                        printf("%c", k[text[i] - 97]);
                    }
                    else
                    {
                        printf("%c", k[text[i] - 97] + 32);
                    }
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