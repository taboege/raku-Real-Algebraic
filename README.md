# Proof of concept for algebraic numbers in Raku

This is the absolute minimum of work to get exact arithmetic with
real algebraic numbers available to Raku programmers. That is, you
can work with a number type that supports the following operations
*exactly*:

  - addition, subtraction, negation: Int goes this far,
  - multiplication, division, integer exponentiation: FatRat goes this far,
  - integer roots and fractional exponentiation: Real::Algebraic needed!

## Installation

The module relies on CGAL's CORE interface and provides a tiny wrapper
in NativeCall-friendly C++. The `Build.pm` file should be executed by
`zef` upon installation and hopefully succeeds in building the wrapper.
You will need to install CGAL, GMP and boost libraries, also `g++` and
`make`.

## Usage

The interface is extremely spartan. You get a `&postfix:<ra>` operator
which converts `Int`, `Rat` or `Num` to a `Real::Algebraic` instance.
This type has arithmetic and some comparison operators overloaded,
as well as some methods.

In particular `kth-root` is a new method. The `FatRat` coercer can be
given an arbitrarily high precision to return for the FatRat.

One thing that demonstrably works in the current version is:

``` raku
my \η = - (8ra).kth-root(4);  # 4th of 8 but negated for good measure
say η ** -4 == (1/8)ra;       # OUTPUT: «True»
say η.FatRat(1e-200).nude;
#= (-1288670006706428342630003269978511434467282678875631749 766247770432944429179173513575154591809369561091801088)
```

This computes the irrational number `8 ** ¼` and then raises it to
the -4th power. The result compares equal to `1/8`, as it should.
Then we compute a FatRat approximation to this irrational number
that is accurate to at least 200 decimal places.

## Go forth

... and extend this module so that it fits more seamlessly into Raku,
if you care. *Someone* should definitely add tests and check for
memory leaks.
