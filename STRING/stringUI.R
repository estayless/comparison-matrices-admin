tabItem(tabName = "stringScores",
        fluidRow(
          column(width = 12,
                 box(
                   title=span(icon("cogs"), "STRING population"), width = NULL, status = "primary", solidHeader = TRUE,
                   #textOutput("safeError"),
                   textInput(inputId = "userSTRING", label = "User name", value = "", width = NULL, placeholder = NULL),
                   passwordInput(inputId = "passwordSTRING", label = "Password", value = "", width = NULL, placeholder = NULL),
                   fileInput(inputId = "proteinInfo", "Choose the protein info file from STRING",
                             multiple = FALSE,
                             accept = ".txt"),
                   fileInput(inputId = "linksDetailed", "Choose the protein links detailed file from STRING",
                             multiple = FALSE,
                             accept = ".txt"),
                   actionButton(inputId = "exeStringPop", label = "Populate definitions database", class = "btn-block primary"),
                 ),
                 
          )
        )
        
)