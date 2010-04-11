OOC?=ooc

all: mustang/*.ooc
	mkdir -p bin
	${OOC} mustang/mustang.ooc -o=bin/mustang

clean:
	rm -rf bin

manpages:
	ronn -b man/*.ronn --roff --html

install:
	cp bin/mustang /usr/bin
	cp man/*.1 /usr/local/man/man1
