
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output) {

  output$selected_var <- renderText({
    paste('Viewing water quality data at',input$site,'between',input$dates[1],'and',input$dates[2])
    
  })

  output$plot1 <- renderPlot({
    
    plotdata <- subset(df,SiteName == input$site & time >= input$dates[1] &
                         time <= input$dates[2])
    ggplot((data = plotdata), aes(x = plotdata[,input$param1], y = plotdata[,input$param2])) +
      geom_point() + xlab(input$param1) + ylab(input$param2) + geom_smooth()
    
  })
  
  output$selected_var2 <- renderText({
    paste('Viewing water quality data Comparison of Red Butte Water Quality Data of the iutah
          site at 1300E and 1300S 900W','between',input$dates[1],'and',input$dates[2])
    
  })
  
  output$plot2 <- renderPlot({
    
    plotdata1 <- subset(df,SiteName == sitename_1300[1] & time >= input$dates[1] &
                         time <= input$dates[2])
    plotdata2 <- subset(df,SiteName == sitename_900[1] & time >= input$dates[1] &
                          time <= input$dates[2])
    
    ggplot() + geom_smooth(data = plotdata1, aes(x = plotdata1$time, y=plotdata1[,input$param3],color='red')) +
      
      geom_smooth(data = plotdata2, aes(x=plotdata2$time, y=plotdata2[,input$param3],color='blue')) +
      
      labs(title = "Site Comparison Plot", x = "Time", y = input$param3, color = "Legend\n") +
      
      scale_color_manual(labels = c(sitename_1300[1], sitename_900[1]), values = c("red", "blue")) +
      
      theme_bw() +
      
      theme(axis.text.x = element_text(size = 14), axis.title.x = element_text(size = 16),
            plot.title = element_text(size = 20, face = "bold", color = "darkgreen"))
  })
  
  plotmod <- reactive({
    plotdata <- subset(df, SiteName == input$site & time >= input$dates[1] &
                         time <= input$dates[2])
    mod <- lm(plotdata[,input$param1]~plotdata[,input$param2])
    modsummary <- summary(mod)
    return(modsummary)
  })
  
  output$modelresults <- renderText({
    paste( "R-Squared between", input$param1," and ",input$param2," during this timeframe:",signif((plotmod()$r.squared), digits = 4)) 
  })
  
  output$mymap <- renderLeaflet ({
    leafdata <- subset(sitename_df, SiteName == input$site)
    leaflet() %>% addTiles() %>% addMarkers (lng  = leafdata$Long,
                                             lat = leafdata$Lat)
  })
  
  plotmod2 <- reactive({
    plotdata1 <- subset(df,SiteName == sitename_1300[1] & time >= input$dates[1] &
                          time <= input$dates[2])
    plotdata2 <- subset(df,SiteName == sitename_900[1] & time >= input$dates[1] &
                          time <= input$dates[2])
    mod1 <- rbind("Site_Location" = sitename_1300[1],
                      "Para"= input$param3,
                     "5%" = round(quantile(plotdata1[,input$param3],na.rm=TRUE,(0.05)),2),
                     "95%"= round(quantile(plotdata1[,input$param3],na.rm=TRUE,(0.95)),2),
                     "Mean" = round(mean(plotdata1[,input$param3],na.rm=TRUE),2), 
                     "Median" = round(median(plotdata1[,input$param3],na.rm=TRUE),2),
                     "Std Dev" = round(sd(plotdata1[,input$param3],na.rm = TRUE),2))
    mod2 <- rbind("Site_Location" = sitename_900[1],
                  "Para"= input$param3,
                  "5%" = round(quantile(plotdata2[,input$param3],(0.05),na.rm=TRUE),2),
                  "95%"= round(quantile(plotdata2[,input$param3],(0.95),na.rm=TRUE),2),
                  "Mean" = round(mean(plotdata2[,input$param3],na.rm=TRUE),2), 
                  "Median" = round(median(plotdata2[,input$param3],na.rm=TRUE),2),
                  "Std Dev" = round(sd(plotdata2[,input$param3],na.rm = TRUE),2))
    modtable <- data.frame(col1 = c("Site Location","Parameter","5% Quartile","95% Quartile","Mean","Median","Std Dev"),
                           col2 = mod1, col3= mod2)
    `colnames<-`(modtable,NULL)
    
  })
  
  output$table <- renderTable(plotmod2())
  
  
  output$plot3 <- renderPlot({
    
    plotdata1 <- subset(df,SiteName == sitename_1300[1] & time >= input$dates[1] &
                          time <= input$dates[2])
    plotdata2 <- subset(df,SiteName == sitename_900[1] & time >= input$dates[1] &
                          time <= input$dates[2])
    ggplot((data = plotdata), aes(x = plotdata[,input$param1], y = plotdata[,input$param2])) +
      geom_point() + xlab(input$param1) + ylab(input$param2) + geom_smooth()
    
  })
  
  output$plot3 <- renderPlot({
    
    plotdata3 <- subset(df, time >= input$dates[1] & time <= input$dates[2])
    
    ggplot((data = plotdata3), aes(x = plotdata3$SiteName, y = plotdata3[,input$param3], fill = plotdata3$SiteName)) +
      geom_boxplot(outlier.colour="black", outlier.shape = 8, outlier.size = 4) + xlab("Sites") + ylab(input$param3) +
      scale_fill_discrete(name = "Legend\n")
    
  })
  
})
