require 'formula'

class DeosGccBinutils < Formula
  homepage ""
  url "http://localhost/binutils-2.21.1.tar.bz2"
  version "2.21.1"
  sha1 "525255ca6874b872540c9967a1d26acfbc7c8230"

  # {prefix}/opt/gnu-sed/bin will get added to PATH used when
  # install() runs.  That's a Good Thing as part of our build from
  # source needs gsed rather than OS X sed.
  depends_on "gnu-sed" => :build

  bottle do
    root_url "http://localhost"
    revision 1
    sha1 "f35356abad64fd58b84d87b098a0e510e574baed" => :yosemite
  end

  keg_only "We need Deos gcc tools only when building Deos apps."

  # binutils-2.21.1 invokes 'sed' using constructs not compatible with
  # the Mac sed variant.  We patch the affected invocations to use
  # 'gsed' instead.
  #
  # The 'patch' function will apply the patch that resides after the
  # __END__ statement below.
  patch :DATA
  
  @@CROSS_TARGETS = %w[ arm-eabi i686-pc-elf mips-elf powerpc-motorola-elf ]

  def install

    # Repeat for target.
    @@CROSS_TARGETS.each do | target |
      # Record all files and directories.
      before = Dir.glob(File.join("**","*"))  # Assume we are in buildpath
      
      system "./configure", "--disable-nls", "--target=#{target}", "--prefix=#{prefix}"
      system "make", "all", "ERROR_ON_WARNING=no"
      system "make", "install"
      
      # Make another inventory of all files and directories.
      after = Dir.glob(File.join("**","*"))

      # Return to state just prior to configure, make all, make install
      ohai "Deleting configure and build litter."
      FileUtils.rm_rf( (after - before) )
    end

  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    # We assume binutils built successfully if each target's objdump can be invoked.
    test_string = ""
    @@CROSS_TARGETS.each { | t | test_string << "#{bin}/#{t}-objdump --version; "}
    system test_string
  end

end

__END__
diff -rupN binutils-2.21.1/binutils/Makefile.in binutils-2.21.1.patched/binutils/Makefile.in
--- binutils-2.21.1/binutils/Makefile.in	2011-06-27 00:39:08.000000000 -0700
+++ binutils-2.21.1.patched/binutils/Makefile.in	2015-01-31 06:31:38.000000000 -0700
@@ -1295,7 +1295,7 @@ bin2c$(EXEEXT_FOR_BUILD): bin2c.c
 	$(CC_FOR_BUILD) -o $@ $(AM_CPPFLAGS) $(AM_CFLAGS) $(CFLAGS_FOR_BUILD) $(LDFLAGS_FOR_BUILD) $(srcdir)/bin2c.c
 
 embedspu: embedspu.sh Makefile
-	sed "/^program_transform_name=/cprogram_transform_name=$(program_transform_name)" < $< > $@
+	gsed "/^program_transform_name=/cprogram_transform_name=$(program_transform_name)" < $< > $@
 	chmod a+x $@
 
 # We need these for parallel make.
