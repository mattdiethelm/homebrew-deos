class DeosKernel < Formula
  homepage ""
  url "http://localhost/deos-kernel-8.3.0-2.tar.bz2"
  version "8.3.0-2"
  sha1 "2e8be75d713e691ee8a694951b78eb53633d18c9"

  def install
    prefix.install Dir["desk/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test deos-kernel`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
