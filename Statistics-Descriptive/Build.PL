use strict;
use warnings;

use lib "./inc";

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'Statistics::Descriptive',
    license             => 'perl',
    dist_author         => 'Shlomi Fish <shlomif@iglu.org.il>',
    dist_version_from   => 'lib/Statistics/Descriptive.pm',
    build_requires => {
        'Benchmark' => 0,
        'lib' => 0,
        'Test::More' => 0,
    },
    requires => {
        'Carp' => 0,
        'POSIX' => 0,
        'strict' => 0,
        'vars' => 0,
        'warnings' => 0,
    },
    add_to_cleanup      => [ 'Statistics-Descriptive-*' ],
    create_makefile_pl => 'traditional',
    PL_files => {},
    meta_merge =>
    {
        resources =>
        {
            repository => "http://svn.berlios.de/svnroot/repos/web-cpan/Statistics-Descriptive/",
            homepage => "http://web-cpan.berlios.de/modules/Statistics-Descriptive/",
        },
        keywords =>
        [
            qw(
                average
                distribution
                mean
                median
                statistics
                stats
                stddev
            ),
            "standard deviation"
        ],
    },
);

$builder->create_build_script();
