# NAME

Plack::Middleware::SignpostingJSON - A Signposting implementation from JSON content

[![Build Status](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting.svg?branch=master)](https://travis-ci.org/LibreCat/Plack-Middleware-Signposting)
[![Coverage Status](https://coveralls.io/repos/github/LibreCat/Plack-Middleware-Signposting/badge.svg?branch=master)](https://coveralls.io/github/LibreCat/Plack-Middleware-Signposting?branch=master)

# SYNOPSIS

    builder {
       enable "Plack::Middleware::Signposting::JSON";

       sub {200, ['Content-Type' => 'text/plain'], ['hello world']};
    };

# DESCRIPTION

Plack::Middleware::Signposting::JSON is a base class for Signposting(https://signposting.org) protocol.

# AUTHOR

Nicolas Steenlant, `<nicolas.steenlant at ugent.be>`

Vitali Peil, `<vitali.peil at uni-bielefeld.de>`

# COPYRIGHT

Copyright 2017 - Vitali Peil

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
