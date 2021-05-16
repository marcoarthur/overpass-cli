package OverPass::Client;
use Mojo::URL;
use Mojo::UserAgent;
use Carp;
use Moo;
use Mojo::Base -async_await, -signatures;
use namespace::clean;

our $VERSION = "0.01";

has query => (
    is => 'rw',
    lazy => 1,
    default => sub { die "Need a query" },
);

has base_url => (
    is => 'ro',
    default => sub { 
        Mojo::URL->new('https://lz4.overpass-api.de/api/interpreter') 
    },
);

has ua => (
    is => 'ro',
    default => sub { Mojo::UserAgent->new },
);

async sub get_query_p($self, $q = undef) {
    $self->query( $q ) if $q; # set query if given
    my $prog = $self->_api_url; # get a clone for base_url
    $prog->query({ data => $self->query }); # write overpass program
    return $self->ua->get_p($prog); # execute http get query async
}

sub get_query( $self, $q = undef ) {
    my $data;
    $self->get_query_p($q)->then( sub ($tx) {
            $data = $tx->res->json;
        })->catch( sub ($e) {
            carp "Error $e while retrieving: " . $self->query;
        })->wait;
    return $data;
}

sub _api_url( $self ) {
    return $self->base_url->clone;
}

1;

__END__

=encoding utf-8

=head1 NAME

OverPass::Client - Client to Overpass Turbo API (http://overpass-turbo.eu/)

=head1 SYNOPSIS

    use OverPass::Client;
    my $c = OverPass::Client->new;
    my $data = $c->get_query( "[out:json]; area[name="Caraguatatuba"];node["power"];" );

=head1 DESCRIPTION

OverPass::Client is ...

=head1 LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=cut

