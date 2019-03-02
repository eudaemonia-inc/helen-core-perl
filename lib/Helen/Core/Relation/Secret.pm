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
our $VERSION = 'v0.0.4';

package Helen::Core::Relation::Secret;
use Helen::Core::Relation;
use parent 'Helen::Core::Relation';
use fields;

sub new {
  my($self, @args) = @_;

  $self = fields::new($self) unless ref $self;
  $self->SUPER::new(@args);
}

1;
