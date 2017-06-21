TARGET = update-all
PREFIX = /usr/local/bin

.PHONY: all install uninstall

all:
	@echo "Usage:"
	@echo "sudo make install   - Install $(TARGET) to $(PREFIX)"
	@echo "sudo make uninstall - Remove $(TARGET) from $(PREFIX)"

install:
	install ./$(TARGET) $(PREFIX)

uninstall:
	rm -f $(PREFIX)/$(TARGET)
