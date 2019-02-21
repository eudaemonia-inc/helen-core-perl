# Copyright (C) 2018, 2019  Eudaemonia Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) anylater version
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.3';

package Helen::Core::Relation::Secret::Keyring;
use Moose;
use namespace::autoclean;
use Carp::Assert;
use Passwd::Keyring::Gnome;
use parent 'Helen::Core::Relation::Secret';

has 'keyring' => (
		  is => 'rw',
		  isa => 'Object',
		  lazy => 1,
		  default => sub {
		    return Passwd::Keyring::Gnome->new(group => 'Helen::Core');
		  },
		  handles => [qw(get_password set_password)],
		 );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig();
};

sub has_secret {
  my($name) = @_;
  has($name, is => 'rw', traits => ['Hash'], lazy => 1,
      default => sub {
	my $self = shift;
	my %hash;
	tie %hash, 'Helen::Core::Relation::Secret::Keyring::Tie::Hash', $self->keyring, $name;
	return \%hash;
      });
}

has_secret 'client_secret';

sub AUTOLOAD {
  my($self, $service) = @_;
  assert(defined($service));
  my $hash = $self->{hashes}->{$service->name};
  if (defined($hash)) {
    return $hash;
  } else {
    return $self->{hashes}->{$service->name} = {};
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
