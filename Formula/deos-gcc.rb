class DeosGcc < Formula
  homepage ""
  url "http://localhost/deos-gcc-4.6.1.tar.bz2"
  version "4.6.1"
  sha256 "558a555310fe2748087ac18cb3c9a6f6284654ff50f47b0265ced1d4f8bd6264"

  # {prefix}/opt/gnu-sed/bin will get added to PATH used when
  # install() runs.  That's a Good Thing as part of our build from
  # source needs gsed rather than OS X sed.
  depends_on "gnu-sed" => :build

  depends_on "wget" => :build
  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc" => :build
  
  bottle do
    root_url "http://localhost"
    revision 1
    sha256 "e35fcc531ea0d2667d08691dd4f5307e2edd5859cb9aae0fab400cd9e79a2591" => :yosemite
  end

  def install
    system "make", "binaries", "PREFIX=#{prefix}"
  end

  test do
    # We assume the compilers built successfully if each target's gcc compiler  can be invoked.
    test_string = ""
    %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ].each { | t | test_string << "#{bin}/#{t}-gcc --version; "}
    system test_string
  end
end
