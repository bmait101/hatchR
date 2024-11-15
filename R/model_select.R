#' Select a development model structure
#'
#' Parameterizations from published literature for
#' numerous salmonid species used predict
#' both hatching and emergence
#'
#' @param author Source of model.
#' @param species Species common name.
#' @param model Model number of type from Beacham and Murray (1990).
#' @param dev.type Phenology type (e.g., hatch or emerge).
#'
#' @return A model function.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' # access the parameterization for sockeye hatching using
#' # model #2 from Beacham and Murray (1990)
#' sockeye_hatch_mod <- model_select(
#'   author = "Beacham and Murray 1990",
#'   species = "sockeye",
#'   model = 2,
#'   dev.type = "hatch"
#' )
#' # print
#' sockeye_hatch_mod
model_select <- function(author,
                         species,
                         model,
                         dev.type
                         ){

  # base R syntax--needs strings as arguments
  mod <- model_table[which(model_table$author == author &
                             model_table$species == species &
                             model_table$model == model &
                             model_table$dev.type == dev.type), "func"]

  # use dplyr and stingr functions to select model


  # model select using tidyverse (not returning correctly)
  # mod <- model.table %>%
  #   filter(author == {{author}} &
  #            species == {{species}} &
  #            model == {{model}} &
  #            dev.type == {{dev.type}}) %>%
  #   pull(func)

  mod <- parse(text = mod) # turn model to text and parse
  return(mod)

}

# TO DO:
# - use tidyvserse instead of base r
