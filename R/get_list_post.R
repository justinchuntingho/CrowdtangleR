#' Get List Posts
#'
#' Get posts from CrowdTangle list. To use the function you need to first create the list in your CrowdTangle dashboard.
#'
#' @param listIds string, list id obtained from CrowdTangle dashboard
#' @param startDate string, the earliest date at which a post could be posted. Time zone is UTC. Format is “yyyy-mm-ddThh:mm:ss” or “yyyy-mm-dd” (defaults to time 00:00:00).
#' @param endDate string, the latest date at which a post could be posted. Time zone is UTC. Format is “yyyy-mm-ddThh:mm:ss” or “yyyy-mm-dd” (defaults to time 00:00:00).
#' @param token string, your CrowdTangle API access token
#' @param data_path string, path to store data json
#' @param searchTerm string, returns only posts that match this search term.
#' @param language string, ISO 639-1 locale code
#' @param count integer, the number of posts to return, the maximum is 100.
#'
#' @return a dataframe
#' @export
#'
#' @examples
#' \dontrun{
#' get_list_post("1234567",
#'               "2021-06-22T00:00:00",
#'               "2021-06-22T00:00:10",
#'               token)
#' }
get_list_post <- function(listIds,
                          startDate,
                          endDate,
                          token,
                          data_path = NULL,
                          searchTerm = NULL,
                          language = NULL,
                          count = 100)
{
  params <- list(
    "listIds" = listIds,
    "startDate" = startDate,
    "endDate" = endDate,
    "token" = token,
    "count" = 100,
    "sortBy" = "date"
  )
  endpoint_url <- "https://api.crowdtangle.com/posts"

  # Get first page
  if(!is.null(data_path)){
    create_data_dir(data_path)
  }
  df_all <- data.frame()
  page_num <- 0
  response <- make_query(endpoint_url, params, token)
  next_page <- response$result$pagination$nextPage
  df <- response$result$posts
  if(!is.null(data_path)){
    df_to_json(df, data_path)
  }
  df_all <- dplyr::bind_rows(df_all, df)
  page_num <- page_num + 1
  cat("Page: ", page_num, "\n")

  # Get next pages
  while(!is.null(next_page)){
    response <- make_query(next_page)
    next_page <- response$result$pagination$nextPage
    df <- response$result$posts
    if(!is.null(data_path)){
      df_to_json(df, data_path)
    }
    df_all <- dplyr::bind_rows(df_all, df)
    page_num <- page_num + 1
    cat("Page: ", page_num, "\n")
  }
  df_all
}

