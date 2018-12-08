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
use Class::Load ':all';
use Helen::Core::Agent;

if (@ARGV != 2) {
  die "usage: $0 email-address service-name\n";
}

my $email_address = shift;
my $service_name = shift;

die "illegal service name $service_name\n" unless $service_name =~ /^[A-Za-z0-9_]+$/;
die "can't load service $service_name\n" unless load_class("Helen::Service::$service_name");

my $identity = Helen::Core::Agent->new($email_address);
my $service = eval "Helen::Service::$service_name->new(\$identity);";
$service->authorize_helen(sub {
			   my($url) = shift;
			   print "URL: $url\n";
			   print "Please go to the above url (or otherwise follow instructions) and enter the returned code: ";
			   my $code = <>;
			   chomp $code;
			   return $code;
			 });
