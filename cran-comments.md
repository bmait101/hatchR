## R CMD check resutls

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

* checking CRAN incoming feasibility:
  Maintainer: 'Bryan M. Maitland <bryan.maitland@usda.gov>'
  
  Version contains large components (0.3.2.9000)
  
  Found the following (possibly) invalid URLs:
    URL: https://doi.org/10.1577/1548-8659(1990)119<0927:TESADO>2.3.CO;2
      From: inst/doc/Introduction.html
            inst/doc/Parameterize_models.html
      Status: 400
      Message: Bad Request
  
  Despite an odd DOI number, this is a valid URL and DOI. 
      
* checking installed package size
  installed size is  5.4Mb
    sub-directories of 1Mb or more:
      data   2.4Mb
      doc    2.7Mb
  
  The package contains 4 datasets that will rarely, if ever, be updated.
  There is no doc directory in the project as shown by running this:
  fs::dir_ls(path = c("C:/Users/BryanMaitland/Projects/hatchR"), type = "directory", glob = "*doc", recurse = TRUE)
  Result: character(0). I cannot determine how to fix this. 
      
## revdepcheck results

There are currently no downstream dependencies for this package.
