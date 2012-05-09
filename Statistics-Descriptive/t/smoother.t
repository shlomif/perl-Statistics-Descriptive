#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 11;

use Statistics::Descriptive::Smoother;
use Test::Exception;

local $SIG{__WARN__} = sub { };

{

    #Test factory pattern
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0,
           data     => [1,2,3],
           samples  => [100, 100, 100],
    });

    # TEST
    isa_ok ($smoother, 'Statistics::Descriptive::Smoother::Exponential', 'Exponential class correctly created');
}

{

    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'weightedExponential',
           coeff    => 0,
           data     => [1,2,3],
           samples  => [100, 100, 100],
    });

    # TEST
    isa_ok ($smoother, 'Statistics::Descriptive::Smoother::Weightedexponential', 'Weightedexponential class correctly created');
    
}

{

    # Test invalid smoothing method
    # TEST
    dies_ok (sub {
                Statistics::Descriptive::Smoother->instantiate({
                        method   => 'invalid_method',
                        coeff    => 0,
                        data     => [1,2,3],
                        samples  => [100, 100, 100],
            });}, 
            'Invalid method');
    
}

{

    #TODO get output from Carp
    #Test invalid coefficient
    my $smoother_neg = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => -123,
           data     => [1,2,3],
           samples  => [100, 100, 100],
        });

    # TEST
    is ($smoother_neg, undef, 'Invalid coefficient: < 0');

    my $smoother_pos = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 123,
           data     => [1,2,3],
           samples  => [100, 100, 100],
        });

    # TEST
    is ($smoother_pos, undef, 'Invalid coefficient: > 1');
 
}

{

    #Test unsufficient number of samples
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0,
           data     => [1],
           samples  => [100],
        });

    # TEST
    is ($smoother, undef, 'Insufficient number of samples');

}

{

    #Test smoothing coefficient accessors
    my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0.5,
           data     => [1,2,3],
           samples  => [100, 100, 100],
        });

    # TEST
    is ($smoother->get_smoothing_coeff(), 0.5, 'get_smoothing_coeff');

    my $ok = $smoother->set_smoothing_coeff(0.7);

    # TEST
    ok ($ok, 'set_smoothing_coeff: set went fine');

    # TEST
    is ($smoother->get_smoothing_coeff(), 0.7, 'set_smoothing_coeff: correct value set');

    my $ok2 = $smoother->set_smoothing_coeff(123);

    # TEST
    is ($ok2, undef, 'set_smoothing_coeff: set failed');

    # TEST
    is ($smoother->get_smoothing_coeff(), 0.7, 'set_smoothing_coeff: value not modified after failure');

}

1;
