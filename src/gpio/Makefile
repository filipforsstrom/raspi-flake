CC = gcc
bin = ./bin
lib = ./lib
include = ../include

# Target for the main executable
$(bin)/main: main.c | $(bin)
	$(CC) -o $@ $^ -I$(include)

# Target for the shared library
$(lib)/libgpio.so: main.c | $(lib)
	$(CC) -shared -fPIC -o $@ $^ -I$(include)

$(bin):
	mkdir -p $(bin)

$(lib):
	mkdir -p $(lib)

all: $(bin)/main $(lib)/libgpio.so

clean:
	rm -rf $(lib)
	rm -rf $(bin)