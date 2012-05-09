#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;

use Statistics::Descriptive;

local $SIG{__WARN__} = sub { };

my @original_data = qw/1 2 3 4 5 6 7 8 9 10/;

{
    # testing set_smoother
    my $stats = Statistics::Descriptive::Full->new();

    $stats->add_data(\@original_data );

    $stats->set_smoother({
           method   => 'exponential',
           coeff    => 0,
    });
    # TEST
    isa_ok ( $stats->{_smoother}, 'Statistics::Descriptive::Smoother::Exponential', 'set_smoother: smoother set correctly');

}

{
    # testing get_smoothed_data
    my $stats = Statistics::Descriptive::Full->new();

    # TEST
    is ( $stats->get_smoothed_data(), undef, 'get_smoothed_data: smoother needs to be defined');

    $stats->add_data(\@original_data );

    $stats->set_smoother({
           method   => 'exponential',
           coeff    => 0.5,
    });

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

    my @smoothed_data = $stats->get_smoothed_data();

    # TEST
    is_deeply( \@smoothed_data, \@expected_values, 'Smoothing with C=0.5');
}
