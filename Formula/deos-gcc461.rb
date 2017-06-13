class DeosGcc461 < Formula
  desc "FSF GNU gcc 4.6.1 for Deos development."
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.6.1/gcc-4.6.1.tar.bz2"
  mirror "http://localhost/gcc-4.6.1.tar.bz2"
  sha256 "8eebf51c908151d1f1a3756c8899c5e71572e8469a547ad72a1ef16a08a31b59"

  depends_on "wget" => :build
  depends_on "gmp" => :build
  depends_on "mpfr" => :build
  depends_on "libmpc" => :build

  bottle do
    root_url "http://localhost"
    sha256 "7da0d731b2e928c5783583b37a9aa4fd9d6fb3614f06c970a09fc1ca37708f3f" => :sierra
  end

  # There are syntax errors in GCC 4.6.1 and 4.6.2 that are caught when
  # their sources are compiled with newer compilers.  This patch fixes
  # them. See http://gcc.gnu.org/bugzilla/show_bug.cgi?id=51969.
  patch  :DATA

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
               "--disable-nls",
               "--enable-languages=c,c++",
               "--without-headers",
               "--with-mpfr=#{prefix}",
               "--with-mpc=#{prefix}",
               "--with-gmp=#{prefix}",
               "--with-libiconv-prefix=#{prefix}"
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
--- gcc-4.6.1/gcc/gengtype.c	2012/02/14 23:26:47	184238
+++ gcc-4.6.1/gcc/gengtype.c	2012/02/14 23:31:42	184239
@@ -3594,14 +3594,13 @@
 		  int has_length, struct fileloc *line, const char *if_marked,
 		  bool emit_pch, type_p field_type, const char *field_name)
 {
+  struct pair newv;
   /* If the field reference is relative to V, rather than to some
      subcomponent of V, we can mark any subarrays with a single stride.
      We're effectively treating the field as a global variable in its
      own right.  */
   if (v && type == v->type)
     {
-      struct pair newv;
-
       newv = *v;
       newv.type = field_type;
       newv.name = ACONCAT ((v->name, ".", field_name, NULL));
