
TARGET= libffitest.dylib

all: $(TARGET)

$(TARGET): ffi-test.c
	clang -shared -o $@ $^ -arch arm64 -arch x86_64

clean:
	rm -f $(TARGET)
