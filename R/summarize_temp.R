#' Summarize Temperature Data
#'
#' The `summarize_temp` function is used to summarize sub-daily temperature
#' measurements to obtain mean daily temperature.
#'
#' @param data
#' @param dates
#' @param temperature
#'
#' @return
#' @export
#'
#' @examples
summarize_temp <- function(data, dates, temperature){

  ## check to make sure data are in correct format (check.1 is for datetime object, check.2 is for Date object)
  check <- data %>%
    pull({{dates}}) %>%
    is.character()


  if(check == TRUE){stop("Your dates are formatted as a character they need to be formatted as a timepoint object with lubridate (e.g. ymd()" )}


  ### if data pass checks, run function
  sum_dat <- data %>%
    mutate(ag_date = date({{dates}})) %>% # mutate date-time to date only
    group_by(ag_date) %>% # group by a unique day
    summarise(daily_temp = mean({{temperature}})) # summarize to daily mean temp

  return(sum_dat)
}
