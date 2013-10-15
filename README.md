Overview
========

This cookbook downloads, builds and installs the 'pconv' Bruker image 
converter.  The installation location is the default for Perl as given
by "perl -V:installbin".

Dependencies
============

The converter is a Perl command-line utility

Attributes
==========

See `attributes/default.rb` for the default values.

* `node['pvconv']['download_url']` - The URL to fetch the source distro from.

TO_DO List
==========

Make the installation location configurable.
