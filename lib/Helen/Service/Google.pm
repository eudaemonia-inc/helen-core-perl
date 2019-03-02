# Copyright (C) 2019  Eudaemonia Inc
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


package Helen::Service::Google;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.4';

use Moose;
use namespace::autoclean;
use Helen::Service::Oauth;
use parent 'Helen::Service::Oauth';
use Carp::Assert;

use constant name => 'Google';

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({provider => name,
			uri => 'https://www.eudaemonia.org/helen/auth/',
			scope => 'https://www.googleapis.com/auth/spreadsheets.readonly',
			client_id => '946335429559-bvssbfifn8upug93fcmnfub6e1bvo552.apps.googleusercontent.com',
			map {$_ => shift } qw(subject subservice)});
};

sub authorize_helen {
  my($self, $code_sub) = @_;
  $self->subject->client_secret->{$self} = &$code_sub('Enter the client_secret for the Helen::Core web application:');
  $self->subject->client_secret->{$self->subservice} = $self->subject->client_secret->{$self};
  $self->SUPER::authorize_helen($code_sub, $self->subservice);
  return;
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;
