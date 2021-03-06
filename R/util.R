#' Get the maximum hit 
#'
#' The resulting data.frame will be complete, with every (qseqid, staxid) pair represented
#'
#' @param d A dataframe with the columns 'qseqid', 'staxid', and 'score'. Other
#'        columns may be present, if so, they are left unchanged.
#' @export
get_max_hit <- function(d){
  .validate_table(d, "get_max_hit", c('qseqid', 'staxid', 'score'))
  d %>%
    dplyr::group_by(.data$qseqid, .data$staxid) %>%
    dplyr::filter(.data$score == max(.data$score)) %>%
    # the filter step can lead to multiple hits with equal score, I want just
    # one, so have to pass through distinct
    dplyr::ungroup() %>%
    dplyr::distinct(.data$qseqid, .data$staxid, .keep_all=TRUE)
}

.validate_table <- function(d, function_name, required_columns){
  in_names <- required_columns %in% names(d)
  if(!all(in_names)){
    msg <- "'%s': input table is missing required columns: %s\nColumns: %s"
    msg <- sprintf(msg,
      function_name,
      paste(required_columns[!in_names], collapse=", "),
      paste(names(d), collapse=", ")
    )
    stop(msg)
  }
}

maybe_message <- function(msg, verbose=TRUE, ...){
  if(verbose)
    message(sprintf(msg, ...))
}

.check_type <- function(
  m,
  type,
  test   = function(x) { setequal(class(x), type) },
  nframe = sys.nframe()-1,
  place  = if(nframe > 0) { deparse(sys.calls()[[nframe]]) } else { 'global' }
){
  if(!test(m)){
    varname <- deparse(substitute(m)) # NOTE: this has to be outside of glue
    stop(glue::glue(
      "In 'phylostratr::{place}', expected '{name}' to be of class {exp_type} but got '{obs_type}'",
      obs_type = class(m),
      name     = varname,
      place    = place,
      exp_type = type
    ))
  }
}

# An internal utility function that transforms a named list into a list of
# 3-element lists holding a name, value, and position.
tuplify <- function(x){
  lapply(seq_along(x), function(i){
    list(name=names(x)[i], value=x[[i]], position=i)
  })
}

# Undo the tuplify function, returning a named list
untuplify <- function(xs){
  tuple_names <- sapply(xs, function(x) x$name)
  xs <- lapply(xs, function(x) x$value)
  names(xs) <- tuple_names
  xs
}

# This example of the torturous tree munging in ape is borrowed from:
# http://blog.phytools.org/2012/11/adding-single-tip-to-tree.html
bind.tip <- function(tree, tip.label, edge.length=NULL, where=NULL){
  if(is.null(where)) where <- length(tree$tip) + 1
  tip <- list(
    edge        = matrix(c(2,1),1,2),
    tip.label   = tip.label,
    edge.length = edge.length,
    Nnode       = 1
  )
  class(tip) <- "phylo"
  obj <- ape::bind.tree(tree, tip, where = where)
  return(obj)
}

# Access a cached value, if missing, perform FUN on ... 
access_cache <- function(cache, FUN, ...){
  if(file.exists(cache)){
    d <- readRDS(cache)
  } else {
    d <- FUN(...) 
    saveRDS(d, cache)
  }
  d
}
