######################################################################
# Test suite for Mail::DWIM
# by Mike Schilli <cpan@perlmeister.com>
######################################################################

use warnings;
use strict;

use Test::More;
use Mail::DWIM qw(mail);
use Data::Dumper;
use File::Temp qw(tempfile);
use Log::Log4perl qw(:easy);

#Log::Log4perl->easy_init($DEBUG);

plan tests => 2;

my $rc = mail(
  from    => 'foo@foo.com',
  to      => 'bar@bar.com',
  subject => 'subject test 1',
  text    => 'text test 2',
  transport => 'smtp',
  raise_error => 0,
);

ok(!$rc, "SMTP server missing");
like(Mail::DWIM::error(), qr/No smtp_server set/, "Error set in error()");
