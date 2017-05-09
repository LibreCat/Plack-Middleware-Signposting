use strict;
use warnings FATAL => 'all';
use Test::More;
use HTTP::Request::Common;
use Plack::Builder;
use Plack::Test;
use Catmandu;

my $store = Catmandu->store;

subtest 'simple handler' => sub {
    $store->bag('default')->add({
        _id => 1,
        signs => [
            ["http://orcid.org/0000-0000-0001-0221", "author"],
            ["http://orcid.org/0000-0000-0001-0001", "author"],
            ["ISI:000001213131", "identifier"],
            ["10.1233/3247239487239", "describes"],
        ],
    });

    my $simple_handler = builder {
        enable "Plack::Middleware::Signposting",
            handler => 'Catmandu', options => {
                store => $store,
            },
            path => 'http://localhost/record/',
        ;

        sub { ['200', ['Content-Type' => 'text/html'], ['hello world']] };
    };

    test_psgi app => $simple_handler, client => sub {
        my $cb = shift;

        {
            my $req = GET "http://localhost/record/1";
            my $res = $cb->($req);
            # like qr/\<http:\/\/orcid.org\/0000-0000-0001-0001\>; rel="auhtor"/, $res->header('Link');
        }
    };
};

subtest 'advanced handler with fix' => sub {
    $store->bag('default')->add({
        _id => 1,
        author => {
            full_name => 'Einstein, Albert',
            orcid => 'http://orcid.org/0000-0000-0001-0221',
        }
    });

    my $handler = builder {
        enable "Plack::Middleware::Signposting",
            handler => 'Catmandu', options => {
                store => $store,
                bag => 'default',
                fixes => 't/test.fix',
            },
            path => 'http://localhost/record/',
        ;

        sub { ['200', ['Content-Type' => 'text/html'], ['hello world']] };
    };

    test_psgi app => $handler, client => sub {
        my $cb = shift;

        {
            my $req = GET "http://localhost/record/1";
            my $res = $cb->($req);
            is_deeply [$res->header('Link')], ['<http://orcid.org/0000-0000-0001-0221>; rel="author"'];
        }
    };
};

done_testing;
