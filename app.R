#library for shiny
library("shiny")
library("shinydashboard")
#top file size
options(shiny.maxRequestSize = 1000*1024^2)

#library for parallel computing
library(parallel)
#library for set working directory
library("rstudioapi")
#set relative working directory
setwd(dirname(getActiveDocumentContext()$path))

#library for manage database
library("mongolite")
#library for manipulate data
library("tidyverse")

#library for database conection
source("connection/collectionConnection.R")

#library and source for definitions module
library("taxize")
source("definitions/definitionsPopulation.R")
#source("definitions/definitionsUI.R")
#source("definitions/definitionsSERVER.R")
#END definitions module

#library for STRING module
library('biomaRt')
source("STRING/stringPopulation.R")


header <- dashboardHeader(
  title = span(tagList(icon("cogs"), "Comparison Matrices administration")),
  titleWidth = 400
)

sidebar <- dashboardSidebar(width = 400,
                            column(width = 11, offset = 1,
                                   sidebarMenu(
                                     tags$h4("Administration modules"),
                                     
                                     menuItem("Gene definitions", tabName = "geneDefinitions",icon = icon("book")),
                                     menuItem("STRING scores", tabName = "stringScores",icon = icon("project-diagram"))
                                   )
                              
                            )
                            )

body <- dashboardBody(
  tabItems(
    source(file.path("definitions", "definitionsUI.R"),  local = TRUE)$value,
    source(file.path("STRING", "stringUI.R"),  local = TRUE)$value
  )
)

ui <- dashboardPage(
  skin = "black",
  header = header,
  sidebar = sidebar,
  body = body,
)

server <- function(input, output, session){
  #variable for cath errors
  errorCatch<-reactiveValues()
  errorCatch$val<-""
  source(file.path("definitions", "definitionsSERVER.R"),  local = TRUE)$value
  source(file.path("STRING", "stringSERVER.R"),  local = TRUE)$value
}

shinyApp(ui = ui, server = server)