# Copyright (C) 2019  Eudaemonia Inc
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


package Helen::Exception::Runtime;
use strict;
use warnings;
use version 0.77; our $VERSION = version->declare('v0.0.4');
use Moose;
use namespace::autoclean;
use Carp::Assert;

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({map {$_ => shift } qw()});
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
