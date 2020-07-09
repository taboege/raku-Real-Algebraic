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

## Go forth

... and extend this module so that it fits more seamlessly into Raku,
if you care. *Someone* should definitely add tests and check for
memory leaks.
