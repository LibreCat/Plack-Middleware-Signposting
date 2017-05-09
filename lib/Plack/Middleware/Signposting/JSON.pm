package Plack::Middleware::Signposting::JSON;

use strict;
use warnings;

use parent 'Plack::Middleware';
use JSON qw(decode_json);
use Plack::Request;
use Plack::Util;
#use Plack::Util::Accessor qw();

#sub prepare_app {
    #my $self = shift;
#}

sub call {
    my ($self, $env) = @_;
    my $request = Plack::Request->new($env);
    my $res = $self->app->($env);
    # only get requests
    return $res unless $request->method =~ m{^get|head$}i;
    # see http://search.cpan.org/~miyagawa/Plack-1.0044/lib/Plack/Middleware.pm#RESPONSE_CALLBACK
    $self->response_cb($res, sub {
        my $res = shift;
        my $content_type = Plack::Util::header_get($res->[1], 'Content-Type') || '';
        # only json responses
        return unless $content_type =~ m{^application/json}i;
        # ignore streaming response for now
        return unless ref $res->[2] eq 'ARRAY';

        my $body = join('', @{$res->[2]});
        my $data = decode_json($body);

        # simple hardcoded example
        if ($data->{orcid}) {
            Plack::Util::header_push($res->[1], 'Link' => qq{<http://orcid.org/$data->{orcid}> ; rel="author"});
        }
    });
}

1;
