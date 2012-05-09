package Statistics::Descriptive::Smoother::Exponential;
use strict;
use warnings;

use base 'Statistics::Descriptive::Smoother';
    
our $VERSION = '3.0500';
    
sub new {
    my ($class, $args) = @_;
        
    return bless $args || {}, $class;
}   

# The name of the variables used in the code refers to the explanation in the pod
sub get_smoothed_data {
    my ($self) = @_;

    my @smoothed_values;
    push @smoothed_values, @{$self->{data}}[0];
    my $C = $self->get_smoothing_coeff();

    foreach my $sample_idx (1 .. $self->{count} -1) {
        my $smoothed_value = $C * ($smoothed_values[-1]) + (1 - $C) * $self->{data}->[$sample_idx];
        push @smoothed_values, $smoothed_value;
    }
    return @smoothed_values;
}

1;

__END__

=head1 NAME

Statistics::Descriptive::Smoother::Exponential - Implement exponential smoothing

=head1 SYNOPSIS

  use Statistics::Descriptive::Smoother;
  my $smoother = Statistics::Descriptive::Smoother->instantiate({
           method   => 'exponential',
           coeff    => 0.5,
           data     => [1, 2, 3, 4, 5],
           samples  => [110, 120, 130, 140, 150],
    });
  my @smoothed_data = $smoother->get_smoothed_data();

=head1 DESCRIPTION

This module implement the exponential smoothing algorithm to smooth the trend of a series of statistical data.

This algorithm works well for unsmoothed data build with big number of samples. If this is not
the case you might consider using the C<Weighted Exponential> one.

The algorithm implements the following formula:

S(0) = X(0)

S(t) = C*S(t-1) + (1-C)*X(t)

where:

=over 3

=item * t = index in the series

=item * S(t) = smoothed series value at position t

=item * C = smoothing coefficient. Value in the [0;1] range. C<0> means that the series is not smoothed at all,
while C<1> the series is universally equal to the initial unsmoothed value.

=item * X(t) = unsmoothed series value at position t

=back

=head1 METHODS

=over 5

=item $stats->get_smoothed_data();

Returns a copy of the smoothed data array.

=back

=head1 AUTHOR

Fabio Ponciroli

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
