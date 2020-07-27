#include "helpers.h"
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

// Set color value to 255 if value is more 255
int roundColor(int color)
{
    if (color > 255)
    {
        color = 255;
    }
    return color;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    // TODO variables declaration
    int gRed, gGreen, gBlue;
    int gXRed, gYRed;
    int gXGreen, gYGreen;
    int gXBlue, gYBlue;
    int xKernel[3][3] = 
    {
        {-1, 0, 1}, 
        {-2, 0, 2}, 
        {-1, 0, 1}
    };
        
    int yKernel[3][3] = 
    {
        {-1, -2, -1},
        {0, 0, 0},
        {1, 2, 1}
    };
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
            // TODO constant instanciation
            gRed = 0;
            gGreen = 0;
            gBlue = 0;
            gXRed = 0;
            gXGreen = 0;
            gXBlue = 0;
            gYRed = 0;
            gYGreen = 0;
            gYBlue = 0;
            // Iterate 9 pixels around given and checking for corner and edge cases
            for (int i = h - 1; i < h + 2; i++)
            {
                for (int j = w - 1; j < w + 2; j++)
                {
                    // Checking border conditions
                    if ((i > -1) && (j > -1) && (i < height) && (j < width))
                    {
                        // TODO calculation of Gx and Gy for each color
                        gXRed += buff[i][j].rgbtRed * xKernel[i - h + 1][j - w + 1] ; 
                        gXGreen += buff[i][j].rgbtGreen * xKernel[i - h + 1][j - w + 1];
                        gXBlue += buff[i][j].rgbtBlue * xKernel[i - h + 1][j - w + 1];
                        gYRed += buff[i][j].rgbtRed * yKernel[i - h + 1][j - w + 1] ; 
                        gYGreen += buff[i][j].rgbtGreen * yKernel[i - h + 1][j - w + 1];
                        gYBlue += buff[i][j].rgbtBlue * yKernel[i - h + 1][j - w + 1];
                    }
                }
            }
            //  TODO Calculate results and 
            gRed = roundColor(round(sqrt(pow(gXRed, 2) + (pow(gYRed, 2)))));
            gGreen = roundColor(round(sqrt(pow(gXGreen, 2) + (pow(gYGreen, 2)))));
            gBlue = roundColor(round(sqrt(pow(gXBlue, 2) + (pow(gYBlue, 2)))));
            image[h][w].rgbtRed = gRed;
            image[h][w].rgbtGreen = gGreen; 
            image[h][w].rgbtBlue = gBlue;
        }
    }
}
