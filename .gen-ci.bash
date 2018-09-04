#! /bin/bash
#
# .gen-ci.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#

set -e
set -x
ci-generate --theme dzil --param 'subdirs=Statistics-Descriptive/'
