#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 9;

use Statistics::Descriptive;

{
    # testing set_filter
    my $stat = Statistics::Descriptive::Full->new();

    ok ( !defined($stat->set_filter()), 'set_filter: undef code reference value');
    ok ( !defined($stat->set_filter(1)), 'set_filter: invalid code ref value');

    sub foo {};
    ok ( $stat->set_filter(\&foo) == 1, 'set_filter: valid code reference - return value');
    ok ( $stat->{_outlier_filter} == \&foo, 'set_filter: valid code reference - internal');

}

{
    # testing get_data_without_outliers without removing outliers
    my $stat = Statistics::Descriptive::Full->new();

    ok ( !defined($stat->get_data_without_outliers()), 'get_data_without_outliers: insufficient samples');

    $stat->add_data( 1, 2, 3, 4, 5 );
    ok ( !defined($stat->get_data_without_outliers()), 'get_data_without_outliers: undefined filter');

    # We force the filter function to never detect outliers...
    sub bar {0};
    $stat->set_filter(\&bar);

    no warnings 'redefine';
    local *Statistics::Descriptive::Full::_outlier_candidate_index = sub { 0 };
    my @results = $stat->get_data_without_outliers();

    #...we expect the data set to be unmodified
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
    sub baz { $_[0] > 0 };
    $stat->set_filter(\&baz);
    my @results = $stat->get_data_without_outliers();

    # Note that 100 has been filtered out from the data set
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

    ok ($stat->_outlier_candidate_index == 4, '_outlier_candidate_index' );

}
