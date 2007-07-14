######################################################################
# Test suite for Mail::DWIM
# by Mike Schilli <cpan@perlmeister.com>
######################################################################

use warnings;
use strict;

use Test::More;
use Mail::DWIM;
use Data::Dumper;
use File::Temp qw(tempfile);

plan tests => 2;

my($fhg, $gcfg) = tempfile();
my($fhu, $ucfg) = tempfile();

blurt("from: goof\@goof.com\n", $gcfg);
blurt("from: goof2\@goof.com\n", $ucfg);
my $m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
is($m->{from}, 'goof2@goof.com', "user cfg overrides global");

blurt("", $ucfg);
$m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
is($m->{from}, 'goof@goof.com', "global cfg");

###########################################
sub blurt {
###########################################
    my($data, $file) = @_;

    open FILE, ">$file" or die "Cannot open $file";
    print FILE $data;
    close FILE;
}

###########################################
sub slurp {
###########################################
    my($file) = @_;

    local($/);
    $/ = undef;

    open FILE, "<$file" or die "Cannot open $file";
    my $data = <FILE>;
    close FILE;
    return $data;
}
