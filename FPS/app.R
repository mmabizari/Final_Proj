#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(dplyr)
library(ggthemes)
library(janitor)
library(gt)
library(rvest)
library(fivethirtyeight)

x <- read_csv("raw-data/NCAA_stats.csv")
y <- read_csv("raw-data/Player List.csv")

rebound <- x %>%
    arrange(desc(RPG)) %>%
    slice(1:12) %>%
    rename( "TPP" = "FT%")

ui <- fluidPage(
    titlePanel("Player Prediction Model"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("scoringInput", "Scoring", 0, 50, c(10, 15)),
            radioButtons("typeInput", "Statistic",
                         choices = c("Points", "Rebounding", "Shooting"),
                         selected = "Scoring"),
            
        ),
        mainPanel(
            plotOutput("coolplot"),
            br(), br(),
            tableOutput("results")
        )
    )
)

server <- function(input, output) {
    output$coolplot <- renderPlot({
        ggplot(rebound,
               aes(x =PPG , y = TPP  , color = Player)) +
            geom_point() +
            labs(title = "NCAA Best Scoring Big Men",
                 subtitle = "NCAA Top 12 Rebounders",
                 caption = "Class of 2018-2019") +
            xlab("Points Per Game") +
            ylab("Free Throw Percentage") +
            scale_x_continuous(limits=c(10,35))
    })
}

shinyApp(ui = ui, server = server)
