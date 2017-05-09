package Plack::Middleware::Signposting;

use strict;
use warnings;
use parent 'Plack::Middleware';
use Plack::Util;
use Plack::Util::Accessor qw(path handler options);
use Carp qw(croak);

our $VERSION = '0.01';

sub call {
    my ($self, $env) = @_;
    my $res  = $self->app->($env);

    # my $path_match = $self->path or return;
    # my $uri = $env->{PATH_INFO};
    # $uri =~ s/$path_match// or return;

    $self->response_cb(
        $res,
        sub {
            my $res = shift;

            my $headers = $res->[1];

            my $signs = $self->_handler->get_signs('1');
            push @$headers, ('Link' => $self->_to_link_format(@$signs));
        }
    );
}

sub _handler {
    my ($self) = @_;

    $self->{_handler} ||= do {
        my $class = Plack::Util::load_class($self->handler, 'Plack::Middleware::Signposting::Handler');
        $class->new($self->options || {});
    };
}

sub _to_link_format {
    my ($self, @signs) = @_;

    my $body = join(",\n", map {
        my ($uri, $relation, $type) = @$_;
        my $link_text = qq|<$uri>; rel="$relation"|;
        $link_text .= qq|; type="$type"| if $type;
        $link_text;    } @signs);

    "$body\n";
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Signposting - A base class for Signposting implementations

=head1 SYNOPSIS

  package Plack::Middleware::Signposting::Handler::MyStore;

  use Moo;

  with 'Plack::Middleware::Signposting::Handler';

  sub get_signs {
      my ($self, $id) = @_;

      # your code goes here


      return [
        [''],
        [..],
        [xxx],
        #...
      ]
  }

=head1 DESCRIPTION

Plack::Middleware::Signposting is a base class for Signposting(https://signposting.org) protocol.
You only need to implement a *get_sings()* method.

=head1 AUTHOR

Vitali Peil E<lt>vitali.peil@uni-bielefeld.deE<gt>

=head1 COPYRIGHT

Copyright 2016- Vitali Peil

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
