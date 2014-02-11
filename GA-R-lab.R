#download RStudio if you haven't already
#http://www.rstudio.com/ide/download/
  
#fantastic book to understand more written by Hadley himself
#( creator of the ggplot2 package)
#http://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448

#ggplot2 website w/ good examples
#http://ggplot2.org/

#get the necessary pacakges
#equivalent to a pip install in python
install.packages('ggplot2')

#load the packages
#equivalent to an import module_name in python
library(ggplot2)

#How to get info about R packages
?ggplot

#which datasets are included in R/imported packages
data()

#laod in the mtcars dataset
attach(mtcars)

#get summary stats
summary(mtcars)

#get the data types
str(mtcars)

#examine the data
head(mtcars)

#plot everything
#produces an ugly scatterplot
plot(mtcars)
#mpg goes down as cyl/weight goes up, etc
#lots of info but hard to read

#lets look at a boxplot
boxplot(mtcars)

#lets look at a boxplot
boxplot(mtcars$mpg)

#Introducing ggplot2
#We've got 2 main functions qplot and ggplot
#qplot is great for quickly exploring data
#it's the quick plot version of ggplot (Grammar of Graphics Plot)
qplot(wt,mpg,data=mtcars)
#function
#qplot(x,y,data=data_set)
?qplot

#lets add some color
qplot(wt,mpg,data=mtcars,color=mpg)

#lets add a trend line
qplot(wt,mpg,data=mtcars,geom="smooth")

#add the points back in
qplot(wt,mpg,data=mtcars,geom=c("smooth","point"))

#explore a few of the other variables
qplot(gear,hp,data=mtcars,color=hp)

#experiment on your own
#make a histogram
qplot(mpg, data=mtcars, geom="histogram")

#adjust the bins
qplot(mpg, data=mtcars, geom="histogram",binwidth=10)

#showing facets
#Facet = one plot per facet (in this example horsepower)
qplot(data=mtcars,x=wt,y=mpg,log="xy",color=hp,facets = ~hp)
#okay its not very interesting

#introducing the diamonds dataset
#you can run data() to see that ggplot2 loads this dataset
#when the package is imported
#showing a better example of facets
qplot(data=diamonds,carat,price,color=clarity,facets = ~clarity)

#that's not very linear
#what can we do to fix that?
qplot(data=diamonds,carat,price,log="xy",color=clarity,facets = ~clarity)
#much better :)


#part 2
#ggplot
#grammar of graphics plot function
?ggplot


#c is our object that gets assigned the output of ggplot
c <- ggplot(data=mtcars,y=wt, x=mpg, colour=cyl)

#nothing shows up?
c

#add in layers
#ggplot uses aes (aesthetics) to make your pretty plots
#aes are aesthetics
c + geom_point(aes(wt,mpg))

#you can add them at the start
c <- ggplot(mtcars, aes(y=wt, x=mpg, colour=cyl))

#we dont have any layers
c 

#explore the ggplot doc for all the layers you can add
#adding a statistical line with stat_smooth
#color -> convert the cyl var into a factor
c + stat_smooth(method=loess, aes(fill = factor(cyl))) 

#add the points back in
c + stat_smooth(method=loess, aes(fill = factor(cyl))) + geom_point()


#makes a numberical values into a categorical variable
c <- ggplot(mtcars, aes(y=wt, x=mpg, colour=factor(cyl)))

#method = lm (linear model)
c + stat_smooth(method=lm, aes(fill = factor(cyl))) + geom_point()

#method = loess (polynomials)
c + stat_smooth(method=loess, aes(fill = factor(cyl))) + geom_point()

#experiment with the diamonds data set
attach(diamonds)

#this lets us add 3 dimensions to our chart
#carat size
#price of the diamond
#cut of the diamond
#how does the cut affect the price per carat?
qplot(carat,price,color=cut,data=diamonds)

#making a histogram
ggplot(diamonds) + geom_histogram(aes(x=price))

#making a histogram
ggplot(diamonds) + geom_point(aes(carat,price))

#using ggplot
ggplot(mtcars, aes(mpg, wt)) + geom_point()

#assign the plot to a variable
p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()

#change the background
p + theme_bw()

#add functions
#band shows the variance in the data
p + stat_smooth()

#boxplot?
p + geom_boxplot()

#boxplot using aes mapping
ggplot(mpg, aes(class, hwy)) + stat_boxplot()

#bring in the ggplot2 mpg dataset
p <- ggplot(mpg, aes(displ, hwy))

p + geom_point() + stat_smooth()

###not sure about this
#play around with this data
#play around with enron data
install.packages('RSQLite')
library(RSQLite)

sqldriver    <- dbDriver("SQLite")
enron <- dbConnect(sqlite,"~/Downloads/enron.db")
enron
dbListTables(enron)

#send a query to the database
#assign the output to a results object
results <- dbSendQuery(enron, "select * from EmployeeBase")

#An object that points to our query. WTF?
results

#Common pattern when accessing db's
#You have to have fetch the data
a <- fetch(results)

#look at the object
head(a,2)

#examine the structure
str(a)

#make an org chart plot
qplot(department,title,data=a)

#what if we add gender?
qplot(department,title,data=a,color=gender)

#get some interesting data
results2 <- dbSendQuery(enron, "select count(*) as num,gender,department 
                        from EmployeeBase group by gender,department")

#Common pattern when accessing db's
#You have to have fetch the data
a2 <- fetch(results2)

#how does gender fit across departments?
qplot(gender,num,data=a2,color=department)

#Explore!!!!
