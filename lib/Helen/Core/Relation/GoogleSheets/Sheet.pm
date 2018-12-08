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
use version; our $VERSION = version->declare('v0.0.0');

package Helen::Core::Relation::GoogleSheets::Sheet;
use Moose;
use namespace::autoclean;
use Carp::Assert;
use Helen::Service::GoogleSheets;
use Helen::Core::Relation::REST::Json;
use parent 'Helen::Core::Relation::REST::Json';

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  my $subject = new Helen::Service::GoogleSheets(shift);
  my $name = 'spreadsheets/11FCFgLhT-0f82qlZrOI0PzKrZoVIsAZnWRLlGNiwBOQ/values/'.shift;
  #my $name = 'spreadsheets'; shift;
  return $class->$orig({ subject => $subject, name => $name, path => '$..*', map { $_ => shift } qw(arguments)});
};

sub BUILD {
  my $self = shift;
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;