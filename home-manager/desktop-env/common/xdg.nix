{ pkgs, ... }:
{
  xdg = {
    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "image/jpeg" = "org.gnome.Loupe.desktop";
        "image/png" = "org.gnome.Loupe.desktop";
        "image/gif" = "org.gnome.Loupe.desktop";
        "image/webp" = "org.gnome.Loupe.desktop";
        "image/tiff" = "org.gnome.Loupe.desktop";
        "image/x-tga" = "org.gnome.Loupe.desktop";
        "image/vnd-ms.dds" = "org.gnome.Loupe.desktop";
        "image/x-dds" = "org.gnome.Loupe.desktop";
        "image/bmp" = "org.gnome.Loupe.desktop";
        "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop";
        "image/vnd.radiance" = "org.gnome.Loupe.desktop";
        "image/x-exr" = "org.gnome.Loupe.desktop";
        "image/x-portable-bitmap" = "org.gnome.Loupe.desktop";
        "image/x-portable-graymap" = "org.gnome.Loupe.desktop";
        "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";
        "image/x-portable-anymap" = "org.gnome.Loupe.desktop";
        "image/x-qoi" = "org.gnome.Loupe.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "image/svg+xml-compressed" = "org.gnome.Loupe.desktop";
        "image/avif" = "org.gnome.Loupe.desktop";
        "image/heic" = "org.gnome.Loupe.desktop";
        "image/jxl" = "org.gnome.Loupe.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";

        "inode/directory" = "org.gnome.Nautilus.desktop";
      };

      associations.added = {
        "x-scheme-handler/http" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "x-scheme-handler/https" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "text/html" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "application/xhtml+xml" = [
          "firefox.desktop"
          "brave-browser.desktop"
        ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
        "image/x-tga" = [ "org.gnome.Loupe.desktop" ];
        "image/vnd-ms.dds" = [ "org.gnome.Loupe.desktop" ];
        "image/x-dds" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/vnd.microsoft.icon" = [ "org.gnome.Loupe.desktop" ];
        "image/vnd.radiance" = [ "org.gnome.Loupe.desktop" ];
        "image/x-exr" = [ "org.gnome.Loupe.desktop" ];
        "image/x-portable-bitmap" = [ "org.gnome.Loupe.desktop" ];
        "image/x-portable-graymap" = [ "org.gnome.Loupe.desktop" ];
        "image/x-portable-pixmap" = [ "org.gnome.Loupe.desktop" ];
        "image/x-portable-anymap" = [ "org.gnome.Loupe.desktop" ];
        "image/x-qoi" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml-compressed" = [ "org.gnome.Loupe.desktop" ];
        "image/avif" = [ "org.gnome.Loupe.desktop" ];
        "image/heic" = [ "org.gnome.Loupe.desktop" ];
        "image/jxl" = [ "org.gnome.Loupe.desktop" ];
        "text/plain" = [
          "brave-browser.desktop"
          "org.gnome.TextEditor.desktop"
        ];
      };
    };

    configFile."gtk-3.0/bookmarks".text = ''
      file:///home/santhosh/Desktop Desktop
      file:///home/santhosh/Pictures Pictures
      file:///home/santhosh/Downloads Downloads
      file:///home/santhosh/Music Music
    '';

    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];

      config = {
        common = {
          default = "wlr";
        };
      };
    };
  };
}
