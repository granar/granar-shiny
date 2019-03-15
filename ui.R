# 
# Copyright © 2018, Université catholique de Louvain
# All rights reserved.
# 
# Copyright © 2018 Forschungszentrum Jülich GmbH
# All rights reserved.
# 
# Developers: Guillaume Lobet
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted under the GNU General Public License v3 and provided that the following conditions are met:
#   
#   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
# 
# Disclaimer
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# You should have received the GNU GENERAL PUBLIC LICENSE v3 with this file in license.txt but can also be found at http://www.gnu.org/licenses/gpl-3.0.en.html
# 
# NOTE: The GPL.v3 license requires that all derivative work is distributed under the same license. That means that if you use this source code in any other program, you can only distribute that program with the full source code included and licensed under a GPL license.


library(shiny)

shinyUI(fluidPage(

  # Application title
  navbarPage(title="Generator of Root ANAtomy in R   [GRANAR]",
             
     ## Load data ----              
     
     tabPanel("The model", id="tab1", icon = icon("bullseye"),

        # Sidebar with a slider input for number of bins
        fluidRow(
          column(4,
                 tabsetPanel(type = "tabs",
                             tabPanel("Cortex", 
                                      tags$hr(),
                                      helpText("Parameters for the cortex. You can adjust the number of cell layers and the size of individual cells"),
                                      tags$hr(),
                                      sliderInput("n_cortex", "Layers:", num_cortex, min = 1, max = 15, step = 1),
                                      sliderInput("s_cortex", "Diameter:", diam_cortex, min = round(diam_cortex/3, 3), max = diam_cortex*2, step = 0.01)),
                             tabPanel("Stele",
                                      tags$hr(),
                                      helpText("Parameters for the stele. You can adjust the total diameter of the stele and the size of individual cells"),
                                      tags$hr(),
                                      sliderInput("s_stele", "Diameter of stele:", size_stele, min = round(size_stele/3, 3), max = size_stele*2, step = 0.01),
                                      sliderInput("ss_stele", "Diameter of cells:", diam_stele, min = round(diam_stele/3, 3), max = diam_stele*2, step = 0.01)),
                             tabPanel("Xylem",
                                      tags$hr(),
                                      helpText("Parameters for the xylem vessels. You can adjust the number of xylem vessel files"),
                                      tags$hr(),
                                      sliderInput("n_xylem", "Number of files:", n_xylem_files, min = 2, max = 6, step = 1),
                                      sliderInput("s_xylem", "Max size of vessels:", diam_xylem, min = round(diam_xylem/3, 3), max = diam_xylem*2, step = 0.01)),
                             
                             tabPanel("Aerenchyma",
                                      tags$hr(),
                                      helpText("Parameters for the production of aerenchyma. You can adjust the number of aerenchyma files and the total proportion of aerenchyma within the cortex."),
                                      tags$hr(),
                                      helpText("Creating aerenchyme take time in GRANAR. Be patient!"),
                                      tags$hr(),
                                      sliderInput("aerenchyma", "Proportion of aerenchyma [%]", min = 0, max = 30, value = proportion_aerenchyma),
                                      sliderInput("n_aerenchyma", "Number of files:", n_aerenchyma_files, min = 1, max = 20, step = 1))
                 ),
                 tags$hr(),
                 selectInput("planttype", label = "Plant type", choices = c("monocot"=1, 'dicot'=2)),
                 helpText("You can choose here wether to simulate a dicot or monocot plant"),
                 # sliderInput("random",
                 #      "Randomness of cell positions [%]",
                 #      min = 0,
                 #      max = 5,
                 #      value = random),
                 tags$hr(),
                 bsButton(inputId = "refresh", type = "action", style="primary", label="Refresh",icon("recycle")),
                 tags$hr(),
                 img(src='logo.png', align = "left", width="100%")
          ),
    
          # Show a plot of the generated distribution
          column(8,    
            selectInput("toplot", "Variable to display", choices=c("Type"="type", 
                                                                   "Area" = "area", 
                                                                   "Distance from center" = "dist",
                                                                   "Cell ID" = "id_cell",
                                                                   "Angle" = "angle")),
            tableOutput('section_data'),
            tags$hr(),
            plotOutput("distPlot", width="700", height="700"),
            tags$hr(), 
            downloadButton("downloadSVG", "SVG"),
            downloadButton("downloadCSV", "CSV"),
            downloadButton("downloadXML", "XML"),
            downloadButton("downloadPNG", "PNG"),
            tags$hr()
          )
        )
     ),
     tabPanel("About", id="tab1", icon = icon("plus"),
              fluidRow(
                column(3),
                column(6,
                       
                       h4("Cite us"),
                       tags$hr(),
                       tags$strong("GRANAR, a new computational tool to better understand the functional importance of root anatomy (2019)"),
                       helpText("Adrien Heymans, Valentin Couvreur, Therese LaRue, Ana Paez, Guillaume Lobet"),
                       actionButton(inputId='ab1', label="View paper", icon = icon("flask"), onclick ="window.open('#', '_blank')"),
                       
                       tags$hr(),
                       
                       h4("Licence"),
                       tags$hr(),
                        helpText("GRANAR is free to use and released under a GPL licence. It means that redistribution and use in source and binary forms, with or without modification, are permitted under the GNU General Public License v2 and provided that the following conditions are met:"),
                               
                       helpText("1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer."),
                               
                       helpText("2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution."),
                               
                        helpText("3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission."),  
                       actionButton(inputId='ab1', label="View source code", icon = icon("flask"), onclick ="window.open('https://github.com/granar', '_blank')"),
                       tags$hr()
                )
              )
     )
  )
))
