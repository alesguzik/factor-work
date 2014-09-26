USING: ;
IN: simulation
: random-game ( start range number-of-games -- game-results ) iota swap '[ drop 0 _ uniform-random-float ] map swap '[ _ + ] map ;
: count-actual-wins ( game1 game2 -- percent ) [ < ] 2map [ length ] keep [ ] filter length swap / 1.0 * ;
: game-10 ( start -- result ) 10 100000 random-game ;
: 2-games-with-diff ( diff -- game1 game2 ) game-10 0 game-10 swap ;
: count-my-function ( game1 game2 -- value ) [ natural-sort ] dip [ ] inv-sort-with count-actual-wins ;
: abcd ( game1 game2 -- a b c d ) { [ a ] [ b ] [ c ] [ d ] } 2cleave ;
:: my-f2 ( a b c d -- value ) a d + b c + 2 / + a b + c + d + / 1.0 * ;
: results ( delta -- actual parallel cross ) 2-games-with-diff { [ count-actual-wins ] [ abcd my-f2 ] [ count-my-function ] } 2cleave ;
: main ( -- ) 5 results . . .
MAIN: main
