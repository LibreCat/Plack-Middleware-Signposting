package Plack::Middleware::Signposting;

use Catmandu::Sane;
use parent 'Plack::Middleware';

our $VERSION = '0.02';

sub to_link_format {
    my ($self, @signs) = @_;

    my $body = join(", ", map {
        my ($uri, $relation, $type) = @$_;
        my $link_text = qq|<$uri>; rel="$relation"|;
        $link_text .= qq|; type="$type"| if $type;
        $link_text;
    } @signs);

    $body;
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Signposting - a base class for Signposting implementations

=begin markdown

[![Build Status](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting.svg?branch=master)](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting)
[![Coverage Status](https://coveralls.io/repos/github/LibreCat/Plack-Middleware-Signposting/badge.svg?branch=master)](https://coveralls.io/github/LibreCat/Plack-Middleware-Signposting?branch=master)

=end markdown

=head1 DESCRIPTION

Plack::Middleware::Signposting is a base class for L<<Signposting>>( https://signposting.org) protocol.

=head2 METHODS

=over

=item to_link_format(ARRAYREF)

This method produces the format for the link header. It expects an arrayref as input.

=back

=head1 AUTHOR

Nicolas Steenlant, C<< <nicolas.steenlant at ugent.be> >>

Vitali Peil, C<< <vitali.peil at uni-bielefeld.de> >>

=head1 COPYRIGHT

Copyright 2017 - Vitali Peil

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
