class Goldedx < Formula
  desc "GoldED+ Fidonet Message Editor"
  homepage "https://github.com/golded-plus/golded-plus"
  head "https://github.com/golded-plus/golded-plus.git"

  def install
    cp "golded3/mygolded.__h", "golded3/mygolded.h"
    inreplace "golded3/mygolded.h", "Put in your full name here", "project2 homebrew"
    inreplace "golded3/mygolded.h", "your Fidonet-AKA", "FidoNet"
    inreplace "golded3/mygolded.h", "your email@address", "rjakub@pm.me"
    inreplace "golded3/mygolded.h", "personal edition", "edition"
    system "make"
    system "make", "strip"
    mv "bin/gedlnx", "bin/golded"
    mv "bin/gnlnx", "bin/goldnode"
    mv "bin/rddtlnx", "bin/rddt"
    bin.install "bin/golded"
    bin.install "bin/goldnode"
    bin.install "bin/rddt"
    man1.install Dir["docs/*.1"]
    (pkgshare).install Dir["cfgs/*"]
  end

end
