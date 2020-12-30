definitionsPopulation <- function(user, password, fileGz){
  
  #settings for connection to the application database
  ip <- "127.0.0.1"
  port <- "27017"
  db <- "comparisonMatrices"
  
  #Setting for dictionary collection
  collection <- "dictionary"
  
  #instance of the connection
  conDict <- collectionConnection(user, password, ip, port, db, collection)
  conDict$drop()
  #function to call back when the chunk is readed.
  #Select the needed fields and insert into the database collection created.
  f <- function(x, pos){
    x <- x %>% 
      rename("tax_id" = '#tax_id')%>% 
      select(tax_id,GeneID, Symbol, Synonyms, description, Symbol_from_nomenclature_authority,
             Full_name_from_nomenclature_authority, Other_designations)
    conDict$insert(x)
  }
  
  
  #Dictionary section
  showModal(modalDialog("Processing dictionary info", footer=NULL))
  #Read the data of genes from the ftp repository by chunks, and insert into the Dictionary collection.
  read_delim_chunked(file = fileGz, SideEffectChunkCallback$new(f), chunk_size = 10000, delim = "\t", col_names = TRUE)
  
  removeModal()
  
  #Index taxons section
  showModal(modalDialog("Generating taxons index", footer=NULL))
  #Find all the taxon ids.
  taxIds <- conDict$distinct({"tax_id"})
  #Close connection to dictionray.
  rm(conDict)
  #Setting for the taxons collection.
  collectionTax <- "taxons"
  #Instance of the connection for the taxons collection.
  conTax <- collectionConnection(user, password, ip, port, db, collectionTax)
  #Set the api key for NCBI privileges.
  Sys.setenv(ENTREZ_KEY = "9a183eebc943f5650f317c098b8f4702fa08")
  #Get the name of the taxon id.
  taxons<-mclapply(taxIds,ncbi_get_taxon_summary)
  #Formating te results.
  taxons<-taxons %>% bind_rows() %>% select(-last_col()) %>% rename(tax_id = uid)
  #Drop old collection.
  conTax$drop()
  #Insert into the taxons collection.
  conTax$insert(taxons)
  #Close connection.
  rm(conTax)
  removeModal()
  #Clean the environment.
  gc()
  
}
