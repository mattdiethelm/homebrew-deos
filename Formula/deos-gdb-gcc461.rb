class DeosGdbGcc461 < Formula
  desc "FSF GNU gdb for Deos development using GCC 4.6.1."
  url "https://ftp.gnu.org/gnu/gdb/gdb-7.7.tar.bz2"
  mirror "http://localhost/gdb-7.7.tar.bz2"
  sha256 "0404d1c6ee6b3ddd811722b5197944758d37b4591c216030effbac204f5a6c23"
  
  bottle do
    root_url "http://localhost"
    sha256 "9eec533690177c873dee0436f904a6a71d8f1ad6e09edf2c2f5acb88215e8b28" => :sierra
  end
 
  # The targets we want to build for.
  CROSS_TARGETS = %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ]

  # Build and install an instance for each target.
  def install
    for t in CROSS_TARGETS
      mkdir "#{t}" do
        system "../configure",
               "--srcdir=../",
               "--target=#{t}",
               "--prefix=#{prefix}",
               "--disable-sim"
        system "make", "all", "ERROR_ON_WARNING=no"
        system "make", "install"
      end
    end

    # Remove items conflicting with binutils
    rm_rf share/"info"

  end

  test do
    # We assume build was successful if each target's instance can be invoked.
    test_string = ""
    CROSS_TARGETS.each { | t | test_string << "#{bin}/#{t}-gdb --version; "}
    system test_string
  end
end
