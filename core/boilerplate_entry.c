#include "mruby.h"
#include "mruby/irep.h"
#include "bytecode.h"

int main() {
  mrb_state *mrb = mrb_open();
  if (!mrb) { /* handle error */ }
  mrb_load_irep(mrb, bytecode);
  mrb_close(mrb);
  return 0;
}
