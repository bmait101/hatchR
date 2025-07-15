# hatchR (development version)

-   add new article showing how to parameterize for [non-fish](https://bmait101.github.io/hatchR/articles/Non-fish.html) (#65)
-   fix test for ggplot object class (#61)
-   added [Predict spawn](https://bmait101.github.io/hatchR/articles/Predict_spawning.html) vignette for examples of using `predict_spawn()` function
-   added new function `predict_spawn()` to take observed hatch or spawn events and back calculate when a parent spawned
-   adding @pfrater and @allisonswartz as a contributors (should have been done for v0.3.2)
-   secondary y-axis in `plot_phenology()` now "Cumulative EF Values" and updated documentation (#43)
-   added new vignette for launching Shiny app (#45)
-   changed name of element `dev.period` to `dev_period` in `predict_phenology()` output; updated name throughout (#50)

# hatchR 0.3.2

## Bug fixes

-   omitted "+ file LICENSE" from DESCRIPTION and the file itself
-   ommited the email address from README

# hatchR 0.3.1

## Bug fixes

-   added a missing dependency on R \>= 4.1.0 because package code uses the pipe syntax added in R 4.1.0

# hatchR 0.3.0

## Minor improvements and bug fixes

-   fix `model_table` bug (#11) and add link to Shiny app (#12); (PR #13)
-   new contributions from @pfrater (#26)
    -   added axis labels to make output plot from `fit_model()` more intuitive
    -   added second axis to `plot_phenology()`
-   fix citations in `model_table` and throughout (#11)
-   added minimum versions for all dependencies (#16)

# hatchR 0.2.0

## Minor improvements and bug fixes

-   `model_select` and `predict_phenology` tweaks (#1)
-   fix `predict_phenology` `NaN` problem (#3)
-   fix Isaak data (#5)
-   function cleaning (#6)
-   adding unit tests (#7)

# hatchR 0.1.0

-   Initial package version.
