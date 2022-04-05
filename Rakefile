require 'fileutils'

config_root = File.expand_path('.')
config_core = File.expand_path("#{config_root}/core")

config_build_config = File.expand_path("#{config_root}/core/mruby_build.rb")

config_build_raylib_source = File.expand_path("#{config_root}/core/raylib/src")

config_mruby = File.expand_path("#{config_root}/core/mruby")
config_include_mruby = File.expand_path("#{config_mruby}/include")

config_vendor = File.expand_path("#{config_root}/vendor")

config_tux = File.expand_path("#{config_vendor}/tux")
config_tux_include = File.expand_path("#{config_vendor}/tux/include")
config_tux_lib = File.expand_path("#{config_vendor}/tux/lib")

config_web = File.expand_path("#{config_vendor}/web")
config_web_include = File.expand_path("#{config_vendor}/web/include")
config_web_lib = File.expand_path("#{config_vendor}/web/lib")

config_build = File.expand_path("#{config_root}/build")
config_build_temp = File.expand_path("#{config_build}/temp")
config_build_tux = File.expand_path("#{config_build}/tux")
config_build_web = File.expand_path("#{config_build}/web")

config_game = File.expand_path("#{config_root}/game")

namespace :build do

  #@vendor_dir = '../vendor'
  #@include_dir = "#{@vendor_dir}/include"
  #@library_dir = "#{@vendor_dir}/lib"
  #@bytecode_header_path = "../build/temp"
  desc "Build the engine"
  task :mruby do
    Dir.chdir("core/mruby") do
      Dir.mkdir(config_vendor) unless File.exists?(config_vendor)
      #Dir.each_child("build/repos") do |repo_dir|
      #  Dir.each_child("build/repos/#{repo_dir}") do |gem_dir|
      #    puts "Checking updates for: #{gem_dir}"
      #    Dir.chdir("build/repos/#{repo_dir}/#{gem_dir}") do
      #      system('git pull')
      #    end
      #  end
      #end
      system("env MRUBY_CONFIG=#{config_build_config} rake")
      FileUtils.cp("build/web/lib/libmruby.a", "#{config_web_lib}/")
      FileUtils.cp("build/host/lib/libmruby.a", "#{config_tux_lib}/")
      #FileUtils.cp("build/win/lib/libmruby.a", "../vendor/lib/win/mruby/")
    end
  end

  desc "Build Raylib"
  task :raylib do
    Dir.mkdir(config_vendor) unless File.exists?(config_vendor)
    Dir.chdir(config_build_raylib_source) do
      `make clean`
      puts 'building for tux...'
      `make PLATFORM=PLATFORM_DESKTOP`
      puts
    Dir.mkdir(config_tux) unless File.exists?(config_tux)
      puts 'installing, this should prompt you to enter password unless you are already in sudo'
      `sudo DESTDIR=#{config_tux} make install`
      `make clean`
      puts 'building for web...'
      `make PLATFORM=PLATFORM_WEB`
      puts
    Dir.mkdir(config_web) unless File.exists?(config_web)
      puts 'installing, this should prompt you to enter password unless you are already in sudo'
      `sudo DESTDIR=#{config_web} make install`
      `make clean`
    end
  end
  #desc 'Export to single file'
  task :single_file do
    result = ''
    main = File.read("#{config_game}/main.rb")
    tmp = main.lines(chomp: true).select do |line|
      line.include? 'require '
    end
    tmp.each do |file|
      file.delete_prefix!('require ')
      result += "#{File.read("#{config_game}/#{file[1, file.length - 2]}")}\n"
    end

    result += main.lines.reject do |line|
      line.include? 'require '
    end.join

    Dir.mkdir(config_build) unless File.exists?(config_build)
    Dir.mkdir(config_build_temp) unless File.exists?(config_build_temp)
    File.write("#{config_build_temp}/main.rb", result)
  end
  #desc 'Compile the game to bytecode'
  task :bytecode => :single_file do
    Dir.mkdir(config_build) unless File.exists?(config_build)
    Dir.mkdir(config_build_temp) unless File.exists?(config_build_temp)
    Dir.chdir(config_build_temp) do
      system("#{config_mruby}/bin/mrbc -Bbytecode -obytecode.h main.rb")
    end
  end

  desc 'Build the game for web'
  task :web => :bytecode do
    Dir.mkdir(config_build) unless File.exists?(config_build)
    Dir.mkdir(config_build_web) unless File.exists?(config_build_web)
    Dir.chdir(config_game) do
      system("emcc -Os -Wall -I#{config_web_include} -I#{config_include_mruby} -I#{config_build_temp} #{config_core}/boilerplate_entry.c #{config_web_lib}/libmruby.a #{config_web_lib}/libraylib.a -o #{config_build_web}/index.html -s USE_GLFW=3 -DPLATFORM_WEB --preload-file ./assets --shell-file #{config_core}/shell.html -s TOTAL_MEMORY=268435456") # -s ASYNCIFY
    end
  end

  desc 'Build the game for Linux'
  task :tux => :bytecode do
    Dir.mkdir(config_build) unless File.exists?(config_build)
    Dir.mkdir(config_build_tux) unless File.exists?(config_build_tux)
    #Dir.chdir("build/tux") do
    Dir.chdir(config_game) do
      system("zig cc -target native #{config_core}/boilerplate_entry.c -o #{config_build_tux}/game -lGL -lm -lpthread -ldl -lrt -lX11 -I#{config_build_temp} -I#{config_tux_include} -I#{config_include_mruby} #{config_tux_lib}/libmruby.a #{config_tux_lib}/libraylib.a")
    end
    if File.exists?("#{config_game}/assets")
      system("rsync -r #{config_game}/assets #{config_build_tux}") # TODO: maybe get rid of this? copying assets can be costly
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

desc 'Launch the game with the interpreter'
task :playtest => "build:single_file" do
  Dir.chdir("game") do
    system("#{config_mruby}/build/host/bin/mruby #{config_build_temp}/main.rb")
  end
end
task :p => :playtest


namespace :clean do
  desc "Clean the mruby build folders"
  task :mruby do
    Dir.chdir(config_mruby) do
      system('rake deep_clean')
    end
  end
  task :raylib do
    puts 'Not implemented yet'
  end
end
=begin
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
=end

