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

package Helen::Core::Relation::REST::Json;
use strict;
use warnings;
use Moose;
use namespace::autoclean;
use Carp::Assert;
use JSON::API;
use JSON::Path;
use parent 'Helen::Core::Relation::REST';

has 'name' => (is => 'ro', isa => 'Str');
has 'path' => (is => 'ro', isa => 'Str');

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({map {$_ => shift } qw(subject name path arguments)});
};

sub BUILD {
  my $self = shift;
  
  # assert(defined($class));
  # assert(defined($service));
  # assert(defined($name));
  # assert(defined($path));

  my $jpath = JSON::Path->new($self->path);
  
  my $result = $self->subject->get($self->name);
  my(%results, %extension);
  
  foreach my $item ($jpath->values($result)) {
    $extension{join("/", map { $item->{$_} } @{$self->arguments})} = $item;
    @results{keys %{$item}} = ();
  }
	 
  map { delete $results{$_} } @{$self->arguments};

  $self->results([ keys %results ]);
  $self->extension(\%extension);
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
