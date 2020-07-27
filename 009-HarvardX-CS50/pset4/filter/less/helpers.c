#include "helpers.h"
#include <stdio.h>
#include <math.h>


// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            int average = round((float)(image[h][w].rgbtBlue + image[h][w].rgbtRed + image[h][w].rgbtGreen) / 3);
            image[h][w].rgbtBlue = average;
            image[h][w].rgbtGreen = average;
            image[h][w].rgbtRed = average;
        }
    }
}

// Set color value to 255 if value is more 255
int roundColor(int color)
{
    if (color > 255)
    {
        color = 255;
    }
    return color;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            // Remember original values
            int originalRed = image[h][w].rgbtRed;
            int originalGreen = image[h][w].rgbtGreen;
            int originalBlue = image[h][w].rgbtBlue;
            // Calculate new color values
            int sepiaRed = (roundColor(round(.393 * originalRed + .769 * originalGreen + .189 * originalBlue)));
            int sepiaGreen = (roundColor(round(.349 * originalRed + .686 * originalGreen + .168 * originalBlue)));
            int sepiaBlue = (roundColor(round(.272 * originalRed + .534 * originalGreen + .131 * originalBlue)));
            // Updating color values
            image[h][w].rgbtBlue = sepiaBlue;
            image[h][w].rgbtGreen = sepiaGreen;
            image[h][w].rgbtRed = sepiaRed;
        }
    }
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE buff[height][width];
    // copy image to buffer
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            buff[h][w] = image[h][w];
        }
    }
    // rewriting image by pixels from buffer (from right to left)
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            image[h][w] = buff[h][width - 1 - w];
        }
    }

}


// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    int count;
    int sumRed;
    int sumGreen;
    int sumBlue;
    // Create duplicate for defining average
    RGBTRIPLE buff[height][width];
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            buff[h][w] = image[h][w];
        }
    }
    // Iterate image pixels and assigning new values based on duplicate average
    for (int h = 0; h < height; h++)
    {
        for (int w = 0; w < width; w++)
        {
            sumRed = 0;
            sumGreen = 0;
            sumBlue = 0;
            count = 0;
            // Iterate 9 pixels around given and checking for corner and edge cases
            for (int i = h - 1; i < h + 2; i++)
            {
                for (int j = w - 1; j < w + 2; j++)
                {
                    // Checking border conditions
                    if ((i > -1) && (j > -1) && (i < height) && (j < width))
                    {
                        // Updating counter and adding color value to sum buffers
                        count++;
                        sumRed += buff[i][j].rgbtRed ; 
                        sumGreen += buff[i][j].rgbtGreen;
                        sumBlue += buff[i][j].rgbtBlue;
                    }
                }
            }
            // Calculate average
            image[h][w].rgbtRed = round((float)sumRed / count);
            image[h][w].rgbtGreen = round((float)sumGreen / count);
            image[h][w].rgbtBlue = round((float)sumBlue / count);
        }
    }
}
