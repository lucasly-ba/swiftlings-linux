BINDIR := $(HOME)/.local/bin

.DEFAULT_GOAL := build
.PHONY: build install uninstall test clean

build:
	swift build -c release

install: build
	mkdir -p $(BINDIR)
	cp .build/release/swiftlings $(BINDIR)/swiftlings
	@echo "Installed to $(BINDIR)/swiftlings"
	@echo "Make sure $(BINDIR) is on your PATH."

uninstall:
	rm -f $(BINDIR)/swiftlings

test:
	swift test

clean:
	swift package clean
