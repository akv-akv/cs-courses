#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef uint8_t BYTE;

int main(int argc, char *argv[])
{
    // Checking proper number of arguments
    if (argc != 2)
    {
        printf("Usage: ./recover filename");
        return 1;
    }
    
    // Remember filenames
    char *infile = argv[1];
    
    // Open file
    FILE *inptr = fopen(infile, "r");
    
    // Checking if file opens
    if (inptr == NULL)
    {
        printf("File cannot be opened for reading");
        return 1;
    }

    // declaring variables
    FILE *img = NULL;
    unsigned char buffer[512];
    int number = 0;
    char filename[8];

    //while card file read is not empty
    while (fread(buffer, 512, 1, inptr))
    {
        //does the fread start from jpg intro?
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff
            && (buffer[3] >= 0xe0 && buffer[3] <= 0xef))
        {
            // If yes then open file and write block into it
            sprintf(filename, "%03d.jpg", number);
            number ++;
            img = fopen(filename, "w");
            fwrite(&buffer, 512, 1, img);
        }
        else
        {
            // if no output file open go to next block, else append block to file
            if (img != NULL)
            {
                fwrite(&buffer, 512, 1, img);
            }
        }
    }
    
    fclose(img);
    fclose(inptr);

}
