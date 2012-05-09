#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 4;

use Statistics::Descriptive::Smoother;

local $SIG{__WARN__} = sub { };

my @original_data    = qw/1 2 3 4 5 6 7 8 9 10/;
my @original_samples = qw/100 50 100 50 100 50 100 50 100 50/;

{

    #Test no smoothing
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'weightedExponential',
           coeff    => 0,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();

    # When the smoothing coefficient is 0 the series is not smoothed
    #TEST
    is_deeply( \@smoothed_data, \@original_data, 'No smoothing C=0');
}

{

    #Test max smoothing
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'weightedExponential',
           coeff    => 1,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();

    # When the smoothing coefficient is 1 the series is universally equal to the initial unsmoothed value
    my @expected_values = map { $original_data[0] } 1 .. $smoother->{count};
    #TEST
    is_deeply( \@smoothed_data, \@expected_values, 'Max smoothing C=1');
}

{

    #Test smoothing coeff 0.5
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'weightedExponential',
           coeff    => 0.5,
           data     => \@original_data,
           samples  => \@original_samples,
    });

    my @smoothed_data = $smoother->get_smoothed_data();
    my @expected_values = qw/
                    1
                    1.33333333333333
                    2.24242424242424
                    2.85944551901999
                    4.0651836704636
                    4.75526654493058
                    6.03174342835728
                    6.7367839208657
                    8.02706266125788
                    8.73457937329917
    /; 

    #TEST
    is_deeply( \@smoothed_data, \@expected_values, 'Smoothing with C=0.5');
}

{

    #Test different number of samples and data are not allowed
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'weightedExponential',
           coeff    => 0,
           data     => [1,2,3,4],
           samples  => [1,2,3],
    });

    #TEST
    is ( $smoother, undef, 'Different number of samples and data');
}


1;
