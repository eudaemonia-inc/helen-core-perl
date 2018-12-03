#!/usr/bin/env perl
# Copyright (C) 2018  Eudaemonia Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use Helen::Core::Agent;
use Helen::Service::GoogleSheets;

my $identity = Helen::Core::Agent->new('hermit@acm.org');
my $sheets = Helen::Service::GoogleSheets->new($identity);
$sheets->authorize_helen(sub {
			   my($url) = shift;
			   print "URL: $url\n";
			   print "Please go to the above url and enter the returned code: ";
			   my $code = <>;
			   chomp $code;
			   return $code;
			 });
