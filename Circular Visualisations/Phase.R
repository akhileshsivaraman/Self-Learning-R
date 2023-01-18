library(circlize)
library(ggplot2)

## code to generate clock face
circos.par(gap.degree = 0, cell.padding = c(0, 0, 0, 0), start.degree = 90)
circos.initialize(factors = c("a"), xlim = c(0, 24))
circos.track(ylim = c(0, 1), bg.border = F,  track.height = 0.00001) 
circos.axis(h = "top", major.at = c(0,6,12,18,24,0), labels = F, direction = "inside", 
            major.tick = T, minor.ticks = 5, major.tick.length = uy(4, "mm"))
circos.text(c(6), c(6), labels = c("6"), facing = "downward", adj = c(-0.5,0.5))
circos.text(c(12), c(12), labels = c("12"), facing = "downward", adj = c(0.5,1.3))
circos.text(c(18), c(18), labels = c("18"), facing = "downward", adj = c(1.12, 0.5))
circos.text(c(24), c(24), labels = c("24"), facing = "downward", adj = c(0.5,-0.5))
circos.track(ylim = c(0, 1), bg.border = F, track.height = 0.945)
circos.yaxis(side = "left", labels.cex = 0.7, tick = F)


## write a function
random.comparisons <- function(number.tips, number.trees, difference.function) {
  trees1 <- rmtree(number.trees, number.tips, br = NULL, rooted = F)
  trees2 <- rmtree(number.trees, number.tips, br = NULL, rooted = F)
  result <- median(unlist(mapply(difference.function, trees1, trees2, SIMPLIFY = F)))
  return(result)
}

phaseplot <- function(ph24, ci, R){}


## 
ph24.1 <- 1.4 
ci.1 <- 24
R.1 <- 0.396
# convert hours to degrees
ph24.1 <- 15*ph24.1
ci.1 <- 15*ci.1
# draw arrow for Ph24
ph24.1r <- ph24.1*pi/180
x.1 <- cos(pi/2 - ph24.1r)*R.1
y.1 <- sin(pi/2 - ph24.1r)*R.1
arrows(x0 = 0, y0 = 0, x1 = x.1, y1 = y.1, lty = 2, lwd = 2, col = "#CD5C5C") # Google 'hex codes' for more colours
# add confidence interval
min.1 <- 90 - (ph24.1 - ci.1)
max.1 <- 90 - (ph24.1 + ci.1)
colour.1 <- alpha("#CD5C5C", alpha = 0.25) # check this colour matches up to the arrow
draw.sector(start.degree = min.1, end.degree = max.1, rou1 = 0, rou2 = R.1, col = colour.1, border = NA)

## 
ph24.2 <- 2.9 
ci.2 <- 24
R.2 <- 0.261

ph24.2 <- 15*ph24.2
ci.2 <- 15*ci.2
ph24.2r <- ph24.2*pi/180
x.2 <- cos(pi/2 - ph24.2r)*R.2
y.2 <- sin(pi/2 - ph24.2r)*R.2
arrows(x0 = 0, y0 = 0, x1 = x.2, y1 = y.2, lty = 1, lwd = 2, col = "#CD5C5C")
min.2 <- 90 - (ph24.2 - ci.2)
max.2 <- 90 - (ph24.2 + ci.2)
colour.2 <- alpha(colour = "#CD5C5C", alpha = 0.25)
draw.sector(start.degree = min.2, end.degree = max.2, rou1 = 0, rou2 = R.2, col = colour.2, border = NA)

## 
ph24.3 <- 13.7
ci.3 <- 2.2
R.3 <- 0.641

ph24.3 <- 15*ph24.3
ci.3 <- 15*ci.3
ph24.3r <- ph24.3*pi/180
x.3 <- cos(pi/2 - ph24.3r)*R.3
y.3 <- sin(pi/2 - ph24.3r)*R.3
arrows(x0 = 0, y0 = 0, x1 = x.3, y1 = y.3, lty = 1, lwd = 2, col = "#33B5FA")
min.3 <- 90 - (ph24.3 - ci.3)
max.3 <- 90 - (ph24.3 + ci.3)
colour.3 <- alpha(colour = "#33B5FA", alpha = 0.25)
draw.sector(start.degree = min.3, end.degree = max.3, rou1 = 0, rou2 = R.3, col = colour.3, border = NA)

## 
ph24.4 <- 19.8
ci.4 <- 3.2
R.4 <- 0.485

ph24.4 <- 15*ph24.4
ci.4 <- 15*ci.4
ph24.4r <- ph24.4*pi/180
x.4 <- cos(pi/2 - ph24.4r)*R.4
y.4 <- sin(pi/2 - ph24.4r)*R.4
arrows(x0 = 0, y0 = 0, x1 = x.4, y1 = y.4, lty = 2, lwd = 2, col = "#CD5C5C") # Google 'hex codes' for more colours
min.4 <- 90 - (ph24.4 - ci.4)
max.4 <- 90 - (ph24.4 + ci.4)
colour.4 <- alpha("#CD5C5C", alpha = 0.25) # check this colour matches up to the arrow
draw.sector(start.degree = min.4, end.degree = max.4, rou1 = 0, rou2 = R.4, col = colour.4, border = NA)


legend(x = -1, y = -1.2, legend = c("", "", "", ""), 
       col = c("", "", "", ""), 
       lty = c(1,2,1,1), lwd = 2,
       box.lty = 0, horiz = T)

circos.clear() # run this line when done to stop adding to the plot
