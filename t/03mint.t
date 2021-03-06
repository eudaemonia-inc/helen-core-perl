#!/usr/bin/perl

use strict;
use warnings;
use Test;

BEGIN { plan tests => 1 }
use Data::Dumper;

use Helen::Core::Relation::Dump;
use Helen::Core::Relation::Mint;
use Helen::Core::Agent;

my $identity = Helen::Core::Agent->new('hermit@mint.com');
my $thing = Helen::Core::Relation::Mint->new($identity, 'Accounts', ['Name'], ['Kind']);
my $dumpthing = Helen::Core::Relation::Dump->new('/tmp/dump');
$thing->planck($dumpthing);

ok(1);
