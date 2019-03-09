#testing how to draw a random pic from a series 
runif(1,1,10)
#maybe at first i want to set seed to make sure it is working?
x <- sample(1:4, 1)

#tags$img(src = "monkey1.jpg", height = 100, width = 100)

#filename <- normalizePath(file.path('./images',
                   
                 paste('image', input$n, '.jpeg', sep='')))

x <- sample(1:4, 1)
pic <- paste('monkey', x, sep = '')
tags$img(src = pic, height = 100, width = 100)
#ok, but i can't get that to run everytime, right? cause it will have to be above the UI and only run once
#ways around: 
#1.have a button to generate
#2. create a random list of 10 numbers without replacement and then assign each a varibale. or..
#    i could just call by element maybe....
#    then, use that var each time....messy but might work


x <- sample(1:4, 4, replace = FALSE)
pic <- paste('monkey', x[1], sep = '')
tags$img(src = pic, height = 100, width = 100)

x <- sample(1:4, 4, replace = FALSE)
pic1 <- paste('monkey', x[1],'.jpg', sep = '')
pic2 <- paste('monkey', x[2],'.jpg', sep = '')
pic3 <- paste('monkey', x[3],'.jpg', sep = '')
pic4 <- paste('monkey', x[4], '.jpg', sep = '')
tags$img(src = pic1, height = 100, width = 100)





#####will also have to have the response be recoded by the pic number in order to get the right info in the sheet.
#how to do that?
#1. maybe have the choice in the buttons be the pic1, pic2, etc....the numbers will be weird but might work..


#######ok, so this work locally but once on the host the assingments are in the global context..
###utting it in the server doesn't seem to work but based on what i read it should...
#solitons
#1. play around wit server  function
#2. maybe write a function and have taht in the global
#     then would have to call that function later?
#3. or i  would need to have something that user clicks button and 
#    that then generates everything?


x <- sample(1:4, 4, replace = FALSE)
pic1 <- paste('monkey', x[1],'.jpg', sep = '')
pic2 <- paste('monkey', x[2],'.jpg', sep = '')
pic3 <- paste('monkey', x[3],'.jpg', sep = '')
pic4 <- paste('monkey', x[4], '.jpg', sep = '')
tags$img(src = pic1, height = 100, width = 100)


function(input, output, session){
  output$what <- renderDataTable(x)
}
)



#this might be a clue
#https://stackoverflow.com/questions/44524619/call-r-script-from-shiny-app



###triyng to build it via a click
#idea...use render infobox? 


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
         
         
         
         
         output$myImage <- renderImage({
           # A temp file to save the output.
           # This file will be removed later by renderImage
           outfile <- tempfile(fileext = '.png')
           
           # Generate the PNG
           png(outfile, width = 400, height = 300)
           hist(rnorm(input$obs), main = "Generated in renderImage()")
           dev.off()
           
           # Return a list containing the filename
           list(src = outfile,
                contentType = 'image/png',
                width = 400,
                height = 300,
                alt = "This is alternate text")
         }, deleteFile = TRUE)
         }



######################################################
###https://stackoverflow.com/questions/46700748/making-multiple-images-hyperlinked-in-shiny
######

#another idea is to have all the images in a dataframe, where one col points to the img source
#ad then i select random ones from that?

###so this works kinda...
#nnext steps
#1. make up fake set with the flag data
#2. see if you can pull random with code
#think about where this will be.....might not work unelss i can find where to put it

#code basics
z <- sample(1:4, 4, replace = FALSE)
temp$loc[z[1]] #would get first value


nimage <- eventReactive(input$goButton, {
  z <- sample(1:4, 4, replace = FALSE)  
  first_image <- temp$loc[z[1]]
  second_image <- temp$loc[z[2]]
  tags$img(src = first_image, height = 100, width = 100)
  
  
})


temp2$loc[z[1]]

tags$img(src = temp2 %>% select(loc) %>% sample_n(1))

nimage <- eventReactive(input$goButton, {
  x <- sample(1:4, 4, replace = FALSE)
  pic1 <- paste('monkey', x[1],'.jpg', sep = '')
  pic2 <- paste('monkey', x[2],'.jpg', sep = '')
  pic3 <- paste('monkey', x[3],'.jpg', sep = '')
  pic4 <- paste('monkey', x[4],'.jpg', sep = '')
  radioButtons("set_1", "which do you prefer", c(pic1,pic2))
  h6(" first")
  tags$img(src = pic1, height = 100, width = 100)
  tags$img(src = pic2, height = 100, width = 100)
  
})



#http://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Flag_of_the_People%27s_Republic_of_China.svg/200px-Flag_of_the_People%27s_Republic_of_China.svg.png"
#width="100" height="80"></img>', '<img src="https://upload.wikimedia.org/wikipedia/en/a/ae/Flag_of_the_United_Kingdom.svg"width="100" height="80"></img>', '<img src="https://upload.wikimedia.org/wikipedia/en/b/ba/Flag_of_Germany.svg"width="100" height="80"></img>', '<img src="https://upload.wikimedia.org/wikipedia/en/c/c3/Flag_of_France.svg"width="100" height="80"></img>'),                                                    
#      infolink = c('https://en.wikipedia.org/wiki/United_States', 'https://en.wikipedia.org/wiki/China', 'https://en.wikipedia.org/wiki/United_Kingdom', 'https://en.wikipedia.org/wiki/Germany', 'https://en.wikipedia.org/wiki/France'),