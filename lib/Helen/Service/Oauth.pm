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

package Helen::Service::Oauth;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.3';

use Moose;
use namespace::autoclean;
use Carp::Assert;
use LWP::Authen::OAuth2;
use JSON;
use Try::Tiny;

has 'provider' => (is => 'ro', isa => 'Str');
has 'uri' => (is => 'ro', isa => 'Str');
has 'scope' => (is => 'ro', isa => 'Str');
has 'subject' => (is => 'ro', isa => 'Object', handles => [qw(bearer_token client_secret)]);
has 'client_id' => (is => 'ro', isa => 'Str');
has 'oauth2' => (is => 'rw', isa => 'Object');
has 'subservice' => (is => 'ro', isa => 'Object');

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(provider uri scope client_id subject)});
};

sub BUILD {
  my $self = shift;

  try {
    my $keyring = Helen::Core::Relation::Secret::Keyring->new();
    my $oauth2 = LWP::Authen::OAuth2->new(
					  client_id => $self->client_id,
					  client_secret => $keyring->client_secret->{$self->name},
					  service_provider => $self->provider,
					  redirect_uri => $self->uri,
					  save_tokens => \&save_tokens,
					  save_tokens_args => [$self]
					 );
    $self->oauth2($oauth2);
  } catch {
    warn "oh well: $_";
  };
  return;
}

sub save_tokens {
  my($tokens, $self) = @_;
  $tokens = decode_json $tokens;
  $self->subject->bearer_token->{$self->subservice} = $tokens->{access_token};
  print "saving tokens!\n";
  return;
}

sub authorize_helen {
  my $self = shift;
  assert($self);
  assert($self->oauth2);
  my $code_sub = shift;
  my $subservice = shift;
  my $thing = &$code_sub($self->oauth2->authorization_url(scope => $self->scope));
  $self->subject->code->{$self} = $thing;
  $self->subject->client_secret($subservice->client_secret);
  $self->get_token;
  return;
}

sub get_token {
  my $self = shift;
  $self->oauth2->request_tokens(code => $self->subject->code->{$self}, client_secret => $self->subject->client_secret->{$self});
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
