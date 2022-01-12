task :build do
  desc "Build game"
  Dir.chdir("mruby") do
    `env MRUBY_CONFIG=build_config/felflame_linux.rb rake`
  end
end

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
