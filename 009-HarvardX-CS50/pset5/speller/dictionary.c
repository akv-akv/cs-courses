// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <ctype.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 20000;

// Hash table
node *table[N];

// Word counter
int word_counter = 0;

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    // Create a copy of word with all lower chars.
    char word_copy[LENGTH + 1];
    int n = strlen(word);
    for (int i = 0; i < n; i++)
    {
        word_copy[i] = tolower(word[i]);
    }
    word_copy[n] = '\0';

    // Hashing prepared word copy
    int h = hash(word_copy);

    // Finding table bucked for the hashed word and setting cousor to the head of list
    node *cursor = table[h];

    // If the word exists, you should be able to find in dictionary data structure.
    // Check for word by asking, which bucket would word be in? hashtable[hash(word)]
    // While cursor does not point to NULL, search dictionary for word.
    while (cursor != NULL)
    {
        // Comparing word_copy with cursor->word
        if (strcasecmp(cursor->word, word_copy) == 0)
        {
            return true;
        }
        else // if not found try next node
        {
            cursor = cursor->next;
        }
    }
    // Cursor has reached end of list and word has not been found in dictionary so it must be misspelled
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    int hash = 401;
    int c;
    
    while (*word != '\0')
    {
        hash = ((hash << 4) + (int)(*word)) % N;
        word++;
    }
    return hash % N;
}


// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Open dictionary
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        unload();
        return false;
    }

    // Buffer for a word
    char word[LENGTH + 1];

    // Insert words into hash table
    while (fscanf(file, "%s", word) != EOF)
    {
        // Allocates memory for a new word node and returns false if not succeeded
        node *new_word = malloc(sizeof(node));
        if (new_word == NULL)
        {
            unload();
            return false;
        }
        
        // Puts scanned word to new_word node
        strcpy(new_word->word, word);

        // Hashes word
        int h = hash(new_word->word);

        // Initializes head to point to hashtable index/bucket
        node *list_head = table[h];

        // Inserts new nodes at beginning of lists
        // Checks if there is no list linked
        if (list_head == NULL)
        {
            new_word->next = NULL;
            table[h] = new_word; // Adds node as a first element
        }
        else // If list already exists
        {
            new_word->next = table[h]; // Puts list to the node next field
            table[h] = new_word; // Adds updated node as a first element
    
        }
        word_counter++;
    }

    // Close dictionary
    fclose(file);

    // Indicate success
    return true;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    return word_counter;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        if (table[i] != NULL)
        {
            node *cursor = table[i];
            // freeing linked lists
            do
            {
                node *temp = cursor;
                cursor = cursor->next;
                free(temp);
            }
            while (cursor != NULL);
        }
    }
    return true;
}
