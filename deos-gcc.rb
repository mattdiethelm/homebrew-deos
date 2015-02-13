class DeosGcc < Formula
  homepage ""
  url "http://localhost/deos-gcc.tar.bz2"
  version "4.6.1"
  sha1 "7774789818fac99122a3cc92c76f0b016fa9428d"

  # {prefix}/opt/gnu-sed/bin will get added to PATH used when
  # install() runs.  That's a Good Thing as part of our build from
  # source needs gsed rather than OS X sed.
  depends_on "gnu-sed" => :build

  depends_on "wget" => :build
  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc" => :build
  
  #keg_only "We need Deos gcc tools only when building Deos apps."

  def install
    system "make", "binaries" #TODO Set PREFIX!
  end

  test do
    # We assume the compilers built successfully if each target's gcc compiler  can be invoked.
    test_string = ""
    %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ].each { | t | test_string << "#{bin}/#{t}-gcc --version; "}
    system test_string
  end
end
