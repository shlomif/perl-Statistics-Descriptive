#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) =
    (map { m{\$VERSION *= *'([^']+)'} ? ($1) : () }
    io->file('lib/Statistics/Descriptive.pm')->getlines()
    )
    ;

if (!defined ($version))
{
    die "Version is undefined!";
}

my $mini_repos_base = 'https://svn.berlios.de/svnroot/repos/web-cpan/Statistics-Descriptive';

my @cmd = (
    "hg", "tag", "-m",
    "Tagging the Statistics-Descriptive release as $version",
    "releases/$version",
);

print join(" ", @cmd), "\n";
exec(@cmd);

