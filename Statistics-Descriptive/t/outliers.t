#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;

use Statistics::Descriptive;

sub foo {return;};

local $SIG{__WARN__} = sub { };

{
    # testing set_outlier_filter
    my $stat = Statistics::Descriptive::Full->new();

    # TEST
    ok ( !defined($stat->set_outlier_filter()), 'set_outlier_filter: undef code reference value');
    # TEST
    ok ( !defined($stat->set_outlier_filter(1)), 'set_outlier_filter: invalid code ref value');

    # TEST
    is ( $stat->set_outlier_filter(\&foo), 1, 'set_outlier_filter: valid code reference - return value');
    # TEST
    is ( $stat->{_outlier_filter}, \&foo, 'set_outlier_filter: valid code reference - internal');

}

{
    # testing get_data_without_outliers without removing outliers
    my $stat = Statistics::Descriptive::Full->new();

    # TEST
    ok ( !defined($stat->get_data_without_outliers()), 'get_data_without_outliers: insufficient samples');

    $stat->add_data( 1, 2, 3, 4, 5 );
    # TEST
    ok ( !defined($stat->get_data_without_outliers()), 'get_data_without_outliers: undefined filter');

    # We force the filter function to never detect outliers...
    $stat->set_outlier_filter( sub {0} );

    no warnings 'redefine';
    local *Statistics::Descriptive::Full::_outlier_candidate_index = sub { 0 };
    my @results = $stat->get_data_without_outliers();

    #...we expect the data set to be unmodified
    # TEST
    is_deeply (
        [@results],
        [1, 2, 3, 4, 5],
        'get_data_without_outliers: no outliers',
    );

}

{
    # testing get_data_without_outliers removing outliers
    my $stat = Statistics::Descriptive::Full->new();

    # 100 is definitively the candidate to be an outlier in this series
    $stat->add_data( 1, 2, 3, 4, 100, 6, 7, 8 );

    # We force the filter function to always detect outliers for this data set
    $stat->set_outlier_filter( sub {$_[0] > 0} );
    my @results = $stat->get_data_without_outliers();

    # Note that 100 has been filtered out from the data set
    # TEST
    is_deeply (
        [@results],
        [1, 2, 3, 4, 6, 7, 8, ],
        'get_data_without_outliers: remove outliers',
    );

}

{
    # testing _outlier_candidate_index
    my $stat = Statistics::Descriptive::Full->new();

    # 100 is definitively the candidate to be an outlier in this series
    $stat->add_data( 1, 2, 3, 4, 100, 6, 7, 8 );

    # TEST
    is ($stat->_outlier_candidate_index, 4, '_outlier_candidate_index' );

}
