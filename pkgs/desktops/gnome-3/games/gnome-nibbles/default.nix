{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gsound, clutter-gtk, gettext, itstool, vala, python3
, libxml2, libgee, libgnome-games-support, meson, ninja
, desktop-file-utils, hicolor-icon-theme}:

stdenv.mkDerivation rec {
  pname = "gnome-nibbles";
  version = "3.34.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rh4c39gbgr2m5gfmfphymmjipywh1pcxr648lgkddfbbp3r4g7a";
  };

  nativeBuildInputs = [
    meson ninja vala python3
    pkgconfig wrapGAppsHook gettext itstool libxml2
    desktop-file-utils hicolor-icon-theme
  ];
  buildInputs = [
    gtk3 librsvg gsound clutter-gtk gnome3.adwaita-icon-theme
    libgee libgnome-games-support
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome3.gnome-nibbles";
    };
  };

  meta = with stdenv.lib; {
    description = "Guide a worm around a maze";
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
