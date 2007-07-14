###########################################
package Mail::DWIM;
###########################################

use strict;
use warnings;

our $VERSION = "0.01";

###########################################
sub new {
###########################################
    my($class, %options) = @_;

    my $self = {
        %options,
    };

    bless $self, $class;
}

1;

__END__

=head1 NAME

Mail::DWIM - Do-What-I-Mean Mailer

=head1 SYNOPSIS

    use Mail::DWIM qw(mail);

    mail(
      to      => 'foo@bar.com'
      subject => 'test message',
      body    => 'test message text'
    );

=head1 DESCRIPTION

C<Mail::DWIM> makes it easy to send out mail messages. You just name the
recipient, the subject line and the mail text and Mail::DWIM does the rest.

C<Mail::DWIM> lets you store commonly used settings (like the default
sender email address or the transport mechanism) in a local
configuration file, so that you don't have to repeat settings in your
program code every time you want to send out an email. You are
certainly free to override the default settings if required.

C<Mail::DWIM> uses defaults wherever possible. So if you say

    use Mail::DWIM qw(mail);

    mail(
      to      => 'foo@bar.com'
      subject => 'test message',
      body    => 'test message text',
    );

that's enough for the mailer to send out an email to the specified
address. There's no C<from> field, so C<Mail::DWIM> uses 'user@domain.com'
where C<user> is the current Unix user and C<domain.com> is the domain
set in TODO. If you want to specify a different 'From:' field, go ahead:

    mail(
      from    => 'me@mydomain.com',
      to      => 'foo@bar.com'
      subject => 'test message',
      body    => 'test message text',
    );

By default, C<Mail::DWIM> connects to a running sendmail daemon to 
deliver the mail. But you can also specify an SMTP server:

    mail(
      to          => 'foo@bar.com'
      subject     => 'test message',
      body        => 'test message text',
      transport   => 'smtp',
      smtp_server => 'smtp.foobar.com',
    );

Or the unix mail command:

    mail(
      to          => 'foo@bar.com'
      subject     => 'test message',
      body        => 'test message text',
      transport   => 'mail_cmd',
      mail_cmd    => '/usr/bin/mail',
    );

On a given system, these settings need to be specified only once and
put into a configuration file. All C<Mail::DWIM> instances running on 
this system will pick them up as default settings.

There is a global C<Mail::DWIM> configuration file in C</etc/maildwim>
with global settings and a user-specific file in C<~user/.maildwim>
which overrides global settings. Both files are optional, and
their format is YAML:

    # ~user/.maildwim
    from:      me@mydomain.com
    reply-to:  me@mydomain.com
    transport: sendmail

=head2 Why another Mail Module?

The problem with other Mail:: or Email:: modules on CPAN is that they 
expose more options than the casual user needs. Why create a
mailer object, call its accessors and then its C<send> method if all I
want to do is call a function that works similarily to the Unix
C<mail> program? C<Mail::DWIM> makes easy things easy while making
sure that hard things are still possible (I think I know this motto from
somewhere :).

=head1 LEGALESE

Copyright 2007 by Mike Schilli, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2007, Mike Schilli <cpan@perlmeister.com>
