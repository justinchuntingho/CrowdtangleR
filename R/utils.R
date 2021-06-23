make_query <- function(url, params, token, max_error = 4, verbose = TRUE) {
  count <- 0
  while (TRUE) {
    if (count >= max_error) {
      stop("Too many errors.")
    }
    r <- httr::GET(url, query = params)
    status_code <- httr::status_code(r)
    if (!status_code %in% c(200, 429, 503)) {
      stop(paste("something went wrong. Status code:", httr::status_code(r)))
    }
    if (status_code == 200) {
      break()
    }
    if (status_code == 503) {
      count <- count + 1
      Sys.sleep(count * 5)
    }
    if (status_code == 429) {
      .vcat(verbose, "Rate limit reached, sleeping... \n")
      count <- count + 1
      Sys.sleep(60)
    }
  }
  jsonlite::fromJSON(httr::content(r, "text"), flatten = TRUE)
}

df_to_json <- function(df, data_path){
  # check input
  # if data path is supplied and file name given, generate data.frame object within loop and JSONs
  jsonlite::write_json(df,
                       file.path(data_path, paste0("data_", df$id[nrow(df)], ".json")))
}

create_data_dir <- function(data_path, verbose = TRUE){
  #create folders for storage
  if (dir.exists(file.path(data_path))) {
    .vwarn(verbose, "Directory already exists. Existing JSON files may be parsed and returned, choose a new path if this is not intended.")
    invisible(data_path)
  }
  dir.create(file.path(data_path), showWarnings = FALSE)
  invisible(data_path)
}

.vcat <- function(bool, ...) {
  if (bool) {
    cat(...)
  }
}

.vwarn <- function(bool, ...) {
  if (bool) {
    warning(..., call. = FALSE)
  }
}
