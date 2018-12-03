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

package Helen::Service::Smartsheet;
use strict;
use warnings;
use Moose;
use namespace::autoclean;
use JSON::API;
use Helen::Service::Oauth;
use parent 'Helen::Service::Json';

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig(subject => shift, uri => 'https://api.smartsheet.com/2.0');
};

sub BUILD {
  my $self = shift;
  $self->pagination({ includeAll => 'true' });
  return;
}

sub authorization {
  my($self) = @_;
  return { Authorization => "Bearer ".$self->subject->bearer_token->{$self->subject}};
}

sub authorize_helen {
  my($self, $code_sub) = @_;
  $self->subject->bearer_token->{$self->subject} = &$code_sub('just get it from the smartsheet web site');
  return;
}

sub get {
  my($self, $name, $params) = @_;
  return $self->SUPER::get($self->subject, $name, $params);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
