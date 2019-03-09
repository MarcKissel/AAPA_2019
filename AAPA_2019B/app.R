library(shiny)
library(shinydashboard)
library(rdrop2)
library(readr)
library(tidyverse)
fields <- c("name", "age", "from", "gender", "knowledge", "rate_enjoy", "thoughts", "suggestions", "updates", "set_1", "set_2")

#setup dropbox and store the data somewhere. I already have a droptoken.rds saved that lets send data to dropbox
outputDir <- "responses_2"

#temp is a fake dataset (flags, since that was example i found)
#that tests ways to get images into shiny
temp <- read_csv("temp.csv")

#funtion to save the data and send to dropbox
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

#funtion to loaddata if we want it to show in the Shiny app
#maybe a way to only show if someone is an admin...
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
                        box(title = "temp",
                            actionButton("goButton", "push me"),
                            p("Click the button to  start the survey!")
                                                        )
                        ,
                        tabBox(
                            title = "images as seperate tabs",
                            # The id lets us use input$tabset1 on the server to find the current tab
                            id = "tabset1", height = "250px",
                            tabPanel("set 1", "First set",
                                     radioButtons("set_1", "which do you prefer", c(pic1,pic2)),
                                     h6(" first"),
                                     tags$img(src = pic1, height = 100, width = 100),
                                     tags$img(src = pic2, height = 100, width = 100)
                                     
                                     ),
                            #for this panel i am trying tidyverse stuff. but the wAY IT
                            #samples means that will only work if  we have 2 different tables
                            #but it might work this way.
                            #need to think more
                            #note that this set is the flags since it was my temp set
                            #i <think> this could work...but we would need tothink more on it
                            #might not be random once it is uploaded to the server...
                            #have X number of setsin the images
                            tabPanel("set 2", "Second set 1st using tidy but will repeat",
                                     xx <- temp %>% select(loc) %>% sample_n(1),
                                     yy <- temp %>% select(loc) %>% sample_n(1),
                                     radioButtons("set_2", "which do you prefer", c(xx$loc,yy$loc)),
                                     h6(" Second set"),
                                     
                                     tags$img(src = xx, height = 100, width = 100),
                                     tags$img(src = yy, height = 100, width = 100)
                                     
                                     
                                     
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
                            #,
                            #tags$img(src = temp$loc[4]) this would load image from the temp dataframe
                            
                        ),
                        box (title = "images2 Button click one",
                             #radioButtons("inRadioButtons2", "Input radio buttons 2",
                             #             c("Item A", "Item B", "Item C")),
                             uiOutput("nImage"),
                             uiOutput("nImage2")
                             
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
    #x <- sample(1:4, 4, replace = FALSE)
    #pic1 <- paste('monkey', x[1],'.jpg', sep = '')
    #pic2 <- paste('monkey', x[2],'.jpg', sep = '')
    #pic3 <- paste('monkey', x[3],'.jpg', sep = '')
    #pic4 <- paste('monkey', x[4],'.jpg', sep = '')
  
    
    #what happpens when go button is pressed
    #below is getting from a dataframe/tibble
    nimage <- eventReactive(input$goButton, {
        z <- sample(1:4, 4, replace = FALSE)  
        first_image <- temp$loc[z[1]]
        second_image <- temp$loc[z[2]]
        tags$img(src = first_image, height = 100, width = 100)
        tags$img(src = second_image, height = 100, width = 100)
        #c(tags$img(src = first_image, height = 100, width = 100)
        #,tags$img(src = second_image, height = 100, width = 100))
    })
    
    #below is from folder on the local computer. not run now but can replace
    #with above
    
    #nimage <- eventReactive(input$goButton, {
    #    x <- sample(1:4, 4, replace = FALSE)
    #    pic1 <- paste('monkey', x[1],'.jpg', sep = '')
    #    pic2 <- paste('monkey', x[2],'.jpg', sep = '')
    #    pic3 <- paste('monkey', x[3],'.jpg', sep = '')
    #    pic4 <- paste('monkey', x[4],'.jpg', sep = '')
    #    radioButtons("set_1", "which do you prefer", c(pic1,pic2))
    #    h6(" first")
    #    tags$img(src = pic1, height = 100, width = 100)
    #    tags$img(src = pic2, height = 100, width = 100)
    #    })
    
    output$nImage <- renderUI({
        nimage()
    })
   
    
    
        
    updateRadioButtons(session, "inRadioButtons2",
                       label = paste("radioButtons"),
                       choices = c(pic1, pic2),
                       selected = NULL)
    
    
    
    
       
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