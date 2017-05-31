# R Heatmap Code
Author: Megan Chen
Date Created: Jan 23, 2017

##Summary

This is a code explanation for superimposed_heatmap.R, a program which superimposes a heatmap onto a jpeg or png image, using a custom heatmap color scheme, and custom heatmap box locations. This outputs two heatmaps with an identical underlying image superimposed with heatmaps that represent different data values. Thus, differences in quantitative data between two groups can be compared visually. These heatmaps are output as png files.

Using the code to create a heatmap requires changing the GLOBAL VARIABLES prior to running the entire program. Below describes the variables and their use in the code:

##1. IMAGE IMPORT

`wkdir` - url string to the directory where your image is located.

`img_url` - url to the image to which you're superimposing the heatmap. If the image is a jpeg file, use lines 18-20 and comment out lines 23-25. If the image is a png file, do the opposite.

##2. DATA
`data1` - vector which holds the numeric values used to color the boxes in the first heatmap. To add or remove boxes from the heatmap, adjust the boxes included in the vector box_dims and edit the box# variables (located under BOX DIMENSIONS AND BORDER).

`data2` - vector which holds the numeric values used to color the boxes in the second heatmap.

NOTE: The two vectors `data1` and `data2` must have the same length. Also, the vector box_dims under BOX DIMENSIONS AND BORDER must also have length n.

##3. BOX DIMENSIONS AND BORDER

`box1` - adjusts the dimensions of `box1` in the heatmap. Each box's edges are represented as a vector `c(xleft, ybottom, xright, ytop)`, in pixels. For the entire image, the *x* coordinates range from 1 to `total_width`, where the left edge is 1. Similarly, the *y* coordinates range from 1 to `total_height`, where the bottom edge has coordinate 1. For example, to move the left edge of box1 to the right, change the first coordinate of the `box1` vector to be some numeric value greater than 1 and less than `total_width`. 

In line 44, change `bCol` to be the desired color of the border of the boxes in the heatmap.

##4. COLOR SCALE
`color_scale` - changes the color scale of the heatmap. Simply add or remove colors from the vector of colors. 

To change the transparency of the heatmap, in line 47, change `transparency_val` to be a value between 0 (completely transparent) and 1 (completely opaque).

`num_interpolated_cols` - the number of colors that will be created in the color palette. 

##5. SCALE INTERVALS
`scale_intervals` - a vector of numeric values that will be displayed on the color legend. (What's the range limitation?). Line 52 is an example of how to label the legend so that it is evenly spaced. Line 53 is an example of how to mark the colors in the heatmap as the legend intervals.

##6. TEXT
`col_scale_title` - the title of color scale displayed for reference

`graphic_title1` - the title of the heatmap generated using data1. In the sample code, the output image will be titled "Graphic Image - Data1"

`graphic_title2` - the title of the heatmap generated using `data2`.

##7. OUTPUT
These are the names of the heatmap images that will be output by the program.

`output_img_name_1` - corresponds with the heatmap generated using `data1`. In the sample code, the output image will be a png file named "d1.png".

`output_img_name_2` - corresponds with the heatmap generated using `data2`

Once all of the global variables are adjusted to satisfaction, run the entire file to generate the heatmaps. The heatmaps will be outputted as png files in the same working directory as the superimposed_heatmap.R file.

More in depth code explanation for the curious:
To create custom color palettes, this file uses the colorRampPalette function from the RColorBrewer package.