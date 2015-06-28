-module(geometry).
-export([area/1]).

area({rectangle, Width, Height}) -> Width * Height;
area({square, Side}) -> Side * Side;
area({circle, Radius}) ->
    PI = 3.14,
    PI * Radius * Radius;
area({right_triangle, W, H}) -> W * H / 2.0.
