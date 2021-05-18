class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_22.tar.gz"
  sha256 "833ab5f51f0f42fd3bc7d71b1fc616b0da5b97d6a421f3cad489a2aeebb2dc7c"
  license "GPL-2.0"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "4721314881382789163f956e5ab1edba62d3984a2d5b2ee714f57ed695ad03a4"
    sha256 big_sur:       "d5870925f8214783c694f3c359d75a816c40f2e76ce0c0e7443357603cd0193e"
    sha256 catalina:      "c3174a08eaeabce252f16224d93fcb1503584ac6b2d7733a6e80eb558cfefee5"
    sha256 mojave:        "4c4dc47fe8af598594c4dd24184f7b5400e383e7649c6f6aa98f1663997b04ec"
    sha256 high_sierra:   "2c8d33eddc1311f098175f2854173bbd4181d9f20fa0d1807950a84198fca6e1"
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "perl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
