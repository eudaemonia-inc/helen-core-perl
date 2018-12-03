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

package Helen::Core::Relation::Directory;
use Carp::Assert;
use parent 'Helen::Core::Relation';
use fields qw(path);

sub new {
  my($class, $path) = @_;
  assert(defined($class));
  assert(defined($path));
  
  my %extension;
  my($self) = fields::new($class);
  $self->SUPER::new(undef, ['name'], [], \%extension);
  $self->{path} = $path;
  opendir(DIR, $path) && do {
    my(@children) = (readdir DIR);
    foreach my $child (@children) {
      $extension{$child} = { name => $child };
    }
    closedir DIR;
  };
  return $self;
}
1;
