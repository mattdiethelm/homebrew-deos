class DeosBinutilsGcc461 < Formula
  desc "FSF Binutils for Deos development using GCC 4.6.1."
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.21.1.tar.bz2"
  mirror "http://localhost/binutils-2.21.1.tar.bz2"
  sha256 "cdecfa69f02aa7b05fbcdf678e33137151f361313b2f3e48aba925f64eabf654"

  depends_on "gnu-sed" => :build

  bottle do
    root_url "http://localhost"
    sha256 "2bda351a1a2d35408bfd220c0fe60e86a05378553d8629d33af7cb5212cb1f0e" => :sierra
  end

  # Binutils makefile expects GNU sed syntax not supported by macOS
  # 'sed'.  Easiest hack is to patch makefile to call 'gsed' instead.
  patch  :DATA

  # The targets we want to build for.
  CROSS_TARGETS = %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ]

  # Build and install a binutils instance for each target.
  def install
    for t in CROSS_TARGETS
      mkdir "#{t}" do
        system "../configure",
               "--srcdir=../",
               "--target=#{t}",
               "--prefix=#{prefix}",
               "--disable-nls"
        system "make", "all", "ERROR_ON_WARNING=no"
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

__END__
--- binutils-2.21.1/binutils/Makefile.in	2011-06-27 00:39:08.000000000 -0700
+++ binutils-2.21.1.patched/binutils/Makefile.in	2015-01-31 06:31:38.000000000 -0700
@@ -1295,7 +1295,7 @@ bin2c$(EXEEXT_FOR_BUILD): bin2c.c
 	$(CC_FOR_BUILD) -o $@ $(AM_CPPFLAGS) $(AM_CFLAGS) $(CFLAGS_FOR_BUILD) $(LDFLAGS_FOR_BUILD) $(srcdir)/bin2c.c
 
 embedspu: embedspu.sh Makefile
-	sed "/^program_transform_name=/cprogram_transform_name=$(program_transform_name)" < $< > $@
+	gsed "/^program_transform_name=/cprogram_transform_name=$(program_transform_name)" < $< > $@
 	chmod a+x $@
 
 # We need these for parallel make.
