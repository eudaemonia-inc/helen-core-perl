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

package Helen::Core::Relation::REST::Json;
use Carp::Assert;
use Data::Dumper;
use Devel::Confess;
use JSON::API;
use JSON::Path;
use parent 'Helen::Core::Relation::REST';
use fields qw(service name);

sub new {
  my($class, $subject, $service, $name, $path, $arguments) = @_;
  assert(defined($class));
  assert(defined($subject));
  assert(defined($service));
  assert(defined($name));
  assert(defined($path));
  my $jpath = new JSON::Path($path);
  
  my $result = $service->get($subject, $name);
  my(%results, %extension);
  
  foreach my $item ($jpath->values($result)) {
    $extension{join("/", map { $item->{$_} } @{$arguments})} = $item;
    @results{keys %{$item}} = ();
  }
	 
  map { delete $results{$_} } @{$arguments};

  my($self) = fields::new($class);
  $self->SUPER::new($subject, $arguments, [ keys %results ], \%extension);
  $self->{service} = $service;
  $self->{name} = $name;

  return $self;
}
1;
