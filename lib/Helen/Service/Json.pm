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
use version; our $VERSION = version->declare('v0.0.1');
use Moose;
use namespace::autoclean;
use JSON::API;
use Data::Dumper;
use parent 'Helen::Service';

has 'uri' => (
	      is => 'ro',
	      isa => 'Str',
	     );

has 'api' => (
	      is => 'rw',
	      isa => 'Object',
	     );

has 'authorization_headers' => (is => 'ro', isa => 'Maybe[HashRef]');

has 'authorization_params' => (is => 'ro', isa => 'Maybe[HashRef]');

has 'name' => (is => 'ro', isa => 'Str');

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
  my $accumulated_result;
  my $result;
  my $count = 0;
  do {
    my %params;
    %params = %{$params} if defined $params;
    
    foreach my $param (keys %{$self->pagination_params($count)}) {
      $params{$param} = $self->pagination_params($count)->{$param};
    }
    if (defined($self->authorization_params)) {
      foreach my $param (keys %{$self->authorization_params}) {
	$params{$param} = $self->authorization_params->{$param};
      }
    }
  
    $result = $self->{api}->get($name, \%params, $self->authorization_headers);
    # ~~~ error handling
    die $self->{api}->errstr unless $self->{api}->was_success;
    $accumulated_result = $self->combine_results($accumulated_result, $result);
    $count++;
  } while ($self->more_results($result));
  
  return $accumulated_result;
}

sub combine_results {
  my($self, $accum, $result) = @_;
  return $result;
}

sub more_results {
  my($self, $result) = @_;
  return undef;
}

sub pagination_params {
  return {};
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
