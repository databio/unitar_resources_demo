# _targets.R
library("targets")
library("unitar")

source("functions.R")

loadable_targets = unitar::build_pep_resource_targets("config.yaml")
loadable_targets
