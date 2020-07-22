#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <math.h>

int count_letters(string text)
{
    int result = 0;
    for (int i = 0; i < strlen(text); i++)
    {
        if isalpha(text[i])
        {
            result++;
        }
    }
    return result;
}

int count_words(string text)
{
    int result = 0;
    for (int i = 0; i < strlen(text); i++)
    {
        if isspace(text[i])
        {
            result++;
        }
    }
    return result + 1;
}

int count_sentences(string text)
{
    int result = 0;
    char dot[2] = ".";
    char exc[2] = "!";
    char que[2] = "?";
    for (int i = 0; i < strlen(text); i++)
    {
        if (((text[i] == dot[0]) || (text[i] == exc[0])) || (text[i] == que[0]))
        {
            result++;
        }
    }
    return result;
}

int main(void)
{
    // The Coleman-Liau index of a text
    // index = 0.0588 * L - 0.296 * S - 15.8
    // String input from user
    string text = get_string("Text: ");
    int letters = count_letters(text); // Letters in text
    int words = count_words(text); // Words. in text
    int sentences = count_sentences(text); // Sentences in text
    float L = letters * 100 / (float)words; //the average number of letters per 100 words in the text
    float S = sentences * 100 / (float)words; //is the average number of sentences per 100 words in the text.
    int index = (int)(round((0.0588 * L - 0.296 * S - 15.8)));
    // result output
    if (index > 16)
    {
        printf("Grade 16+\n");
    }
    else if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else
    {
        printf("Grade %d\n", index);
    }
}