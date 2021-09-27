TARGET= librun-cocoa.dylib

all:  $(TARGET)

$(TARGET): run-cocoa.m
	clang -shared -o $(TARGET) run-cocoa.m -framework Cocoa -arch arm64 -arch x86_64

clean:
	rm -f $(TARGET)
