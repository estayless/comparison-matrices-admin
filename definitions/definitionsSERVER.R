executeDefinitionsPopulation <- observeEvent(input$exeDefPop,{
  req(input$user, input$password, input$fileGz)
  out<-tryCatch({definitionsPopulation(input$user, input$password, as.character(input$fileGz[4]))},
                  error = function(err) {
                  errorCatch$val<-as.character(err)
                  message("Error: Authentication failed.")
                  },
                  finally = invalidateLater(1))

})

output$safeError <- renderText({
  if (errorCatch$val == "Error: Authentication failed.\n") {
    stop(safeError("Authentication failed." ))
  } 
})
