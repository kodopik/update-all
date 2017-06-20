TARGET = update-all
PREFIX = /usr/local/bin

.PHONY: all install uninstall

all:

install:
	install ./$(TARGET) $(PREFIX)

uninstall:
	rm -f $(PREFIX)/$(TARGET)
