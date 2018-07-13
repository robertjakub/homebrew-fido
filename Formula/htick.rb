class Htick < Formula
  desc "HTick - the Husky Project fileecho ticker"
  homepage "https://github.com/huskyproject/htick"
  head "https://github.com/huskyproject/htick.git"

  depends_on "fidoconf"
  depends_on "areafix"
  depends_on "smapi"

  #patch :DATA
  def install
    inreplace "Makefile", "../huskymak.cfg", "huskymak.cfg"
    system "make"
    bin.install "htick"
    man1.install Dir["man/*.1"]
  end
end
