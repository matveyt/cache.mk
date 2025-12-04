# cache.mk - GNU Make persistent variable cash
# https://github.com/matveyt/cache.mk
#
# This is free and unencumbered software released into the public domain.

ifeq (,$(strip $(plain@cache) $(sorted@cache) $(unique@cache)))
    $(warning Neither plain@cache nor sorted@cache nor unique@cache was assigned)
endif
ifneq (,$(strip $(foreach v,$(plain@cache) $(sorted@cache) $(unique@cache),\
    $(filter-out recursive,$(flavor $v)))))
    $(warning All cached variables should be recursive)
endif

uniq ?= $(strip $(if $1,$(firstword $1) $(call $0,$(filter-out $(firstword $1),$1))))
file@cache ?= .make.cache
-include $(file@cache)
$(foreach v,$(plain@cache),$(eval $v := $($v)))
$(foreach v,$(sorted@cache),$(eval $v := $(call sort,$($v))))
$(foreach v,$(unique@cache),$(eval $v := $(call uniq,$($v))))

$(file@cache) :
	$(file  >$@,# This file is auto-generated. DO NOT EDIT.)
	$(file >>$@,)
	$(file >>$@,# Unless -B flag specified and no MAKE_RESTARTS)
	$(file >>$@,ifneq (B,$$(findstring B,$$(firstword $$(MAKEFLAGS)))$$(MAKE_RESTARTS)))
	$(foreach v,$(plain@cache) $(sorted@cache) $(unique@cache),$(file >>$@,$v := $($v)))
	$(file >>$@,endif)
