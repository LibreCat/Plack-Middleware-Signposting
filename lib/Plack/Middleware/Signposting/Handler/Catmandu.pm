package Plack::Middleware::Signposting::Handler::Catmandu;

use Catmandu::Sane;
use Catmandu;
use Catmandu::Util qw/is_instance/;
use Moo;

our $VERSION = '0.01';

with 'Plack::Middleware::Signposting::Handler';

has store => (is => 'ro', required => 1);
has bag => (is => 'ro', required => 1);
has fixes => (is => 'lazy');

sub get_signs {
    my ($self, $id) = @_;

    my $store = $self->store;
    unless (is_instance($store)) {
        $store = Catmandu->store($store);
    }

    my $bag = $store->bag($self->bag);
    my $rec = $bag->get($id);
    $self->fixes->fix($rec);

    return $rec;

    # return [
    #     ["http://orcid.org/0000-0000-0001-0221", "author"],
    #     ["http://orcid.org/0000-0000-0001-0001", "author"],
    #     ["ISI:000001213131", "identifier"],
    #     ["10.1233/3247239487239", "describes"],
    # ];

}

1;
