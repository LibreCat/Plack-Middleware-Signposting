package Plack::Middleware::Signposting::Handler::Catmandu;

use Catmandu::Sane;
use Catmandu;
use Catmandu::Util qw/is_instance/;
use Moo;

our $VERSION = '0.01';

with 'Plack::Middleware::Signposting::Handler';

has store => (is => 'ro', required => 1);
has bag => (is => 'lazy');
has fix => (is => 'lazy');

sub _build_bag {
    my $self = shift;
    state $bag = $self->bag // 'default';
}

sub _build_fix {
    my $self = shift;
    state $fixer = Catmandu::Fix->new(fixes => $self->fix);
}

sub get_signs {
    my ($self, $id) = @_;

    my $fixer = $self->fix;

    my $store = $self->store;
    unless (is_instance($store)) {
        $store = Catmandu->store($store);
    }

    my $bag = $store->bag($self->bag);
    my $rec = $bag->get($id);

    $fixer->fix($rec);

    return $rec->{signs};
}

1;
