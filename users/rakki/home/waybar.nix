{ pkgs, config, ... }:
let
  minicava = "${pkgs.nur.repos.misterio.minicava}/bin/minicava";
in {
  programs.waybar = let colorscheme = config.colorscheme; in {
    enable = true;
    settings = [{
      layer = "top";
      height = 36;
      position = "top";
      modules-left = [
        "sway/workspaces"
        "disk"
        "network"
        "custom/minicava"
      ];
      modules-center = [ "sway/window" ];
      modules-right = [
        "custom/themes"
        "idle_inhibitor"
        "pulseaudio"
        "memory"
        "cpu"
        "temperature"
        "clock"
        "tray"
      ];
      modules = {
        clock = {
          format = " {:%H:%M - %a - %d}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        cpu = {
          format = " {usage}%";
          tooltip = false;
          interval = 3;
        };
        memory = {
          format = "  {used:0.2f}G";
          tooltip-format = "Used {used:0.3f}G of {total:0.3f}G | {percentage}%";
          interval = 3;
        };
        disk = {
          interval = 30;
          path = "/nix";
          format = "{used}";
        };
        network = {
          interval = 1;
          format = "{bandwidthDownBits} | {bandwidthUpBits}";
          format-disconnected = "";
          tooltip-format = "{ipaddr}";
        };
        pulseaudio = {
          format = "{volume}% 墳";
          format-muted = "婢   ";
          scroll-step = 5.0;
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
        };
        temperature = {
          thermal_zone = 2;
          format = " {temperatureC}°C";
          format-critical = "{temperatureC}°C_*critical*";
          critical-threshold = 80;
        };
        tray = {
          icon-size = 18;
          spacing = 0;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated ="";
          };
        };
        "sway/window" = { max-lenght = 40; };
        "sway/workspaces" = {
          format = "{icon} {name}";
          format-icons = {
            focused = "綠 ";
            default = "祿 ";
        };
      };
      "custom/minicava" = {
        "exec" = "${minicava}";
        "restart-interval" = 5;
      };
      "custom/themes" = {
        exec = "echo '{\"text\": \"  \", \"tooltip\": \"${colorscheme.name}\"}'";
        return-type = "json";
        interval = 5;
        on-click = "alacritty -t 'themes' --class AlacrittyFloatingSelector --command /dotfiles/users/rakki/home/scripts/themeselector";
      };
    };
  }];
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: Fira Sans, Fira Code NerdFont;
        font-size: 12pt;
        margin: 1px 0;
        padding: 0 8px;
      }

      window#waybar {
        color: #${colorscheme.colors.base05};
        background-color: #${colorscheme.colors.base00};
        border-bottom: 2px solid #${colorscheme.colors.base0C};
      }

      #workspaces button.visible {
      background-color: #${colorscheme.colors.base02};
      color: #${colorscheme.colors.base04};
      }
    '';
  };
}
