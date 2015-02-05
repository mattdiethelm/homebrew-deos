class DeosGcc < Formula
  homepage ""
  url "http://localhost/gcc-4.6.1.tar.bz2"
  version "4.6.1"
  sha1 "a5ed86840d701ec0492cca7651ff98878471f3ea"

  depends_on "deos-gcc-binutils" => :build
  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc" => :build
  
  keg_only "We need Deos gcc tools only when building Deos apps."

  bottle do
    root_url "http://localhost"
    sha1 "f955a05f0407cd7ebb5c5b2af4c3c30b4c8735cb" => :yosemite
  end

  # There were some latent bugs in GCC 4.6.1 that only show up when
  # compiling with GCC 4.7 or newer.  These patches fix those build
  # bugs.  Hopefully they don't have any runtime incompatibilities.

  # This only applies to GCC 4.6.1 & 4.6.2.  See
  # http://gcc.gnu.org/bugzilla/show_bug.cgi?id=51969
  patch :p0 do
    url "http://localhost/gengtype.c.patch"
    sha1 "c8110d854b0a61f6e1ad5524c87aebbddb1d5deb"
  end
  
  @@CROSS_TARGETS = %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ]

  def install

    # Repeat for target.
    @@CROSS_TARGETS.each do | target |
      # Record all files and directories.
      before = Dir.glob(File.join("**","*"))  # Assume we are in buildpath

      system "./configure", "--target=#{target}",
        "--prefix=#{prefix}",
        "--disable-nls",
        "--enable-languages=c,c++",
        "--without-headers",
        "--with-mpfr=#{HOMEBREW_PREFIX}",
        "--with-mpc=#{HOMEBREW_PREFIX}",
        "--with-gmp=#{HOMEBREW_PREFIX}",
        "--with-libiconv-prefix=#{HOMEBREW_PREFIX}"
      system "make", "all-gcc"
      system "make", "install-gcc"
      
      # Make another inventory of all files and directories.
      after = Dir.glob(File.join("**","*"))

      # Return to state just prior to configure, make all, make install
      ohai "Deleting configure and build litter."
      FileUtils.rm_rf( (after - before) )
    end

  end

  test do
    # We assume the compilers built successfully if each target's gcc compiler  can be invoked.
    test_string = ""
    @@CROSS_TARGETS.each { | t | test_string << "#{bin}/#{t}-gcc --version; "}
    system test_string
  end
end
