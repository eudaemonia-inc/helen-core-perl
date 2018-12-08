# Copyright (C) 2018  Eudaemonia Inc
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
use version; our $VERSION = version->declare('v0.0.1');

package Helen::Core::Relation::Secret::Keyring;
use Moose;
use namespace::autoclean;
use Carp::Assert;
use Passwd::Keyring::Gnome;
use Sentinel;
use parent 'Helen::Core::Relation::Secret';

has 'agent' => (
		is => 'ro',
		isa => 'Helen::Core::Agent',
	      );

has 'keyring' => (
		  is => 'rw',
		  isa => 'Object',
		  handles => [qw(get_password set_password)],
		 );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig(agent => shift);
};

sub BUILD {
  my $self = shift;
  $self->keyring(new Passwd::Keyring::Gnome(group => 'Helen::Core'));
}

sub client_id {
  my($self, $service) = @_;
  return $self->keyring->get_password("client-id", $service->name);
}

sub client_secret {
  my($self, $service) = @_;
  return $self->keyring->get_password("client-secret", $service->name);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
