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

package Helen::Service::Json;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.1pre');
use Moose;
use namespace::autoclean;
use JSON::API;
use parent 'Helen::Service';

has 'uri' => (
	      is => 'ro',
	      isa => 'Str',
	     );

has 'api' => (
	      is => 'rw',
	      isa => 'Object',
	     );

has 'pagination' => (
		    is => 'rw',
		    isa => 'Maybe[HashRef]',
		   );

has 'subject' => (
		  is => 'rw',
		  isa => 'Object',
		 );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig(@_);
};

sub BUILD {
  my $self = shift;

  $self->api(JSON::API->new($self->uri));
  return;
}

sub get {
  my($self, $subject, $name, $params) = @_;
  my %params;
  %params = %{$params} if defined $params;
  if (defined($self->pagination)) {
    foreach my $param (keys %{$self->pagination}) {
      $params{$param} = $self->pagination->{$param};
    }
  }
  
  my $result = $self->{api}->get($name, $self->pagination, $self->authorization);
  return $result;
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;
