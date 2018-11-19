# TFX(TensorFlow Extended): A TensorFlow-Based Production-Scale Machine Learning Platform

Platfor design and anatomy:

* one machine learning platform for many learning tasks
* continuous training
* easy-to-use configuration and tools
* production-level reliability and scalability

This paper focuses on components below:

* data analysis
* data transformation
* data validation
* trainer
* model evaluation and validation
* serving

## Data analysis, transformation and validation

### Data analysis

For data analysis, the component processes each dataset fed to the system and generates a set of descriptive statistics on the included features.

### Data tronsformation

Our component implements a suite of data transformations to allow feature wrangling for model training and serving.

### Data validation

After completing the analysis of the data, the component deals with the task of validation:  is the data healthy or are there anomalies that need to be flagged to the user?

## Model training

