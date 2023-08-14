#Install packages
install.packages("arules")
install.packages("tidyverse")
install.packages("arulesViz")

#Load libraries
library(arules)
library(tidyverse)
library(arulesViz)

#Read the groceries.txt file
lines <- readLines('/Users/alfredosandoval/Documents/ UT/Summer/Intro to Machine Learning/Project 2/groceries.txt')

#Create baskets
baskets <- lapply(lines, function(line) strsplit(line, split = ",")[[1]])

View(baskets)

#Remove duplicates
baskets <- lapply(baskets, unique)

transactions <- as(baskets, "transactions")
summary(transactions)

#Generate association rules
groceriesrules <- apriori(transactions,
                          parameter = list(support = 0.005,
                                           confidence = 0.1))
inspect(groceriesrules)

inspect(subset(groceriesrules, subset=lift > 4))
inspect(subset(groceriesrules, subset=lift > 3))

#Plots
plot(groceriesrules)
plot(groceriesrules, measure = c("support", "lift"), shading = "confidence")

#Export to GEPHI for a nice visualization of the rules
groceries_graph = associations2igraph(subset(groceriesrules, lift>1.5), associationsAsNodes = FALSE)
igraph::write_graph(groceries_graph, file='groceries.graphml', format = "graphml")
