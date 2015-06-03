stub: $(SAPI_STUB_PATH)

$(SAPI_STUB_PATH): $(PHP_GLOBAL_OBJS) $(PHP_BINARY_OBJS) $(PHP_STUB_OBJS)
	$(BUILD_STUB)

install-stub: $(SAPI_STUB_PATH)
	@echo "Installing PHP STUB binary:        $(INSTALL_ROOT)$(bindir)/"
	@$(mkinstalldirs) $(INSTALL_ROOT)$(bindir)
	@$(INSTALL) -m 0755 $(SAPI_STUB_PATH) $(INSTALL_ROOT)$(bindir)/$(program_prefix)stub$(program_suffix)$(EXEEXT)
	@echo "Installing PHP STUB man page:      $(INSTALL_ROOT)$(mandir)/man1/"
	@$(mkinstalldirs) $(INSTALL_ROOT)$(mandir)/man1
	@$(INSTALL_DATA) sapi/stub/stub.1 $(INSTALL_ROOT)$(mandir)/man1/$(program_prefix)stub$(program_suffix).1

