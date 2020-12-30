tabItem(tabName = "geneDefinitions",
        fluidRow(
          column(width = 12,
                 box(
                   title=span(icon("cogs"), "Gene definitions population"), width = NULL, status = "primary", solidHeader = TRUE,
                   textOutput("safeError"),
                   textInput(inputId = "user", label = "User name", value = "", width = NULL, placeholder = NULL),
                   passwordInput(inputId = "password", label = "Password", value = "", width = NULL, placeholder = NULL),
                   fileInput(inputId = "fileGz", "Choose the .gz file from the NCBI",
                             multiple = FALSE,
                             accept = ".gz"),
                   actionButton(inputId = "exeDefPop", label = "Populate definitions database", class = "btn-block primary"),
                   verbatimTextOutput("dictProgress")
                 ),
                 
          )
        )
        
        # password <- .rs.askForPassword("Enter password:")
        # key <- .rs.askForPassword("Enter Entrez api key:")
        # definitionsPopulation(password, key)  
)
