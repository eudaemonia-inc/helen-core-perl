#!/usr/bin/perl

use strict;
use warnings;
use Test;

BEGIN { plan tests => 1 }
use Data::Dumper;

use Helen::Core::Relation::Dump;
use Helen::Core::Relation::Smartsheet;
use Helen::Core::Agent;

my $identity = Helen::Core::Agent->new('mbuda@cisco.com');
my $thing = Helen::Core::Relation::Smartsheet->new($identity, 'NGFW Component Leads', ['Component Name']);
my $dumpthing = Helen::Core::Relation::Dump->new('/dev/null');
$thing->planck($dumpthing);

ok(1);
