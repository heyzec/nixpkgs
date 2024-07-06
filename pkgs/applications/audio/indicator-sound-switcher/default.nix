{ python3Packages
, lib
, fetchFromGitHub
, perlPackages
, gettext
, gtk3
, gobject-introspection
, intltool, wrapGAppsHook, glib
, librsvg
, libayatana-appindicator
, libpulseaudio
, keybinder3
, gdk-pixbuf
, inkscape
, imagemagick
}:

python3Packages.buildPythonApplication rec {
  pname = "indicator-sound-switcher";
  version = "2.3.9";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qJ1lg9A1aCM+/v/JbQAVpYGX25qA5ULqsM8k7uH1uvQ=";
  };

  postPatch = ''
    substituteInPlace lib/indicator_sound_switcher/lib_pulseaudio.py \
      --replace "CDLL('libpulse.so.0')" "CDLL('${libpulseaudio}/lib/libpulse.so')"
  '';

  nativeBuildInputs = [
    gettext
    intltool
    wrapGAppsHook
    glib
    gdk-pixbuf
    gobject-introspection
  ];

  buildInputs = [
    librsvg
  ];

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.pygobject3
    gtk3
    gobject-introspection
    librsvg
    libayatana-appindicator
    libpulseaudio
    keybinder3
  ];

postInstall = ''
    find $out/share/icons -name '*.svg' -exec ${inkscape}/bin/inkscape --actions="select-all;object-rotate-90-cw;object-rotate-90-cw" --export-overwrite "{}" \;

    find $out/share/icons -name '*.png' -exec ${imagemagick}/bin/convert "{}" -fuzz 9% -fill red -opaque black -rotate 90 "{}" \;
'';

  meta = with lib; {
    description = "Sound input/output selector indicator for Linux";
    homepage = "https://yktoo.com/en/software/sound-switcher-indicator/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alexnortung ];
    platforms = [ "x86_64-linux" ];
  };
}
