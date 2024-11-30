{ ... }: {
  services.swaync = {
    enable = true;

    settings = {
      # General settings
      cssPriority = "user";
      image-visibility = "when-available";
      keyboard-shortcut = true;
      relative-timestamps = true;
      timeout = 5;
      timeout-low = 5;
      timeout-critical = 0;
      script-fail-notify = true;
      transition-time = 200;

      # Layer settings
      layer-shell = true;
      layer = "overlay";
      control-center-layer = "overlay";

      # Notification settings
      positionX = "right";
      positionY = "top";
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 32;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      notification-window-width = 300;

      # Control center settings
      control-center-positionX = "right";
      control-center-positionY = "top";
      control-center-margin-top = 4;
      control-center-margin-bottom = 4;
      control-center-margin-left = 0;
      control-center-margin-right = 4;
      control-center-width = 500;
      control-center-exclusive-zone = true;
      fit-to-screen = true;
      hide-on-action = true;
      hide-on-clear = false;

      # Widget settings
      widgets = [ "title" "dnd" "notifications" "mpris" ];

      # Widget config
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = { text = "Do Not Disturb"; };
        mpris = {
          image-size = 96;
          image-radius = 12;
          blur = true;
        };
      };
    };

    # Custom style
    # style = builtins.readFile (./. + "/style.css");
    style = ''
      @define-color base00 #2e3440; @define-color base01 #3b4252; @define-color base02 #434c5e; @define-color base03 #4c566a;
      @define-color base04 #d8dee9; @define-color base05 #e5e9f0; @define-color base06 #eceff4; @define-color base07 #8fbcbb;

      @define-color base08 #bf616a; @define-color base09 #d08770; @define-color base0A #ebcb8b; @define-color base0B #a3be8c;
      @define-color base0C #88c0d0; @define-color base0D #81a1c1; @define-color base0E #b48ead; @define-color base0F #5e81ac;

      @define-color background rgba(17, 17, 27, 0.85);
      @define-color background-alt rgba(137, 180, 250, 0.05);
      @define-color background-focus rgba(255, 255, 255, 0.1);
      @define-color border rgba(255, 255, 255, 0.1);
      @define-color red rgb( 243, 139, 168);
      @define-color orange rgb( 250, 179, 135);
      @define-color yellow rgb( 249, 226, 175 );
      @define-color green rgb( 166, 227, 161 );
      @define-color blue rgb( 137, 180, 250 );
      @define-color gray rgb( 108, 112, 134 );
      @define-color black rgb( 49, 50, 68 );
      @define-color white rgb( 205, 214, 244 );

      * {
      all: unset;
      font:
      12pt JetBrainsMono Nerd Font;
      transition: 200ms;
      }

      /*** Global ***/
      progress,
      progressbar,
      trough {
      border: 1px solid @base0D;
      border-radius: 16px;
      }

      trough {
      background: @base01;
      }

      .notification.low,
      .notification.normal {
      border: 1px solid @base0D;
      }

      .notification.low progress,
      .notification.normal progress {
      background: @base0F;
      }

      .notification.critical {
      border: 1px solid @red;
      }

      .notification.critical progress {
      background: @red;
      }

      .summary {
      color: @base05;
      }

      .body {
      color: alpha(@white, 0.7);
      }

      .time {
      color: alpha(@white, 0.7);
      }

      .app-icon,
      .image {
      -gtk-icon-effect: none;
      margin: 0.25rem;
      }

      .notification-action {
      color: @base05;
      background: @base01;
      border: 1px solid @base0D;
      border-radius: 5px;
      margin: 0.5rem;
      }

      .notification-action:hover {
      background: @background-focus;
      color: @base05;
      }

      .notification-action:active {
      background: @base0F;
      color: @base05;
      }

      .close-button {
      margin: 0.5rem;
      padding: 0.25rem;
      border-radius: 5px;
      color: @black;
      background: @red;
      }

      .close-button:hover {
      background: lighter(@red);
      color: lighter(@black);
      }

      .close-button:active {
      background: @red;
      color: @base00;
      }

      /*** Notifications ***/
      .floating-notifications.background .notification-row .notification-background {
      background: @base00;
      border-radius: 5px;
      color: @base05;
      margin: 0.25rem;
      padding: 0;
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification {
      padding: 0.5rem;
      border-radius: 5px;
      }

      .floating-notifications.background
      .notification-row
      .notification-background
      .notification
      .notification-content {
      margin: 0.5rem;
      }

      /*** Notifications Group ***/
      .notification-group {
      /* Styling only for Grouped Notifications */
      }

      .notification-group.low {
      /* Low Priority Group */
      }

      .notification-group.normal {
      /* Low Priority Group */
      }

      .notification-group.critical {
      /* Low Priority Group */
      }

      .notification-group .notification-group-buttons,
      .notification-group .notification-group-headers {
      margin: 0.5rem;
      color: @base05;
      }

      .notification-group .notification-group-headers {
      /* Notification Group Headers */
      }

      .notification-group .notification-group-headers .notification-group-icon {
      color: @base05;
      }

      .notification-group .notification-group-headers .notification-group-header {
      color: @base05;
      }

      .notification-group .notification-group-buttons {
      /* Notification Group Buttons */
      }

      .notification-group.collapsed .notification-row .notification {
      background: @base01;
      }

      .notification-group.collapsed .notification-row:not(:last-child) {
      /* Top notification in stack */
      /* Set lower stacked notifications opacity to 0 */
      }

      .notification-group.collapsed
      .notification-row:not(:last-child)
      .notification-action,
      .notification-group.collapsed
      .notification-row:not(:last-child)
      .notification-default-action {
      opacity: 0;
      }

      .notification-group.collapsed:hover
      .notification-row:not(:only-child)
      .notification {
      background: @background-focus;
      }

      /*** Control Center ***/
      .control-center {
      background: @base00;
      border: 1px solid @base0D;
      border-radius: 8px;
      color: @base05;
      padding: 1rem;
      }

      .control-center-list {
      background: transparent;
      }

      .control-center .notification-row .notification-background {
      background: @base01;
      border-radius: 8px;
      color: @base05;
      margin: 0.5rem;
      }

      .control-center .notification-row .notification-background .notification {
      border-radius: 8px;
      padding: 0.5rem;
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content {
      margin: 0.5rem;
      }

      .control-center
      .notification-row
      .notification-background
      .notification
      .notification-content
      .time {
      margin-right: 0.75rem;
      }

      .control-center .notification-row .notification-background:hover {
      background: @background-focus;
      color: @base05;
      }

      .control-center .notification-row .notification-background:active {
      background: @base0F;
      color: @base05;
      }

      /*** Widgets ***/
      /* Title widget */
      .widget-title {
      color: @base05;
      margin: 0.5rem;
      }

      .widget-title > label {
      font-weight: bold;
      }

      .widget-title > button {
      background: @base01;
      border: 1px solid @base0D;
      border-radius: 8px;
      color: @base05;
      padding: 0.5rem;
      }

      .widget-title > button:hover {
      background: @background-focus;
      }

      /* DND Widget */
      .widget-dnd {
      color: @base05;
      margin: 0.5rem;
      }

      .widget-dnd > label {
      font-weight: bold;
      }

      .widget-dnd > switch {
      background: @base01;
      border: 1px solid @base0D;
      border-radius: 8px;
      }

      .widget-dnd > switch:hover {
      background: @background-focus;
      }

      .widget-dnd > switch:checked {
      background: @base0F;
      }

      .widget-dnd > switch slider {
      background: @background-focus;
      border-radius: 8px;
      padding: 0.25rem;
      }

      /* Mpris widget */
      .widget-mpris {
      color: @base05;
      }

      .widget-mpris .widget-mpris-player {
      background: @base01;
      border: 1px solid @base0D;
      border-radius: 8px;
      margin: 0.5rem;
      padding: 0.5rem;
      }

      .widget-mpris .widget-mpris-player button:hover {
      background: @background-focus;
      }

      .widget-mpris .widget-mpris-player .widget-mpris-album-art {
      border-radius: 16px;
      }

      .widget-mpris .widget-mpris-player .widget-mpris-title {
      font-weight: bold;
      }

      .widget-mpris .widget-mpris-player .widget-mpris-subtitle {
      font-weight: normal;
      }

      .widget-mpris .widget-mpris-player > box > button {
      border: 1px solid transparent;
      border-radius: 8px;
      padding: 0.25rem;
      }

      .widget-mpris .widget-mpris-player > box > button:hover {
      background: @background-focus;
      border: 1px solid @base0D;
      }

      .widget-mpris > box > button {
      /* Change player side buttons */
      }

      .widget-mpris > box > button:disabled {
      /* Change player side buttons insensitive */
      }
    '';
  };
}
