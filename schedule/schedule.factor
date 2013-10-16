TUPLE: event name date-predicate time place ;
: <event> ( -- event ) \ event new ;
: pair ( n -- time )
    {
        { 1 [ " 8:00 -  9:35" ] }
        { 2 [ " 9:45 - 11:20" ] }
        { 3 [ "11:40 - 13:15" ] }
        { 4 [ "13:25 - 15:00" ] }
        { 5 [ "15:20 - 16:55" ] }
        { 6 [ "17:05 - 18:40" ] }
        [ drop "invalid pair number" ]
    } case ;
