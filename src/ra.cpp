#include <cstdlib>
#include <CGAL/CORE_Expr.h>

using CE = CORE::Expr;
using real_t = CORE::Expr*;

extern "C" {

real_t ra_from_int(int i) {
	return new CE(i);
}

real_t ra_from_rat(int p, unsigned int q) {
	return new CE(CE(p) / CE(q));
}

real_t ra_from_double(double d) {
	return new CE(d);
}

void ra_destroy(real_t r) {
	delete r;
}

real_t ra_add(real_t r, real_t s) {
	return new CE(*r + *s);
}

real_t ra_sub(real_t r, real_t s) {
	return new CE(*r - *s);
}

real_t ra_neg(real_t r) {
	return new CE(-*r);
}

real_t ra_mul(real_t r, real_t s) {
	return new CE(*r * *s);
}

real_t ra_div(real_t r, real_t s) {
	return new CE(*r / *s);
}

real_t ra_root(real_t r, int k) {
	return new CE(CGAL::kth_root(k, *r));
}

real_t ra_pow(real_t r, int k) {
	auto s = CE(1);
	while (k < 0) {
		s /= *r;
		k++;
	}
	while (k > 0) {
		s *= *r;
		k--;
	}
	return new CE(s);
}

int ra_sign(real_t r) {
	return CGAL::sign(*r);
}

int ra_compare(real_t r, real_t s) {
	return CGAL::compare(*r, *s);
}

/* absprec and relprec define absolute and relative precision as exponents
 * 2^(-absprec) and 2^(-relprec)! Both requirements are satisfied. */
char* ra_approx(real_t r, unsigned int absprec, unsigned int relprec) {
	auto q = r->approx(relprec, absprec).BigRatValue();
	auto s = q.get_str();
	char* qs = (char*) calloc(1, s.length() + 1);
	s.copy(qs, s.length());
	return qs;
}

}
