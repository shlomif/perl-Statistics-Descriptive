package Utils;

use strict;
use warnings;

require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/is_between compare_hash_by_ranges is_array_between/;

use Test::More;

sub is_between {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($have, $want_bottom, $want_top, $blurb) = @_;

    ok (
        (($have >= $want_bottom) &&
        ($want_top >= $have)),
        $blurb
    );
}

sub is_array_between {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($got_array_ref, $expected_array_ref, $low_tolerance, $high_tolerance, $blurb) = @_;

    my $i = 0;
    foreach my $got_val (@$got_array_ref) {
        is_between ($got_val,
                    $expected_array_ref->[$i] - $low_tolerance,
                    $expected_array_ref->[$i] + $high_tolerance,
                    "$blurb - ".$expected_array_ref->[$i]
        );
        $i++;
    }
}

sub compare_hash_by_ranges
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $got_hash_ref = shift;
    my $expected = shift;
    my $blurb = shift;

    my $got =
        [
            map { [$_, $got_hash_ref->{$_} ] }
            sort { $a <=> $b }
            keys(%$got_hash_ref)
        ]
        ;

    my $success = 1;

    if (scalar(@$expected) != scalar(@$got))
    {
        $success = 0;
        diag("Number of keys differ in hashes.");
    }
    else
    {
        COMPARE_KEYS:
        for my $idx (0 .. $#$got)
        {
            my ($got_key, $got_val) = @{$got->[$idx]};
            my ($expected_bottom, $expected_top, $expected_val)
                = @{$expected->[$idx]};

            if (! (    ($got_key >= $expected_bottom)
                    && ($got_key <= $expected_top)
                    && ($got_val == $expected_val)
                )
            )
            {
                $success = 0;
                diag(<<"EOF");
Key/Val pair No. $idx is out of range or wrong:
Got: [$got_key, $got_val]
Expected: [$expected_bottom, $expected_top, $expected_val]
EOF

                last COMPARE_KEYS;
            }
        }
    }

    ok($success, $blurb);
}

1;

=pod

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> , C<shlomif@cpan.org>

=head1 COPYRIGHT

Copyright(c) 2012 by Shlomi Fish.

=head1 LICENSE

This file is licensed under the MIT/X11 License:
http://www.opensource.org/licenses/mit-license.php.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut
