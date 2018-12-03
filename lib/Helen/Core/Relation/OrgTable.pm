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
use Moose;
use namespace::autoclean;

use Carp::Assert qw(:DEBUG);
use parent 'Helen::Core::Relation';

our $org = new Org::Parser;

has 'file_name' => (
		    is => 'ro',
		    isa => 'Str',
		   );

has 'table_name' => (
		     is => 'ro',
		     isa => 'Str',
		    );


around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({map { $_ => shift } qw(file_name table_name arguments)});
};

sub BUILD {
  my $self = shift;
  
  # assert(defined($class));
  # assert(defined($file_name));
  # assert(defined($table_name));
  # assert($arguments);

  my $doc = $org->parse_file($self->file_name);
  
  $self->extension({});
  my %positions;
  
  foreach my $table ($doc->find('Org::Element::Table')) {
    next unless $_ = $table->parent;
    next unless $_ = $_->title();
    next unless $_ = $_->text();
    next unless $_ eq $self->table_name;
    foreach my $row (@{$table->rows()}) {
      $row = $row->as_string;
      chomp $row;
      my @tuple = split /\|/, $row;
      shift @tuple;
      if (!$self->results) {
	assert($#{$self->arguments} == 0);
	assert($self->arguments->[0] eq (shift @tuple));
	$self->results([ @tuple ]);
	map { assert(defined($_)); $positions{$self->arguments->[$_]} = $_ } (0..$#{$self->arguments});
	map { $positions{$self->results->[$#{$self->arguments} + $_]} = $#{$self->arguments} + $_ + 1} (0..$#{$self->results});
	next;
      }
      my @tmp = map {
      	$tuple[$positions{(@{$self->arguments}, @{$self->results})[$_]}]
      } (0..$#tuple);
      foreach my $index (0..$#tmp) {
	$self->extension->{$tuple[$positions{$self->arguments->[0]}]}{(@{$self->arguments}, @{$self->results})[$index]} = $tmp[$index];
      }
    }
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
