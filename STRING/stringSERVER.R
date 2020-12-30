# linksDetailed<-reactive({
#   req(input$linksDetailed)
#   df<-read.delim(input$linksDetailed$datapath, header = TRUE, sep = "")
#   print(df)
# })
# #SERA LA TRADUCCION CON PROTEIN INFO
# proteinInfo<-reactive({
#   req(input$proteinInfo)
#   df<-read.delim(input$proteinInfo$datapath, header = TRUE, sep = "\t")
#   print(df)
# })



executeStringPopulation<-observeEvent(input$exeStringPop,{
  # out<-tryCatch({stringPopulation(input$userSTRING, input$passwordSTRING, linksDetailed(), proteinInfo(), martData="hsapiens_gene_ensembl")},
  #               error = function(err) {
  #                 errorCatch$val<-as.character(err)
  #                 message("Error: Authentication failed.")
  #               },
  #               finally = invalidateLater(1))
  print(input$linksDetailed)
  print(input$proteinInfo)
  showModal(modalDialog("Reading files", footer=NULL))
  linksDetailed<-read.delim(as.character(input$linksDetailed$datapath), header = TRUE, sep = "")
  proteinInfo<-read.delim(as.character(input$proteinInfo$datapath), header = TRUE, sep = "\t")
  removeModal()
  stringPopulation(input$userSTRING, input$passwordSTRING, linksDetailed, proteinInfo, martData="hsapiens_gene_ensembl")
  
})