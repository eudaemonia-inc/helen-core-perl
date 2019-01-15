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
use version; our $VERSION = version->declare('v0.0.1');

package Helen::Core::Relation::Secret::Keyring::Tie::Hash;
require Tie::Hash;
use parent -norequire, 'Tie::StdHash';

sub TIEHASH {
  my $self = shift;
  my($keyring, $what) = @_;
  my $thing = bless { keyring => $keyring, what => $what }, $self;
  return $thing;
}

sub STORE {
  my($self, $key, $value) = @_;
  $self->{keyring}->set_password($self->{what}, $value, $key->name);
}

sub FETCH {
  my($self, $key) = @_;
  if (ref $key) {
    return $self->{keyring}->get_password($key->name, $self->{what}) // '';
  } else {
    return $self->{$key};
  }
}

1;
