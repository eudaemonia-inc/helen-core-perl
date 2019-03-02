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


package Helen::Core::Relation::Directory;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.4';

use Moose;
use namespace::autoclean;
use Carp::Assert;
use parent 'Helen::Core::Relation';

has 'path' => ( is => 'ro', isa => 'Str' );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(path)});
};

sub BUILD {
  my $self = shift;
  # assert(defined($class));
  # assert(defined($path));
  
  my %extension;
  opendir(DIR, $self->path) && do {
    my(@children) = (readdir DIR);
    foreach my $child (@children) {
      $extension{$child} = { name => $child };
    }
    closedir DIR;
  };
  $self->arguments(['name']);
  $self->results([]);
  $self->extension(\%extension);
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
