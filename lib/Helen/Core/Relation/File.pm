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

use Devel::Confess;

package Helen::Core::Relation::File;
use Carp::Assert;

sub new {
  my($class, $file_name, $arguments, $results) = @_;
  assert(defined($class));
  assert(defined($file_name));
  assert(defined($arguments));
  assert(defined($results));
  chomp
  my(@fields) = split /\|/;
  my %extension{@{$arguments}, @{$results}} = @fields;
1;
