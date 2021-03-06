# Copyright (C) 2018, 2019  Eudaemonia Inc
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

package Helen::Service::GoogleSheets;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.5';

use Moose;
use namespace::autoclean;
use Helen::Service::Google;
use parent 'Helen::Service::Json';
use Carp::Assert;

use constant name => 'GoogleSheets';

has 'subject' => (is => 'rw', isa => 'Object', handles => [qw(bearer_token client_secret)]);

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig(subject => shift,
		       uri => 'https://sheets.googleapis.com/v4');
};
  
sub BUILD {
  my $self = shift;
  $self->subject(Helen::Service::Google->new($self->subject, $self));
  return;
}

sub authorization_headers {
  my $self = shift;
  assert($self);
  assert($self->subject);
  return { Authorization => "Bearer ".$self->subject->bearer_token->{$self} };
}

sub authorize_helen {
  my($self, $code_sub) = @_;
  assert($self);
  assert($self->subject);
  $self->subject->authorize_helen($code_sub);
  return;
}

sub get {
  my($self, $name, $params) = @_;
  return $self->SUPER::get($self->subject, $name, $params);
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;
