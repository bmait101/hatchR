#' Predict phenologt of fish based on temperature
#'
#' @description
#' A short description...
#'
#' @param data Dataframe with dates and temperature.
#' @param dates Date of temperature measurements.
#' @param temperature Temperature measurements.
#' @param spawn.date Date of spawning.
#' @param model Model to predict phenology.
#'
#' @return
#' A list with the following elements:
#'
#' @export
#'
#' @examples
#' # to come...
predict_phenology <- function(data, dates, temperature,  spawn.date, model){

  #define user dataframe and make sure dates are sorted
  dat <-  data |>
    dplyr::arrange({{dates}})

  # errors if data is in wrong format (Date)
  if(lubridate::is.timepoint(spawn.date) == TRUE || lubridate::is.Date(spawn.date) == TRUE ){
    stop("Your spawn.date is formatted as a Date it needs to
         be formatted as a character string (e.g. '09-15-2000')")

  }

  check <-  dat |>
    dplyr::pull({{dates}}) |>
    is.character()

  if(check == TRUE ) {
    stop("Your dates are formatted as a character, they need to
         be formatted as a timepoint (e.g. using ymd())")
  }

  # turn dates from strings to datetime for using lubridate
  s.d<- lubridate::ymd(spawn.date)
  #dat[,dates] <-mdy(dat[,dates] )

  #subset to spawn date
  #spawn.position<- which(dat[,dates] == s.d) # old base R version
  spawn.position <-dat |>
    tibble::rownames_to_column() |>
    dplyr::mutate(rowname = as.numeric(rowname)) |>
    dplyr::filter({{dates}} == s.d) |>
    dplyr::pull(rowname) # grab row number where spawn data matches

  spawn.period <- dat[spawn.position:c(nrow(dat)),] # subset data frame for spawn period

  #effective value function
  Ef <- model
  #Ef.t <-function(x){1 / exp(6.727 - log(x + 2.394))}

  x <- spawn.period |> dplyr::pull({{temperature}}) # vector of temps for Ef to evluate

  #walk along temps and sum Ef to 1 and count how many days
  #D_Ef <- min(which(cumsum(Ef.t(spawn.period[, temps])) >= 1)) #Apply Effective Value model


  D_Ef <- min(which(cumsum(eval(Ef)) >= 1))

  ####  If fish doesn't hatch value returns Inf, if that's the case this returns ef.results as NULL ####
  #### which can be used in a loop to pass over the Inf vals and skip to next iteration             ####
  if (D_Ef == Inf){
    ef.results <- NULL
    message("| Fish did not develop, did not accrue enough
            effective units. Spawn date = ",
            spawn.date,
            ". Did your fish spawn too close to the end of your data?")}
  else{

      # make df with Ef info (dates, temps, Ef vals)
      ef.df <- dat[spawn.position:(spawn.position+(D_Ef-1)),]
      x <- ef.df |> dplyr::pull({{temperature}})
      ef.df$ef_vals <- eval(Ef)
      ef.df$ef_cumsum <- cumsum(ef.df$ef_vals)
      colnames(ef.df)[1:2] <- c("dates", "temperature")

      dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
      colnames(dev.period) <- c("start", "stop")
      dev.period$start <- min(ef.df$dates)
      dev.period$stop <- max(ef.df$dates)

      #output a list with the various data stored
      ef.results <- list(days2done = D_Ef ,
                         dev.period = dev.period,
                         ef.vals = ef.df$ef_vals,
                         ef.tibble = ef.df
      )
    }
  return(ef.results)
}
