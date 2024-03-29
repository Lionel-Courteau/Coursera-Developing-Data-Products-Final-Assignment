#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(datasets)
library(ggpubr)

mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    formulaText <- reactive({
      paste("mpg ~", input$variable)
    })
    
    formulaTextPoint <- reactive({
      paste("mpg ~", "as.integer(", input$variable, ")")
    })
    
    fit <- reactive({
      lm(as.formula(formulaTextPoint()), data=mpgData)
    })
    
    output$caption <- renderText({
      formulaText()
    })
    
    output$mpgBoxPlot <- renderPlot({
      boxplot(as.formula(formulaText()), 
              data = mpgData,
              outline = input$outliers)
    })
    
    output$fit <- renderPrint({
      summary(fit())
    })
    
    output$mpgPlot <- renderPlot({
      with(mpgData, {
        plot(as.formula(formulaTextPoint()))
        abline(fit(), col=2)
      })
    })

})
