# NAME

OverPass::Client - Client to Overpass Turbo API (http://overpass-turbo.eu/)

# SYNOPSIS

    use OverPass::Client;
    my $c = OverPass::Client->new;
    my $data = $c->get_query( "[out:json]; area[name="Caraguatatuba"];node["power"];" );

# DESCRIPTION

OverPass::Client is ...

# LICENSE

Copyright (C) Marco Arthur.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Marco Arthur <arthurpbs@gmail.com>
