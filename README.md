# CrowdtangleR

A R package to collect Facebook data with CrowdTangle API

## Installation
```
devtools::install_github("justinchuntingho/CrowdtangleR")
```
## Introduction
Currently there is one function to get data from a list:
```
get_list_post("123456", 
              "2020-06-23T00:00:00", 
              "2021-06-21 01:41:05", 
              token, 
              data_path = "data_folder")
```

And another function to read jsons and return a dataframe:
```
facebook_data <- bind_tweets("data_folder")
```

## Credit
Most codes are adapted from [AcademictwitteR](https://github.com/cjbarrie/academictwitteR)
