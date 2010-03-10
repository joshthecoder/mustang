all: mustang/*.ooc
	mkdir -p bin
	ooc mustang/mustang.ooc -o=bin/mustang

clean:
	rm -rf bin

install:
	cp bin/mustang /usr/bin
