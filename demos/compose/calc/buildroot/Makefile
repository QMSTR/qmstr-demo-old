#CC = gcc -wrapper $(shell pwd)/wrapper.sh
CC = gcc
DEPS = add.c subtract.c multiply.c devide.c
OBJS := ${DEPS:c=o}
TARGETS := calc calcs
ADDSUB := add.c subtract.c
MULDIV := multiply.c devide.c
PUNKTRECHNUNG := punktrechnung.o

all: strip calcs

.PHONY: strip
strip: calc
	strip -s calc

calcs: libcalc.a
	$(CC) -static main.c -o $@ $^ -ljson-c

calc: libcalc.so
	${CC} main.c -o calc -L. -lcalc -ljson-c

$(PUNKTRECHNUNG): $(MULDIV)
	${CC} -nostartfiles -static-libgcc -fPIC -r -o $@ $^

libcalc.so: $(ADDSUB) $(PUNKTRECHNUNG)
	${CC} -shared -fPIC -o $@ $^

libcalc.a: $(OBJS)
	ar rcs $@ $^

# When building with more than one job this will be issued more than once. This is done on purpose!
${OBJS}: ${DEPS}
	${CC} -c $^

clean:
	rm -rf $(OBJS) $(TARGETS) $(PUNKTRECHNUNG) *.so *.a
