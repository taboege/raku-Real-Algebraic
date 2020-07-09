use Test;
use Real::Algebraic;

plan 1;
ok (-(8ra).kth-root(4)) ** -4 == (1/8)ra, "4th root of 8";
