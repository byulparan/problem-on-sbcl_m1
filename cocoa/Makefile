TARGET= librun-cocoa.dylib

all:  $(TARGET)

$(TARGET): run-cocoa.m
	clang -shared -o $(TARGET) run-cocoa.m -framework Cocoa

clean:
	rm -f $(TARGET)
