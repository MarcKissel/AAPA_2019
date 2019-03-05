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
