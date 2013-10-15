build_dir="/tmp/pvconv-build"
distro="/tmp/pvconv.tar.gz"

cpan_client 'ExtUtils::MakeMaker' do
  user "root"
  group "root"
  dry_run true
  install_type "cpan_module"
  action :install
end

remote_file distro do
  source node['pvconv']['download_url']
  not_if { ::File.exists?(distro) }
end

bash "prep-build-dir" do
  code "rm -rf #{build_dir} && mkdir #{build_dir} && " +
       "cd #{build_dir} && tar xfz #{distro}"
end

bash "build-and-install" do
   user "root"
   cwd build_dir
   code "cd pvconv-* && perl Makefile.PL && make && make install"
end

bash "tidy-build" do
  user "root"
  code "rm -rf #{build_dir}"
end
