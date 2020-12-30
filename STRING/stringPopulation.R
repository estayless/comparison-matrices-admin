
stringPopulation<-function(user, password, linksDetailed, proteinInfo, martData){
  #dinamizar
  print(user)
  print(password)
  print(linksDetailed)
  print(proteinInfo)
  print(martData)
  martData<-"hsapiens_gene_ensembl"
  
  #HACER UNICOS LOS GENES
  showModal(modalDialog("Processing input data", footer=NULL))
  raw_ensp<-unique(linksDetailed$protein1)
  raw_ensp_matched<-raw_ensp %in%proteinInfo$protein_external_id
  table(raw_ensp_matched)
  removeModal()
  showModal(modalDialog("Complementing", footer=NULL))
  raw_ensp_not_matched<-raw_ensp[!raw_ensp_matched]
  
  #PARA LOS GENES QUE NO SE ENCUENTREN
  #raw_ensp_not_matched
  #PREPARAR LOS DATOS PORQUE DESDE STRING VIENEN CON TAXON
  cut<-(stringr::str_split(raw_ensp_not_matched,"\\.", simplify = TRUE))
  taxon<-cut[1,1]
  ensp_not_matched_noTax<-cut[,2]
  
  #BIOMART
  #OCUPO MART DATA DE ENTRADA DE BIOMART DINAMICO
  mart <- useDataset(martData, useMart("ensembl"))
  ensp_not_matched_noTax_symbol_bmrt <- getBM(filters= "ensembl_peptide_id", attributes= c("ensembl_peptide_id","hgnc_symbol"),values=ensp_not_matched_noTax, mart= mart)
  bad_names_bio<-which(ensp_not_matched_noTax_symbol_bmrt$hgnc_symbol %in% "")
  ensp_not_matched_noTax_symbol_bmrt_noBad<-ensp_not_matched_noTax_symbol_bmrt[-bad_names_bio,]
  #LOS QE NO PASEN BIO MART
  ensp_not_matched_noTax_symbol_bmrt_Bad<-ensp_not_matched_noTax_symbol_bmrt[bad_names_bio,]
  length(ensp_not_matched_noTax_symbol_bmrt_noBad$ensembl_peptide_id)
  ensp_not_matched_noTax_symbol_bmrt$ensembl_peptide_id<-paste0(taxon,".",ensp_not_matched_noTax_symbol_bmrt$ensembl_peptide_id)
  colnames(ensp_not_matched_noTax_symbol_bmrt)<-colnames(proteinInfo[,1:2])
  
  ENSPs<-rbind(proteinInfo[,1:2],ensp_not_matched_noTax_symbol_bmrt)
  removeModal()
  #AHORA DEBO CAMBIAR LOS VALORES DE ENPS EN PROTEIN LINKS A SYMBOLS
  #prot1
  showModal(modalDialog("Translating", footer=NULL))
  pos_name1<-match(linksDetailed$protein1,ENSPs$protein_external_id)
  linksDetailed$protein1<-ENSPs$preferred_name[pos_name1]
  #prot2
  pos_name2<-match(linksDetailed$protein2,ENSPs$protein_external_id)
  linksDetailed$protein2<-ENSPs$preferred_name[pos_name2]
  
  #FALTA REMOVER LOS NA
  linksDetailed<-na.omit(linksDetailed)
  removeModal()
  
  showModal(modalDialog("Populating", footer=NULL))
  #insertar
  #DB CONFIG
  ip <- "127.0.0.1"
  port <- "27017"
  db <- "comparisonMatrices"
  collection <- paste0("STRING_",taxon)
  
  #instance of the connection
  con <- collectionConnection(user, password, ip, port, db, collection)
  con$drop()
  con$insert(linksDetailed)
  removeModal()
}



