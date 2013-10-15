#
# Cookbook Name:: pvconv
# Recipe:: default
#
# Copyright (c) 2013, The University of Queensland
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the The University of Queensland nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF QUEENSLAND BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

perl_site_bin = /.*'(.*)';/.match(`perl -V:installsitebin`)[1]
pvconv_bin = "#{perl_site_bin}/pvconv.pl"
node['pvconv']['command'] = pvconv_bin

if ::File.exists?( pvconv_bin ) then
  return
end

include_recipe "cpan::bootstrap"

build_dir="/tmp/pvconv-build"
distro="/tmp/pvconv.tar.gz"

cpan_client 'ExtUtils::MakeMaker' do
  user "root"
  group "root"
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
perl_site_bin
  code "rm -rf #{build_dir}"
end
