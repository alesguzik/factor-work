#! /usr/bin/env factor
USING: kernel arrays sequences hashtables vectors formatting command-line math.parser
       http.client xml io.sockets.secure urls.encoding xml.traversal libc ;
IN: vkpd

CONSTANT: lastfm-apikey "9ed8ca94e596f58b4068588500d66d54"

CONSTANT: vk-access-token
"03f8282439cf3db6a309a7a63fe0367b9e5957b5bbeb61bd14f826708968abc9897851018d7ece3216f26"

: query-lastfm ( params -- xml )
    lastfm-apikey "api_key" rot ?set-at
    assoc>query "http://ws.audioscrobbler.com/2.0/?" swap 2array concat
    http-get nip string>xml ;

: query-vk ( params method -- result )
    "https://api.vk.com/method/" 2array reverse ".xml?" suffix
    swap
    vk-access-token "access_token" rot ?set-at assoc>query
    suffix concat
    http-get nip string>xml ;

: recent-tracks-xml ( user -- recent-tracks-xml )
    "user" H{ { "method" "user.getrecenttracks" } } ?set-at
    query-lastfm "recenttracks" tag-named "track" tags-named ;

: recent-tracks ( user -- strings )
    recent-tracks-xml [
        [ "artist" tag-named children>string ]
        [ "name" tag-named children>string ]
        bi 2array
    ] map
    ;

: vk-get-song-url ( artist song  -- url )
    2array " - " join
    "q" f ?set-at "audio.search" query-vk
    "audio" tags-named
    [ "url" tag-named children>string ] map
    first
    ;

: mpd-clear ( -- )
    "mpc clear" system drop ;

: mpd-play ( -- )
    "mpc play" system drop ;

: mpd-add ( location -- )
    "mpc add %s" sprintf system drop ;

: add-song ( artist song -- )
    vk-get-song-url mpd-add ;

: add-recent-user-songs ( user n -- )
    swap
      recent-tracks >vector dup
      [ shorten ] dip
    [ first2 add-song ] each ;


: main ( -- )
    mpd-clear
      (command-line) ?first dup "kachuchu" ?
      (command-line) ?second dup "2" ? string>number 
    add-recent-user-songs
    mpd-play ;

MAIN: main