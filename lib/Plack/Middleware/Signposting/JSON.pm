package Plack::Middleware::Signposting::JSON;

use strict;
use warnings;

use parent 'Plack::Middleware';
use JSON qw(decode_json);
use Plack::Request;
use Plack::Util;
use Catmandu;
use Catmandu::Fix;

sub call {
    my ($self, $env) = @_;

    my $request = Plack::Request->new($env);
    my $res = $self->app->($env);

    # only get/head requests
    return $res unless $request->method =~ m{^get|head$}i;

    # see http://search.cpan.org/~miyagawa/Plack-1.0044/lib/Plack/Middleware.pm#RESPONSE_CALLBACK
    return $self->response_cb($res, sub {
        my $res = shift;

        my $content_type = Plack::Util::header_get($res->[1], 'Content-Type') || '';
        # only json responses
        return unless $content_type =~ m{^application/json}i;
        # ignore streaming response for now
        return unless ref $res->[2] eq 'ARRAY';

        my $body = join('', @{$res->[2]});
        my $data = decode_json($body);

        # harcoded fix file
        my $fixer = Catmandu::Fix->new(fixes => ['example/signposting.fix']);
        $fixer->fix($data);

        # add information to the 'Link' header
        if ($data->{signs}) {
            Plack::Util::header_push(
                $res->[1],
                'Link' => $self->_to_link_format( @{$data->{signs}} )
            );
        }
    });
}

# produces the link format
sub _to_link_format {
    my ($self, @signs) = @_;

    my $body = join(", ", map {
        my ($uri, $relation, $type) = @$_;
        my $link_text = qq|<$uri>; rel="$relation"|;
        $link_text .= qq|; type="$type"| if $type;
        $link_text;
    } @signs);

    $body;
}


1;
