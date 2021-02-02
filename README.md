# [charlier](https://github.com/BigelowLab/charlier)

A small set of R tools to make working on `charlie` with worklows a little easier.

## Requirements

  + [R v4+](https://www.r-project.org/)
  
  + [futile.logger](https://CRAN.R-project.org/package=futile.logger)
  
  + [rlang](https://CRAN.R-project.org/package=rlang)
  
  + [dplyr](https://CRAN.R-project.org/package=dplyr)

  + [stringr](https://CRAN.R-project.org/package=stringr)
  
  + [yaml](https://CRAN.R-project.org/package=yaml)
  
  
## Features

+ Establish standard logging (to log file and console)

+ Audit currently installed R software

+ Interact with environment

+ Manage configuration lists

+ Version parsing

+ Sending emails

+ Tidy R data files (Rds)

+ File extensions

+ Miscellaneous goodies


## Installation

Within R...

```
# if you have credentials to github
devtools::install_github("BigelowLab/charlier") 

# or 

# if you have access to github /mnt/storage/data/edna/packages
devtools::install("/mnt/storage/data/edna/packages/charlier") 
```

## Introduction

### Logging

We recommend using the [futile.logger](https://CRAN.R-project.org/package=futile.logger) package.  We don't use it's full functionality, but it's interface is pretty simple and easy. Well, **except** for kicking it off.  We suggest that you log to the console and a log file at the same time - called a unixy term `tee`. Configuring the logger to `tee` can be a bit opaque to the casual scripter, so we have wrapped the details in a simplifying function.  Once you load the `futile.logger` package it's logging services are available to you, then just configure the `tee`, and, finally, start messaging.

```
library(futile.logger)
charlier::start_logger(filename = "~/my_log")
```

At the simplest usage, we have three levels of messaging available to us: informational, warning and error.  Messages can be crafted programmatically using the same string construction as used in the [sprintf](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/sprintf) function. The point is to use logging in a an automated script or workflow, so learning to build messages programmatically is worthwhile.

```
what <- list("coffee", 2, "you're gonna need a lot more")

flog.info("Good morning, have you had your %s?", what[[1]])
#INFO [2020-12-14 07:52:44] Good morning, have you had your coffee?

flog.warn("Oh, you might need %i cups of %s", what[[2]], what[[1]])
#WARN [2020-12-14 07:53:43] Oh, you might need 2 cups of coffee

flog.error("Uh, %s than %i cups of %s", what[[3]], what[[2]], what[[1]])
#ERROR [2020-12-14 07:53:57] Uh, you're gonna need a lot more than 2 cups of coffee
```


### Auditing installed R software

In addition to using repositories, containers, modules and the like to manage software versions, soemtimes it is nice to simple dump a snapshot of current software to a text file.  It is not a bad idea to do so for every workflow version you run - much as you might establish logging. 

```
charlier::audit(filename = "~/my_audit.txt")
```

Here's an snippet of the first dozen lines...

```
Audit date: 2020-12-14 08:04:49 EST 
System PID: 14355 
PBS_JOBID:  
Cores: 4 
R version: R version 4.0.3 (2020-10-10) 
libPaths():
     /home/btupper/R/x86_64-conda-linux-gnu-library/4.0 
     /mnt/modules/bin/dada2/1.18/lib/R/library 
installed.packages():
"Package","Version","LibPath"
"charlier","0.1","/home/btupper/R/x86_64-conda-linux-gnu-library/4.0"
"dplyr","1.0.2","/home/btupper/R/x86_64-conda-linux-gnu-library/4.0"
"generics","0.1.0","/home/btupper/R/x86_64-conda-linux-gnu-library/4.0"
  .
  .
  .
```


### Interact with the environment

Some information we need to get from the system environment. Currently we provide functions to retrieve the currently active PBS jobid (if any) and the number of cores which is set in the PBS environment.

If you have not invoked a PBS environment then there is no jobid and an epmty string is returned. If you prefer it be explicit you can provide the text to use when there is no PBS jobid.
```
charlier::get_pbs_jobid()
# [1] ""
charlier::get_pbs_jobid(no_pbs_text = "ooops, did you forget to queue up a session?")
#[1] "ooops, did you forget to queue up a session?"
```


If the `NCPUS` system environment variable has been set then we return that, but if not then we allow R to autodetect using the function [parallel::detectCores()](https://www.rdocumentation.org/packages/parallel/versions/3.6.2/topics/detectCores).

```
charlier::count_cores()
# [1] 4
```


### Manage configuration files

We use a simple and widely used configuration file format called [yaml](https://yaml.org/).  We rely on the [yaml](https://CRAN.R-project.org/package=yaml) R package for input and output.  Once you are within R, a configuration is just a list, possibly nested, where every element in named.  See the [wiki](https://github.com/BigelowLab/charlier/wiki/Configurations) for an example.


### Version parsing

If you are using segmented version patterns, like `v72.002.304` which is comprised of 'major.minor.release', you can parse or build version strings.

```
v <- "v72.002.304"

v_parts <- charlier::parse_version(v)
# major   minor release 
# "v72"   "002"   "304" 
 
v_again <- charlier::build_version(major = v_parts[1], minor = v_parts[2], release = v_parts[3])
# [1] "v72.002.304"
```

### Sending simple mail messages

`charlie` provides a simple wrapper around the [mail](https://linux.die.net/man/1/mail) application. You can easily send an email to one or more email addresses. Note that you can also configure your PBS session to also notify by email, but it provides no customization of messages or attachments.

```
charlier::sendmail(to = "henry@bigelow.org", 
                   subject = "thanks for the fishes",
                   message = c("these skate eggs are delicious",
                               sprintf("but the shells are so %s", "chewy")),
                   attachment = "~/breakfast.jpg")
```


### Tidy R data files (Rds)

[Serialized R data files](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/readRDS) can be handy when saving complex list-like structures.  Be aware that these do not provide version-agnostic access like simple text files, standard image files or scientific data formats (netcdf, hdf, ...) Backwards compatibility is not a sure thing.  But they can be handy sometimes.  We wrap `saveRDS` and `readRDS` in functions to permit their use in tidy workflows.

```
library(magrittr)
x <- list(a = "foo", b = sample(100, 10)) %>%
  charlier::write_RDS("~/my_list.rds")
  
y <- charlier::read_RDS("~/my_list.rds")

identical(x, y)
# [1] TRUE
``` 


### File extensions

We provide simple functionality to manage file extensions: retrieving them, stripping them and adding them.

```
filenames = c("BR2_2016_S216_L001_R2_001.fastq", "foobar.fastq.gz", "fuzzbaz", "oof.txt")

charlier::get_extension(filenames)
# [1] "fastq" "gz"    NA      "txt"  

charlier::get_extension(filenames, segments = 2)
# [1] NA         "fastq.gz" NA         NA 

charlier::strip_extension(filenames)

```

### Miscellany


### Set operations on multiple vectors

R provides set operations for working on pairs of vectors - see `?union`.  We provide an expansion of these to operate on multiple vectors bundled in a list.

```
x <- c(1, 5, 7, 9)
y <- c(3, 5, 8, 9, 11, 42)
z <- c(0, 5, 6, 9, 11)

charlier::munion(list(x,y,z))
# [1]  1  5  7  9  3  8 11 42  0  6 

charlier::mintersect(list(x,y,z))
# [1]  5  9
```

### String operations

R has some nice string matching functions (see `?grep`), and the [stringr](https://CRAN.R-project.org/package=stringr) package exposes a lot of nice uniform interface utilities for same end.

Sometimes you have a set of strings like names and you want to search for one or more patterns within that set without caring to know how the match exactly.  Use the `mgrepl` function (for "multiple grepl" - get it?) to generate a logica vector of match/no-match.  This is analogous to using the `%in%` operator, but you can deploy partial matching. Be sure to see the `?grepl` docs for details on other extra arguments.

```
x <- c("dog", "canine", "squirrel", "fish", "banana")
pattern <- c("nine", "ana")
charlier::mgrepl(pattern, x, fixed = TRUE)
# [1] FALSE  TRUE FALSE FALSE  TRUE
```
