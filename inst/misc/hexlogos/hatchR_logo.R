library(hexSticker)

# current logo
sticker(here::here("inst/misc/hexlogos/hatchR_FINAL.tif"), package="hatchR", p_size=60, s_x=1, s_y=.75, s_width=.6,
        h_fill="white", h_color = "black", p_color = "black",
        filename=here::here("inst/misc/hexlogos/hatchR_logo.png"), dpi = 1000)


# FS colors
sticker("~/Downloads/hatchR_FINAL.tif", package="hatchR", p_size=20, s_x=1, s_y=.75, s_width=.6,
        h_fill="#01502f", h_color = "#ffd330", p_color = "#ffd330",
        filename="~/Downloads/hatchR_hexsticker.png")
