namespace :build do
  desc "Build the engine"
  task :mruby do
    Dir.chdir("mruby") do
      system('env MRUBY_CONFIG=build_config/felflame_linux.rb rake')
    end
  end
  desc 'Build the game for web'
  task :web do
    Dir.mkdir("build/web") unless File.exists?("build/web")
    Dir.chdir("build/web") do
      system('emcc -s WASM=1 -Os -I ../../mruby/include/ ../template/game.c ../../mruby/build/web/lib/libmruby.a -o index.html --closure 1 ../../raylib_lib_files/web/libraylib.a -I ../../raylib/src/ -s USE_GLFW=3')
    end
  end
  desc 'Build the game for Linux'
  task :tux do
    Dir.mkdir("build/tux") unless File.exists?("build/tux")
    Dir.chdir("build/tux") do
      system('zig cc -target native ../template/game.c -o game -lGL -lm -lpthread -ldl -lrt -lX11 -I../../mruby/include -I../../raylib/src ../../raylib_lib_files/libraylib.a ../../mruby/build/host/lib/libmruby.a')
    end
  end
  #desc 'Build the game for Window'
  #task :win do
  #  Dir.mkdir("build/win") unless File.exists?("build/win")
  #  Dir.chdir("build/win") do
  #    system('zig cc -target x86_64-windows-gnu ../template/game.c -o game -lwinmm -lgdi32 -lopengl32 -I../../mruby/include -I../../raylib/src ../../raylib_lib_files/raylib.lib ../../mruby/build/host/lib/libmruby.a')
  #  end
  #end
end

namespace :clean do
  desc "Clean the mruby build folders"
  task :mruby do
    Dir.chdir("mruby") do
      system('rake deep_clean')
    end
  end
end

desc "Create a server and open your game in your browser"
task :serve do
  link = "http://localhost:8000/index.html"
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
    system "start #{link}"
  elsif RbConfig::CONFIG['host_os'] =~ /darwin/
    system "open #{link}"
  elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
    system "xdg-open #{link}"
  end
  `ruby -run -ehttpd build/web/ -p8000`
end
task :s => :serve
