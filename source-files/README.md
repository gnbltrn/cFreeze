
<!-- README.md is generated from README.Rmd. Please edit that file -->

## cFreeze <img src="logo.png" align="right" width="100" height="100" />

<!-- badges: start -->
<!-- badges: end -->

## Introduction

The purpose of cFreeze is to help corn seed growers understand the
potential risk of freeze damage at harvest time. cFreeze calculates the
percent occurrence of temperatures below zero degrees Celsius for any
day of the year, given the GPS coordinates for a location of interest
and the last 30-year historical weather data extracted from Iowa
Environmental Mesonet (IEM) closest to that location. cFreeze also
calculates the last day to harvest given certain levels of freeze risk
after the summer months in the northern hemisphere (NH).

## Data

All weather data used by this package is extracted directly from IEM
using the apsimx package. cFreeze uses the minimum temperature (mint)
reported by IEM. No data is stored or kept by the cFreeze package.

To learn more about IEM, follow this link:
<https://mesonet.agron.iastate.edu/>

## Requirements

The following package needs to be installed and loaded for cFreeze to be
able to extract weather data directly from IEM.

``` r
install.packages("apsimx") #if not installed already
library(apsimx)
```

## Instalation

cFreeze can be installed directly from its GitHub public repository
using the devtools package:

``` r

install.packages("devtools")  #if not installed already
devtools::install.github("gnbltrn/cFreeze/cFreeze")

#Load cFreeze
library(cFreeze)
```

## Basic Demonstration of Funtionality

Once cFreeze is installed and loaded, you can use any of its 5 functions
independently:

``` r

#Returns the last day to harvest (after June, NH) with no historical risk of freezing.
nofreeze(-118.607994, 41.659626)
[1] "Sep-17"
```

For detailed information on each of the 5 cFreeze functions, consult the
Reference section of the Freeze website, or follow this link:

<https://gnbltrn.github.io/cFreeze_Package/reference/index.html>

For additional examples on how to use cFreeze, please check the article
“Using cFreeze Package” in the Articles section of Freeze website, or
follow this link:

<https://gnbltrn.github.io/cFreeze_Package/articles/using-package.html>
