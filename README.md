# Unitar resources demo

Unitar allows you to load targets from external projects. This is useful for sharing targets across projects. One specific use case is if you have some general-purpose data resources that you use frequently in many projects. Using unitar, you can create a single "resources" project, and then use those resources repeatedly. This repository provides a demo for this kind of resources project

## Unitar target factor for csv targets

In addition to its target sharing functions, `unitar` also provides a target factor that makes it easy to populate a targets project by specifying target parameters in a `csv` file.

In this project, the list of resource targets are defined in the included [targets_list.csv](targets_list.csv). In [_targets.R](_targets.R), we use `unitar::build_pep_resource_targets` to convert this csv into targets.

## How to use this project as a typical targets project

This resource repository can then be used as a normal `targets` project:

```{r}
library("targets")

tar_make()
tar_meta()

tar_load("file1")
file1
```

## How to use this project as a resource project

Like any normal targets project, this project can also now be used as an external targets project using `unitar`:

```{r}
library("unitar")
options(tar_dirs=c("/home/nsheff/code/unitar_resources_demo"))

unitar_meta()
unitar_load("file1")
file1

```

Now, you can use these just as any of the modes defined in the unitar documentation. One common mode would be to use these resources to create derived resources or analysis in your more specialized targets project, and you want to track the resources so you can update things if they change, but you don't want to duplicate the caches into your local folder because they're large. Todo that, you'd do something like:

```{r}
# _targets.R
library("unitar")
options(tar_dirs=c("/home/nsheff/code/unitar_resources_demo"))


local_filter_big_reference_data = function(big_data_set_path) {
  big_data_set = unitar_read_from_path(big_data_set_path)
  big_data_set[big_data_set > 2]
}

list(
  tar_target(
    big_data_set_path,
    unitar_path("file1"),
    format = "file"
  ),
  tar_target(
    filtered_data_set,
    local_filter_big_reference_data(big_data_set_path)
  )
)
```


## How to create your own targets

The targets list is a [PEP](http://pep.databio.org). Each target is a row in `targets_list.csv`. The columns are:

- `sample_name`: target name
- `type`: Specify `file` if the target is a file load, or `call` if it's a function call
- `function`: this is the function to call (or to read the file, for file targets)
- `description`: ignored by the software, just for your information
- `local_path`: For targets of type `file`, specify the path to the file

For targets of type `call`, you may specify parameters to the function in the `target_params.csv` file. In this table, each row is a function parameter. You must specify 3 columns:

- `sample_name`: target name, which must match the value in the `targets_list.csv` file.
- `arg`: argument name, as assigned by your function signature
- `val`: value to pass for that argument.
