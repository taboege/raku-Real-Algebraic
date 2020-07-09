unit module Real::Algebraic;

use NativeCall;

constant LIB_RA = %?RESOURCES<libra.so>;

sub ra_from_int    (int32 $i           --> Pointer) is native(LIB_RA) { * }
sub ra_from_rat    (int32 $p, int32 $q --> Pointer) is native(LIB_RA) { * }
sub ra_from_double (num64 $d           --> Pointer) is native(LIB_RA) { * }
sub ra_destroy     (Pointer $r         --> void)    is native(LIB_RA) { * }

sub ra_add     (Pointer $r, Pointer $s --> Pointer) is native(LIB_RA) { * }
sub ra_sub     (Pointer $r, Pointer $s --> Pointer) is native(LIB_RA) { * }
sub ra_neg     (Pointer $r             --> Pointer) is native(LIB_RA) { * }
sub ra_mul     (Pointer $r, Pointer $s --> Pointer) is native(LIB_RA) { * }
sub ra_div     (Pointer $r, Pointer $s --> Pointer) is native(LIB_RA) { * }
sub ra_root    (Pointer $r, int32 $k   --> Pointer) is native(LIB_RA) { * }
sub ra_pow     (Pointer $r, int32 $k   --> Pointer) is native(LIB_RA) { * }

sub ra_sign    (Pointer $r             --> int32)   is native(LIB_RA) { * }
sub ra_compare (Pointer $r, Pointer $s --> int32)   is native(LIB_RA) { * }

sub ra_approx(Pointer $r, uint32 $ap, uint32 $rp --> Str) is native(LIB_RA) { * }

class Real::Algebraic #`(does Real) is export {
    has $.o;

    submethod DESTROY {
        ra_destroy($!o)
    }

    method from-int (Int $i) {
        self.new: o => ra_from_int($i)
    }

    method from-rat (Rat $q) {
        self.new: o => ra_from_rat($q.numerator, $q.denominator)
    }

    method from-num (Num $r) {
        self.num: o => ra_from_double($r)
    }

    method FatRat ($prec is copy = 1e-10) {
        # Convert the 1e-10 style $prec argument to the 2^(-$prec)
        # expected by the library. Ignore the relative precision.
        my $s = ra_approx($!o, $prec.log(½).ceiling, 1);
        my ($nu, $de) = $s.comb(/'-'? \d+/)».Int;
        FatRat.new: $nu, $de // 1
    }

    method Numeric {
        fail "you shouldn't need to Numeric a Real::Algebraic"
    }

    method Str {
        self.FatRat.Str
    }

    method gist {
        self.Str
    }

    method sqrt {
        self.kth-root(2)
    }

    method kth-root (Int $k) {
        self.new: o => ra_root($!o, $k)
    }

    method sign {
        ra_sign($!o)
    }
}

multi postfix:<ra> (Int $x) is export {
    Real::Algebraic.from-int($x)
}

multi postfix:<ra> (Rat $q) is export {
    Real::Algebraic.from-rat($q)
}

multi postfix:<ra> (Num $r) is export {
    Real::Algebraic.from-num($r)
}

multi infix:<+> (Real::Algebraic $r, Real::Algebraic $s) is export {
    Real::Algebraic.new: ra_add($r.o, $s.o)
}

multi prefix:<-> (Real::Algebraic $r) is export {
    Real::Algebraic.new: o => ra_neg($r.o)
}

multi infix:<-> (Real::Algebraic $r, Real::Algebraic $s) is export {
    Real::Algebraic.new: o => ra_sub($r.o, $s.o)
}

multi infix:<*> (Real::Algebraic $r, Real::Algebraic $s) is export {
    Real::Algebraic.new: o => ra_mul($r.o, $s.o)
}

multi infix:</> (Real::Algebraic $r, Real::Algebraic $s) is export {
    Real::Algebraic.new: o => ra_div($r.o, $s.o)
}

multi infix:<**> (Real::Algebraic $r, Int $k) is export {
    Real::Algebraic.new: o => ra_pow($r.o, $k)
}

multi infix:«<=>» (Real::Algebraic $r, Real::Algebraic $s) is export {
    Order(ra_compare($r.o, $s.o))
}

multi infix:<==> (Real::Algebraic $r, Real::Algebraic $s) is export {
    $r <=> $s == Same
}
