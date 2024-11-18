#' Select a development model structure
#'
#' @description The function calls a model table with the parameterizations for
#' different species from different studies built in. Refer to the
#' table (`model_table`) before using function to find inputs for
#' the different function arguments. It pulls the model format as a
#' string and parses it to be usable in `hatchR` model.
#'
#' @param author Source of model.
#' @param species Species common name.
#' @param model Model number of type from Beacham and Murray (1990).
#' @param dev.type Phenology type (e.g., "hatch" or "emerge").
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
                         dev.type) {
  # model select using tidyverse (not returning correctly)
  mod <- model_table |>
    dplyr::filter(
      author == {{ author }} &
        species == {{ species }} &
        model == {{ model }} &
        dev.type == {{ dev.type }}
    ) |>
    dplyr::pull("func")

  # base R syntax (needs strings as arguments)
  # mod <- model_table[which(model_table$author == author &
  #                            model_table$species == species &
  #                            model_table$model == model &
  #                            model_table$dev.type == dev.type), "func"]

  mod <- parse(text = mod)
  return(mod)
}

# TO DO:
# - use tidyvserse instead of base r
# - add ID to each model for easily selection
