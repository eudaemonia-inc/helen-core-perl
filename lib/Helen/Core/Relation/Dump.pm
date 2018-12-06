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

package Helen::Core::Relation::Dump;
use Carp::Assert;
use Data::Dumper;
use parent 'Helen::Core::Relation';
use fields qw(file_name);

sub new {
  my($class, $file_name) = @_;
  assert(defined($class));
  assert(defined($file_name));
  my($self) = fields::new($class);
  $self->SUPER::new();
  $self->{file_name} = $file_name;
  return $self;
}

sub receive {
  my($self, $other) = @_;

  open(my $FILE, '>', $self->{file_name}) || die;
  print $FILE Dumper($other);
  close($FILE);
}
1;
