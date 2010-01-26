require 'radrails'

command "Update" do |cmd|
  cmd.input = :none
  cmd.output = :show_as_tooltip
  cmd.invoke do
    str = ""
    bundles_dir = File.expand_path("~/Documents/RadRails Bundles")
    Dir.chdir(bundles_dir)  # Go to bundles root dir
    Dir.glob("*.ruble").each do |filename|
      bundle_dir = File.join(bundles_dir, filename)
      bundle_dir = File.readlink(bundle_dir) if File.symlink?(bundle_dir)
      Dir.chdir(bundle_dir) do |dir|
        IO.popen("git pull", 'r') {|io| str << io.read } if File.exists?(File.join(dir, ".git"))
        IO.popen("svn update", 'r') {|io| str << io.read } if File.exists?(File.join(dir, ".svn"))
      end
    end
    str
  end
end