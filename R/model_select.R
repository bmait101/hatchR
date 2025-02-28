#' Select a development model structure
#'
#' @description
#' The function calls a model table with the parameterizations for
#' different species from different studies built in. Refer to the
#' table (`model_table`) before using function to find inputs for
#' the different function arguments. It pulls the model format as a
#' string and parses it to be usable in **hatchR** model.
#'
#' @param author Character string of author name.
#' @param species Character string of species name.
#' @param model_id Either model number from Beacham and Murray (1990) or specific to other paper (e.g., Sparks et al. 2017 = AK).
#' @param development_type The phenology type. A vector with possible values
#' "hatch" or "emerge". The default is "hatch".
#'
#' @return A data.frame giving model specifications to be passed to
#'  `predict_phenology()`.
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
#'   model_id = 2,
#'   development_type = "hatch"
#' )
#' # print
#' sockeye_hatch_mod
model_select <- function(author,
                         species,
                         model_id,
                         development_type = "hatch") {
  mod <- model_table |>
    dplyr::filter(
      author == {{ author }} &
        species == {{ species }} &
        model_id == {{ model_id }} &
        development_type == {{ development_type }}
    )
  mod
}
