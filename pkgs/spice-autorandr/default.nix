{ lib, stdenv, fetchFromGitHub, pkg-config, autoconf, automake, libX11, libXrandr }:
stdenv.mkDerivation rec {
  name = "spice-autorandr";
  version = "0.0.2";
  src = fetchFromGitHub {
    owner = "seife";
    repo = name;
    rev = "0f61dc9";
    sha256 = "sha256-eBvzalWT3xI8+uNns0/ZyRes91ePpj0beKb8UBVqo0E=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ autoconf automake libX11 libXrandr ];
  buildPhase = ''
    autoreconf -is
    ./configure
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $name $out/bin/
  '';
  meta = with lib; {
    description = "Automatically adjust the client window resolution in Linux KVM guests using the SPICE driver.";
    longDescription = ''
    '';
    homepage = "https://github.com/seife/spice-autorandr";
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
