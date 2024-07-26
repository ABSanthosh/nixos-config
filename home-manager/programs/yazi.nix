{ config, ... }:

{
  home.file.".config/yazi/yazi.toml" = {
    # Overwrite the file
    force = true;
    text = ''
      [preview]
      max_width
    '';
  };
}
