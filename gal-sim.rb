require 'formula'

class GalSim < Formula
  homepage 'https://github.com/GalSim-developers/GalSim'
  url 'https://github.com/GalSim-developers/GalSim/zipball/v0.3'
  sha1 '5215bb6fdb07fe0bafb1c3036006c1ac29900351'
  head 'https://github.com/GalSim-developers/GalSim.git'

  depends_on 'scons' => :build
  depends_on 'fftw'
  depends_on 'boost'
  depends_on 'tmv-cpp'

  def install
    # This ought to be part of a standard homebrew install;
    # required so that homebrew creates symlinks
    #   lib/pythonX.Y/galsim -> Cellar/gal-sim/0.2/lib/pythonX.Y/galsim
    # rather than
    #   lib/pythonX.Y -> Cellar/gal-sim/0.2/lib/pythonX.Y
    pyver = ''
    IO.popen("python -c 'import sys; print sys.version[:3]'") {|pv_io|
        pyver = pv_io.read.strip
    }
    ohai "Python version is *#{pyver}*"
    mkdir_p "#{HOMEBREW_PREFIX}/lib/python#{pyver}"

    system "scons"
    system "scons install PREFIX=#{prefix} PYPREFIX=#{lib}/python#{pyver}"

    ohai ""
    ohai "The GalSim installer may warn you that #{lib}/python isn't in your python search path."
    ohai "You may want to add all Homebrew python packages to the default paths by running:"
    ohai "   sudo bash -c 'echo \"/usr/local/lib/python\" >> \\\\"
    ohai "     /Library/Python/#{pyver}/site-packages/homebrew.pth'"
    ohai "Which will create the file   /Library/Python/#{pyver}/site-packages/homebrew.pth"
    ohai "with contents:"
    ohai "  /usr/local/lib/python#{pyver}"
    ohai ""
  end
end
