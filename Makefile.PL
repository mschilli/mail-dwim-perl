######################################################################
# Makefile.PL for Mail::DWIM
# 2007, Mike Schilli <cpan@perlmeister.com>
######################################################################
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Mail::DWIM',
    'VERSION_FROM' => 'lib/Mail/DWIM.pm', # finds $VERSION
    'PREREQ_PM'    => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/Mail/DWIM.pm',
       AUTHOR     => 'Mike Schilli <cpan@perlmeister.com>') : ()),
);
