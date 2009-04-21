#!/usr/bin/perl

use strict;
use warnings;

# Should be 14.
use Test::More tests => 14;

use Benchmark;
use Statistics::Descriptive;

# print "1..14\n";

# test #1

my $stat = Statistics::Descriptive::Full->new();
my @results = $stat->least_squares_fit();
# TEST
ok (!scalar(@results), "Results on an non-filled object are empty.");

# test #2
# data are y = 2*x - 1

$stat->add_data( 1, 3, 5, 7 );
@results = $stat->least_squares_fit();
# TEST
is_deeply (
    [@results[0..1]],
    [-1, 2],
    "least_squares_fit returns the correct result."
);

# test #3
# test error condition on harmonic mean : one element zero
$stat = Statistics::Descriptive::Full->new();
$stat->add_data( 1.1, 2.9, 4.9, 0.0 );
my $single_result = $stat->harmonic_mean();
# TEST
ok (!defined($single_result),
    "harmonic_mean is undefined if there's a 0 datum."
);

# test #4
# test error condition on harmonic mean : sum of elements zero
$stat = Statistics::Descriptive::Full->new();
$stat->add_data( 1.0, -1.0 );
$single_result = $stat->harmonic_mean();
# TEST
ok (!defined($single_result),
    "harmonic_mean is undefined if the sum of the reciprocals is zero."
);

# test #5
# test error condition on harmonic mean : sum of elements near zero
$stat = Statistics::Descriptive::Full->new();
my $savetol = $Statistics::Descriptive::Tolerance;
$Statistics::Descriptive::Tolerance = 0.1;
$stat->add_data( 1.01, -1.0 );
$single_result = $stat->harmonic_mean();
# TEST
ok (! defined( $single_result ),
    "test error condition on harmonic mean : sum of elements near zero"
);

$Statistics::Descriptive::Tolerance = $savetol;

# test #6
# test normal function of harmonic mean
$stat = Statistics::Descriptive::Full->new();
$stat->add_data( 1,2,3 );
$single_result = $stat->harmonic_mean();
# TEST
ok (scalar(abs( $single_result - 1.6363 ) < 0.001),
    "test normal function of harmonic mean",
);

# test #7
# test stringification of hash keys in frequency distribution
$stat = Statistics::Descriptive::Full->new();
$stat->add_data(0.1,
                0.15,
                0.16,
               1/3);
my %f = $stat->frequency_distribution(2);

# TEST
ok ((($f{0.216666666666667} == 3) &&
      ($f{0.333333333333333} == 1)),
    "test stringification of hash keys in frequency distribution"
);

# test #8
##Test memorization of last frequency distribution
my %g = $stat->frequency_distribution();
# TEST
is_deeply(
    \%f,
    \%g,
    "memorization of last frequency distribution"
);

# test #9
# test the frequency distribution with specified bins
$stat = Statistics::Descriptive::Full->new();
my @freq_bins=(20,40,60,80,100);
$stat->add_data(23.92,
                32.30,
                15.27,
                39.89,
                8.96,
                40.71,
                16.20,
                34.61,
                27.98,
                74.40);
%f = $stat->frequency_distribution(\@freq_bins);

# TEST
ok (
    (($f{20} == 3) &&
      ($f{40} == 5) &&
      ($f{60} == 1) &&
      ($f{80} == 1) &&
      ($f{100} == 0)
    ),
    "test the frequency distribution with specified bins"
);

# test #10 and #11
# Test the percentile function and caching
$stat = Statistics::Descriptive::Full->new();
$stat->add_data(-5,-2,4,7,7,18);
##Check algorithm
# TEST
is ($stat->percentile(50),
    4,
    "percentile function and caching - 1",
);
# TEST
is ($stat->percentile(25),
    -2,
    "percentile function and caching - 2",
);

# tests #12 and #13
# Check correct parsing of method parameters
$stat = Statistics::Descriptive::Full->new();
$stat->add_data(1,2,3,4,5,6,7,8,9,10);
# TEST
is(
    $stat->trimmed_mean(0.1,0.1),
    $stat->trimmed_mean(0.1),
    "correct parsing of method parameters",
);

# TEST
is ($stat->trimmed_mean(0.1,0),
    6,
    "correct parsing of method parameters - 2",
);

# tests #14
# Make sure that trimmed_mean caching works but checking execution times
# This test may fail on very fast machines but I'm not sure how to get better
# timing without requiring extra modules to be added.

$stat = Statistics::Descriptive::Full->new();
##Make this a really big array so that it takes some time to execute!
$stat->add_data((1,2,3,4,5,6,7,8,9,10,11,12,13) x 10000);

my ($t0,$t1,$td);
my @t = ();
foreach (0..1) {
  $t0 = new Benchmark;
  $stat->trimmed_mean(0.1,0.1);
  $t1 = new Benchmark;
  $td = timediff($t1,$t0);
  push @t, $td->cpu_p();
}

# TEST
ok ($t[1] < $t[0],
    "trimmed_mean caching works",
);
