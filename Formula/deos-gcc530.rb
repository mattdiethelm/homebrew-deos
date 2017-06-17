class DeosGcc530 < Formula
  desc "FSF GNU gcc 5.3.0 for Deos development."
  url "https://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2"
  mirror "http://localhost/gcc-5.3.0.tar.bz2"
  sha256 "b84f5592e9218b73dbae612b5253035a7b34a9a1f7688d2e1bfaaf7267d5c4db"

  depends_on "wget" => :build
  depends_on "deos-binutils-gcc530" => :build
  
  bottle do
    root_url "http://localhost"
    sha256 "3085232b0475297d75ec8f51924e1b77dd25ed7d2dd053450f4db3ea397a7ceb" => :sierra
  end

  # Apple's clang is used to compile GCC, and it does not like the
  # amount of bracket nesting in some machine description files.  The
  # way around this is to patch in a clang compiler option into the
  # build.
  patch :p0, :DATA

  # The targets we want to build for.
  CROSS_TARGETS = %w[ arm-eabi i686-pc-elf powerpc-motorola-elf ]

  # Build and install an instance for each target.
  def install
    for t in CROSS_TARGETS
      mkdir "#{t}" do
        system "../configure",
               "--srcdir=../",
               "--target=#{t}",
               "--prefix=#{prefix}",
               "--disable-nls",
               "--disable-multilib",
               "--enable-languages=c,c++",
               "--without-headers",
               "--with-pkgversion=DDCI_5.3.0"

        # We want only the compiler to be built.
        system "make", "all-gcc"
        system "make", "install-gcc"
      end
    end
  end

  test do
    # We assume build was successful if each target's instance can be invoked.
    test_string = ""
    CROSS_TARGETS.each { | t | test_string << "#{bin}/#{t}-gcc --version; "}
    system test_string
  end
end

__END__
--- gcc/Makefile.in	2015-05-04 03:46:32.000000000 -0700
+++ /Users/mdiethelm/Documents/Makefile.in	2017-06-16 13:06:27.000000000 -0700
@@ -968,7 +968,7 @@
 # programs built during a bootstrap.
 # autoconf inserts -DCROSS_DIRECTORY_STRUCTURE if we are building a
 # cross compiler which does not use the native headers and libraries.
-INTERNAL_CFLAGS = -DIN_GCC $(PICFLAG) @CROSS@
+INTERNAL_CFLAGS = -fbracket-depth=2048 -DIN_GCC $(PICFLAG) @CROSS@
 
 # This is the variable actually used when we compile. If you change this,
 # you probably want to update BUILD_CFLAGS in configure.ac
