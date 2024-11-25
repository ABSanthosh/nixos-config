{ config, ... }: {
  home.file.".config/kitty/kitty.conf" = {
    force = true;
    text = ''
      configuration {
          modi: "drun,run,window";
          font: "SF Pro Display 14";
          show-icons: true;
          icon-theme: "Papirus";
          display-drun: "";
          drun-display-format: "{name}";
          disable-history: false;
          fullscreen: false;
          hide-scrollbar: true;
          sidebar-mode: false;
      }

      window {
          transparency: "real";
          background-color: #00000090;
          text-color: #FFFFFF;
          border: 0px;
          border-color: #000000;
          border-radius: 20px;
          width: 45%;
          location: center;
          x-offset: 0;
          y-offset: 0;
      }

      prompt {
          enabled: false;
          padding: 0.5% 0.5% 0.5% 0%;
          background-color: transparent;
          text-color: #FFFFFF;
          font: "SF Pro Display 14";
      }

      entry {
          background-color: transparent;
          text-color: #FFFFFF;
          placeholder-color: #FFFFFF;
          expand: true;
          horizontal-align: 0;
          placeholder: "Search";
          padding: 0.15% 0% 0% 0%;
          blink: true;
      }

      inputbar {
          children: [ prompt, entry ];
          background-color: transparent;
          text-color: #FFFFFF;
          expand: false;
          border: 0% 0% 0% 0%;
          border-radius: 12px;
          border-color: #404040;
          margin: 0% 0% 0% 0%;
          padding: 1%;
      }

      listview {
          background-color: transparent;
          padding: 10px;
          columns: 1;
          lines: 8;
          spacing: 1%;
          cycle: false;
          dynamic: true;
          layout: vertical;
      }

      mainbox {
          background-color: transparent;
          border: 0% 0% 0% 0%;
          border-radius: 0% 0% 0% 0%;
          border-color: #1e1e1e;
          children: [ inputbar, listview ];
          spacing: 2%;
          padding: 2% 1% 2% 1%;
      }

      element {
          background-color: transparent;
          text-color: #FFFFFF;
          orientation: horizontal;
          border-radius: 12px;
          padding: 1% 0.5% 1% 0.75%;
      }

      element-icon {
          background-color: transparent;
          text-color: inherit;
          size: 32px;
          border: 0px;
      }

      element-text {
          background-color: transparent;
          text-color: inherit;
          expand: true;
          horizontal-align: 0;
          vertical-align: 0.5;
          margin: 0% 0.25% 0% 0.25%;
      }

      element selected {
          background-color: #FFFFFF15;
          text-color: #FFFFFF;
          border: 0% 0% 0% 0%;
          border-radius: 12px;
          border-color: #1e1e1e;
      }

      element.selected.active {
          background-color: #FFFFFF15;
          color: #FFFFFF;
      }
    '';
  };
}
