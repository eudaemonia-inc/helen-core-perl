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

use strict;
use warnings;
use version; our $VERSION = version->declare('v0.0.0');

package Helen::Core::Relation::File;
use Carp::Assert;
use parent 'Helen::Core::Relation';
use fields qw(file_name);

sub new {
  my($class, $file_name, $arguments, $results) = @_;
  assert(defined($class));
  assert(defined($file_name));
  assert(defined($arguments));
  assert(defined($results));
  assert($#$arguments >= 0);
  assert($#$results >= 0);
  my %extension;
  my($self) = fields::new($class);
  $self->SUPER::new(undef, $arguments, $results, \%extension);
  $self->{file_name} = $file_name;

  my %positions;
  
  map { $positions{$arguments->[$_]} = $_ } (0..$#$arguments);
  map { $positions{$results->[$#$arguments + $_]} = $#$arguments + $_ + 1} (0..$#$results);
  
  if (open(my $FILE, '<', $file_name)) {
    while (<$FILE>) {
      chomp;
      my(@fields) = split /\|/;
      my %line;
      @line{@{$arguments}, @{$results}} = @fields;
      $extension{join("/", @fields[0..$#$arguments])} = \%line;
    }
    close(FILE);
  }

  return $self;
}

sub receive {
  my($self, $other) = @_;

  open(my $FILE, '>', $self->{file_name}) || die;
  foreach my $item (values %{$other->{extension}}) {
    print $FILE join("|", map { defined($item->{$_}) ? $item->{$_} : '' } (@{$self->{arguments}}, @{$self->{results}})), "\n";
  }
  close($FILE);
}
  
1;
