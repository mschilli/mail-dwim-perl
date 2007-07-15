######################################################################
# Test suite for Mail::DWIM
# by Mike Schilli <cpan@perlmeister.com>
######################################################################

use warnings;
use strict;

use Test::More;
use Mail::DWIM qw(mail);
use File::Temp qw(tempfile);
use Log::Log4perl qw(:easy);

Log::Log4perl->easy_init($DEBUG);

plan tests => 4;

my($fhg, $gcfg) = tempfile();
my($fhu, $ucfg) = tempfile();

  # Local overrides global
Mail::DWIM::blurt("from: goof\@goof.com\n", $gcfg);
Mail::DWIM::blurt("from: goof2\@goof.com\n", $ucfg);
my $m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
is($m->{from}, 'goof2@goof.com', "user cfg overrides global");

  # No local, just global
Mail::DWIM::blurt("", $ucfg);
$m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
is($m->{from}, 'goof@goof.com', "global cfg");

  # Empty conf files
Mail::DWIM::blurt("", $ucfg);
Mail::DWIM::blurt("", $gcfg);
$m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
like($m->{from}, qr/\S\@\S/, "from: determined by user/domain");

  # No conf files
unlink $ucfg;
unlink $gcfg;
$m = Mail::DWIM->new(
  global_cfg_file => $gcfg,
  user_cfg_file   => $ucfg,
);
like($m->{from}, qr/\S\@\S/, "from: determined by user/domain");

mail(
  from    => 'a@b.com',
  to      => 'c@d.com',
  subject => 'This is the subject line',
  text    => 'This is the mail text',
);
