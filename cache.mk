# cache.mk - GNU Make persistent variable cash
# https://github.com/matveyt/cache.mk
#
# This is free and unencumbered software released into the public domain.

ifeq (,$(strip $(sorted@cache) $(unsorted@cache)))
    $(warning Neither sorted@cache nor unsorted@cache was assigned)
endif
ifneq (,$(strip $(foreach v,$(sorted@cache) $(unsorted@cache),\
    $(filter-out recursive,$(flavor $v)))))
    $(warning All items in sorted@cache and unsorted@cache should be recursive)
endif

file@cache ?= .make.cache
-include $(file@cache)
$(foreach v,$(sorted@cache),$(eval $v := $(sort $($v))))
$(foreach v,$(unsorted@cache),$(eval $v := $($v)))

$(file@cache) :
	$(file  >$@,# This file is auto-generated. DO NOT EDIT.)
	$(file >>$@,)
	$(file >>$@,# Unless -B flag specified and no MAKE_RESTARTS)
	$(file >>$@,ifneq (B,$$(findstring B,$$(firstword $$(MAKEFLAGS)))$$(MAKE_RESTARTS)))
	$(foreach v,$(sorted@cache) $(unsorted@cache),$(file >>$@,$v := $($v)))
	$(file >>$@,endif)
