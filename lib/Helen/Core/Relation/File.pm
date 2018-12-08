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

package Helen::Core::Relation::File;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.1pre');
use Moose;
use Carp::Assert;
use Data::Dumper;
use parent 'Helen::Core::Relation';

has 'file_name' => (is => 'ro', isa => 'Str');

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(file_name arguments results)});
};

sub BUILD {
  my $self = shift;

  # assert(defined($class));
  # assert(defined($file_name));
  # assert(defined($arguments));
  # assert(defined($results));
  # assert($#$arguments >= 0);
  # assert($#$results >= 0);
  my %extension;
  my %positions;
  
  map { $positions{$self->arguments->[$_]} = $_ } (0..$#{$self->arguments});
  map { $positions{$self->results->[$_]} = $#{$self->arguments} + $_ + 1} (0..$#{$self->results});
  
  if (open(my $FILE, '<', $self->file_name)) {
    while (<$FILE>) {
      chomp;
      my(@fields) = split /\|/;
      my %line;
      @line{@{$self->arguments}, @{$self->results}} = @fields;
      $extension{join("/", @fields[0..$#{$self->arguments}])} = \%line;
    }
    close($FILE);
  }

  $self->extension(\%extension);
}

sub receive {
  my($self, $other) = @_;

  open(my $FILE, '>', $self->file_name) || die;
  foreach my $item (values %{$other->{extension}}) {
    print $FILE join("|", map { defined($item->{$_}) ? $item->{$_} : '' } (@{$self->arguments}, @{$self->results})), "\n";
  }
  close($FILE);
}
  
no Moose;
__PACKAGE__->meta->make_immutable;
1;
