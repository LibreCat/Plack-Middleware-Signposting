use strict;
use warnings FATAL => 'all';

use Catmandu;
use HTTP::Request::Common;
use Plack::App::Catmandu::Bag;
use Plack::Builder;
use Plack::Test;
use Test::More;
use Data::Dumper;

my $pkg;
BEGIN {
    $pkg = "Plack::Middleware::Signposting::Catmandu";
    use_ok $pkg;
}
require_ok $pkg;

Catmandu->define_store('library', 'Hash');
my $bag = Catmandu->store('library')->bag('books');

my $data = {
    _id => 1,
    signs => [
        ["https://orcid.org/i-am-orcid", "author"],
        ["https://orcid.org/987654", "author"],
    ]
};

$bag->add($data);

my $app = builder {
        enable "Plack::Middleware::Signposting::Catmandu", store => "library", bag => "books";
        mount '/publication' => Plack::App::Catmandu::Bag->new(
            store => 'library',
            bag => 'books',
        );
    };

test_psgi app => $app, client => sub {
    my $cb = shift;

    {
        my $req = GET "http://localhost/publication/1";
        my $res = $cb->($req);
note Dumper $res;
        like $res->header('Link'), qr{\<https*:\/\/orcid.org\/i-am-orcid\>; rel="author"}, 'ORCID in Link header';
        like $res->header('Link'), qr{\<https*:\/\/orcid.org\/987654\>; rel="author"}, 'another ORCID in Link header';
    }
};

done_testing;
