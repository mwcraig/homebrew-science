require 'formula'

class Wcslib < Formula
  homepage 'http://www.atnf.csiro.au/people/mcalabre/WCS/'
  url 'ftp://ftp.atnf.csiro.au/pub/software/wcslib/wcslib-4.19.tar.bz2'
  sha1 'b8703b59fa97fa7f7d8aff620b0bd695d613b766'

  option 'with-pgsbox', 'Build PGSBOX, a general curvilinear axis drawing routine for PGPLOT'
  option 'with-fortran', "Build Fortran wrappers. Needed for --with-pgsbox."
  option 'check', "Perform `make check`. Note, together --with-pgsbox it will display GUI"

  depends_on 'cfitsio'
  depends_on 'pgplot' if build.include? 'with-pgsbox'
  depends_on :x11 if build.include? 'with-pgsbox'
  depends_on :fortran if build.with? 'fortran' or build.with? 'pgsbox'

  def install
    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--with-cfitsiolib=#{Formula.factory('cfitsio').opt_prefix}/lib",
             "--with-cfitsioinc=#{Formula.factory('cfitsio').opt_prefix}/include" ]

    if build.include? 'with-pgsbox'
      args << "--with-pgplotlib=#{Formula.factory('pgplot').opt_prefix}/lib"
      args << "--with-pgplotinc=#{Formula.factory('pgplot').opt_prefix}/include"
    else
      args << "--without-pgplot"
      args << "--disable-fortran" unless build.with? 'fortran'
    end

    system "./configure", *args

    ENV.deparallelize
    system "make"
    system "make check" if build.include? 'check'
    system "make install"
  end
end
