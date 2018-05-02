# NOTE!!!

Please install this using CPAN or similar. See
http://perl-begin.org/topics/cpan/ and our
[MetaCPAN page](https://metacpan.org/release/Statistics-Descriptive) .

The GitHub repository uses [dzil](http://dzil.org/) and is not directly
installable.

# ABOUT

Statistics::Descriptive - Module of basic descriptive statistical functions.

```
use Statistics::Descriptive;
my $stat = Statistics::Descriptive::Full->new();
$stat->add_data(1,2,3,4);
my $mean = $stat->mean();
my $var = $stat->variance();
my $tm = $stat->trimmed_mean(.25);
$Statistics::Descriptive::Tolerance = 1e-10;
```

This module provides basic functions used in descriptive statistics.
It has an object oriented design and supports two different types of
data storage and calculation objects: sparse and full. With the sparse
method, none of the data is stored and only a few statistical measures
are available. Using the full method, the entire data set is retained
and additional functions are available.
