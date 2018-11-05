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

our $org = new Org::Parser;

sub new {
  my($class, $file_name, $table_name, $key_name) = @_;
  assert(defined($class));
  assert(defined($file_name));
  assert(defined($table_name));
  assert(defined($key_name));

  my $doc = $org->parse_file($file_name);

  my(@arguments, %extension);
  my %argument_positions;

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
      if (!@arguments) {
	@arguments = @tuple;
	map { $argument_positions{$arguments[$_]} = $_ } (0..$#arguments);
	assert(defined($argument_positions{$key_name}));
	next;
      }
      @{$extension{@tuple[$argument_positions{$key_name}]}} = @tuple[0..$#arguments];
    }
  }
  my $self = bless {
		    arguments => \@arguments,
		    primary_key => $key_name,
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
