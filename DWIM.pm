###########################################
package Mail::DWIM;
###########################################

use strict;
use warnings;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(mail);
our $VERSION = "0.01";

use YAML qw(LoadFile);
use Log::Log4perl qw(:easy);

###########################################
sub mail {
###########################################
    my(@params) = @_;

    my $mailer = Mail::DWIM->new(@params);
}

###########################################
sub new {
###########################################
    my($class, %options) = @_;

    my($homedir) = glob "~";

    my %defaults;

    my $self = {
        global_cfg_file => "/etc/maildwim",
        user_cfg_file   => "$homedir/.maildwim",
        transport       => "sendmail",
        %options,
    };

    for my $cfg (qw(global_cfg_file user_cfg_file)) {
        if(-f $self->{$cfg}) {
            my $yml = LoadFile( $self->{$cfg} );
            if(defined $yml and ref $yml ne 'HASH') {
                  # Needs to be a hash, but YAML file can be empty (undef)
                LOGDIE "YAML file $self->{$cfg} format not a hash";
            }
              # merge with existing hash
            %defaults = (%defaults, %$yml) if defined $yml;
        }
    }

    %$self = (%$self, %defaults);

    bless $self, $class;
}

###########################################
sub html_compat {
###########################################
    my($text) = @_;

    eval "require MIME::Lite";
 
my $msg = MIME::Lite->new(
From=> 'sender@host.com',
To=> 'recipient@host.com',
Subject=> "Both Plain and in HTML",
Type=>'multipart/alternative',
);
#$msg->attach(Type => 'text/plain',
#Data => $plaintext
#);
#$msg->attach(Type => 'text/html',
#Data => $htmltext,
#);
#$msg->send();
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
      text    => 'test message text'
    );

=head1 DESCRIPTION

C<Mail::DWIM> makes it easy to send email. You just name the
recipient, the subject line and the mail text and Mail::DWIM
does the rest.

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
      text    => 'test message text',
    );

that's enough for the mailer to send out an email to the specified
address. There's no C<from> field, so C<Mail::DWIM> uses 'user@domain.com'
where C<user> is the current Unix user and C<domain.com> is the domain
set in TODO. If you want to specify a different 'From:' field, go ahead:

    mail(
      from    => 'me@mydomain.com',
      to      => 'foo@bar.com'
      subject => 'test message',
      text    => 'test message text',
    );

By default, C<Mail::DWIM> connects to a running sendmail daemon to 
deliver the mail. But you can also specify an SMTP server:

    mail(
      to          => 'foo@bar.com'
      subject     => 'test message',
      text        => 'test message text',
      transport   => 'smtp',
      smtp_server => 'smtp.foobar.com',
    );

Or the unix mail command:

    mail(
      to          => 'foo@bar.com'
      subject     => 'test message',
      text        => 'test message text',
      transport   => 'unixmail',
      mail_cmd    => '/usr/bin/mail',
    );

On a given system, these settings need to be specified only once and
put into a configuration file. All C<Mail::DWIM> instances running on 
this system will pick them up as default settings.

=head2 Configuration files

There is a global C<Mail::DWIM> configuration file in C</etc/maildwim>
with global settings and a user-specific file in C<~user/.maildwim>
which overrides global settings. Both files are optional, and
their format is YAML:

    # ~user/.maildwim
    from:      me@mydomain.com
    reply-to:  me@mydomain.com
    transport: sendmail

=head2 Sending Attachments

To attach an image or a PDF document to the email, set the C<attach>
parameter to the filename:

    mail(
      to      => 'foo@bar.com'
      subject => 'test message',
      text    => 'test message text'
      attach  => 'somepic.jpg',
    );

You can even name those attachements and/or include several of them:

    mail(
      to      => 'foo@bar.com'
      subject => 'test message',
      text    => 'test message text'
      attach  => [ 
        { text => 'Me at Copacabana' 
          file => 'copa.jpg', 
        },
        { text => 'Me at Eiffel Tower'
          file => 'eiffel.jpg', 
        },
      ],
    );

=head2 Error Handling

By default, C<Mail::DWIM> throws an error if something goes wrong
(aka: it dies). If that's not desirable and you want it to return
a true/false value code instead, set the C<raise_error> option to 
a false value:

    my $rc = mail(
      raise_error => 0,
      to          => 'foo@bar.com'
      ...
    );

    if(! $rc) {
        die "A dreadful mailer error! Release the hounds!";
    }

=head2 Sending HTML Emails

Many people hate HTML emails, but if you also attach a plaintext version 
for people with arcane email readers, everytext is happy. C<Mail::DWIM>
makes this easy with the C<html_compat> option:

    mail(
      to          => 'foo@bar.com'
      subject     => 'test message',
      html_compat => 1,
      text        => 'This is an <b>HTML</b> email.'
    );

This will create two attachments, the first one as plain text
(generated by HTML::Text to the best of its abilities), followed by
the specified HTML message marked as content-type C<text/html>. 
Non-HTML mail readers will pick up the first one, and Outlook-using
marketroids get fancy HTML. Everytext wins.

=head2 Test Mode

If the environment variable C<MAIL_DWIM_TEST> is set to a filename,
C<Mail::DWIM> prepares mail as usual, but doesn't send it off 
using the specified transport mechanism. Instead, it appends outgoing
mail ot the specified file. 

C<Mail::DWIM>'s test suite uses this mode to run a regression test
without needing an MTA.

=head2 Why another Mail Module?

The problem with other Mail:: or Email:: modules on CPAN is that they 
expose more options than the casual user needs. Why create a
mailer object, call its accessors and then its C<send> method if all I
want to do is call a function that works similarily to the Unix
C<mail> program? C<Mail::DWIM> makes easy things easy while making
sure that hard things are still possible (I think I've heard this
motto before :).

C<Mail::DWIM> tries to be as 'Do-What-I-mean' as the venerable Unix
mail command. Noboby has to read its documentation to use it:

    $ mail m@perlmeister.com
    Subject: foobar
    quack! quack!
    .
    Cc:
    CTRL-D

=head1 LEGALESE

Copyright 2007 by Mike Schilli, all rights reserved.
This program is free software, you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 AUTHOR

2007, Mike Schilli <cpan@perlmeister.com>
