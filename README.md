This is persistent variable cache for GNU Make. It allows to store values between runs.

The idea is as follows:

```make
# let's build Gtk application
hello_gtk : hello_gtk.o
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@
%.o : %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

# hide shell invocation into *recursive* variable
CFLAGS += $(shell pkg-config gtk4 --cflags)
LDLIBS += $(shell pkg-config gtk4 --libs)

# override from cache or expand once
sorted@cache = CFLAGS LDLIBS
include cache.mk
```

Then `make` creates file named .make.cache (or whatever is the value of `file@cache`
variable) in the first run. In subsequent runs the variables are read from cache file and
no shell command is executed.

If you need to rebuild cache file then pass -B option, e.g., `make -B .make.cache`.
