configure_project_root = File.expand_path('../..')
configure_mrbgem_dir = File.expand_path("#{configure_project_root}/mrbgems")


MRuby::Build.new do |conf|
  # load specific toolchain settings
  conf.toolchain :clang
  #conf.toolchain

  disable_lock # disables being stuck on a single commit

  # -- CORE GEMS --
  conf.gembox "stdlib"
  conf.gembox "stdlib-ext"
  conf.gembox "math"
  conf.gembox "metaprog"
  #conf.gembox "stdlib-io"

  # Use standard IO/File class
  conf.gem :core => "mruby-io"

  # TODO: this gem doesnt current work
  # with windows export
  #conf.gem :core => "mruby-socket"

  # Use standard print/puts/p
  conf.gem :core => "mruby-print"

  # Generate mrbc command
  conf.gem :core => "mruby-bin-mrbc"

  # Generate mirb command
  conf.gem :core => "mruby-bin-mirb"

  # Generate mruby command
  conf.gem :core => "mruby-bin-mruby"

  # Generate mruby-strip command
  conf.gem :core => "mruby-bin-strip"

  # Generate mruby-config command
  conf.gem :core => "mruby-bin-config"

  # -- POTENTIAL GEMS --
  # gems that we may want incorperated

  # Simple Http
  #conf.gem :git => 'https://github.com/matsumotory/mruby-simplehttp'

  # Memory Profiler
  #conf.gem :git => 'https://github.com/iij/mruby-memprof'

  # Testing Framework
  #conf.gem :git => 'https://github.com/iij/mruby-mtest'

  # Regex
  #conf.gem :git => 'https://github.com/iij/mruby-regexp-pcre'

  # JSON
  #conf.gem :git => 'https://github.com/iij/mruby-iijson'

  # Dir
  #conf.gem :git => 'https://github.com/iij/mruby-dir'

  # -- YOUR GEMS --
  # gems added into the mrbgems directory

  Dir.each_child(configure_mrbgem_dir) do |mrb_gem|
    conf.gem "#{configure_mrbgem_dir}/#{mrb_gem}"
  end

  # ---

  # C compiler settings
  conf.cc do |cc|
    cc.command = 'zig cc -target native -O2'
    cc.include_paths << ["#{configure_project_root}/vendor/tux/include"]
  end

  # Linker settings
  conf.linker do |linker|
    #linker.command = ENV['LD'] || 'gcc'
    linker.command = 'zig c++ -target native -O2'
    linker.flags << ['-lraylib -lGL -lm -lpthread -ldl -lrt -lX11']
    linker.library_paths << ["#{configure_project_root}/vendor/tux/lib"]
  end

  conf.cxx.command = 'zig c++ -target native -O2'

  # Turn on `enable_debug` for better debugging
  # conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
