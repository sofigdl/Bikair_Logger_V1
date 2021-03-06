########################################################################################
ui <- tagList(
  useShinyjs(),
  navbarPage(title = div(img(src='pics/Logo.png', style="margin-top: -10px; padding-right:10px; padding-bottom:10px", height = 50)),
             windowTitle="AirQ Log",
             theme = shinytheme("slate"),
             #######################################################################  Data Import
             tabPanel("Data Import",
                      tags$head(
                        # Include our custom CSS
                        includeCSS("dolcenils.css")
                      ),
                      icon = icon("table"),
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     h4(strong("Load Data:"), align = "left"), 
                                     fileInput("file", NULL, accept = c(".txt",".TXT")),
                                     br(),
                                     sliderInput("range_tab", "Range", 1, 2, value = c(1,2), step = 1),
                                     selectInput("variable_tab", "Variable", choices = c("Pm1"),
                                                 selected = "Pm1"
                                     ),
                                     selectInput("ValSummary", "Summary :", choices = 1, selectize = F, size = 10),
                                     verbatimTextOutput('summary')
                        ),
                        mainPanel(width = 9,
                                  br(),
                                  DT::dataTableOutput("table1")
                        )
                        
                        
                      )),
             ######################################################################################## Interactive map
             tabPanel("Interactive map", 
                      icon = icon("map-marked"),
                      div(class="outer",
                          # If not using custom CSS, set height of leafletOutput to a number instead of percent
                          leafletOutput("map", width="100%", height="100%"),
                          
                          # Shiny versions prior to 0.11 should use class = "modal" instead.
                          absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                        draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                                        width = 330, height = "auto",
                                        
                                        br(),
                                        h4(strong("Display Parameters"), align = "left"), 
                                        
                                        ##########################################################
                                        radioGroupButtons(
                                          inputId = "GeometryButton",
                                          label = "Type",
                                          choices = c("Clear","Points", "Line", "Raster"),
                                          selected = "Clear",
                                          individual = TRUE,
                                          justified = TRUE
                                        ),
                                        
                                        ##########################################################
                                        
                                        sliderInput("range", "Range", 1, 2, value = c(1,2), step = 1),
                                        
                                        selectInput("variable", "Variable", choices = c("TMP"), selected = "TMP"),
                                        
                                        selectInput("colors", "Color Pallete",
                                                    rownames(subset(brewer.pal.info, category %in% c("seq", "div"))),
                                                    selected = "Spectral"),
                                        sliderInput("size", "Size:", min = 1, max = 20, value = 20, step = 0.5),
                                        
                                        sliderInput("transp", "Transparency:", min = 0, max = 1, value = 1, step = 0.1),
                                        
                                        awesomeCheckboxGroup(
                                          inputId = "LegendCheckbox",
                                          label = "Legend", 
                                          choices = c("Show Legend", "Dynamic Legend"),
                                          selected = c("Show Legend", "Dynamic Legend"),
                                          inline = TRUE),
                                        
                                        ######## 
                                        
                                        colourInput("Line_col", "Base colour", "#03F"),
                                        
                                        colourInput("Line_fill", "Pulse colour", "#ffffff"),
                                        
                                        ######## 
                                        
                                        selectInput("colorsRst", "Color Pallete",
                                                    rownames(subset(brewer.pal.info, category %in% c("seq", "div"))),
                                                    selected = "Spectral"
                                        ),
                                        
                                        shinyWidgets::sliderTextInput("res","Resolution:",
                                                                      choices=c(0.001, 0.0005, 0.0001),
                                                                      selected=0.001, grid = T),
                                        
                                        sliderInput("transpRst", "Transparency:", min = 0, max = 1, value = 0.5, step = 0.1),
                                        
                                        awesomeCheckboxGroup(
                                          inputId = "LegendCheckboxRst",
                                          label = "Legend", 
                                          choices = c("Show Legend", "Dynamic Legend"),
                                          selected = c("Show Legend", "Dynamic Legend"),
                                          inline = TRUE),
                                        downloadButton("export_map", "Export")
                                        
                          )
                      )
             ),
             ######################################################################################## Plots
             tabPanel("Plots",icon = icon("chart-line"),
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     sliderInput("range_plot", "Range", 1, 2, value = c(1,2), step = 1),
                                     selectInput("variable_plot", "Variable", choices = c("TMP"),
                                                 selected = "TMP"
                                     ),
                                     actionButton("export_plot", "Export")),
                        mainPanel(style = "background-color: #272b30ff;", width = 9,
                                  plotOutput("plot", width = "100%", height = "670px", inline = FALSE)
                        )
                      )
             ),
             ########################################################################################
             tabPanel("Sen-5P", icon = icon("globe"),
                      leafletOutput("map5p", width="100%", height="100%"),
                      absolutePanel(id = "controls5p", class = "panel panel-default", fixed = TRUE,
                                    draggable = FALSE, top = 60, left = "auto", right = 20, bottom = "auto",
                                    width = 330, height = "auto",
                                    
                                    h4(strong("Sentinel 5p data"), align = "left")
                      )
             ),
             tabPanel("About", icon = icon("globe"),
                      leafletOutput("About", width="100%", height="100%")
             )
  )
)
