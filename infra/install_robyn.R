# install_robyn.R

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

Sys.setenv(DOWNLOAD_STATIC_LIBV8=1)

install.packages("remotes")
install.packages("reticulate")
install.packages("data.table")

# Create the conda environment before loading reticulate
system("/opt/conda/bin/conda create --yes --name r-reticulate python=3.10 --quiet -c conda-forge")

# Use the newly created conda environment
Sys.setenv(RETICULATE_PYTHON = "/opt/conda/envs/r-reticulate/bin/python")

remotes::install_github("facebookexperimental/Robyn/R")

library(reticulate)
Sys.setenv(RETICULATE_PYTHON = "/opt/conda/envs/r-reticulate/bin/python")

print(" ---------- PYTHON PATH IN RSESSION:")
print(Sys.which("python"))
print(reticulate::py_config())

reticulate::use_condaenv("r-reticulate")
reticulate::conda_install("r-reticulate", "nevergrad", pip=TRUE)
