#include <cstdlib>
#include <CGAL/CORE/extLong.h>
#include <CGAL/CORE_Expr.h>

using namespace CORE;

extern "C" {

Expr* ra_from_int(int i) {
	return new Expr(i);
}

Expr* ra_from_rat(int p, unsigned int q) {
	return new Expr(Expr(p) / Expr(q));
}

Expr* ra_from_double(double d) {
	return new Expr(d);
}

void ra_destroy(Expr* r) {
	delete r;
}

Expr* ra_add(Expr* r, Expr* s) {
	return new Expr(*r + *s);
}

Expr* ra_sub(Expr* r, Expr* s) {
	return new Expr(*r - *s);
}

Expr* ra_neg(Expr* r) {
	return new Expr(-*r);
}

Expr* ra_mul(Expr* r, Expr* s) {
	return new Expr(*r * *s);
}

Expr* ra_div(Expr* r, Expr* s) {
	return new Expr(*r / *s);
}

Expr* ra_root(Expr* r, int k) {
	return new Expr(CGAL::kth_root(k, *r));
}

Expr* ra_pow(Expr* r, int k) {
	auto s = Expr(1);
	while (k < 0) {
		s /= *r;
		k++;
	}
	while (k > 0) {
		s *= *r;
		k--;
	}
	return new Expr(s);
}

int ra_sign(Expr* r) {
	return CGAL::sign(*r);
}

int ra_compare(Expr* r, Expr* s) {
	return CGAL::compare(*r, *s);
}

static char* to_string(BigRat q) {
	auto s = q.get_str();
	char* qs = (char*) calloc(1, s.length() + 1);
	s.copy(qs, s.length());
	return qs;
}

/* absprec and relprec define absolute and relative precision as exponents
 * 2^(-absprec) and 2^(-relprec)! Only the weaker one will be satisfied! */
char* ra_approx(Expr* r, unsigned int absprec, unsigned int relprec) {
	return to_string(r->approx(relprec, absprec).BigRatValue());
}

char* ra_approx_abs(Expr* r, unsigned int prec) {
	return to_string(r->approx(CORE_INFTY, prec).BigRatValue());
}

char* ra_approx_rel(Expr* r, unsigned int prec) {
	return to_string(r->approx(prec, CORE_INFTY).BigRatValue());
}

}
