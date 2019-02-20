use ExtUtils::MakeMaker;

package MY;

our $org_pm_dir = 'Helen/Core/Relation';
our @org_pms = qw(Mint.pm RailsModel.pm);

sub libscan {
  my($self, $path) = @_;
  if ($path =~ m/\.org$/) {
    return '';
  } else {
    return $self->SUPER::libscan($path);
  }
}

sub init_PM {
  my $self = shift;
  my $ret = $self->SUPER::init_PM(@_);
  foreach my $pm (@org_pms) {
    my $path = $self->catfile('lib', $org_pm_dir, $pm);
    my $inst = $self->catfile($self->{INST_LIB},$org_pm_dir, $pm);
    print "libscan($path) => '$inst'\n" if ($Verbose >= 2);
    $self->{PM}{$path} = $inst;
  }
  return $ret;
}

sub special_targets {
  my $self = shift;
  my $make_frag = $self->SUPER::special_targets(@_);
  $make_frag .= <<'FRAGGLE_ROCK';
.SUFFIXES: .org .pm

.org.pm:
	org-babel-tangle $<

clean ::
FRAGGLE_ROCK
  $make_frag .= join("", map { "\t\$(RM_F) ".$self->catfile('lib', $org_pm_dir, $_)."\n" } @org_pms);
  return $make_frag;
}

package main;

WriteMakefile(
    NAME            => 'Helen',
    VERSION_FROM    => 'lib/Helen.pm'
    );
