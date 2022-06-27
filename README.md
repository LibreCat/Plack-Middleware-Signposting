# NAME

Plack::Middleware::Signposting - a base class for Plack implementations of the [Signposting](https://signposting.org) protocol

![Test status](https://github.com/LibreCat/Plack-Middleware-Signposting/actions/workflows/linux.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/LibreCat/Plack-Middleware-Signposting/badge.svg?branch=master)](https://coveralls.io/github/LibreCat/Plack-Middleware-Signposting?branch=master)
[![CPANTS kwalitee](http://cpants.cpanauthors.org/dist/Plack-Middleware-Signposting.png)](http://cpants.cpanauthors.org/dist/Plack-Middleware-Signposting)

# SYNOPSIS

    package Plack::Middleware::Signposting::Foo;

    use Moo;

    extends 'Plack::Middleware::Signposting';

    sub call {
        my ($self, $env) = @_;

        ...
        my @data = ("0001", $relation, $type);
        $self->to_link_format(\@data);
    }

# METHODS

- to\_link\_format(\\@ARRAY)

    This method produces the format for the link header.

# MODULES

- [Plack::Middleware::Signposting::JSON](https://metacpan.org/pod/Plack%3A%3AMiddleware%3A%3ASignposting%3A%3AJSON)
- [Plack::Middleware::Signposting::Catmandu](https://metacpan.org/pod/Plack%3A%3AMiddleware%3A%3ASignposting%3A%3ACatmandu)

# AUTHOR

Vitali Peil, `<vitali.peil at uni-bielefeld.de>`

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

# CONTRIBUTORS

Mohammad S Anwar (@manwar)

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Plack::Middleware](https://metacpan.org/pod/Plack%3A%3AMiddleware)
