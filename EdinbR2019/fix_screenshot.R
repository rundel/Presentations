x1 = magick::image_read("imgs/github_mod1.png") %>% magick::image_border("gray", "1x1") %>% magick::image_border("white", "5x5")
x2 = magick::image_read("imgs/github_mod2.png") %>% magick::image_border("gray", "1x1") %>% magick::image_border("white", "5x5")
x3 = magick::image_read("imgs/github_mod3.png") %>% magick::image_border("gray", "1x1") %>% magick::image_border("white", "5x5")

x2_expand = magick::image_border(x2, color = "white", geometry = "0x483")

magick::image_join(x1,x3) %>%
  magick::image_append(stack = TRUE) %>%
  magick::image_join(x2_expand) %>%
  magick::image_append() %>%
  magick::image_write("imgs/github_mod.png")
