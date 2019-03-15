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



source("www/create_anatomy.R")
source("www/read_param_xml.R")
source("www/write_anatomy_xml.R")

# devtools::install_github("granar/granar")
# library(granar)

library(shinyBS)
library(viridis)
library(deldir)
library(tidyverse)
library(plyr)
library(xml2)
library(alphahull)
library(sp)
library(cowplot)
library(retistruct)
library(Hmisc)

# Init values

params <- read_param_xml("www/Zea_mays_Heymans_2019.xml")

random <- 4
proportion_aerenchyma  <- params$value[params$name == "aerenchyma" & params$type == "proportion"] * 100
n_aerenchyma_files      <- params$value[params$name == "aerenchyma" & params$type == "n_files"]
diam_cortex             <- params$value[params$name == "cortex" & params$type == "cell_diameter"]
num_cortex              <- params$value[params$name == "cortex" & params$type == "n_layers"]
n_xylem_files           <- params$value[params$name == "xylem" & params$type == "n_files"]
diam_xylem              <- params$value[params$name == "xylem" & params$type == "max_size"]
diam_stele              <- params$value[params$name == "stele" & params$type == "cell_diameter"]
size_stele              <- params$value[params$name == "stele" & params$type == "layer_diameter"]

