.PHONY: all
all: libra.so
	install $< -Dt ../resources

libra.so: ra.cpp
	g++ -std=c++17 -fPIC -shared -ggdb -o $@ $< -l{gmp,CGAL,CGAL_Core,boost_thread}
