configure_project_root = '..'
configure_mrbgem_dir = "#{configure_project_root}/mrbgems"


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

  # -- YOUR GAMES --
  # gems added into the mrbgems directory

  Dir.each_child(configure_mrbgem_dir) do |mrb_gem|
    conf.gem mrb_gem
  end

  # ---

  # C compiler settings
  conf.cc do |cc|
    cc.command = 'zig cc -target native -O2'
  end

  # Linker settings
  conf.linker do |linker|
    #linker.command = ENV['LD'] || 'gcc'
    linker.command = 'zig c++ -target native -O2'
  end

  conf.cxx.command = 'zig c++ -target native -O2'

  conf.cc do |cc|
    cc.include_paths << ["#{configure_project_root}/vendor/tux/include"]
  end
  conf.linker do |linker|
    linker.flags << ['-lraylib -lGL -lm -lpthread -ldl -lrt -lX11']
    linker.library_paths << ["#{configure_project_root}/vendor/tux/lib"]
  end

  # Turn on `enable_debug` for better debugging
  # conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
=begin
MRuby::CrossBuild.new("tux") do |conf|
  conf.toolchain :clang

  # Use mrbgems
  disable_lock # disables being stuck on a single commit
  # conf.gem 'examples/mrbgems/ruby_extension_example'
  # conf.gem 'examples/mrbgems/c_extension_example' do |g|
  #   g.cc.flags << '-g' # append cflags in this gem
  # end
  # conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
  # conf.gem :core => 'mruby-eval'
  # conf.gem :mgem => 'mruby-onig-regexp'
  # conf.gem :github => 'mattn/mruby-onig-regexp'
  conf.gem :core => 'mruby-bin-mirb'
  conf.gem :git => 'git@github.com:realtradam/sample-mruby-gem.git', :branch => 'test', :options => '-v'

  # include the GEM box
  #conf.gembox 'default'
  conf.gembox "stdlib"
  conf.gembox "stdlib-ext"

  #conf.gembox "stdlib-io"
  # Use standard print/puts/p
  conf.gem :core => "mruby-print"
  # Use standard IO/File class
  conf.gem :core => "mruby-socket"
  # Use standard IO/File class
  conf.gem :core => "mruby-io"

  conf.gembox "math"
  conf.gembox "metaprog"
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


  conf.cc do |cc|
    cc.command = 'zig cc -target x86_64-linux-gnu'
    cc.include_paths = ["#{root}/include", '../raylib/src']
  end


  conf.linker do |linker|
    linker.command = 'zig cc -target x86_64-linux-gnu'
    linker.flags = ['-lraylib -lOpenGL -lrt -ldl -lm -X11 -lpthread' ]
    linker.library_paths = ['../raylib_lib_files']
  end

  conf.cxx.command = "zig c++ -target x86_64-linux-gnu"
end
=end
=begin
MRuby::CrossBuild.new("win") do |conf|
  conf.toolchain :clang

  disable_lock # disables being stuck on a single commit

  # include the GEM box
  conf.gembox 'felflame'

  conf.host_target = "x86_64-w64-mingw32"

  conf.cc do |cc|
    cc.command = 'zig cc -target x86_64-windows-gnu'
    cc.include_paths = ["#{root}/include", '../raylib/src']
  end


  conf.linker do |linker|
    linker.command = 'zig cc -target x86_64-windows-gnu'
    linker.flags = ['-lraylib -lwinmm -lgdi32 -lopengl32' ]
    linker.library_paths = ['../raylib_lib_files']
  end

  conf.cxx.command = "zig c++ -target x86_64-windows-gnu"
end
=end
=begin
MRuby::CrossBuild.new("web") do |conf|
  conf.toolchain :clang

  # Use mrbgems
  disable_lock # disables being stuck on a single commit
  #conf.gem :git => 'git@github.com:realtradam/sample-mruby-gem.git', :branch => 'test', :options => '-v'


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

  # -- YOUR GAMES --
  # gems added into the mrbgems directory

  Dir.each_child(configure_mrbgem_dir) do |mrb_gem|
    conf.gem mrb_gem
  end

  # ---

  conf.cc do |cc|
    cc.command = 'emcc'
    cc.flags = ['-std=c99']
  end

  conf.linker do |linker|
    linker.command = 'emcc'
    linker.flags = ["-std=c99 --shell-file #{configure_project_root}/raylib/src/shell.html"]
    linker.library_paths = ['.']
  end

  conf.archiver do |archiver|
    archiver.command = 'emar'
  end

  conf.cxx do |cxx|
    cxx.command = "em++"
  end

  # FelECS
  conf.gem github: 'realtradam/FelECS', path: 'mrbgem'

  # Raylib
  #conf.gem :git => 'git@github.com:realtradam/mruby-raylib.git', :branch => 'master'
  conf.gem '../../mruby-raylib'# do |g|
  conf.cc do |cc|
    cc.include_paths << ["#{configure_project_root}/include", "#{configure_project_root}/vendor/include/raylib"]
    cc.flags << ['-Wall', '-D_DEFAULT_SOURCE', '-Wno-missing-braces', '-Os', '-DPLATFORM_WEB']
  end
  conf.linker do |linker|
    linker.flags << ["-lraylib -Wall -D_DEFAULT_SOURCE -Wno-missing-braces -Os -s USE_GLFW=3 -s TOTAL_MEMORY=67108864 -s FORCE_FILESYSTEM=1"]
    linker.library_paths << ["#{configure_project_root}/raylib/src", "#{configure_project_root}/vendor/lib/web/raylib"]
  end

end
=end
