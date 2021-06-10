shinyServer(function(input, output, session) {
    
    source("C:/Users/Administrator/Desktop/R/R_shiny/IoT_Ver9/Login/global.R")
    
    ####################################################################
    ################### SETTINGS tab panel ############################
    ####################################################################
    
    #Login Logout
    USER <- reactiveValues(Logged = FALSE , session = session$user) 
    source("www/Login.R",  local = TRUE)
    
    output$LoginPage <- renderUI({    
        if (USER$Logged == TRUE) {
            
            #Dang nhap thanh cong
            
            #Edit Email person
            fluidRow(
                titlePanel(title = "PARAMETERS SETTINGS"), align = "center"
            )
            hr()
            uiOutput("Email")#hien thi GUI Email and Acceptable range
        }#End IF (login thanh cong)                 
    })  
    
    #--------------------------------------------------------------------------
    #Design UI for range value and Email
    ##Khai bao bien
    rec_person=""
    nd=""
    
    t_min=tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),2),1)
    t_max=tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),3),1)
    ph_min=tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),4),1)
    ph_max=tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),5),1)
    od_min=tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),6),1)
    
    output$Email <- renderUI({
        fluidRow(
            #-------------------------------------------------------------------
            #Giao dien thiet lap cho muc Email
            #-------------------------------------------------------------------
            column(width = 3,style = "background-color:#edeef7;",
                   tags$h4("Email settings"),
                   #p(),
                   textInput("email_to", "TO:", value="itspider2018@gmail.com",),
                   
                   #Temperature
                   numericInput(inputId="temperature_min",label="Temperature MIN",value=t_min,min = 0,max = 100,step = 1,width = NULL),
                   numericInput(inputId="temperature_max",label="Temperature MAX",value=t_max,min = 0,max = 100,step = 1,width = NULL),
                   #pH
                   #p(),
                   numericInput(inputId="pH_min",label="pH MIN",value=ph_min,min = 0,max = 10,step = 0.1,width = NULL),
                   numericInput(inputId="pH_max",label="PH MAX",value=ph_max,min = 0,max = 10,step = 0.1,width = NULL),
                   #Dissolved Oxygen
                   #p(),
                   numericInput(inputId="Dissolved_Oxygen_min",label="Dissolved Oxygen MIN",value=od_min,min = 0,max = 100,step = 1,width = NULL),
                   #Button
                   actionButton("Accept_datarange", "Accept!"),
                   p()   
            ),#End Column Acceptable Range
            
            #-------------------------------------------------------------------
            #Giao dien thiet lap va dieu khien cho muc Control Panel
            #-------------------------------------------------------------------
            uiOutput("ControlPanel")
                #Ta goi ui o day la vi: giao dien cua ControlPanel nam ben phai cua Email settings
            
        )#End Fluid Row UI
        
    })#End Output Email
    
    
    #--------------------------------------------------------------------------
    #Send Email fuction
    #--------------------------------------------------------------------------
    
    send.emails <- function(nguoinhan,noidung) {
        email <- gm_mime() %>%
            gm_to(nguoinhan) %>%
            gm_from("itspider2019@gmail.com") %>%
            gm_subject("NTU SmartAgri Alert message") %>%
            gm_text_body(noidung)
        gm_send_message(email)
    }#End function
    
    #Check condition
        
    if (datane_top$Temperature > t_max || datane_top$Temperature < t_min){
        nd = paste0(toupper("Temperature is out of range"), "\n\n","Temperature is: ", datane_top$Temperature, "\n", "pH is: ", datane_top$pH, "\n","Dissolved Oxygen is: ", datane_top$Dissolved_Oxygen)
        
    }
    else
    {
        if(datane_top$pH > ph_max || datane_top$pH < ph_min ){
            nd = paste0(toupper("pH is out of range"), "\n\n","Temperature is: ", datane_top$Temperature, "\n", "pH is: ", datane_top$pH, "\n","Dissolved Oxygen is: ", datane_top$Dissolved_Oxygen)
        }
        else
        {
            if(datane_top$Dissolved_Oxygen < od_min){
                nd = paste0(toupper("Dissolved Oxygen is below of acceptable range"), "\n\n","Temperature is: ", datane_top$Temperature, "\n", "pH is: ", datane_top$pH, "\n","Dissolved Oxygen is: ", datane_top$Dissolved_Oxygen) 
            }
        }
    }
    
    #Check and send mail
    
    observeEvent(nd, {
        if(nd!=""){
            #Doc noi dung file
            rec_person = tail(head(read.table(paste0(path_datarange,"/www/datarange.txt")),1),1)
            send.emails(rec_person,nd)
        }
    })
    
    #Nhan nut Accept va tien hanh luu vao file
    
    observeEvent(input$Accept_datarange,{
        if(file.exists("www/datarange.txt")){
            file.remove("www/datarange.txt")
        }
        
        file.create("www/datarange.txt")
        write.table(input$email_to,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        write.table(input$temperature_min,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
        write.table(input$temperature_max,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
        write.table(input$pH_min,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
        write.table(input$pH_max,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
        write.table(input$Dissolved_Oxygen_min,"www/datarange.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE)
        refresh()
    })
    
    #--------------------------------------------------------------------------
    #Click control Panel
    #--------------------------------------------------------------------------
    #Khi moi load trang, chua nhan nut dieu khien cac thiet bi
    last_water <- tail(datalog,1)
    last_humi <- head(tail(datalog,2),1)
    last_bulb <- head(tail(datalog,3),1)
    if(last_water == "Pump ON"){
        water_count = 1 #1~ ON 0 ~ OFF
    }
    if(last_water == "Pump OFF"){
        water_count = 0 #1~ ON 0 ~ OFF
    }
    if(last_humi == "Humidity ON"){
        humi_count = 1 #1~ ON 0 ~ OFF
    }
    if(last_humi == "Humidity OFF"){
        humi_count = 0 #1~ ON 0 ~ OFF
    }
    if(last_bulb == "Lamp ON"){
        bulb_count = 1 #1~ ON 0 ~ OFF
    }
    if(last_bulb == "Lamp OFF"){
        bulb_count = 0 #1~ ON 0 ~ OFF
    }
    
    makeReactiveBinding('bulb_count')
    makeReactiveBinding('humi_count')
    makeReactiveBinding('water_count')
    
    observeEvent(input$bulb, {
        bulb_count <<- bulb_count + 1
        if(bulb_count %% 2 == 0){
            updateActionButton(session, "bulb", label = "OFF", icon = icon("toggle-off"))
        }
        else
        {
            updateActionButton(session, "bulb", label = "ON", icon = icon("toggle-on"))
        }

    })

    observeEvent(input$humidity, { 
        humi_count <<- humi_count + 1
        if(humi_count %% 2 == 0){
            updateActionButton(session, "humidity", label = "OFF", icon = icon("percentage"))
        }
        else
        {
            updateActionButton(session, "humidity", label = "ON", icon = icon("percent"))
        }
        
    })
    
    observeEvent(input$water, {
        water_count <<- water_count + 1
        if(water_count %% 2 == 0){
            updateActionButton(session, "water", label = "OFF", icon = icon("tint-slash"))
        }
        else
        {
            updateActionButton(session, "water", label = "ON", icon = icon("tint"))
        }

    })
    
    #Nhan nut SET de ghi du lieu vao file dieu khien
    observeEvent(input$SET,{
        if(file.exists("www/control.txt")){
            file.remove("www/control.txt")
        }
        
        file.create("www/control.txt")
        if(bulb_count %% 2 == 0){
            write.table("Lamp OFF","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        if(bulb_count %% 2 != 0){
            write.table("Lamp ON","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        
        if(humi_count %% 2 == 0){
            write.table("Humidity OFF","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        if(humi_count %% 2 != 0){
            write.table("Humidity ON","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        
        if(water_count %% 2 == 0){
            write.table("Pump OFF","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        if(water_count %% 2 != 0){
            write.table("Pump ON","www/control.txt",sep = "",row.names=FALSE, col.names=FALSE, eol="\n", append =TRUE )
        }
        
        #Khong can refresh trang
    })
    
    #--------------------------------------------------------------------------
    # Display log file control Panel
    #--------------------------------------------------------------------------
    
    #Hien thi noi dung cho o History
    output$historycontrol <- renderUI({
        #rawText <- tail(readLines('www/log.txt'),32) # get raw text
        rawText <- readLines('www/log.txt') # get raw text
        
        # split the text into a list of character vectors
        #   Each element in the list contains one line
        splitText <- stringi::stri_split(str = rawText, regex = '\\n')
        
        # wrap a paragraph tag around each element in the list
        replacedText <- lapply(splitText, p)
        
        return(replacedText)
    })
    
    #Su dung bien de theo doi ON hay OFF
    #Phan nay la de hien thi ra giao dien
    
    output$ControlPanel <- renderUI({
        column(width = 9,
               
               #Khung hien thi ON OFF
               fluidRow(width=12, style = "background-color:#f4f9f9;",
                        tags$h4("Conrol Panel"),
                        hr(),
                        #h5("Curent Status"),
                        
                        #Load bulb icons
                        column(width = 3,
                               if(bulb_count %% 2 == 0){
                                   HTML('<img src="images/pic_bulboff.gif" height= "80" width = "80"> ')},
                               if(bulb_count %% 2 != 0){
                                   HTML('<img src="images/pic_bulbon.gif" height= "80" width = "80"> ')},
                               ),
                        
                        #Load humidity icons
                        column(width = 3,
                               if(humi_count %% 2 == 0){
                                   HTML('<img src="images/pic_humidityoff.gif" height= "80" width = "80"> ')},
                               if(humi_count %% 2 != 0){
                                   HTML('<img src="images/pic_humidityon.gif" height= "80" width = "80"> ')},
                               ),
                        
                        #Load water icons
                        column(width = 3,
                               if(water_count %% 2 == 0){
                                   HTML(' <img src="images/pic_wateroff.gif" height= "80" width = "80"> ')},
                               if(water_count %% 2 != 0){
                                   HTML(' <img src="images/pic_wateron.gif" height= "80" width = "80"> ')}
                               ),
                        
                        #Load OK set icons
                        column(width = 3,
                               HTML('<img src="images/pic_setok.png" height= "80" width = "80"> ')
                               ),
                        
                        #Load icon butons
                        fluidRow(width = 12,
                                 
                                 
                                 column(width = 3, actionButton("bulb", "", icon = icon("lightbulb"), style="font-size: 36px")),
                                 column(width = 3,actionButton("humidity", "", icon = icon("percent"),style="font-size: 36px")),
                                 column(width = 3,actionButton("water", "", icon = icon("tint"),style="font-size: 36px")),
                                 column(width = 3,actionButton("SET", "", icon = icon("check-circle"),style="font-size: 36px")),
                                 ),
                        ),#End fluidRow cua cac icon va hinh anh
               
            
            #Chen them khung history ben phai cua Email Settings va ben duoi Control Panel
               fluidRow(width =12,
                        tags$h4("History"),
                        hr(),
                        #Hien thi thanh cuon
                        div(style = 'overflow-y: scroll; max-height: 242px; overflow-x: scroll; max-width: 100%',uiOutput("historycontrol")))
        )#End colum 9 (ben phai cua giao dien Email Settings)
        
    })#Ending Render UI for Control Panel
    
    
    ####################################################################
    ################### Statistic tab panel ############################
    ####################################################################
    
    ############loading file -------------------------------
    
    df_products_NOupload <- reactive({
        inFile <- input$target_upload
        inFile$datapath = paste0(getwd(),"/data")
        wd.init = getwd()
        setwd(inFile$datapath)
        df = read.csv("admissions.csv", header = input$header,sep = input$separator, quote=input$quote)
        #Khi khoi dong thi load tam 100 hang
        df = tail(df,50)
        setwd(wd.init)
        
        if (is.null(inFile))
            return(NULL)
        #df = read.csv(inFile$datapath, header = input$header,sep = input$separator, quote=input$quote)
        return(df)
    })
    
    df_products_upload <- reactive({
        inFile <- input$target_upload
        if (is.null(inFile))
            return(NULL)
        df = read.csv(inFile$datapath, header = input$header,sep = input$separator, quote=input$quote)
        return(df)
    })
    
    #Khi khong nhan nut Upload
    output$the_data<- DT::renderDataTable({
        df <- df_products_NOupload()
        DT::datatable(df, options = list(lengthMenu = c(10, 25, 50), pageLength = 10))
    })
    
    #Khi nut Upload duoc nhan
    observeEvent(input$target_upload,{
        
        output$the_data<- DT::renderDataTable({
            df <- df_products_upload()
            DT::datatable(df, options = list(lengthMenu = c(10, 25, 50), pageLength = 10))
        })
        shinyjs::enable("downloadData")
        shinyjs::show("button_filter")
        
    })
    
    ############ downloading file
    #An het cac nut truoc khi load file 
    shinyjs::disable("downloadData") # Tat nut Download cho den khi nhan nut Upload
    shinyjs::hide("button_filter")
    shinyjs::hide("dateRange")
    shinyjs::hide("COLUMN")
    shinyjs::hide("CONDITION")
    shinyjs::hide("COL_VALUE")
    shinyjs::hide("COLUMN2")
    shinyjs::hide("CONDITION2")
    shinyjs::hide("COL_VALUE2")
    shinyjs::hide("COLUMN3")
    shinyjs::hide("CONDITION3")
    shinyjs::hide("COL_VALUE3")
    
    getData <- reactive({
        
        inFile <- input$target_upload
        if (is.null(input$target_upload))
            return(NULL)
        read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                 quote=input$quote)
    })
    
    output$contents <- renderTable(
        getData()
    )
    
    output$downloadData <- downloadHandler(
        filename = function() { 
            paste("data-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            write.csv(getData(), file,sep = ',')
        })
    
    ############ Filtering 
    
    #Khi nut Filter duoc nhan
    observeEvent(input$button_filter,{
        shinyjs::show("dateRange")
        shinyjs::show("COLUMN")
        shinyjs::show("CONDITION")
        shinyjs::show("COL_VALUE")
        shinyjs::show("COLUMN2")
        shinyjs::show("CONDITION2")
        shinyjs::show("COL_VALUE2")
        shinyjs::show("COLUMN3")
        shinyjs::show("CONDITION3")
        shinyjs::show("COL_VALUE3")
        
        output$COL_VALUE <- renderUI({
            x <- datane %>% select(!!sym(input$COLUMN))
            selectInput("VALUE", "Value", choices = x)
        })
        
        output$COL_VALUE2 <- renderUI({
            x <- datane %>% select(!!sym(input$COLUMN2))
            selectInput("VALUE2", "Value", choices = x)
        })
        
        output$COL_VALUE3 <- renderUI({
            x <- datane %>% select(!!sym(input$COLUMN3))
            selectInput("VALUE3", "Value", choices = x)
        })
        
        
        output$the_data <- DT::renderDataTable({
            # To hide error when no value is selected
            
            #DK0
            my_data <- datane %>% filter(datane$Date >= input$dateRange[1] & datane$Date <= input$dateRange[2])
            #my_data <- filter(datane, between(datane$Date, as.Date("2021-05-05"), as.Date("2021-05-05")))
            
            #DK1
            if (input$VALUE == "") {
                my_data <- my_data 
            } else {
                my_data <- my_data %>% 
                    filter(eval(parse(text = paste0(input$COLUMN, input$CONDITION, input$VALUE))))  
            }
            #DK2
            if (input$VALUE2 == "") {
                my_data <- my_data
            } else {
                my_data <- my_data %>% 
                    filter(eval(parse(text = paste0(input$COLUMN2, input$CONDITION2, input$VALUE2))))  
            }
            #DK3
            if (input$VALUE3 == "") {
                my_data <- my_data
            } else {
                my_data <- my_data %>% 
                    filter(eval(parse(text = paste0(input$COLUMN3, input$CONDITION3, input$VALUE3))))  
            }
            
            return(my_data)
            
            DT::datatable(my_data, options = list(lengthMenu = c(10, 25, 50), pageLength = 25))
        })
        
    })#End Filterring
    
    #CHART in STATISTIC --------------------------------------------------------
    
    output$Temperature2 <- renderPlot({
        stat_data <- datane %>% filter(datane$Date >= input$Sta_dateRange[1] & datane$Date <= input$Sta_dateRange[2])
        ggplot(stat_data, aes(Date, Temperature)) + 
            stat_summary(fun = "mean", colour = "red", size = 1, geom = "line") 
        # Axis limits c(min, max)
        # min <- min(datane$Date)
        # max <- max(datane$Date)
        # dp+ scale_x_date(limits = c(min, max))
        
        # Format : month/day
        #dp +  scale_x_date(labels = date_format("%m/%d")) +theme(axis.text.x = element_text(angle=45))
        
        # Format : Week
        #dp + scale_x_date(labels = date_format("%W"))
        
        # Months only
        #dp + scale_x_date(breaks = date_breaks("months"),labels = date_format("%b"))
        
        # year only
        #dp + scale_x_date(breaks = date_breaks("years"),labels = date_format("%Y"))
    })
    
    #SliderInput nhan gia tri tu DateRangeInput
    output$Sta_DatesMerge_Sta <- renderUI({
        sliderInput("Sta_DatesMerge",
                    "",
                    width = '100%',
                    min = min(datane$Date),
                    max = max(datane$Date),
                    value=c(input$Sta_dateRange[1],input$Sta_dateRange[2])
        )
    })
    
    output$StatisticDetail <- renderPlot({
        
        #Load lai data theo khoang thoi gian chu load het thi du lieu qua lon
        
        stat_data <- datane %>% filter(datane$Date >= input$Sta_DatesMerge[1] & datane$Date <= input$Sta_DatesMerge[2])
         if(input$Sta_X_Axis=="Days"){
             if(input$Sta_Y_Axis=="Temperature"){
                 ggplot(stat_data, aes(Date, Temperature)) + 
                     stat_summary(fun = "mean", colour = "red", size = 1, geom = "line")
             }
             else if(input$Sta_Y_Axis=="pH"){
                 ggplot(stat_data, aes(Date, pH)) + 
                     stat_summary(fun = "mean", colour = "red", size = 1, geom = "line") 
             }
             else if(input$Sta_Y_Axis=="Dissolved Oxygen"){
                 ggplot(stat_data, aes(Date, Dissolved_Oxygen)) + 
                     stat_summary(fun = "mean", colour = "red", size = 1, geom = "line") 
             }
         }
        else if(input$Sta_X_Axis=="Weeks"){
            if(input$Sta_Y_Axis=="Temperature"){
                dp=ggplot(stat_data, aes(Date, Temperature)) +
                    stat_summary(fun = "mean", colour = "black", size = 1, geom = "line")
                dp + scale_x_date(labels = date_format("%W")) 
            }
            else if(input$Sta_Y_Axis=="pH"){
                dp=ggplot(stat_data, aes(Date, pH)) +
                    stat_summary(fun = "mean", colour = "black", size = 1, geom = "line")
                dp + scale_x_date(labels = date_format("%W")) 
            }
            else if(input$Sta_Y_Axis=="Dissolved Oxygen"){
                dp=ggplot(stat_data, aes(Date, Dissolved_Oxygen)) +
                    stat_summary(fun = "mean", colour = "black", size = 1, geom = "line")
                dp + scale_x_date(labels = date_format("%W")) 
            }
        }
        else if(input$Sta_X_Axis=="Months"){
            if(input$Sta_Y_Axis=="Temperature"){
                dp=ggplot(stat_data, aes(Date, Temperature)) +
                    stat_summary(fun = "mean", colour = "green", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("months"),labels = date_format("%m")) 
            }
            else if(input$Sta_Y_Axis=="pH"){
                dp=ggplot(stat_data, aes(Date, pH)) +
                    stat_summary(fun = "mean", colour = "green", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("months"),labels = date_format("%m")) 
            }
            else if(input$Sta_Y_Axis=="Dissolved Oxygen"){
                dp=ggplot(stat_data, aes(Date, Dissolved_Oxygen)) +
                    stat_summary(fun = "mean", colour = "green", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("months"),labels = date_format("%m"))
            }
        }
        else
        {
            if(input$Sta_Y_Axis=="Temperature"){
                dp=ggplot(stat_data, aes(Date, Temperature)) +
                    stat_summary(fun = "mean", colour = "blue", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("years"),labels = date_format("%Y")) 
            }
            else if(input$Sta_Y_Axis=="pH"){
                dp=ggplot(stat_data, aes(Date, pH)) +
                    stat_summary(fun = "mean", colour = "blue", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("years"),labels = date_format("%Y")) 
            }
            else if(input$Sta_Y_Axis=="Dissolved Oxygen"){
                dp=ggplot(stat_data, aes(Date, Dissolved_Oxygen)) +
                    stat_summary(fun = "mean", colour = "blue", size = 1, geom = "line")
                dp + scale_x_date(breaks = date_breaks("years"),labels = date_format("%Y"))
            }
        }

    })
    ####################################################################
    ##################### HOME tab panel ###############################
    ####################################################################
    
    ##BOX
    
    output$TempBox <- renderValueBox({
        valueBox(datane_top$Temperature,'Temperature',icon = icon("thermometer"),color = "red") 
    })
    output$pHBox <- renderValueBox({
        valueBox(datane_top$pH,'PH',icon = NULL,color = "green") 
    })
    output$OxygenBox <- renderValueBox({
        valueBox(datane_top$Dissolved_Oxygen,'Dissolved Oxygen',icon = icon("percent"),color = "blue") 
    })
    
    
    ##CHART
    # observe({
    #     updateSelectInput(session, "temp_x", choices = (as.character(colnames(datane_20))),selected = "Time")
    # })
    # 
    # observe({
    #     updateSelectInput(session, "temp_y", choices = (as.character(colnames(datane_20))),selected = "Temperature")
    # })
    
    # output$Temperature <- renderPlot({
    #     ggplot(datane_20, aes(get(input$temp_x), get(input$temp_y))) + geom_point(colour = "red", size = 3) + labs(x="", y="")
    
    output$Temperature <- renderPlot({
        ggplot(datane_30, aes(x = factor(Time, levels=unique(Time)), Temperature)) + 
            geom_col(width = 0.3, colour = "gray", fill="gray") + geom_point(shape = 23, colour = "black", size = 5, fill = "red") + 
            xlab("Time") +
            ylab("Temperature")
        
    })
    
    output$pH <- renderPlot({
        ggplot(datane_30, aes(x = factor(Time, levels=unique(Time)), pH)) + 
            geom_col(width = 0.3, colour = "gray", fill="gray") + geom_point(shape = 23, colour = "black", size = 5, fill = "green") +
            xlab("Time") +
            ylab("pH")
        
    })
    
    output$Dissolved_Oxygen <- renderPlot({
        ggplot(datane_30, aes(x = factor(Time, levels=unique(Time)), Dissolved_Oxygen)) + 
            geom_col(width = 0.3, colour = "gray", fill="gray") + geom_point(shape = 23, colour = "black", size = 5, fill = "blue") +
            xlab("Time") +
            ylab("pH")
    })
    
    #Click mouse info on graph temperature
    temp_points <- reactiveValues(pts = NULL)
    observeEvent(input$temp_click, {
        x <- nearPoints(datane_30, input$temp_click, xvar = "Time", yvar = "Temperature")
        temp_points$pts <- x
    })
    
    output$temp_info <- renderPrint({
        temp_points$pts
    })
    
    #Click mouse info on graph pH
    pH_points <- reactiveValues(pts = NULL)
    observeEvent(input$pH_click, {
        x <- nearPoints(datane_30, input$pH_click, xvar = "Time", yvar = "pH")
        pH_points$pts <- x
    })
    
    output$pH_info <- renderPrint({
        pH_points$pts
    })
    
    #Click mouse info on graph Dissolved Oxygen
    Oxygen_points <- reactiveValues(pts = NULL)
    observeEvent(input$Oxygen_click, {
        x <- nearPoints(datane_30, input$Oxygen_click, xvar = "Time", yvar = "Dissolved_Oxygen")
        Oxygen_points$pts <- x
    })
    
    output$Oxygen_info <- renderPrint({
        Oxygen_points$pts
    })
    
    ####################################################################
    ################### CONTROL Panel ############################
    ####################################################################
    
    #xxx Start -------------------------------
    
    #End xxx -------------------------------
    
    ####################################################################
    ##################### XXX tab panel ###############################
    ####################################################################
    #Auto refresh page (lam sau cung khi code xong san pham): 1 hours (1000 milliseconds*60 seconds*60 minutes* 0.5 hours)
    #Auto reload 30 minute = 1800000
    #Auto reload 10 seconds = 10000
    
    shinyjs::runjs(
        "function reload_page() {
            window.location.reload();
            setTimeout(reload_page, 1800000);
        }
        setTimeout(reload_page, 1800000);
    ")
    
})