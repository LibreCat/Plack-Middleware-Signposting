use strict;
use warnings FATAL => 'all';
use Test::More;
use HTTP::Request::Common;
use Plack::Builder;
use Plack::Test;
use Catmandu;
use Data::Dumper;

my $store = Catmandu->store;

subtest 'simple handler' => sub {
    $store->bag('default')->add({
        _id => 1,
        signs => [
            ["http://orcid.org/0000-0000-0001-0221", "author"],
            ["https://doi.org/10.17026/dans-xev-46h7", "describedby", "application/vnd.citationstyles.csl+json"]
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

            like $res->header('Link'), qr/\<http:\/\/orcid.org\/0000-0000-0001-0221\>; rel="author"/, 'match ORCID';
            like $res->header('Link'), qr/type="application\/vnd.citationstyles\.csl\+json"/, "match rel and type";
        }
    };
};

subtest 'advanced handler with fix' => sub {
    $store->bag('default')->add({
        _id => 2,
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
            my $req = GET "http://localhost/record/2";
            my $res = $cb->($req);
            note Dumper $res;
            like $res->header('Link'), qr/0000-0000-0001-0221\>; rel="author"/;
        }
    };
};

done_testing;
