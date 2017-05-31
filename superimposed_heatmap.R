#superimposed_heatmap.R
#Superimposes a heat map onto a jpeg or png image, using a custom heatmap color scheme, and custom heatmap box locations
#Date Created: Aug 26, 2016
#Author: Megan Chen

#removes all vars in your environment
rm(list=ls(all=TRUE))

# =======================
# ===== Global Vars =====
# =======================
#=== IMAGE IMPORT ===
wkdir <- "/Users/meganchen/Desktop/Wellesley/QAI/Bahns-EyeTrackerVisualization/superimposed_heatmap" #current working directory
setwd(wkdir)

img_url <-'robot.png'
#reads the jpeg versions of background photos
#install.packages("jpeg")
#library(jpeg)
#pic <- readJPEG(img_url, native=FALSE) #for jpeg images

#reads the png versions of background photos 
#install.packages("png")
library(png)
pic <- readPNG(img_url, native=FALSE) #for png images

total_width <- ncol(pic) #total width of the image
total_height <- nrow(pic) #total height of the image

#=== DATA ===
data1 <- seq(from = 0.2, to = 1, by= 0.2) #numeric values to represent in the first heatmap
data2 <- c(0.2, 0.9, 0.4, 0.05, 0.8) #numeric values to represent in the second heatmap
data <- c(data1, data2)


#=== BOX DIMENSIONS AND BORDER ===
#c(xleft, ybottom, xright, ytop), in pixels
box1 <- c(2, 3, total_width, 190)
box2 <- c(1, 190, total_width, 260)
box3 <- c(1, 260, total_width, 375)
box4 <- c(1, 375, total_width, 500)
box5 <- c(1, 500, total_width, total_height)
box_dims <- c(box1, box2, box3, box4, box5)

#for Taylor
if(FALSE){
#data for Taylor
data1 <- c(0.99, 0.4, 0.85, 0.45, 0.01) #numeric values to represent in the first heatmap
data2 <- c(0.95, 0.35, 0.1, 0.2, 0.05) #numeric values to represent in the second heatmap
data <- c(data1, data2)

box5 <- c(150, 1, 800, 200)
box4 <- c(150, 200, 800, 500)
box3 <- c(200, 500, 850, 800)
box2 <- c(200, 800, 850, 1200)
box1 <- c(350, 1200, 700, total_height)
box_dims <- c(box1, box2, box3, box4, box5)
}

#for Buzzfeed
if(FALSE){
#data for Buzzfeed
data1 <- c(0.99, 0.4, 0.85, 0.45, 0.01) #numeric values to represent in the first heatmap
data2 <- c(0.95, 0.35, 0.1, 0.30, 0.65) #numeric values to represent in the second heatmap
data <- c(data1, data2)
	
box5 <- c(200, 100, 900, 250)
box4 <- c(970, total_height - 150, 1300, total_height - 60)
box3 <- c(200, 300, 900, 350)
box2 <- c(200, 350, 750, 400)
box1 <- c(200, 400, 900, total_height - 250)
box_dims <- c(box1, box2, box3, box4, box5)
}

bCol <- "black" #box border color

#=== COLOR SCALE ===
transparency_val <- 0.5 #how transparent your boxes are
color_scale <- c("black", "red", "yellow") #vector of colors
num_interpolated_cols <- 100 #num colors in the color palette

#=== SCALE INTERVALS ===
scale_interval <- seq(from = 0, to = 1, by = 0.2) #labels to display on color legend
#scale_interval <- c(data1, 0, 1) #labels to display on color legend, includes 0, 1, and all values which appear in the heat map

#=== TEXT ===
col_scale_title <- 'Scale Title'
graphic_title1 <- 'Graphic Image - Data1'
graphic_title2 <- 'Graphic Image - Data2'

#=== OUTPUT ===
output_img_name_1 <- 'd1.png'
output_img_name_2 <- 'd2.png'

# ==============================
# === Functions and Packages ===
# ==============================

#installs the RColorBrewer package, used for creating the heatmap color palettte
#install.packages("RColorBrewer")
library(RColorBrewer)

#function that adds alpha (transparency) value to a color
#col = color or color palette
#alpha = transparency value, between 0.0-1.0
add.alpha<- function(col, alpha=1){
	if(missing(col))
		stop("Please provide a vector of colors.")
	apply(sapply(col, col2rgb)/255,2,
		function(x)
			rgb(x[1], x[2], x[3], alpha=alpha))
}

#creates a color palette
#n is number of colors to interpolate/create
colPalette <- colorRampPalette(color_scale)(n=num_interpolated_cols)

#adds transparency value to the colPalette 
colPalette<- add.alpha(colPalette, transparency_val)

#installs shape package, used for plotting the color legend
#install.packages("shape")
library(shape)

#creates the background image and overlayed boxes (heatmap) once
img_heatmap_create <- function(data, graphic_title, output_img_name){
	
	d<-data
	
	png(filename=output_img_name, units='px', width=max(total_width, total_height), height=max(total_width, total_height)) #saves resulting image to a png file
	
	#margins adjustment
	#bottom, left, top, right
	ifelse(total_width > total_height, par(mar=c(5.1, 2.1, 4.1, 10)), par(mar=c(5.1, 2.1, 4.1, 2.1)))
	
	if(exists("rasterImage")){
		
		#creates an empty plot
		plot(1:max(total_height, total_width), type="n", bty="n", xaxt='n', yaxt='n', ann=FALSE)
		
		#plots the image
		rasterImage(pic, 1, 1, total_width, total_height)
		
		#matrix of data values to represent in the heat map
		m<-data.frame(matrix(data=box_dims, ncol=4, byrow=TRUE))
		
		#iteratively creates each box and colors it
		for(row in 1:nrow(m)){
			rect(m[1][row,], m[2][row,], m[3][row,], m[4][row,], border=bCol, col=colPalette[d[row]*100])
		}
	}
	
	colorlegend(col=colPalette, c(0,1), zval=c(scale_interval, 0, 1), main=col_scale_title, posx=c(0.89,0.9), posy=c(0.1, 0.9), digit=2) #inserts a legend
	
	title(graphic_title) #adds a title to the graphic
	
	dev.off() #closes the plot, saves it as a png
}

#creates the image outputs
img_heatmap_create(data1, graphic_title1, output_img_name_1)
img_heatmap_create(data2, graphic_title2, output_img_name_2)

