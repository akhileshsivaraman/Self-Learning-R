##### circular
library(circular)
library(CircStats)


x1 <- circular(c(35, 45, 50, 55, 60, 70, 85, 95, 105, 120),
               units="degrees", template="geographics")
x2 <- circular(c(75, 80, 90, 100, 110, 130, 135, 140, 150, 160, 165),
               units="degrees", template="geographics")
plot(x1)

x <- circular(runif(100,0,2*pi))
x <- rvonmises(n=50, mu = circular(0), kappa = 4)
watson.test(x, alpha = 0.05, dist = "vonmises")
watson.two.test(x1, x2, alpha = 0.05)

x <- circular(c(0.8, 15.5), template = "clock24")
watson.test(x, alpha = 0.05, dist = "uniform")

a <- circular(c(18.3), template = "clock24")
b <- circular(c(1.3), template = "clock24")
watson.two(a, b, alpha = 0.05, plot = T)

plot.circular(x)
lines.circular()

watson
##### pracma
library(pracma)
t <- deg2rad(seq(0, 360, by = 2))
polar(t, cos(2*t), bxcol = "white", main = "Sine and Cosine")
polar(t, sin(2*t), col = "red", add = TRUE)


a <- 18.3*15
b <- 15.3*15
polar(274.5, 0.3)


##### plotly
library(plotly)
plot_ly(
  type = "scatterpolar",
  r = c(1,2,2),
  theta = c(45,90,0),
  mode = "markers"
) 


plot_ly(
  type = "scatterpolar",
  mode = "lines"
) %>%
add_trace(
  r = c(0,0.568,0.568,0),
  theta = c(0,246,303,0),
  fill = "toself",
  fillcolor = "#709Bff",
  line = list(color = "#709Bff")
) %>%
add_trace(
    r = c(0,0.967,0.967,0),
    theta = c(0,223.5,235.5,0),
    fill = "toself",
    fillcolor = "#FFDF70",
    line = list(color = "#FFDF70"))


##### circlize
library(circlize)
# example from booklet
circos.par(gap.degree = 0, cell.padding = c(0, 0, 0, 0), start.degree = 90)
circos.initialize(factors = "a", xlim = c(0, 24))
circos.track(ylim = c(0, 1), bg.border = NA)
circos.axis(major.at = 0:24, labels = NULL, direction = "inside", labels.facing = "outside",
            major.tick.length = uy(3, "mm"))
circos.text(1:24, rep(1, 24) - uy(6, "mm"), 1:24, facing = "downward")
current.time = as.POSIXlt(Sys.time())
sec = ceiling(current.time$sec)
min = current.time$min
hour = current.time$hour
hour.degree = 90 - hour/24 * 360 - min/60 * 360/24
arrows(0, 0, cos(hour.degree/180*pi)*0.58, sin(hour.degree/180*pi)*0.4, lwd = 3)

c <- cos(hour.degree/180*pi)*0.58
s <- sin(hour.degree/180*pi)*0.4




circos.clear()
## Draw clockface
circos.par(gap.degree = 0, cell.padding = c(0, 0, 0, 0), start.degree = 90)
circos.initialize(factors = "a", xlim = c(0, 24))
circos.track(ylim = c(0, 1), bg.border = F)
circos.axis(major.at = c(0,6,12,18,24), labels = F, direction = "inside", 
            major.tick = T, minor.ticks = 4, major.tick.length = uy(5, "mm"))
circos.text(c(6,12,18,24), c(6,12,18,24), labels = c("6", "12", "18", "24"), facing = "downward") ## solve this problem...

## add first genotype
## insert values from phase analysis then convert to degrees
ph24.1 <- 18.3
ci.1 <- 1.9
R.1 <- 0.568
ph24.1 <- 15*ph24.1
ci.1 <- 15*ci.1

## draw arrow for Ph24
ph24.1r <- ph24.1*pi/180
x.1 <- cos(pi/2 - ph24.1r)*R.1
y.1 <- sin(pi/2 - ph24.1r)*R.1
arrows(x0 = 0, y0 = 0, x1 = x.1, y1 = y.1, lty = 1, lwd = 2, col = "#CD5C5C")

## add confidence interval
min.1 <- 90 - (ph24.1 - ci.1)
max.1 <- 90 - (ph24.1 + ci.1)
colour.1 <- alpha("#CD5C5C", alpha = 0.25)
draw.sector(start.degree = min.1, end.degree = max.1, rou1 = 0, rou2 = R.1, col = colour.1, border = NA)

## add second genotype
ph24.2 <- 15.3
ci.2 <- 0.4
R.2 <- 0.967
ph24.2 <- 15*ph24.2
ci.2 <- 15*ci.2

ph24.2r <- ph24.2*pi/180
x.2 <- cos(pi/2 - ph24.2r)*R.2
y.2 <- sin(pi/2 - ph24.2r)*R.2
arrows(x0 = 0, y0 = 0, x1 = x.2, y1 = y.2, lty = 1, lwd = 2, col = "#FAC733")

min.2 <- 90 - (ph24.2 - ci.2)
max.2 <- 90 - (ph24.2 + ci.2)
colour.2 <- alpha(colour = "#FAC733", alpha = 0.25)
draw.sector(start.degree = min.2, end.degree = max.2, rou1 = 0, rou2 = R.2, col = colour.2, border = NA)

## add third genotype
ph24.3 <- 7.6
ci.3 <- 3
R.3 <- 0.67
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
