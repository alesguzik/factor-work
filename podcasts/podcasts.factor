USING: kernel io http.client xml xml.traversal xml.data libc sequences ;
IN: podcasts
: mpc-add ( url -- ) "mpc add " swap append system drop ;
: get-xml ( url -- xml ) http-get nip string>xml ;
: add-podcast ( name -- )
    get-xml
    "channel" tag-named "item" tags-named
    [ "enclosure" tag-named "url" attr ] map
    reverse [ mpc-add ] each
    ;
: main ( -- ) readln add-podcast ;
MAIN: main
