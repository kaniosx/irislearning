devel <- TRUE

if (devel) {
  setwd('~/rprojects/irislearning')
  rm(list = ls(all.names = TRUE))
  gc()
}

library(shiny)
library(datasets)
library(shinythemes)
library(caTools)
library(class)
library(e1071)

source('server.R', local = TRUE)
source('ui.R', local = TRUE)

data(iris)
set.seed(123)

shinyApp(ui = ui, server = server)
