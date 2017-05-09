# NAME

Plack::Middleware::Signposting - A base class for Signposting implementations

# SYNOPSIS

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

# DESCRIPTION

Plack::Middleware::Signposting is a base class for Signposting(https://signposting.org) protocol.
You only need to implement a \*get\_sings()\* method.

# AUTHOR

Vitali Peil <vitali.peil@uni-bielefeld.de>

# COPYRIGHT

Copyright 2016- Vitali Peil

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
