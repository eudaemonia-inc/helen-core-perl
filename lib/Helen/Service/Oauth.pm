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

package Helen::Service::Oauth;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.0');
use Moose;
use namespace::autoclean;
use Carp::Assert;
use LWP::Authen::OAuth2;
use JSON;

has 'provider' => (is => 'ro', isa => 'Str');
has 'uri' => (is => 'ro', isa => 'Str');
has 'scope' => (is => 'ro', isa => 'Str');
has 'subject' => (is => 'ro', isa => 'Object', handles => [qw(bearer_token)]);
has 'oauth2' => (is => 'rw', isa => 'Object');



around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(provider uri scope subject)});
};

sub BUILD {
  my $self = shift;

  $self->oauth2(LWP::Authen::OAuth2->new(
					 client_id => $self->subject->client_id($self),
					 client_secret => $self->subject->client_secret($self),
					 service_provider => $self->provider,
					 redirect_uri => $self->uri,
					 save_tokens => \&save_tokens,
					 save_tokens_args => [$self]
					));
  return;
}

sub save_tokens {
  my($tokens, $self) = @_;
  $tokens = decode_json $tokens;
  $self->subject->bearer_token->{$self} = $tokens->{access_token};
  return;
}

sub authorize_helen {
  my $self = shift;
  my $code_sub = shift;
  my $thing = &$code_sub($self->oauth2->authorization_url(scope => $self->scope));
  $self->subject->code->{$self} = $thing;
  $self->get_token;
  return;
}

sub get_token {
  my $self = shift;
  $self->oauth2->request_tokens(code => $self->subject->code->{$self});
  return $self->oauth2->token_string;
}

sub name {
  return shift->provider;
}

sub code : lvalue {
  my $self = shift;
  return $self->subject->code($self);
}
no Moose;
__PACKAGE__->meta->make_immutable;
1;
