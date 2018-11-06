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
use Org::Parser;
use TryCatch;

package Helen::Core::Relation::OrgTable;
use Carp::Assert qw(:DEBUG);
use Data::Dumper;
use Devel::Confess;

our $org = new Org::Parser;

sub new {
  my($class, $file_name, $table_name, $arguments) = @_;
  assert(defined($class));
  assert(defined($file_name));
  assert(defined($table_name));
  assert($arguments);

  my $doc = $org->parse_file($file_name);

  my($results, %extension);
  my %positions;

  foreach my $table ($doc->find('Org::Element::Table')) {
    next unless $_ = $table->parent;
    next unless $_ = $_->title();
    next unless $_ = $_->text();
    next unless $_ eq $table_name;
    foreach my $row (@{$table->rows()}) {
      $row = $row->as_string;
      chomp $row;
      my @tuple = split /\|/, $row;
      shift @tuple;
      if (!$results) {
	assert($#$arguments == 0);
	assert($arguments->[0] eq (shift @tuple));
	$results = [ @tuple ];
	map { assert(defined($_)); $positions{$arguments->[$_]} = $_ } (0..$#$arguments);
	map { $positions{$results->[$#$arguments + $_]} = $#$arguments + $_ + 1} (0..$#$results);
	next;
      }
      my @tmp = map {
      	$tuple[$positions{(@$arguments, @$results)[$_]}]
      } (0..$#tuple);
      foreach my $index (0..$#tmp) {
	$extension{$tuple[$positions{$arguments->[0]}]}{(@$arguments, @$results)[$index]} = $tmp[$index];
      }
    }
  }
  my $self = bless {
		    arguments => $arguments,
		    results => $results,
		    extension => \%extension
		   }, $class;
  return $self;
}

sub planck {
  my($self, $target) = @_;
  assert(defined($self));
  assert(defined($target));
  $target->receive($self);
}


1;
