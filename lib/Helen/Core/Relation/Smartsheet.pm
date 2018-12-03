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

package Helen::Core::Relation::Smartsheet;
use strict;
use warnings;
use Moose;
use namespace::autoclean;
use Carp::Assert;
use Devel::Confess;
use Helen::Core::Relation::REST::Json;
use Helen::Service::Smartsheet;
use parent 'Helen::Core::Relation';

has 'name' => ( is => 'ro', isa => 'Str' );

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $class = shift;
  my $subject = Helen::Service::Smartsheet->new(shift);
  return $class->$orig({subject => $subject, map {$_ => shift } qw(name arguments)});
};

sub BUILD {
  my $self = shift;

  my $sheets = new Helen::Core::Relation::REST::Json($self->subject, 'sheets', '$.data[*]', [ 'name' ]);
  my $sheet = $self->subject->get('sheets/'.$sheets->{extension}->{$self->name}->{id});
  my %positions;
  @positions{new JSON::Path('$.columns[*].title')->values($sheet)} = new JSON::Path('$.columns[*].index')->values($sheet);

  my %arguments;
  @arguments{@{$self->arguments}} = ();

  $self->results([]);
  
  foreach my $column (keys %positions) {
    push @{$self->results}, $column unless exists $arguments{$column};
  }
  
  my %extension;
  foreach my $row (new JSON::Path('$.rows[*].cells')->values($sheet)) {
    $extension{join("/", map { $row->[$positions{$_}]->{value} } @{$self->arguments})} =
      { map { ($_, $row->[$positions{$_}]->{value}) } grep { exists($row->[$positions{$_}]->{value}) } (keys %positions) };
  }

  $self->extension(\%extension);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
