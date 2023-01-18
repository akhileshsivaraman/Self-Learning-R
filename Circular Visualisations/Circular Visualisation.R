##### Circular Visualisation in R #####
library(circlize)

##### Chapter 1 Introduction #####
# a circular layout is composed of sectors and tracks.
# data is plotted into different sectors based on their category
# the intersection of a track and a sector is called a cell (or a grid/panel) - cells are the basic unit in a circular layout

### 1.1
circos.points() # adds points in a cell, need to call circos.plot() before adding graphics
circos.lines() # adds lines in a cell
circos.segments() # adds segments in a cell
circos.rect() # adds rectangles in a cell
circos.polygon() # adds polygons in a cell
circos.text() # adds text in cell
circos.axis() circos.yaxis() # add axes in a cell

circos.initialize() # allocates sectors on the circle
circos.track() # creates plotting regions for cells in one singular track
circos.update() # updates an existing cell
circos.par() # changes graphic parameters
circos.info() # prints general parameters of current circular plot
circos.clear() # resets graphic parameters and internal variables - stops adding to the current plot and sets up the plotting space for a new plot

### 1.2
set.seed(999)
n <- 1000
df <- data.frame(factors = sample(letters[1:8], n, replace = T),
                 x = rnorm(n), y = runif(n))
circos.par("track.height" = 0.1) # set the track to have a height of 0.1 which is 10% of the circle, which is always a unit circle
circos.initialize(factors = df$factors, x = df$x) # x values are categorised by factors. Allocating sectors only requires the x direction (y is not necessary)

circos.track(factors = df$factors, y = df$y, # before drawing anything, tracks should be created first, x ranges have already been specified in initialize
             panel.fun = function(x, y) { # panel.fun adds graphics to the current cell - adds graphics as soon as the cell is created
               circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + uy(5, "mm"), # adds sector names, CELL_META retrieves meta information of the current cell
                           CELL_META$sector.index) # sector names are drawn outside of the track, uy() offsets the text in the y direction
               circos.axis(labels.cex = 0.6) 
             })
col <- rep(c("green", "red"), 4)
circos.trackPoints(df$factors, df$x, df$y, col = col, pch = 16, cex = 0.5) # adds points, requires categorical variable (sector), x and y directions
circos.text(-1, 0.5, "text", sector.index = "b", track.index = 1) # circos.text() can be used outside of panel.fun but sector and track must be specified

bgcol <- rep(c("#EFEFEF", "#CCCCCC"), 4) # changes background colour of histograms and repeats it 4 times
circos.trackHist(df$factors, df$x, bin.size = 0.2, bg.col = bgcol, col = NA)

circos.track(factors  = df$factors, x = df$x, y = df$y,
             panel.fun = function(x,y) { # 10 data points in each category are selected then connected with lines
               ind = sample(length(x),10)
               x2 = x[ind]
               y2 = y[ind]
               od = order(x2)
               circos.lines(x2[od], y2[od])
             })

circos.update(sector.index = "d", track.index = 2,
              bg.col = "#FF8080", bg.border = "black")
circos.points(x = -2:2, y = rep(0.5,5), col = "white")
circos.text(CELL_META$xcenter, CELL_META$ycenter, "updated", col = "purple")

circos.link("a", 0, "b", 0, h = 0.4) # draws a link between a and b
circos.link("c", c(-0.5,0.5), "d", c(-0.5, 0.5), col = "red", border = "black", h = 0.9) # the vector following the sector name dictates the width of the link at that sector
circos.link("e", 0, "g", c(-2,2), col = "steelblue", border = "orange", lwd = 2, lty = 3) # lty changes the type of line (dashed, solid, etc)

circos.clear()



##### Chapter 2 Circular Layout #####
### 2.2 Rules of Plotting 
# when making the circular plot you need to create the track first before adding graphics

### 2.3 Sectors and Tracks
# sectors are first allocated on the circle by circos.initialize() using factors
# each sector corresponds to one category
# sector width, measured in degrees, are proportional to the data range of a factor in the x direction
# the initialisation step does not define a track - it sets the width of the sector and the order of the sectors
# cells in the same sector share the same data range on the x-axes so we need to specify the data range on the y-axes
# you can plot specifically to one cell - in which case it behaves like a standard rectangular plot

### 2.4 Graphic Parameters
# all set using circos.par() - must be used before circos.initialize
start.degree # starting degree where the first sector is put, moves anti-clockwise as per the polar coordinate system
gap.degree # gap between adjacent sectors. Can be a single value so all sectors are spearated by the same width or it can be a vector
track.margin # a percentage value of the radius of the unit circle - affetcs the blank area outside the plotting region
unit.circle.segments # controls the amount of segments that represent a curve (think of trapezium rule, more segments = more accurate)
track.height # height of the tracks, a percentage of unit circle radius. Can also be set by uh()
canvas.xlim # circlize by default works with the unit circle so canvas.xlim and .ylim are c(-1,1). Changes the plotting region size. Anything smaller than the unit circle produces segments of the circle

### 2.7 panel.fun
# takes x and y from circos.track(factors = , x = , y = , panel.fun = )
# no need to specify sector.index and track.index with panel.fun because panel.fun draws immediately after the cell is created
# inside panel.fun, information of the current cell can be obtained using get.cell.meta.data()
# get.cell.meta.data() can get - place the command in ""
  # sector.index - name of the sector
  # sector.numeric.index - numeric index of the sector
  # track.index - numeric index of the track
  # xlim and ylim - min and max values on the axes
  # xcenter and y center - mean of lim
  # xrange and yrange - xlim[2]-xlim[1]
  # cell.xlim - min and max values of the axis extended by cell paddings
  # xplot - degree of right and left borders in the plotting region
  # yplot - radius of bottom and top radius in the plotting region
  # track.margin - margins of the cell
  # cell.padding - paddings of the cell
# can use CELL_META$ with the command in place of get.cell.meta.data() - CELL_META$ only extracts information from the current cell so is used in panel.fun always


### 2.8 Other Utilities
circos.info() # calls basic information
circos.clear() # always call after finishing a plot



##### Chapter 3 Graphics #####
### 3.1 Points
circos.points(x = , y = , pch = , col = , cex = )
circos.trackPoints() # adds points to all sectors simultaneously, must contain a vector of categorical factors

### 3.2 Lines
circos.lines(x = , y = , col = , lwd = , lty = , straight = T/F) # use lty = to change the type of line
# straight lines  are transformed to curves => segments are generated to represent the curve
# circlize balances quality and size of the figure  but unit.circle.segments can be used in circos.par() to set the length of the segments
# length of the segment is calculated as the length of the unit circle (2pi) divided by unit.circle.segments

### 3.3 Segments
circos.segments(x0 = , y0 = , x1 = , y1 = ) # used similarly to segments()

### 3.4 Text
circos.text(x = , y = , labels = , facing = , adj = , cex = , col = , font = )
# facing can be inside, outside, clockwise, reverse.clockwise, downward, bending.inside, bending.outside
# niceFacing can be used inside circos.text() to automatically adjust text
# adj = c() modifies text positions horizontally and vertically

### 3.5 Rectangles and Polygons
circos.rect(xleft = , ybottom = , xright = , ytop = , col = , border = , lty = , lwd = ) # upper and bottom edges are curved
circos.polygon(x = , y = , col = , border = , lty = , lwd = ) # first and last data points must overlap

### 3.6 Axes
circos.axis(h = , major.at = , # only x-axis
            major.tick = , minor.ticks = , major.tick.length = , direction = , labels = , labels.niceFacing = )
circos.yaxis(side =  , at = , labels = ) # need to adjust gap.degree in circos.par() to make space for the y-axis

### 3.9 Links
circos.link(sector.index1 = , c(), sector.index2 = , c(), col = , lwd = , lty = , border = , h =) # draws links between single points and intervals
# four mandatory arguments: index for the first sector, positions on the first sector, index for the second sector and positions on the second sector
# position of the link end is controleed by rou. rou1 and rou2 can be sued to adjust the positions of two ends
# h = controls height of the link

### 3.10 Highlight sectors and tracks
draw.sector(start.degree = , end.degree = , rou1 = , rou2 = , center = , col = , lwd = , lty = , border = )
# requires arguments for the position of the circle centre (by default c(0,0)), the start degree, the end degree and radius for the two edges
# direction from start.degree to end.degree is by defalut clockwise but can change with clock.wise = F

par(mar = c(1, 1, 1, 1))
plot(c(-1, 1), c(-1, 1), type = "n", axes = F, ann = F, asp = 1)
draw.sector(20, 0)
draw.sector(30, 60, rou1 = 0.8, rou2 = 0.5, clock.wise = FALSE, col = "#FF000080")
draw.sector(15, 340, col = "#00FF0080", border = NA, rou1 = 0, rou2 = 1) ## this one for sd around the arrows
draw.sector(0, 180, rou1 = 0.25, center = c(-0.5, 0.5), border = 2, lwd = 2, lty = 2)
draw.sector(0, 360, rou1 = 0.7, rou2 = 0.6, col = "#0000FF80")

### 3.11 Work together with the base graphic system
# simply using functions after the plot as per R's base system adds to the graphic
title()
legend()