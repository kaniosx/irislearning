ui <- fluidPage(
  titlePanel(
    span(
      tagList(
        icon('leaf'), 
        'Iris Learning'
      )
    )
  ),
  sidebarPanel(
    selectInput(
      'model_id',
      'Select algorithm',
      c(
        'K Nearest Neighbors' = 'k_nearest_neighbors',
        'Support Vector Machine' = 'support_vector_machine',
        'Kernel SVM' = 'kernel_svm',
        
        'Naive Bayes' = 'naive_bayes',
        'Decision Tree Classification' = 'decision_tree_classification',
        'Random Forest Classification' = 'random_forest_classification',
        'K Means Clustering' = 'k_means_clustering',
        'Hierarchical Clustering' = 'hierarchical_clustering',
        'Apriori' = 'apriori',
        'Eclat' = 'eclat',
        'Upper Confidence Bound' = 'upper_confidence_bound',
        'Thomson Sampling' = 'thomson_sampling'
      ),
      selected = 'linear_regression'
    ),
    actionButton('train_action', 'Train model')
  ),
  mainPanel(
    tabsetPanel(
      tabPanel(
        title = 'Accuracy',
        textOutput('accuracy')
      ),
      tabPanel(
        title = 'Confusion Matrix',
        tableOutput('confusion_matrix')  
      ),
      tabPanel(
        title = 'Form',
        fluidRow(
          column(
            6,
            sliderInput(
              'sepal_length',
              'Sepal length',
              min = 3,
              max = 9,
              value = 4.2,
              step = 0.1
            ),
            sliderInput(
              'sepal_width',
              'Sepal width',
              min = 1,
              max = 5,
              value = 2,
              step = 0.1
            ),
            sliderInput(
              'petal_length',
              'Petal length',
              min = 0.5,
              max = 8,
              value = 1,
              step = 0.1
            ),
            sliderInput(
              'petal_width',
              'Petal width',
              min = 0,
              max = 3,
              value = 0.1,
              step = 0.1
            ),
            actionButton('check_action', 'Check')
          ),
          column(
            6,
            textOutput('form_prediction')
          )
        )
      ),
      tabPanel(
        title = 'File',
        fileInput(
          'user_file',
          'Upload CSV',
          multiple = FALSE,
          accept = c(
            'text/csv',
            'text/comma-separated-values,text/plain',
            '.csv'
          )
        ),
        tableOutput('from_file_df'),
        actionButton('generate_answers_action', 'Generate answers'),
        downloadButton('download_template_action', 'Download template'),
        downloadButton('download_user_set_action', 'Download answers')
      )
    )
  )
)
