#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use Statistics::Descriptive::Smoother;

my @original_data       = qw/1 2 3 4 5 6 7 8 9 10/;
my @original_samples    = qw/3 3 3 3 3 3 3 3 3 3/;

{

    #Test no smoothing
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();

    # When the smoothing coefficient is 0 the series is not smoothed
    # TEST
    is_deeply( \@smoothed_data, \@original_data, 'No smoothing C=0');
}

{

    #Test max smoothing
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 1,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();

    # When the smoothing coefficient is 1 the series is universally equal to the initial unsmoothed value
    my @expected_values = map { $original_data[0] } 1 .. $smoother->{count};
    # TEST
    is_deeply( \@smoothed_data, \@expected_values, 'Max smoothing C=1');
}

{

    #Test smoothing coeff 0.5
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0.5,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();
    my @expected_values = qw/
          1
          1.5
          2.25
          3.125
          4.0625
          5.03125
          6.015625
          7.0078125
          8.00390625
          9.001953125
    /; 

    # TEST
    is_deeply( \@smoothed_data, \@expected_values, 'Smoothing with C=0.5');
}

1;
