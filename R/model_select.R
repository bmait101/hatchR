#' Select a development model structure
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' The function calls a model table with the parameterizations for
#' different species from different studies built in. Refer to the
#' table (`model_table`) before using function to find inputs for
#' the different function arguments. It pulls the model format as a
#' string and parses it to be usable in `hatchR` model.
#'
#' @param author Character string of author name.
#' @param species Character string of species name.
#' @param model Model number from Beacham and Murray (1990).
#' @param dev.type The phenology type. A vector with possible values "hatch" or "emerge". The default is "hatch".
#'
#' @return An expression of length 1 giving the selected model structure to be run with `predict_phenology()`.
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
                         dev.type = "hatch") {
  mod <- model_table |>
    dplyr::filter(
      author == {{ author }} &
        species == {{ species }} &
        model == {{ model }} &
        dev.type == {{ dev.type }})
  #   ) |>
  #   dplyr::pull("func")
  #
  # mod <- parse(text = mod)
  # return(mod)
}
