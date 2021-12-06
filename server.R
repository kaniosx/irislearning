server <- function(input, output) {
  observeEvent(input$train_action, {
    split <- sample.split(iris$Species, SplitRatio = 0.8)
    training_set <- subset(iris, split == TRUE)
    test_set <- subset(iris, split == FALSE)
    
    if (input$model_id == 'k_nearest_neighbors') {
      y_pred <- k_nearest_neighbors(training_set, test_set[, -5])
    }
    
    if (input$model_id == 'support_vector_machine') {
      y_pred <- support_vector_machine(training_set, test_set[, -5])
    }
    
    if (input$model_id == 'kernel_svm') {
      y_pred <- kernel_svm(training_set, test_set[, -5])
    }
    
    output$accuracy <- renderText({
      paste('Accuracy of the model is', count_accuracy(test_set, y_pred), '%')
    })
    
    output$confusion_matrix <- renderTable({
      table(test_set[, 5], y_pred)
    })
  })
  
  observeEvent(input$check_action, {
    test_set <- data.frame(
      input$sepal_length,
      input$sepal_width,
      input$petal_length,
      input$petal_width
    )
    colnames(test_set) <- c(
      'Sepal.Length',
      'Sepal.Width',
      'Petal.Length',
      'Petal.Width'
    )
    
    if (input$model_id == 'k_nearest_neighbors') {
      prediction <- k_nearest_neighbors(iris, test_set)
    }
    
    if (input$model_id == 'support_vector_machine') {
      prediction <- support_vector_machine(iris, test_set)
    }
    
    if (input$model_id == 'kernel_svm') {
      prediction <- kernel_svm(iris, test_set)
    }
    
    output$form_prediction <- renderText({
      as.character(prediction)
    })
  })
  
  observeEvent(input$generate_answers_action, {
    user_set <- read.csv(input$user_file$datapath, sep = ';')
    
    for (i in 1:4) {
      user_set[, i] <- as.numeric(gsub(',', '.', user_set[ , i]))
    }
    
    if (input$model_id == 'k_nearest_neighbors') {
      user_set$Species <- k_nearest_neighbors(iris, user_set)
    }
    
    if (input$model_id == 'support_vector_machine') {
      user_set$Species <- support_vector_machine(iris, user_set)
    }
    
    if (input$model_id == 'kernel_svm') {
      user_set$Species <- kernel_svm(iris, user_set)
    }
    
    output$from_file_df <- renderTable({ user_set })
    
    output$download_user_set_action <- downloadHandler(
      filename = function() {
        paste0('user_data_', Sys.Date(), '.csv')
      },
      content = function(file) {
        if (exists('user_set')) {
          write.csv2(user_set, file)
        }
      }
    )
  })
  
  output$download_template_action <- downloadHandler(
    filename = 'template.csv',
    content = function(file) {
      write.csv2(
        head(iris)[, -5],
        file,
        row.names = FALSE
      )
    }
  )
}

k_nearest_neighbors <- function(training_set, test_set) {
  knn(
    train = training_set[, -5],
    test = test_set,
    cl = training_set[, 5],
    k = 5
  )
}

support_vector_machine <- function(training_set, test_set) {
  classifier <- svm(
    formula = Species ~ .,
    data = training_set,
    type = 'C-classification',
    kernel = 'linear'
  )
  
  predict(classifier, test_set)
}

kernel_svm <- function(training_set, test_set) {
  classifier <- svm(
    formula = Species ~ .,
    data = training_set,
    type = 'C-classification',
    kernel = 'radial'
  )
  
  predict(classifier, test_set)
}

count_accuracy <- function(test_set, prediction) {
  100 * sum(test_set[, 5] == prediction) / nrow(test_set)
}
