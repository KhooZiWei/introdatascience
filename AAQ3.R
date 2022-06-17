library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(stringr)
library(DT)
# country and price

country <- unique(data$country)
country <- str_sort(country)
data <- arrange(data, desc(rating))

ui <- fluidPage(theme = shinytheme("spacelab"),
                
                headerPanel('Hotel Recommender'),
                
                tabsetPanel(
                  
                  
                  tabPanel("Top 20 Recommendation",
                           sidebarPanel(
                             #$label(h3('Which hotel do you like?')),
                             selectInput("country", label = "Country:", 
                                         country
                             ),
                             
                             sliderInput("price","Price:",100,1200,200),
                             
                             actionButton("submitbutton", "Search", 
                                          class = "btn btn-primary")
                             
                             
                           ),
                           mainPanel(
                             
                             tags$label(h3('We recommend')),
                             verbatimTextOutput('contents'),
                             tableOutput("table")
                           )
                           
                  )
                )
                
)

server<- function(input, output) {
  
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Recommended hotels:") 
    } else {
      return("Server is ready.")
    }
  })
  
  
  datasetInput <- reactive ({
    rating_table <- filter(data, country==input$country)
    
    rating_table <- filter(rating_table, price <= input$price)
    
    rating_table <- head(rating_table, 20)
    
    print(rating_table)
    
  })
  
  
  output$table <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    }
  })
  
  
}


shinyApp(ui = ui, server = server)