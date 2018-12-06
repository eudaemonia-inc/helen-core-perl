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

package Helen::Service::GoogleSheets;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.0');
use Moose;
use namespace::autoclean;
use Helen::Service::Oauth;
use parent 'Helen::Service::Json';

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  my $subject = Helen::Service::Oauth->new('Google', 'https://www.eudaemonia.org/helen/auth/',
					   'https://www.googleapis.com/auth/spreadsheets.readonly', shift);
  return $class->$orig(subject => $subject, uri => 'https://sheets.googleapis.com/v4');
};
  
sub BUILD {
  my $self = shift;
  $self->pagination(undef);
  return;
}

sub authorization {
  my $self = shift;
  return { Authorization => "Bearer ".$self->subject->bearer_token->{$self->subject} };
}

sub authorize_helen {
  my($self, $code_sub) = @_;
  $self->subject->authorize_helen($code_sub);
  return;
}

sub get {
  my($self, $name, $params) = @_;
  return $self->SUPER::get($self->subject, $name, $params);
}

sub name {
  return 'google-sheets';
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;
