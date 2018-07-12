class BinkdHead < Formula
  desc "Binkd - the binkp daemon"
  head "https://github.com/pgul/binkd.git"

  def install
    cp Dir["mkfls/unix/*"].select { |f| File.file? f }, "."
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ntlm", "--with-bwlim", "--with-perl"
    system "make", "install"
  end
  test do
    system "#{sbin}/binkd", "-v"
  end
end
