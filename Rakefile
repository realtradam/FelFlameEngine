require 'fileutils'
namespace :build do
  @vendor_dir = '../../vendor'
  @include_dir = "#{@vendor_dir}/include"
  @library_dir = "#{@vendor_dir}/lib"
  @bytecode_header_path = "../temp"
  desc "Build the engine"
  task :mruby do
    Dir.chdir("mruby") do
      Dir.each_child("build/repos") do |repo_dir|
        Dir.each_child("build/repos/#{repo_dir}") do |gem_dir|
          puts "Checking updates for: #{gem_dir}"
          Dir.chdir("build/repos/#{repo_dir}/#{gem_dir}") do
            system('git pull')
          end
        end
      end
      system('env MRUBY_CONFIG=build_config/felflame_linux.rb rake')
      FileUtils.cp("build/web/lib/libmruby.a", "../vendor/lib/web/mruby/")
      FileUtils.cp("build/host/lib/libmruby.a", "../vendor/lib/tux/mruby/")
      #FileUtils.cp("build/win/lib/libmruby.a", "../vendor/lib/win/mruby/")
    end
  end
  #desc 'Export to single file'
  task :single_file do
    result = ''
    main = File.read('game/main.rb')
    tmp = main.lines(chomp: true).select do |line|
      line.include? 'require '
    end
    tmp.each do |file|
      file.delete_prefix!('require ')
      result += "#{File.read("game/#{file[1, file.length - 2]}")}\n"
    end

    result += main.lines.reject do |line|
      line.include? 'require '
    end.join

    Dir.mkdir("build/temp") unless File.exists?("build/temp")
    File.write('build/temp/main.rb', result)
  end
  #desc 'Compile the game to bytecode'
  task :bytecode => :single_file do
    Dir.mkdir("build/temp") unless File.exists?("build/temp")
    Dir.chdir("build/temp") do
      system("../../mruby/bin/mrbc -Bbytecode -obytecode.h main.rb")
    end
  end
  desc 'Build the game for web'
  task :web => :bytecode do
    Dir.mkdir("build/web") unless File.exists?("build/web")
    Dir.chdir("build/web") do
      system("emcc -Os -Wall -I#{@include_dir}/raylib -I#{@include_dir}/mruby -I#{@bytecode_header_path} #{@vendor_dir}/boilerplate.c #{@library_dir}/web/mruby/libmruby.a #{@library_dir}/web/raylib/libraylib.a -o index.html -s USE_GLFW=3 -DPLATFORM_WEB --preload-file ./assets")
    end
  end
  desc 'Build the game for Linux'
  task :tux => :bytecode do
    Dir.mkdir("build/tux") unless File.exists?("build/tux")
    Dir.chdir("build/tux") do
      system("zig cc -target native #{@vendor_dir}/boilerplate.c -o game -lGL -lm -lpthread -ldl -lrt -lX11 -I#{@bytecode_header_path} -I#{@include_dir}/raylib -I#{@include_dir}/mruby #{@library_dir}/tux/mruby/libmruby.a #{@library_dir}/tux/raylib/libraylib.a")
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

desc 'Launch the game'
task :playtest => "build:single_file" do
  Dir.chdir("build/temp") do
    system("../../mruby/build/host/bin/mruby main.rb")
  end
end
task :p => :playtest


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
