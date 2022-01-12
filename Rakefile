namespace :build do
  desc "Build the engine"
  task :mruby do
    Dir.chdir("mruby") do
      `env MRUBY_CONFIG=build_config/felflame_linux.rb rake`
    end
  end
  desc 'Build the game'
  task :game do
    Dir.chdir("build/temp") do
      `emcc -s WASM=1 -Os -I ../../mruby/include/ ../template/game.c ../../mruby/build/web/lib/libmruby.a -o game.html --closure 1 ../../raylib_lib_files/web/libraylib.a -I ../../raylib/src/ -s USE_GLFW=3`
    end
  end
end

desc "Create a server and open your game in your browser"
task :serve do
  link = "http://localhost:8000/game.html"
  if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
    system "start #{link}"
  elsif RbConfig::CONFIG['host_os'] =~ /darwin/
    system "open #{link}"
  elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
    system "xdg-open #{link}"
  end
  `ruby -run -ehttpd build/temp/ -p8000`
end
task :s => :serve
