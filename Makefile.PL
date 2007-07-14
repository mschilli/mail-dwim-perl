######################################################################
# Makefile.PL for Mail::DWIM
# 2007, Mike Schilli <cpan@perlmeister.com>
######################################################################
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Mail::DWIM',
    'VERSION_FROM' => 'DWIM.pm', # finds $VERSION
    'PREREQ_PM'    => {
      File::Temp => 1,
      YAML       => 1,
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'DWIM.pm',
       AUTHOR     => 'Mike Schilli <cpan@perlmeister.com>') : ()),
);
