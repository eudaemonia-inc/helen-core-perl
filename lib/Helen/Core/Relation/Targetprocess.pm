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


package Helen::Core::Relation::Targetprocess;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.4';

use Moose;
use namespace::autoclean;
use Carp::Assert;
use Helen::Core::Relation::REST::Json;
use Helen::Service::Targetprocess;
use Data::Dumper;
use Encode qw(decode encode);
use parent 'Helen::Core::Relation::REST::Json';

has 'name' => ( is => 'ro', isa => 'Str' );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  my $subject = shift;
  my $name = shift;
  my $arguments = shift;
  $subject = Helen::Service::Targetprocess->new($subject, $name);
  return $class->$orig({subject => $subject, name => $name, path => '$.Items[*]', arguments => $arguments});
};

# problem 1: take => 1000 pagination

sub BUILD {
  my $self = shift;

  my %arguments = ();
  $arguments{@{$self->arguments}} = ();
  my %results = ();
  foreach my $item (values %{$self->extension}) {
    if (exists $item->{CustomFields}) {
      foreach my $field (@{$item->{CustomFields}}) {
	$item->{$field->{Name}} = $self->stringifyvalue($field->{Value});
	$results{$field->{Name}} = () unless exists $arguments{$field->{Name}};
      }
      delete $item->{CustomFields};
    }
    foreach my $field (keys %{$item}) {
      if (ref $item->{$field} eq 'HASH') {
	  die "customfield with hash value but no resourcetype" unless exists $item->{$field}->{ResourceType};
	  my $resource_type = $item->{$field}->{ResourceType};
	  if ($resource_type eq 'GeneralUser') {
	    my $email_address = $item->{$field}->{Login};
	    $email_address =~ s/\@cisco\.com$//;
	    $item->{$field} = $email_address;
	  } else {
	    if (defined($item->{$field}->{Name})) {
	      #warn "unknown resource type $resource_type";
	      $item->{$field} = $item->{$field}->{Name};
	    } else {
	      die "unknown resource type $resource_type with no Name";
	    }
	  }
	}
      }
  }
  foreach my $result (@{$self->{results}}) {
    $results{$result} = () unless $result eq 'CustomFields';
  }
  $self->results([keys %results]);
  return;
}

sub stringifyvalue {
  my($self, $value) = @_;
  if ((ref $value eq 'HASH') && (exists $value->{Name})) {
    return decode 'UTF-8', $value->{Name};
  }
  return decode 'UTF-8', $value;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
