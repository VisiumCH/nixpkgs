{ stdenv, autoreconfHook, pkgconfig, SDL2, SDL2_mixer, SDL2_net, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "chocolate-doom";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "chocolate-doom";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1zlcqhd49c5n8vaahgaqrc2y10z86xng51sbd82xm3rk2dly25jp";
  };

  postPatch = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL2 SDL2_mixer SDL2_net ];
  enableParallelBuilding = true;

  meta = {
    homepage = http://chocolate-doom.org/;
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    hydraPlatforms = stdenv.lib.platforms.linux; # darwin times out
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
