
generate_some_data = function(n, mean) {
  rnorm(n, mean)
}

my_read_function = function(file) {
  read.csv(file, header=FALSE)
}