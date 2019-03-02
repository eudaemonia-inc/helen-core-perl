#!/usr/bin/perl

use strict;
use warnings;
use Test;
use Syntax::Keyword::Try;
use Data::Dumper;

BEGIN { plan tests => 1 }
use Data::Dumper;
use Helen::Core::Relation::Dump;
use Helen::Core::Relation::GoogleSheets::Sheet;
use Helen::Core::Agent;

try {
  my $identity = Helen::Core::Agent->new('hermit@quarkbuddha.com');
  my $thing = Helen::Core::Relation::GoogleSheets::Sheet->new($identity, 'Accounts', ['Name'], ['Kind']);
  my $dumpthing = Helen::Core::Relation::Dump->new('/tmp/dump');
  $thing->planck($dumpthing);
  
  ok(1);
} catch {
  print Dumper $@;
}

