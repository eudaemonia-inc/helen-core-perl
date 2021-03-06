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
use version 0.77;
our $VERSION = 'v0.0.5';

package Helen::Core::Symbol::REST::Json;
use Carp::Assert;
use JSON::API;
use parent 'Helen::Core::Symbol::REST';
use fields qw(uri token api name);

sub new {
  my($class, $uri, $token, $name) = @_;
  assert(defined($class));
  assert(defined($uri));
  assert(defined($token));
  assert(defined($name));
  my $api = new JSON::API($uri);
  
  my $result = $api->get("$name", undef, { Authorization => "Bearer $token" });

  my($self) = fields::new($class);
  $self->SUPER::new();
  $self->{uri} = $uri;
  $self->{api} = $api;
  $self->{token} = $token;
  $self->{name} = $name;

  return $self;
}

1;
