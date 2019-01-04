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

package Helen::Service::Targetprocess;
use strict;
use warnings;
use version 0.77; our $VERSION = version->declare('v0.0.1');
use Moose;
use Carp::Assert;
use namespace::autoclean;
use parent 'Helen::Service::Json';
use Data::Dumper;

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({subject => shift, uri => 'https://targetprocess.cisco.com/api/v1'});
};

sub authorization_params {
  my $self = shift;
  return { access_token => $self->subject->bearer_token->{$self->subject} };
};

sub authorize_helen {
  my($self, $code_sub) = @_;
  $self->subject->bearer_token->{$self->subject} = &$code_sub('just get it from the targetprocess web site');
  return;
}

sub get {
  my($self, $name, $params) = @_;
  return $self->SUPER::get($self->subject, $name, $params);
}

sub pagination_params {
  my($self, $count) = @_;
  if ($count > 0) {
    return { take => 1000, skip => $count * 1000 };
  } else {
    return { take => 1000 };
  }
}

sub combine_results {
  my($self, $accum, $result) = @_;
  if (defined($accum)) {
    return { Items => [ @{$accum->{Items}}, @{$result->{Items}} ] };
  } else {
    return $result;
  }
}

sub more_results {
  my($self, $result) = @_;
  return exists($result->{Next});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
