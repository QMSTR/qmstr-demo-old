CC = gcc
DEPS = add.c subtract.c multiply.c devide.c
OBJS := ${DEPS:c=o}

all: calc

calc: libcalc.so
	${CC} main.c -o calc -L. -lcalc -ljson-c

libcalc.so: ${OBJS}
	${CC} -shared -o libcalc.so ${OBJS}

# When building with more than one job this will be issued more than once. This is done on purpose!
${OBJS}: ${DEPS}
	${CC} -c $^

clean:
	rm -rf *.o libcalc.so calc
