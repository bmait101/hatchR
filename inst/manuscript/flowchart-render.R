
# path <- here::here("manuscript", "flowchart.gv")
#
# DiagrammeR::grViz(g)

g <- "digraph {

      # a 'graph' statement
      graph [overlap = false, label = 'hatchR workflow', labelloc = t, fontsize = 30]

      # label nodes
      node [fontsize = 20]
      import [label = 'import data', shape = circle, fillcolor = Beige, style=filled]
      dates [label = 'check dates', shape = circle, fillcolor = Beige, style=filled]
      plot1 [label = 'plot_check_data()' shape = rectangle]
      format [label = 'is data as\ndaily average?', shape = circle, fillcolor = Beige, style=filled]
      plot2 [label = 'plot_check_data()' shape = rectangle]
      summarize [label = 'sumamrize_temp()',  shape = rectangle]
      continuous [label = 'check_continuous()', shape = rectangle]
      model [label = 'model type:\ncustom or included?', shape = circle, fillcolor = Beige, style=filled]
      select [label = 'model_select()', shape = rectangle]
      fit [label = 'fit_model()', shape = rectangle]
      phenology [label = 'predict_phenology()', shape = rectangle]
      plot3 [label = 'plot_phenology()', shape = rectangle]

      # edge definitions with the node IDs
      edge [fontsize = 20]
      import -> dates
      dates -> dates [label = 'not dttm\nuse lubridate']
      dates -> plot1 [label = 'is dttm']
      plot1 -> format
      format -> summarize [label = 'multiple measures\nw/in a day']
      format -> model [label = '  mean daily average']
      summarize -> continuous -> plot2 -> model
      model -> select [label = 'hatchR built-\nin model']
      model -> fit [label = ' user custom data']
      {select, fit} -> phenology
      phenology -> plot3

      }

"
DiagrammeR::grViz(g)

DiagrammeR::grViz(g) |>
  DiagrammeRsvg::export_svg() |>
  charToRaw() |>
  rsvg::rsvg()  |>
  png::writePNG("inst/manuscript/flowchart.png")
