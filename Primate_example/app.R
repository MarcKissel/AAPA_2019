#basics from https://deanattali.com/blog/shiny-persistent-data-storage/
#i added a droptoken.rds that lets us send data to the Dropbox
#

library(shiny)

# Define the fields we want to save from the form
fields <- c("name", "age", "from", "gender", "knowledge", "rate_enjoy", "thoughts", "suggestions", "updates")

#setup dropbox and store the data somewhere
library(rdrop2) 
outputDir <- "responses"

saveData <- function(data) {
    data <- t(data)
    # Create a unique file name
    fileName <- sprintf("%s_%s.csv", as.integer(Sys.time()), digest::digest(data))
    # Write the data to a temporary file locally
    filePath <- file.path(tempdir(), fileName)
    write.csv(data, filePath, row.names = FALSE, quote = TRUE)
    # Upload the file to Dropbox
    drop_upload(filePath, path = outputDir)
}

loadData <- function() {
    # Read all the files into a list
    filesInfo <- drop_dir(outputDir)
    filePaths <- filesInfo$path_display
    data <- lapply(filePaths, drop_read_csv, stringsAsFactors = FALSE)
    # Concatenate all data together into one data.frame
    data <- do.call(rbind, data)
    data
}

# Shiny app with 3 fields that the user can submit data for
shinyApp(
    ui = fluidPage(
        #DT::dataTableOutput("responses", width = 300), tags$hr(),
        title = "Aye know Aye’m pretty",
        div(id = "header",
            h1("Aye know Aye’m pretty"),
            h4("some more text here",
               a(href = "https://github.com/MarcKissel/AAPA_2019",
                 "github on the topic")
            ),
            strong( 
                span("Created by "),
                a("Kerryn Warren & Marc Kissel", href = "https://github.com/MarcKissel/AAPA_2019"),
                HTML("&bull;"),
                span("Code"),
                a("on GitHub (need to fix link)", href = "https://github.com/MarcKissel/AAPA_2019"),
                HTML("&bull;"),
                a("More info (for now links to my page but update", href = "https://marckissel.netlify.com/"))
        ),
        
        
        textInput("name", "Name", ""),
        
        sliderInput("age", "How old are you",
                    0, 100, 25, ticks = FALSE),
        radioButtons("from", "Where are you from?", c("North America", "South America", "Africa", "Europe", "Asia", "Australia", "Antarctica")),
        radioButtons("gender", "Gender?", c("Female", "Male", "Non-binary")),
        radioButtons("knowledge", "Rate your current knowledge about primates:", c("I am a primatologist, so you better have your facts straight!", "I have taken a few classes...", "I have read some things...", "What’s a primate?" )),
        radioButtons("rate_enjoy", "19. Rate your enjoyment of this survey (1= low, 5 =  high", c("1","2","3","4", "5")),
        radioButtons("thoughts", "20. Do you think this was an innovative way to learn more about primates?", c("I did this survey again to make sure I saw all the photos and read all the facts", "I am sending this survey to everyone I know!", "I have some reservations", "No")),
        textInput("suggestions", "21. Do you have any suggestions, questions or comments about the survey? (i.e. Was it satisfactorily cute?)", ""),
        textInput("updates", "22. If you would like to receive more information about the outcome of this survey, or would just like to be bombarded with cute primate photos every now and again, please leave us with your email address below.", ""),
    
        actionButton("submit", "click me to submit")
    ),
    server = function(input, output, session) {
        
        # Whenever a field is filled, aggregate all form data
        formData <- reactive({
            data <- sapply(fields, function(x) input[[x]])
            data
        })
        
        # When the Submit button is clicked, save the form data
        observeEvent(input$submit, {
            saveData(formData())
        })
        
        # Show the previous responses
        # (update with current response when Submit is clicked)
        #output$responses <- DT::renderDataTable({
        #    input$submit
        #    loadData()
        #})     
    }
)