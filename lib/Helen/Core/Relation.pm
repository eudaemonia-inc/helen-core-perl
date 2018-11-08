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
use Carp::Assert;
use Devel::Confess;
use Data::Compare;
use Data::Dumper;
use fields qw(arguments results extension);

sub new {
  my $self = shift;
  $self = fields::new($self) unless ref $self;
  my($arguments, $results, $extension) = @_;
  $self->{arguments} = $arguments;
  $self->{results} = $results;
  $self->{extension} = $extension;
  return $self;
}

sub planck {
  my($self, $target) = @_;
  assert(defined($self));
  assert(defined($target));
  $target->receive($self);
}

sub compare {
  my($self, $other) = @_;
  die unless $#{$self->{arguments}} == $#{$other->{arguments}};
  die unless $#{$self->{results}} == $#{$other->{results}};
  my(@a, @b);
  @a = @{$self->{arguments}};
  @b = @{$other->{arguments}};
  while (@a) {
    die unless (shift @a) eq (shift @b);
  }
  @a = @{$self->{results}};
  @b = @{$other->{results}};
  while (@a) {
    die unless (shift @a) eq (shift @b);
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
					  }} @{$self->{results}}} grep { exists $other->{extension}->{$_} } keys %{$self->{extension}}} = ();
  my @here = keys %here;
  my @there = keys %there;
  my @everywhere = keys %everywhere;
  return (\@here, \@there, \@everywhere);
}

1;
