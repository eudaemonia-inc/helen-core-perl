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

package Helen::Core::Relation;
use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.1pre');
use Moose;
use namespace::autoclean;
use Carp::Assert;
use Data::Compare;

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  return $class->$orig({ map { $_ => shift } qw(subject arguments results extension)});
};
  
has 'subject' => (
		  is => 'ro',
		 );

has 'arguments' => (
		    is => 'rw',
		    isa => 'Maybe[ArrayRef[Str]]',
		    );

has 'results' => (
		  is => 'rw',
		  isa => 'Maybe[ArrayRef[Str]]',
		 );

has 'extension' => (
		    is => 'rw',
		    isa => 'HashRef[HashRef]',
		   );

sub apply {
  my($self, $function, @arguments) = @_;
  foreach my $item (values %{$self->{extension}}) {
    &{$function}($item, @arguments);
  }
  return;
}

sub compare {
  my($self, $other) = @_;
  die unless $#{$self->arguments} == $#{$other->arguments};
  die unless $#{$self->results} == $#{$other->results};
  my @a = sort @{$self->arguments};
  my @b = sort @{$other->arguments};
  while (@a) {
    die "@a, @b" unless (shift @a) eq (shift @b);
  }
  @a = sort @{$self->results};
  @b = sort @{$other->results};
  while (@a) {
    die "@, @b" unless (shift @a) eq (shift @b);
  }

  my(%here, %there, %everywhere);
  @here{grep { !exists $other->{extension}->{$_} } keys %{$self->{extension}}} = 1;
  @there{grep { !exists $self->{extension}->{$_} } keys %{$other->{extension}}} = 1;
  @everywhere{grep { my $key = $_; grep { my $foo;
					  if (defined($self->{extension}->{$key}->{$_})) {
					    if (defined($other->{extension}->{$key}->{$_})) {
					      $foo = $self->{extension}->{$key}->{$_} ne $other->{extension}->{$key}->{$_};
					    } else {
					      $foo = 1;
					    }
					  } else {
					    $foo = defined($other->{extension}->{$key}->{$_});
					  }} @{$self->results}} grep { exists $other->{extension}->{$_} } keys %{$self->{extension}}} = ();
  my @here = keys %here;
  my @there = keys %there;
  my @everywhere = keys %everywhere;
  return (\@here, \@there, \@everywhere);
}

sub planck {
  my($self, $target) = @_;
  assert(defined($self));
  assert(defined($target));
  $target->receive($self);
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
