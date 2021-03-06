{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, substituteAll
, pkgconfig
, vala
, libgee
, granite
, gtk3
, libxml2
, switchboard
, tzdata
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-datetime";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-qgsU3NXqH7ryUah7rEnUrsbecV4AsOo4QfgTcWc5bc4=";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Date & Time Plug";
    homepage = https://github.com/elementary/switchboard-plug-datetime;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
