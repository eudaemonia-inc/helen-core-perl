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

package Helen::Core::Relation::Smartsheet;
use Carp::Assert;
use Data::Dumper;
use Devel::Confess;
use Helen::Core::Relation::REST::Json;
use Helen::Service::Smartsheet;
use parent 'Helen::Core::Relation';
use fields;

sub new {
  my($self) = shift;
  $self = fields::new($self) unless ref $self;
  my($subject, $name, $arguments) = @_;

  my $service = new Helen::Service::Smartsheet;
  my $sheets = new Helen::Core::Relation::REST::Json($subject, $service, 'sheets', '$.data[*]', [ 'name' ]);
  my $sheet = $service->get($subject, 'sheets/'.$sheets->{extension}->{$name}->{id});
  my %positions;
  @positions{new JSON::Path('$.columns[*].title')->values($sheet)} = new JSON::Path('$.columns[*].index')->values($sheet);

  my %arguments;
  @arguments{@$arguments} = ();

  my($results) = [];
  
  foreach my $column (keys %positions) {
    push @{$results}, $column unless exists $arguments{$column};
  }
  
  my %extension;
  foreach my $row (new JSON::Path('$.rows[*].cells')->values($sheet)) {
    $extension{join("/", map { $row->[$positions{$_}]->{value} } @{$arguments})} =
      { map { ($_, $row->[$positions{$_}]->{value}) } grep { exists($row->[$positions{$_}]->{value}) } (keys %positions) };
  }
  
  $self->SUPER::new($subject, $arguments, $results, \%extension);
  return $self;
}
1;
