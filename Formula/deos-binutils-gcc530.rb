class DeosBinutilsGcc530 < Formula
  desc "FSF Binutils for Deos development using GCC 5.3.0."
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.bz2"
  mirror "http://localhost/binutils-2.26.tar.bz2"
  sha256 "c2ace41809542f5237afc7e3b8f32bb92bc7bc53c6232a84463c423b0714ecd9"

  bottle do
    root_url "http://localhost"
    sha256 "37cb72de725cb14f7d9ecbc9c2649366222d044d59796b6bc474b67ffb807e55" => :sierra
  end
  
  # The targets we want to build for.
  CROSS_TARGETS = %w[ arm-eabi i686-pc-elf powerpc-motorola-elf ]

  # Build and install a binutils instance for each target.
  def install
    for t in CROSS_TARGETS
      mkdir "#{t}" do
        system "../configure",
               "--with-pkgversion=DDCI_5.3.0",
               "--srcdir=../",
               "--target=#{t}",
               "--prefix=#{prefix}",
               "--enable-languages=c,c++",
               "--disable-nls"
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    #We assume build was successful if each target's linker can be invoked.
    test_string = ""
    CROSS_TARGETS.each { | t | test_string << "#{bin}/#{t}-ld --version; "}
    system test_string
  end
end
