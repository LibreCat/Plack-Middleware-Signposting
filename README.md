# NAME

Plack::Middleware::Signposting - a base class for Plack implementations of the [<Signposting](https://metacpan.org/pod/<Signposting)>( https://signposting.org) protocol

[![Build Status](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting.svg?branch=master)](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting)
[![Coverage Status](https://coveralls.io/repos/github/LibreCat/Plack-Middleware-Signposting/badge.svg?branch=master)](https://coveralls.io/github/LibreCat/Plack-Middleware-Signposting?branch=master)

# METHODS

- to\_link\_format(ARRAYREF)

    This method produces the format for the link header. It expects an arrayref as input.

# MODULES

- [Plack::Middleware::Signposting::JSON](https://metacpan.org/pod/Plack::Middleware::Signposting::JSON)
- [Plack::Middleware::Signposting::Catmandu](https://metacpan.org/pod/Plack::Middleware::Signposting::Catmandu)

# AUTHOR

Vitali Peil, `<vitali.peil at uni-bielefeld.de>`

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Plack::Middleware](https://metacpan.org/pod/Plack::Middleware)
