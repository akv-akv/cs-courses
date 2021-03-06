#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}

// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{
    for (int i = 0; i < candidate_count; i++)
    {
        if (strcmp(candidates[i], name) == 0)
        {
            ranks[rank] = i;
            return true;
        }
    }
    return false;
}

// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    int posI = 0;
    int posJ = 0;
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            // Define position of candidate in rank
            for (int n = 0; n < candidate_count; n++)
            {
                if (ranks[n] == i)
                {
                    posI = n;
                }
                if (ranks[n] == j)
                {
                    posJ = n;
                }
                
            }
            if (posI < posJ)
            {
                preferences[i][j]++;
            }
        }
    }

}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            if (preferences[i][j] > preferences[j][i])
            {

                pairs[pair_count].winner = i;
                pairs[pair_count].loser = j;
                pair_count += 1;
                // printf("Pair %d Winner: %d, Loser: %d, Votes: %d\n", pair_count, i, j, preferences[i][j] - preferences[j][i]);
            }
        }
    }
}

// Compare pairs (for sort_pair)
bool first_pair_stronger(pair p1, pair p2)
{
    return (preferences[p1.winner][p1.loser] > preferences[p2.winner][p2.loser]);
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    pair buff;
    for (int j = 0; j < pair_count; j++)
    {
        for (int i = 0; i < pair_count - 1; i++)
        {
            if (!(first_pair_stronger(pairs[i], pairs[i + 1])))
            {
                buff =  pairs[i];
                pairs[i] = pairs[i + 1];
                pairs[i + 1] = buff;
            }
        }
    }
}

//helper for lock_pairs, defines if argument creates cycle in graph locked.
bool is_cycle(int winner, int loser)
{
    bool result = false;
    if (locked[loser][winner] == true) // Checking for short cycle
    {
        result = true;
    }
    else // Checking for cycle between winner and all loser of the loser
    {
        for (int i = 0; i < candidate_count; i++)
        {
            if (locked[loser][i])
            {
                result = is_cycle(winner, i);
            }
        }
    }
    return result;
}


// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    for (int i = 0; i < pair_count; i++)
    {
        if (!(is_cycle(pairs[i].winner, pairs[i].loser))) // Checking for cycle between winner and loser 
        {
            locked[pairs[i].winner][pairs[i].loser] = true;
        }
    }
}

// Print the winner of the election
void print_winner(void)
{
    for (int j = 0; j < candidate_count; j++)
    {
        int count = 0;
        for (int i = 0; i < candidate_count; i++)
        {
            if (locked[i][j] == true)
            {
                count++;
            }
        }
        if (count == 0) // if column consists of only false elements
        {
            printf("%s\n", candidates[j]); // candidate is the winner
        }
    }
}

