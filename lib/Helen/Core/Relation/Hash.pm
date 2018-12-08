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

package Helen::Core::Relation::Hash;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.0');
use Moose;
use Carp::Assert;
use parent 'Helen::Core::Relation';

has 'hash_ref' => (is => 'ro', isa => 'HashRef');

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(hash_ref arguments results)});
};

sub BUILD {
  my $self = shift;
  
  # assert(defined($class));
  # assert(defined($hash_ref));
  # assert(defined($arguments));
  # assert($#$arguments >= 0);

  if (!defined($self->results)) {
    my %results = ();
    @results{map { keys %$_ } values %{$self->hash_ref}} = ();
    map { delete $results{$_} } @{$self->arguments};
    $self->results([keys %results]);
  }
  my %extension = %{$self->hash_ref};
  $self->extension(\%extension);
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
