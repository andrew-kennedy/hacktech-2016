library(httr)
library(rjson)
app_only_auth = function() {
  # Returns the values that need to be sent in a GET
  # using application-only authentication.
  
  # bearer_token = "AAAAAAAAAAAAAAAAAAAAAJZ7twAAAAAAV15vMv5coEo%2BjofHaFYMU3jLguk%3Dc2aoNRtYAytXZ5EVBMzww2lBgTOhPx8tKjftqBVEdMbMEiB1dC"
  # GET_headers = c(sprintf("Authorization: Bearer %s", bearer_token))
  
  return add_headers(Authorization="bearer AAAAAAAAAAAAAAAAAAAAAJZ7twAAAAAAV15vMv5coEo%2BjofHaFYMU3jLguk%3Dc2aoNRtYAytXZ5EVBMzww2lBgTOhPx8tKjftqBVEdMbMEiB1dC");
}

search_rate_limit = function() {
  # Returns the number of Search calls remaining in the current
  # window, and the time left in the current window.
  
  GET_headers = app_only_auth()
  
  base_url = "https://api.twitter.com/1.1/application/rate_limit_status.json"
  full_url = URLencode(sprintf("%s?resources=search", base_url))
  
  rate_limit_results = GET(url=full_url,GET_headers);
  
  results_content = content(rate_limit_results)$resources$search$"/search/tweets"
  remaining = results_content$remaining
  time_reset = results_content$reset
  time_left = time_reset - as.numeric(Sys.time())
  print(remaining)
  return(list(remaining=remaining, reset=time_left))
}

remove_emoji = function(text_str) {
  # Function to take a character string and replace emoji with "U".
  # Won't work on a vector of character strings.
  #
  # Emoji end up as bytes in the form
  # 0xED 0xnn 0xnn 0xED 0xnn 0xnn
  
  byte_vec = charToRaw(text_str)
  ED_bytes = which(byte_vec == 0xED)
  num_ED = length(ED_bytes)
  
  if (num_ED > 0) {
    bytes_to_remove = numeric()
    replacement_bytes = numeric()
    
    for (i in 1:num_ED) {
      # We'll be altering some bytes as we go, so re-check that we're at 0xED
      if ((byte_vec[ED_bytes[i]] == 0xED) & (byte_vec[ED_bytes[i]+3] == 0xED)) {
        replacement_bytes = c(replacement_bytes, ED_bytes[i])
        bytes_to_remove = c(bytes_to_remove, (ED_bytes[i]+1):(ED_bytes[i]+5))
        # Replace the second 0xED so that we don't then think it's the
        # first 0xED in a pair next time through the loop:
        byte_vec[ED_bytes[i]+3] = as.raw(0x00)
      }
    }
    
    byte_vec[replacement_bytes] = as.raw(0x55)
    byte_vec = byte_vec[-bytes_to_remove]
    
    new_str = rawToChar(byte_vec)
    Encoding(new_str) = "UTF-8"
    return(new_str)
  } else {
    return(text_str)
  }
}

wanted_tweet_data = function(tweet_results) {
  # Function to extract the data I want from the Twitter search.
  # Input is the result of the GET to the search API.
  search_content = content(tweet_results)
  tweets = search_content$statuses
  
  timestamp = sapply(tweets, function(x) x$created_at)
  timestamp = gsub(" \\+[^ ]*", "", timestamp)
  timestamp = as.POSIXct(timestamp, format="%a %b %d %H:%M:%S %Y", tz="GMT")
  
  rt_id = sapply(tweets, function(x) x$retweeted_status$id_str)
  rt_id = sapply(rt_id, function(x) ifelse(is.null(x), "0", x))
  
  username = sapply(tweets, function(x) x$user$screen_name)
  id = sapply(tweets, function(x) x$id_str)
  status = sapply(tweets, function(x) x$text)
  status = unname(sapply(status, remove_emoji))
  
  html_entity_codes = c("&amp;", "&gt;", "&lt;")
  html_entity_chars = c("&", ">", "<")
  
  length_entities = length(html_entity_codes)
  if (length(html_entity_chars) != length_entities) {
    print("Don't have matching HTML entities and characters.")
    stop()
  }
  
  for (i in 1:length_entities) {
    status = gsub(html_entity_codes[i], html_entity_chars[i], status)
  }
  
  iso_lang_code = sapply(tweets, function(x) x$metadata$iso_language_code)
  
  tw_source = sapply(tweets, function(x) x$source)
  tw_source = gsub("<a href[^>]*>", "", tw_source)
  tw_source = gsub("</a>", "", tw_source)
  
  in_reply_to_status_id = sapply(tweets, function(x) x$in_reply_to_status_id_str)
  in_reply_to_status_id = sapply(in_reply_to_status_id, function(x) ifelse(is.null(x), "0", x))
  
  in_reply_to_username = sapply(tweets, function(x) x$in_reply_to_screen_name)
  in_reply_to_username = sapply(in_reply_to_username, function(x) ifelse(is.null(x), "", x))
  
  user_followers = sapply(tweets, function(x) x$user$followers_count)
  user_listed = sapply(tweets, function(x) x$user$listed_count)
  
  user_created_at = sapply(tweets, function(x) x$user$created_at)
  user_created_at = gsub(" \\+[^ ]*", "", user_created_at)
  user_created_at = as.POSIXct(user_created_at, format="%a %b %d %H:%M:%S %Y", tz="GMT")
  
  user_statuses_count = sapply(tweets, function(x) x$user$statuses_count)
  user_lang = sapply(tweets, function(x) x$user$lang)
  
  rt_count = sapply(tweets, function(x) x$rewteet_count)
  rt_count = sapply(rt_count, function(x) ifelse(is.null(x), 0, x))
  
  fav_count = sapply(tweets, function(x) x$favorite_count)
  fav_count = sapply(fav_count, function(x) ifelse(is.null(x), 0, x))
  
  lang = sapply(tweets, function(x) x$lang)
  lang = sapply(lang, function(x) ifelse(is.null(x), 0, x))
  
  # The coordinates field is a funny thing - it's either NULL or
  # a structured list.  When you naively try to replace the NULL's
  # like is done for the other fields above, you get weird behaviour.
  # The workaround is to create a list of the right size and fields
  # with the default values set, and then copy across the non-NULL's
  # into it.
  
  coords_temp = sapply(tweets, function(x) x$coordinates)
  coords = rep(list(structure(list(type="Point", coordinates=c(-999,-999)))), length(coords_temp))
  got_coords = which(!sapply(coords_temp, is.null))
  coords[got_coords] = coords_temp[got_coords]
  
  latitude = sapply(coords, function(x) x$coordinates[2])
  longitude = sapply(coords, function(x) x$coordinates[1])
  
  # I think you can only have one media_url, but you can definitely have
  # multiple link_url's, so keep them as lists:
  media_url = lapply(tweets, function(x) sapply(x$entities$media, function(y) y$expanded_url))
  media_tco = lapply(tweets, function(x) sapply(x$entities$media, function(y) y$url))
  link_url = lapply(tweets, function(x) sapply(x$entities$urls, function(y) y$expanded_url))
  link_tco = lapply(tweets, function(x) sapply(x$entities$urls, function(y) y$url))
  
  
  results.df = data.frame(timestamp,
                          tw_source,
                          id,
                          rt_id,
                          username,
                          in_reply_to_username,
                          in_reply_to_status_id,
                          user_followers,
                          user_listed,
                          user_created_at,
                          user_statuses_count,
                          status,
                          I(media_tco),
                          I(media_url),
                          I(link_tco),
                          I(link_url),
                          rt_count,
                          fav_count,
                          iso_lang_code,
                          user_lang,
                          lang,
                          latitude,
                          longitude,
                          stringsAsFactors=F)
  return(results.df)
}

decrement_id = function(id_str) {
  # Reduces an id by 1.
  id_str = as.character(id_str)
  num_chars = nchar(id_str)
  last_digits = substr(id_str, num_chars-1, num_chars)
  
  # The tweet ID is too long for R's integer format, so mess
  # around with strings to decrease min_id by 1:
  if (last_digits == "00") {
    last_nonzero = regexpr("0(?=0*$)", id_str, perl=T)[1] - 1
    next_id = gsub("0(?=0*$)", "9", id_str, perl=T)
    next_id = sprintf("%s%s%s",
                      substr(next_id, 1, last_nonzero-1),
                      as.character(as.numeric(substr(next_id, last_nonzero, last_nonzero)) - 1),
                      substr(next_id, last_nonzero+1, num_chars))
  } else {
    new_digits = sprintf("%02d", as.numeric(last_digits) - 1)
    next_id = sprintf("%s%s",
                      substr(id_str, 1, num_chars-2),
                      new_digits)
  }
  
  return(next_id)
}

tweet_search = function(search_terms, result_type="recent", geocode="", max_id="", lang="", n=100, return_df=TRUE) {
  # Function to perform Twitter searches and return either a data
  # frame of results or the JSON data.
  
  # First check that we won't get rate-limited.
  ratelimit = search_rate_limit()
  if (ratelimit$remaining < (n/100 + 1)) {
    print("May hit rate limit.")
    print(sprintf("Try again in %1.0f seconds.", ratelimit$reset))
    return(F)
  } else {
    GET_headers = app_only_auth()
    
    base_url = "https://api.twitter.com/1.1/search/tweets.json?"
    search_str = sprintf("q=%s", search_terms)
    
    if (lang != "") {
      search_str = sprintf("%s&lang=%s", search_str, lang)
    }
    
    if (result_type != "") {
      search_str = sprintf("%s&result_type=%s", search_str, result_type)
    }
    
    if (geocode != "") {
      search_str = sprintf("%s&geocode=%s", search_str, geocode)
    }
    
    nmax = min(n, 100)
    count_str = sprintf("&count=%d", nmax)
    
    max_id = as.character(max_id)
    if (max_id != "") {
      max_id_str = sprintf("&max_id=%s", max_id)
    } else {
      max_id_str = ""
    }
    
    full_url = URLencode(sprintf("%s%s%s%s",
                                 base_url,
                                 search_str,
                                 max_id_str,
                                 count_str))
    
    search_results = GET(url=full_url,
                         config=GET_headers)
    
    
    if (return_df) {
      tweets.df = wanted_tweet_data(search_results)
      
      total_results = length(tweets.df$id)
      print(sprintf("Found %d tweets", total_results))
    } else {
      total_results = n
    }
    
    if (total_results == 0) {
      # Skip the next loop if there are no search results.
      total_results = n
    }
    
    while (total_results < n) {
      # We only want tweets up to and not including the earliest
      # tweet so far returned.  So we find the id of the earliest
      # tweet and set max_id to its value minus 1.
      min_id = tweets.df$id[total_results]
      max_id = decrement_id(min_id)
      max_id_str = sprintf("&max_id=%s", max_id)
      
      nmax = min(100, n - total_results)
      count_str = sprintf("&count=%d", nmax)
      
      full_url = URLencode(sprintf("%s%s%s%s",
                                   base_url,
                                   search_str,
                                   count_str,
                                   max_id_str))
      
      search_results = GET(url=full_url,
                           config=add_headers(GET_headers))
      
      newtweets.df = wanted_tweet_data(search_results)
      num_results = length(newtweets.df$id)
      
      if (num_results == 0) {
        # Originally had this as: if (num_results < nmax)
        # But for some reason sometimes the GET returns
        # 99 or 98 results instead of 100.
        total_results = n
        print("End of results.")
      } else {
        total_results = total_results + num_results
        print(sprintf("Found %d tweets", total_results))
      }
      
      tweets.df = rbind(tweets.df, newtweets.df)
    }
    
    if (return_df) {
      return(tweets.df)
    } else {
      return(content(search_results))
    }
  }
}

