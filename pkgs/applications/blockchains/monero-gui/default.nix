{ stdenv, wrapQtAppsHook, makeDesktopItem
, fetchFromGitHub, qmake, qttools, pkgconfig
, qtbase, qtdeclarative, qtgraphicaleffects
, qtmultimedia, qtxmlpatterns
, qtquickcontrols, qtquickcontrols2
, monero, unbound, readline, boost, libunwind
, libsodium, pcsclite, zeromq, libgcrypt, libgpgerror
, hidapi, libusb, protobuf, randomx
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "monero-gui";
  version = "0.16.0.0";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero-gui";
    rev    = "v${version}";
    sha256 = "06vdrsj5y9k0zn32hspyxc7sw1kkyrvi3chzkdbnxk9jvyj8k4ld";
  };

  nativeBuildInputs = [ qmake pkgconfig wrapQtAppsHook ];

  buildInputs = [
    qtbase qtdeclarative qtgraphicaleffects
    qtmultimedia qtquickcontrols qtquickcontrols2
    qtxmlpatterns
    monero unbound readline libgcrypt libgpgerror
    boost libunwind libsodium pcsclite zeromq
    hidapi libusb protobuf randomx
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=format-security" ];

  patches = [ ./move-log-file.patch ];

  postPatch = ''
    echo '
      var GUI_VERSION = "${version}";
      var GUI_MONERO_VERSION = "${getVersion monero}";
    ' > version.js
    substituteInPlace monero-wallet-gui.pro \
      --replace '$$[QT_INSTALL_BINS]/lrelease' '${getDev qttools}/bin/lrelease'
    substituteInPlace src/daemon/DaemonManager.cpp \
      --replace 'QApplication::applicationDirPath() + "' '"${monero}/bin'
  '';

  makeFlags = [ "INSTALL_ROOT=$(out)" ];

  preBuild = ''
    sed -i s#/opt/monero-wallet-gui##g Makefile
    make -C src/zxcvbn-c

    # use nixpkgs monero sources
    rmdir monero
    ln -s "${monero.src}" monero
  '';

  desktopItem = makeDesktopItem {
    name = "monero-wallet-gui";
    exec = "monero-wallet-gui";
    icon = "monero";
    desktopName = "Monero";
    genericName = "Wallet";
    categories  = "Application;Network;Utility;";
  };

  postInstall = ''
    # install desktop entry
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    # install icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/images/appicons/$size.png \
         $out/share/icons/hicolor/$size/apps/monero.png
    done;
  '';

  meta = {
    description  = "Private, secure, untraceable currency";
    homepage     = https://getmonero.org/;
    license      = licenses.bsd3;
    platforms    = platforms.all;
    badPlatforms = platforms.darwin;
    maintainers  = with maintainers; [ rnhmjoj ];
  };
}
