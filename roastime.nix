{ lib
, appimageTools
, fetchurl
, udev
, libusb1
}:

let
  pname = "roastime";
  version = "latest"; # Set a specific version if preferred

  src = fetchurl {
    url = "https://api.roast.world/api/v3/roastime/main/lin/x64";
    name = "roastime.AppImage";
    # If the hash changes or mismatches, leave hash = "" or hash = lib.fakeHash
    # to let nix tell you the exact SRI string.
    hash = "sha256-sAG7kPUcfh8wXgbIgyPYFxa8ATMeoeyOoMG76LeDol8=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Include extra libraries needed for hardware communication (USB connection to Bullet)
  extraPkgs = pkgs: [
    udev
    libusb1
  ];

  extraInstallCommands = ''
    # Install desktop file and icons extracted from the AppImage
    install -m 444 -D ${appimageContents}/roastime.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/ 2>/dev/null || true

    # Adjust Exec in desktop file to point to the wrapped binary
    substituteInPlace $out/share/applications/roastime.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=roastime' || true
  '';

  meta = with lib; {
    description = "Roast profile logging software for Aillio Bullet R1";
    homepage = "https://roast.world";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
