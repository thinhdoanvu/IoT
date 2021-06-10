#### Log in module ###

PASSWORD <- data.frame(
  ID_USER = c("admin","thinhdv"), 
  ID_PASS = c("123","0914949195")
)

output$uiLogin <- renderUI({
  if (USER$Logged == FALSE) {
    sidebarPanel(
      textInput("userName", "User Name:"),
      passwordInput("passwd", "Password:"),
      br(),
      actionButton("Login", "Log in")
    )
  }
})

output$pass <- renderText({  
  if (USER$Logged == FALSE) {
    USER$pass
  }  
})

# Login info successful ----
output$userPanel <- renderUI({
  if (USER$Logged == TRUE) {
    fluidRow(
      strong(paste("logged in as", USER$name, "|")), actionLink(inputId = "logout", "Logout"), align = "right",
      hr()
    )
  }  
})

# control login
observeEvent(input$Login , {
  Username <- isolate(input$userName)
  Password <- isolate(input$passwd)
  Id.username <- which(PASSWORD$ID_USER == Username)
  Id.password <- which(PASSWORD$ID_PASS    == Password)
  if (length(Id.username) > 0 & length(Id.password) > 0) {
    if (Id.username == Id.password) {
      USER$Logged <- TRUE
      USER$name <- Username      
    } 
  } else {
    USER$pass <- "User name or password failed!"
  }
})

# control logout
observeEvent(input$logout , {
  USER$Logged <- FALSE
  USER$pass <- ""
})
