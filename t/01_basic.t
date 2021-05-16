use strict;
use warnings;
use Test2::V0;
use OverPass::Client;
use DDP;

my $c = OverPass::Client->new();
isa_ok $c, 'OverPass::Client';

# overpass query
my $q = <<'EOQ';
[out:json]; //set json as output
area[name="Ubatuba"]; //search only ubatuba city
node["power"](area); // node with tag power
(._;>;);
EOQ

# query async
subtest 'query assynchrolously' => sub {
    plan skip_all => 'Requires $OVERPASS_DEVEL' unless $ENV{OVERPASS_DEVEL};
    my $p = $c->get_query_p( $q );
    isa_ok $p, 'Mojo::Promise';
    $p->then( sub { my $tx = shift;
            ok $tx, 'got a response';
            isa_ok $tx, 'Mojo::Transaction::HTTP';
            my $json = $tx->res->json;
            ok defined $json->{elements}, "has elements in response";
    })
    ->catch( sub { fail 'something happended ' . shift} )->wait;
};


# query sync
subtest 'query osm synchronously' => sub {
    plan skip_all => 'Requires $OVERPASS_DEVEL' unless $ENV{OVERPASS_DEVEL};
    my $d = $c->get_query($q);
    ok $d, "got a response";
    ok $d->{elements}, "contain elements in response";
};

done_testing;
