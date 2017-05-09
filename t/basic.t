use strict;
use warnings FATAL => 'all';
use Catmandu;
use Test::More;
use HTTP::Request::Common;
use Plack::Builder;
use Plack::Test;
use Data::Dumper;

my $store = Catmandu->store;
$store->bag('default')->add({
    _id => 1,
    signs => [
        ["http://orcid.org/0000-0000-0001-0221", "author"],
    ],
});

my $handler = builder {
    enable "Plack::Middleware::Signposting",
        handler => 'Catmandu', options => {
            store => $store,
        },
        path => qr|http:\/\/localhost\/record\/|
    ;
    sub { ['200', ['Content-Type' => 'text/html'], ['hello world']] };
};

test_psgi app => $handler, client => sub {
    my $cb = shift;

    {
        my $req = GET "http://localhost/record/1";
        my $res = $cb->($req);

        like $res->header('Link'), qr/http:\/\/orcid.org\/0000-0000-0001-0221/i;
ok 1;
    }
};

done_testing;
