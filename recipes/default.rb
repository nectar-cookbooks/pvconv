build_dir="/tmp/pconv-build"
distro="/tmp/pconv.tar.gz"

remote_file distro do
  source node['pvconv']['download_url']
end

bash "prep-build-dir" do
  code "rm -rf #{build_dir} && mkdir #{build_dir} && " +
       "cd #{build_dir} && tar xfz #{distro}"
end

bash "build-and-install" do
   user "root"
   cwd build_dir
   code "perl Makefile.PL && make && make install"
end

bash "tidy-build" do
  user "root"
  code "rm -rf #{build_dir}"
end
