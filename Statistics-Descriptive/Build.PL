use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Statistics::Descriptive',
    license             => 'perl',
    dist_author         => 'Shlomi Fish <shlomif@iglu.org.il>',
    dist_version_from   => 'lib/Statistics/Descriptive.pm',
    build_requires => {
        'Benchmark' => 0,
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
);

$builder->create_build_script();
