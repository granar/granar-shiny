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

shinyServer(
  function(input, output, clientData, session) {  
  
    withProgress(message = "Computing cells", {
      dat <- reactiveValues(cell_data = create_anatomy(parameters = params, verbatim=F))
    })
  
    ## MODEL -----
    observeEvent(input$refresh, {
      
      withProgress(message = "Computing cells", {
        
          # Update the parameters with user values  
          params$value[params$name == "planttype" & params$type == "param"] <- as.numeric(input$planttype)
          params$value[params$name == "aerenchyma" & params$type == "proportion"] <- input$aerenchyma/100
          params$value[params$name == "aerenchyma" & params$type == "n_files"]    <- input$n_aerenchyma
          params$value[params$name == "cortex" & params$type == "cell_diameter"]  <- input$s_cortex
          params$value[params$name == "cortex" & params$type == "n_layers"]       <- input$n_cortex
          params$value[params$name == "xylem" & params$type == "n_files"]         <- input$n_xylem
          params$value[params$name == "xylem" & params$type == "max_size"]        <- input$s_xylem
          params$value[params$name == "stele" & params$type == "cell_diameter"]   <- input$ss_stele
          params$value[params$name == "stele" & params$type == "layer_diameter"]  <- input$s_stele

          # Create new anatomy
          dat$cell_data <- create_anatomy(parameters = params, verbatim=F)  
      })
    })
    
    ## PLOTS ---------
    
    ## > Cell plot -------
    cellPlot <- function(cell){
      pl <- ggplot(cell) + 
        geom_polygon(aes_string("x", "y", group="id_cell", fill=input$toplot), colour="white") + 
        theme_classic() + 
        coord_fixed() +
        theme(axis.line=element_blank(),
              axis.text.x=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank())
      
      if(input$toplot != "type"){
        pl <- pl + scale_fill_viridis()
      }else{
        #pl <- pl + scale_fill_brewer(palette = "BrBG") #Accent, Dark2, Paired, Pastel1, Pastel2, Set1, Set2, Set3

      }
      return(pl)
    }
    
    output$distPlot <- renderPlot({
      if(is.null(dat$cell_data$nodes)){return ()}
      cellPlot(dat$cell_data$nodes)
    })
     
    ## OUTPUTS ---------
  
    ## > PNG -------------
    output$downloadPNG <- downloadHandler(
      filename = function() {
        "crosssection.png"
      },
      content = function(file) {
        if(is.null(dat$cell_data$nodes)){return ()}
        plot <- cellPlot(dat$cell_data$nodes)
        plot + ggsave(file, height = 10, width = 10, bg="transparent")
      }
    )   
    
    
    ## > SVG -------------
    output$downloadSVG <- downloadHandler(
      filename = function() {
        "crosssection.svg"
      },
      content = function(file) {
        if(is.null(dat$cell_data$nodes)){return ()}
        plot <- cellPlot(dat$cell_data$nodes)
        plot + ggsave(file, height = 10, width = 10, bg="transparent")
      }
    ) 
    
    ## > XML -------------
    output$downloadXML <- downloadHandler(
      filename = function() {
        "crosssection.xml"
      },
      content = function(file) {
        if(is.null(dat$cell_data)){return ()}
        write_anatomy_xml(dat$cell_data, path=file)
      }
    ) 
    
    
    ############################################################
    ### TABLE ------------
    ############################################################  
    
    output$section_data <- renderTable({
      if(is.null(dat$cell_data$section)){return()}
      dat$cell_data$section
    })    
    
    
  
})
