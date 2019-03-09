library(shiny)
library(shinydashboard)

fields <- c("name", "age", "from", "gender", "knowledge", "rate_enjoy", "thoughts", "suggestions", "updates", "set_1", "set_2")

#setup dropbox and store the data somewhere
library(rdrop2) 
outputDir <- "responses_2"

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


#below is code for random monkey image. right now 4 place holders
#but seems to not work since once it is uploaded as an app this is only 
#run the first time...need to figure this out.
#might need a reactive shiny app 'hidden' in the UI or something



x <- sample(1:4, 4, replace = FALSE)
pic1 <- paste('monkey', x[1],'.jpg', sep = '')
pic2 <- paste('monkey', x[2],'.jpg', sep = '')
pic3 <- paste('monkey', x[3],'.jpg', sep = '')
pic4 <- paste('monkey', x[4],'.jpg', sep = '')


ui <- dashboardPage(
  dashboardHeader(title = "Aye know Aye’m pretty"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Survey", tabName = "Survey", icon = icon("dashboard")),
      menuItem("details", tabName = "details", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Survey",
              fluidRow(
                tabBox(
                  title = "images",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1", height = "250px",
                  tabPanel("set 1", "First set",
                           radioButtons("set_1", "which do you prefer", c(pic1,pic2)),
                           h6(" first"),
                           tags$img(src = pic1, height = 100, width = 100),
                           tags$img(src = pic2, height = 100, width = 100)
                           
                  ),
                  tabPanel("set 2", "Second set",
                           radioButtons("set_2", "which do you prefer", c(pic3,pic4)),
                           h6(" Second set"),
                           tags$img(src = pic3, height = 100, width = 100),
                           tags$img(src = pic4, height = 100, width = 100)
                           
                           
                           
                  )
                ),
                
                box(
                  textInput("name", "1. Please enter your prefered name", ""),
                  
                  sliderInput("age", "2. How old are you?",
                              0, 100, 25, ticks = FALSE),
                  radioButtons("from", "3. Where are you from?", c("North America", "South America", "Africa", "Europe", "Asia", "Australia", "Antarctica")),
                  radioButtons("gender", "4. What is your gender?", c("Female", "Male", "Non-binary")),
                  radioButtons("knowledge", "5. Rate your current knowledge about primates:", c("I am a primatologist, so you better have your facts straight!", "I have taken a few classes...", "I have read some things...", "What’s a primate?" )),
                  radioButtons("rate_enjoy", "19. Rate your enjoyment of this survey (1= low, 5 =  high", c("1","2","3","4", "5")),
                  radioButtons("thoughts", "20. Do you think this was an innovative way to learn more about primates?", c("I did this survey again to make sure I saw all the photos and read all the facts", "I am sending this survey to everyone I know!", "I have some reservations", "No")),
                  textInput("suggestions", "21. Do you have any suggestions, questions or comments about the survey? (i.e. Was it satisfactorily cute?)", ""),
                  textInput("updates", "22. If you would like to receive more information about the outcome of this survey, or would just like to be bombarded with cute primate photos every now and again, please leave us with your email address below.", ""),
                  actionButton("submit", "Submit")
                  
                  
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "details",
              h2("details")
      )
    )
  )
)

server <- function(input, output, session) {
  
  
  
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



shinyApp(ui, server)