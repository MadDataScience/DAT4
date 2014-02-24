# load required library
library(class)

#################################################
# PREPROCESSING
#################################################

data <- iris                # create copy of iris dataframe
labels <- data$Species      # store labels
data$Species <- NULL        # remove labels from feature set (note: could
                            # alternatively use neg indices on column index in knn call)

#################################################
# TRAIN/TEST SPLIT
#################################################

set.seed(1)         # initialize random seed for consistency
                    # NOTE -- run for various seeds --> need for CV!

train.pct <- 0.7    # pct of data to use for training set
N <- nrow(data)     # total number of records (150)

train.index <- sample(1:N, train.pct * N)       # random sample of records (training set)

train.data <- data[train.index, ]       # perform train/test split
test.data <- data[-train.index, ]       # note use of neg index...different than Python!

train.labels <- labels[train.index]     # extract training set labels
test.labels <- labels[-train.index]     # extract test set labels

#################################################
# APPLY MODEL
#################################################

err.rates <- data.frame()       # initialize results object

max.k <- 100
for (k in 1:max.k)              # perform fit for various values of k
{
    knn.fit <- knn(train = train.data,          # training set
                    test = test.data,           # test set
                    cl = train.labels,          # true labels
                    k = k                       # number of NN to poll
               )

    cat('\n', 'k = ', k, ', train.pct = ', train.pct, '\n', sep='')     # print params
    print(table(test.labels, knn.fit))          # print confusion matrix

    this.err <- sum(test.labels != knn.fit) / length(test.labels)    # store gzn err
    err.rates <- rbind(err.rates, this.err)     # append err to total results
}

#################################################
# OUTPUT RESULTS
#################################################

results <- data.frame(1:max.k, err.rates)   # create results summary data frame
names(results) <- c('k', 'err.rate')        # label columns of results df

# create title for results plot
title <- paste('knn results (train.pct = ', train.pct, ')', sep='')

# create results plot
results.plot <- ggplot(results, aes(x=k, y=err.rate)) + geom_point() + geom_line()
results.plot <- results.plot + ggtitle(title)

# draw results plot (note need for print stmt inside script to draw ggplot)
print(results.plot)

idx <- sample(nrow(data), nrow(data))
err.rates <- data.frame(k=factor(), err=numeric())
for (k in seq(5, 13)){
  for (i in seq(1, 130, 30)) {
    test.index <- idx[i:(i+29)]
    test.data <- data[test.index,]
    train.data <- data[-test.index,]
    train.labels <- labels[-test.index]
    test.labels <- labels[test.index]
    knn.fit <- knn(train = train.data, test = test.data, 
                   cl=train.labels, k = k)
    cat('\n', 'k = ', k, ', train.pct = ', train.pct, '\n', sep='')     # print params
    print(table(test.labels, knn.fit))          # print confusion matrix
    
    this.err <- sum(test.labels != knn.fit) / length(test.labels)    # store gzn err
    err.rates <- rbind(err.rates, data.frame(k=k, err=this.err))     # append err to total results
  }  
}
ggplot(err.rates, aes(k, err)) + geom_smooth()


#################################################
# NOTES
#################################################

# what happens for high values (eg 100) of max.k? have a look at this plot:
# > results.plot <- ggplot(results, aes(x=k, y=err.rate)) + geom_smooth()

# our implementation here is pretty naive, meant to illustrate concepts rather
# than to be maximally efficient...see alt impl in DMwR package (with feature
# scaling):
#
# > install.packages('DMwR')
# > library(DMwR)
# > knn

# ed. note: how not to do it (black box)
# http://en.wikibooks.org/wiki/Data_Mining_Algorithms_In_R/Classification/kNN

# R docs
# http://cran.r-project.org/web/packages/class/class.pdf
# http://cran.r-project.org/web/packages/DMwR/DMwR.pdf
