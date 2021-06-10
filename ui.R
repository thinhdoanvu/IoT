
ui <- navbarPage(
    
    "NTU SmartAgri",   
    
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #Tab HOME here
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    
    tabPanel("HOME",
             
             ##BOX
             ui <- dashboardPage(
                 dashboardHeader(title = "Real-Time value"),
                 dashboardSidebar(disable = TRUE, collapsed = TRUE,sidebarMenu()),
                 
                 dashboardBody(
                     fluidRow(
                         column(width = 12,
                                valueBoxOutput("TempBox", width = 4) %>% withSpinner(type=4),
                                valueBoxOutput("pHBox", width = 4),
                                valueBoxOutput("OxygenBox", width = 4),
                         ),#End column
                     ),#End fluidrow
                     
                     ## CHART 
                     
                     #plotOutput("plot1", click = "plot_click"),
                     #verbatimTextOutput("info")
                     # sidebarPanel(
                     #     fluidRow(
                     #         column(8,
                     #                div(style = "font-size: 13px;", selectInput("temp_x", label = "Select X axis", ''))
                     #         ),
                     #         tags$br(),
                     #         tags$br(),
                     #         column(8,
                     #                div(style = "font-size: 13px;", selectInput("temp_y", "Select Y axis", ''))
                     #         ))
                     #     
                     # ),
                     tabPanel("Graphics Page"),
                     mainPanel(width = 12,
                               tabsetPanel(id='Graph',
                                           tabPanel("Temperature",tags$br(),plotOutput("Temperature", height=320, click = "temp_click"), verbatimTextOutput("temp_info")),
                                           tabPanel("pH",tags$br(),plotOutput("pH",height=320, click = "pH_click"),verbatimTextOutput("pH_info")),
                                           tabPanel("Dissolved_Oxygen",tags$br(),plotOutput("Dissolved_Oxygen", height=320, click = "Oxygen_click"),verbatimTextOutput("Oxygen_info"))
                                           
                               )), 
                     
                 ),#End Body
                 
             ),#End UI Dashboard
        ),#Tab HOME end
    
    
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #Tab STATISTIC here
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    
    tabPanel("Statistic", 
             
             #Adding more TAB
             tabPanel("Statistic Content"),
             mainPanel(width = 12, 
                       tabsetPanel(id='Statistic_More',
                                   #Table TAB
                                   tabPanel("Table",
                                            ## Side baner begin ---
                                            sidebarPanel(
                                                fileInput('target_upload', 'Choose file to upload',accept = c('text/csv','text/comma-separated-values','.csv')),
                                                
                                                
                                                radioButtons('separator', 'Separator',
                                                             c(Comma=',',
                                                               Semicolon=';',
                                                               Tab='\t'),selected=","),
                                                radioButtons('quote', 'Quote',
                                                             c(None='',
                                                               'Double Quote'='"',
                                                               'Single Quote'="'"),
                                                             selected=''),
                                                checkboxInput('header', 'Header', TRUE),
                                                
                                                downloadButton('downloadData', 'Download'),
                                                shinyjs::useShinyjs(),
                                                
                                                hr(),
                                                actionButton("button_filter", "Filtering"),
                                                
                                                #DK0 
                                                fluidRow(column(12,dateRangeInput('dateRange',
                                                                                  label = 'Filter by date',
                                                                                  start = as.Date('2021-05-05') , end = Sys.Date()#as.Date('2021-05-05')
                                                ))),
                                                
                                                #DK1
                                                fluidRow(column(8, selectInput("COLUMN", "Filter By:", choices = c("",colnames(datane)[3:5]))), #tru 2 cot dau Date Time
                                                         column(6, selectInput("CONDITION", "Boolean", choices = c("==", "!=", ">=", "<="))),
                                                         column(6, uiOutput("COL_VALUE"))),
                                                ##DK2
                                                fluidRow(column(8, selectInput("COLUMN2", "Filter By:", choices = c("",colnames(datane)[3:5]))),
                                                         column(6, selectInput("CONDITION2", "Boolean", choices = c("==", "!=", ">=", "<="))),
                                                         column(6, uiOutput("COL_VALUE2"))),
                                                ##DK3
                                                fluidRow(column(8, selectInput("COLUMN3", "Filter By:", choices = c("",colnames(datane)[3:5]))),
                                                         column(6, selectInput("CONDITION3", "Boolean", choices = c("==", "!=", ">=", "<="))),
                                                         column(6, uiOutput("COL_VALUE3"))),
                                                
                                            ),
                                            
                                            
                                            
                                            ## Side banner end!
                                            #An cai nay di neu khong ne se sinh ra 2 bang, xau!
                                            
                                            # mainPanel(
                                            #     DT::dataTableOutput("sample_table")
                                            #     
                                            # ),
                                            
                                            ## Filtering data
                                            
                                            
                                            hr(),
                                            mainPanel("Top 50 records, click Browse for more",
                                                      
                                                      hr(),
                                                      
                                                      DT::dataTableOutput("the_data")
                                            )
                                    ),#TABLE Tab Ending ------------------------
                                   
                                   #CHART TAB ----------------------------
                                   tabPanel("Statistic Chart",
                                            sidebarPanel(
                                                dateRangeInput('Sta_dateRange',
                                                               label = 'Select Date Range',
                                                               start = min(datane$Date) , end = Sys.Date()#as.Date('2021-05-05')
                                                            ),
                                                
                                                # Input: Selector for choosing Axis ----
                                                selectInput(inputId = "Sta_X_Axis",
                                                            label = "Choose X axis by:",
                                                            choices = c("Days","Weeks","Months", "Years"),
                                                            ),
                                                selectInput(inputId = "Sta_Y_Axis",
                                                            label = "Choose Y axis by:",
                                                            choices = c("Temperature", "pH", "Dissolved Oxygen"),
                                                            ),
                                                
                                            width=3),
                                            
                                            mainPanel("Average of Sensors data",
                                                plotOutput("StatisticDetail"),
                                                #tabPanel("pH",tags$br(),plotOutput("pH",click = "pH_click"),verbatimTextOutput("pH_info")),
                                                #tabPanel("Dissolved_Oxygen",tags$br(),plotOutput("Dissolved_Oxygen",click = "Oxygen_click"),verbatimTextOutput("Oxygen_info"))
                                                
                                                width=9,
                                                # fluidPage(
                                                #          sliderInput("Sta_DatesMerge",
                                                #                      "",
                                                #                      min = min(datane$Date),
                                                #                      max = max((datane$Date)),
                                                #                      value=c(Sys.Date()-10,Sys.Date())
                                                #          ),
                                                #     )
                                                
                                                #Slider nhan gia tri tu Date Range Input
                                                uiOutput("Sta_DatesMerge_Sta")
                                                )#End main Panel
                                            
                                   )#Chart Tab Ending ----------------------
                      ), 
             )  
    ),#Tab STATISTIC end
    
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #Tab Control Panel here
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    tabPanel("Control Panel",
             fluidPage(
                 uiOutput("uiLogin"),
                 textOutput("pass"),
                 tags$head(tags$style("#pass{color: red;")),#),    
                 
                 #hien thi dong login/logout
                 uiOutput("userPanel"),
                 #Hien thi trang login thanh cong
                 uiOutput("LoginPage")
             )
    ),#END Tab CONTROL
    
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------
    #Tab xxx
    #---------------------------------------------------------------------------
    #---------------------------------------------------------------------------

    navbarMenu("Info",
               tabPanel("USAGE", "INFO")
               #tabPanel("contact", "INFO")
               #tabPanel("acknowlege", "THANKS")
    )
    
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
)#MAIN CODE

