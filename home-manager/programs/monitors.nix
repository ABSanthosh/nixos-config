{ config, ... }: {
  home.file.".config/monitors.xml" = {
    force = true;
    text = ''
      <monitors version="2">
        <configuration>
          <logicalmonitor>
            <x>0</x>
            <y>0</y>
            <scale>2</scale>
            <primary>yes</primary>
            <monitor>
              <monitorspec>
                <connector>eDP-1</connector>
                <vendor>AUO</vendor>
                <product>0x31eb</product>
                <serial>0x00000000</serial>
              </monitorspec>
              <mode>
                <width>3840</width>
                <height>2160</height>
                <rate>60.002</rate>
              </mode>
            </monitor>
          </logicalmonitor>
          <logicalmonitor>
            <x>961</x>
            <y>2160</y>
            <scale>2</scale>
            <transform>
              <rotation>right</rotation>
              <flipped>no</flipped>
            </transform>
            <monitor>
              <monitorspec>
                <connector>HDMI-4</connector>
                <vendor>unknown</vendor>
                <product>unknown</product>
                <serial>unknown</serial>
              </monitorspec>
              <mode>
                <width>1080</width>
                <height>1920</height>
                <rate>60.702</rate>
              </mode>
            </monitor>
          </logicalmonitor>
        </configuration>
      </monitors>
    '';
  };
}
