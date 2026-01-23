{ ... }:
{
  home.file.".config/yazi/yazi.toml" = {
    # Overwrite the file
    force = true;
    text = ''
      [plugin]
      prepend_previewers = [
      	{ mime = "image/tiff", run = "magick" },
      ]
    '';
  };
}
