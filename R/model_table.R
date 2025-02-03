#' Table of phenology models
#'
#' Table providing the model parameterizations for the phenology models.
#'
#' @source Beacham & Murray (1990), Sparks et al. (2017), Austin et al. (2019).
#' @format Data frame with 5 columns:
#' \describe{
#' \item{author}{Author-year short citation}
#' \item{species}{Species name}
#' \item{model_id}{Identification number for a model parameterization}
#' \item{development_type}{Hatch or emergence}
#' \item{expression}{character string of parameterized function expression}
#' }
#' @examples
#' model_table
#' @references
#' Beacham, T.D., Murray, C.B. (1990). Temperature, egg size, and development
#' of embryos and alevins of five species of Pacific salmon: a comparative
#' analysis.
#'   \emph{Canadian Journal of Zoology},
#'   \bold{68}, 1931--1940.
#'
#' Sparks, M.M., Westley, P.A.H., Falke, J.A., Quinn, T.A. (2017). Thermal
#' adaptation and phenotypic plasticity in a warming world: Insights from
#' common garden experiments on Alaskan sockeye salmon.
#'   \emph{Canadian Journal of Fisheries and Aquatic Sciences},
#'   \bold{76(1)}, 123--135.
#'
#' Austin, C.C., Essington, T.E., Quinn, T.A. (2019). Spawning and emergence
#' phenology of bull trout \emph{Salvelinus confluentus} under differing
#' thermal regimes.
#' \emph{Canadian Journal of Fisheries and Aquatic Sciences},
#' \bold{94(1)}, 191--195.
"model_table"
