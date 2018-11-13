library(shiny)
library(dplyr)
library(tibble)
library(ggplot2)

shinyApp(
  ui = fluidPage(
    
    titlePanel("Beta-Binomial"),
    
    sidebarLayout(
      sidebarPanel(
        HTML('<b style="font-size:110%;padding-right:2em">Prior:</b> p ~ Beta(a,b)'),
        numericInput("prior_a","a:", min = 0.0, value = 1),
        numericInput("prior_b","b:", min = 0.0, value = 1),
        br(),
        HTML('<b style="font-size:110%;padding-right:2em">Model:</b> y ~ Binom(n,p)'),
        sliderInput("like_y", "y:", min=0, max=100, value = 31),
        sliderInput("like_n", "n:", min=1, max=100, value = 43),
        br(),
        HTML('<b style="font-size:110%;padding-right:2em">Credible Interval:</b>'),
        sliderInput("ci_width","Width:", value=0.95, min = 0, max = 1, step = 0.01)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Bayes' Theorem", plotOutput("dist_plot")),
          tabPanel("Posterior CI", plotOutput("ci_plot"))
        )
      )
    )
  ),
  
  server = function(input, output, session) {
    
    observeEvent(input$like_n, updateSliderInput(session, "like_y", max = input$like_n))
    
    df = reactive({
      data_frame(
        p = seq(0, 1, length.out = 1000)
      ) %>% mutate(
        prior = dbeta(p, input$prior_a, input$prior_b),
        likelihood = dbinom(input$like_y, input$like_n, p),
        posterior = dbeta(p, input$prior_a + input$like_y, input$prior_b + input$like_n - input$like_y)
      ) %>%
        tidyr::gather(label, density, -p) %>%
        mutate(label = forcats::as_factor(label))
    })
    
    output$dist_plot = renderPlot({
      ggplot(df(), aes(x=p, y=density, color=label, fill=label)) + 
        geom_line() +
        geom_area(alpha=0.2) + 
        theme_bw() + 
        labs(y="") +
        facet_grid(label~., scale="free_y") +
        guides(fill=FALSE, color=FALSE)
    })
    
    output$ci_plot = renderPlot({
      
      alpha = input$prior_a + input$like_y
      beta = input$prior_b + input$like_n - input$like_y 
      
      d_post = df() %>%
        filter(label == "posterior") %>%
        filter(density > 0.001)
      
      ci = data_frame(
        quantile = abs( (1-input$ci_width)/2 + c(0,-1) )
      ) %>%
        mutate(p = qbeta(quantile, alpha, beta)) %>%
        mutate(density = 0)
      
      y_scale = max(d_post$density)
      x_scale = max(d_post$p)
      
      d_post %>%
        ggplot(aes(x=p, y=density)) + 
        geom_line(color="#619CFF") +
        geom_area(
          data = filter(d_post, p >= min(ci$p), p <= max(ci$p)),
          fill = "#619CFF",alpha=0.2) + 
        geom_point(data=ci) +
        geom_line(data=ci) +
        geom_label(
          data = ci,
          aes(label = round(p,3)),
          size = 5,
          hjust = "center",
          vjust = "top",
          nudge_y = -y_scale/75,
        ) +
        theme_bw() + 
        ylim(-y_scale/30, y_scale) +
        labs(y="") 
    })
  }
)
