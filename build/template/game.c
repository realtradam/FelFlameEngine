// emcc -s WASM=1 -Os -I ../include/ hello_ruby.c web/lib/libmruby.a -o hello_ruby.js --closure 1

#include <mruby.h>
#include <mruby/compile.h>

	int
main(void)
{
	mrb_state *mrb = mrb_open();
	if (!mrb) { /* handle error */ }
	// mrb_load_string(mrb, str) to load from NULL terminated strings
	// mrb_load_nstring(mrb, str, len) for strings without null terminator or with known length
	mrb_load_string(mrb, "puts 'hello world'");
	mrb_load_string(mrb, "Ye.c_method");
	mrb_close(mrb);
	return 0;
}
