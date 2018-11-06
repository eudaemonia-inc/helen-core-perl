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

package Helen::Core::Relation::DBI;
use Carp::Assert;
use DBI;
use Devel::Confess;

sub new {
  my($class, $data_source, $table_name) = @_;
  assert(defined($class));
  assert(defined($data_source));
  my $dbh = DBI->connect($data_source, "", "", { RaiseError => 1 });

  my $self = bless {
		    dbh => $dbh,
		    name => $table_name
		   }, $class;
  return $self;
}

sub receive {
  my($self, $other) = @_;
  assert(defined($self));
  assert(defined($other));

  my $dbh = $self->{dbh};
  
  my $sth = $dbh->table_info(undef, 'public', $self->{name});

  $sth->execute || die;

  my $columns = [@{$other->{arguments}}, @{$other->{results}}];

  if (!scalar($sth->fetchrow_array)) {
    $sth = $dbh->prepare("create table ".$self->{name}." (".join(", ", map "$_ varchar", @{$columns}).")");
    $sth->execute() || die;
  }

  $sth = $dbh->prepare('select '.join(", ", @{$other->{arguments}}).' from '.$self->{name});

  $sth->execute() || die;

  my $current = $sth->fetchall_hashref($other->{arguments});

  my $delete_sth = $dbh->prepare('delete from '.$self->{name}.' where '.join(" and ", map { "$_ = ?" } @{$other->{arguments}}));

  my $update_sth = $dbh->prepare('update '.$self->{name}.' set '.join(", ", map "$_ = ?", @{$other->{results}}).' where '.join(" and ", map { "$_ = ?" } @{$other->{arguments}}));

  my $insert_sth = $dbh->prepare('insert into '.$self->{name}.' ('.join(", ", @{$columns}).') values ('.join(", ", map "?", @{$columns}).')');

  my %extension = %{$other->{extension}};
  
  map {
    if (defined($current->{$_})) {
      my $key = $_;
      $update_sth->execute(map { $extension{$key}{$_} } (@{$other->{results}}, @{$other->{arguments}})) || die;
      delete $extension{$key};
    } else {
      $delete_sth->execute($_) || die;
    } } keys %extension;
  

  map { my $key = $_; $insert_sth->execute(map { $extension{$key}{$_} } @{$columns}) || die } keys %extension;

  $sth->execute() || die;
}
  
1;
