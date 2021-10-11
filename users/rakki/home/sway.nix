{ lib, pkgs, config, nix-colors, ... }:

let
  wallpaper = "/dotfiles/users/rakki/home/wallpaper/wallpaper.png";
  alacritty = "${pkgs.alacritty}/bin/alacritty";
  discocss = "${pkgs.discocss}/bin/discocss";
  nautilus = "${pkgs.gnome.nautilus}/bin/nautilus";
  kdeconnect = "${pkgs.kdeconnect}/bin/kdeconnect";
  waybar = "${pkgs.waybar}/bin/waybar";
  grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  nvim = "${pkgs.neovim}/bin/nvim";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swayidle = "${pkgs.swayidle}/bin/swayidle";
  mako = "${pkgs.mako}/bin/mako";
  swayfader = "${pkgs.nur.repos.misterio.swayfader}/bin/swayfader";
  wofi = "${pkgs.wofi}/bin/wofi";
in rec {
  home.packages = with pkgs; [ wl-clipboard wf-recorder slurp ];
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = true;
    QT_QPA_PLATFORM = "wayland";
    TERMINAL = "alacritty";
  };
  wayland.windowManager.sway = let colorscheme = config.colorscheme; in {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      bars = [];
      menu = "exec ${wofi} -S drun -I";
      modifier = "Mod4";
      terminal = "${alacritty}";
      workspaceAutoBackAndForth = true;
      startup = [
        # set keyboard layout to international
        { command = "setxkbmap -layout us -variant intl"; }

        # set initial focus on main monitor
        { command = "swaymsg focus output HDMI-A-2"; }

        # set volume to 100%
        { command = "pactl set-sink-volume @DEFAULT_SINK@ 100%"; }

        # start waybar
        { command = "${waybar}"; }

        # swaylock on startup
        { command = "${swaylock}"; }

        # start swayidle
        { command = "${swayidle} -w"; }

        # start mako
        { command = "${mako} -c $HOME/.config/mako/config"; }

        # start kdeconnect
        { command = "dbus-launch ${kdeconnect}-indicator"; }

        # link fish history
        { command = "ln -s $HOME/Documents/fish_history $HOME/.local/share/fish/"; }

        # start swayfader
        { command = "${swayfader}"; }
      ];
      output = {
        HDMI-A-1 = {
          res = "1920x1080@60Hz";
          pos = "0 0";
          bg = "${wallpaper} fill";
        };
        HDMI-A-2 = {
          res = "1920x1080@60Hz";
          pos = "1920 130";
          bg = "${wallpaper} fill";
        };
      };
      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_numlock = "enable";
        };
      };
      defaultWorkspace = "workspace number 1";
      workspaceOutputAssign = [
        {
          output = "HDMI-A-1";
          workspace = "2";
        }
        {
          output = "HDMI-A-2";
          workspace = "1";
        }
      ];
      gaps = {
        top = 10;
        bottom = 10;
        inner = 8;
        outer = 8;
      };
      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+f" = "fullscreen toggle global";
        "${modifier}+Shift+d" = "exec ${wofi} -D run-always_parse_args=true -k /dev/null -i -e -S run -t ${terminal}";
        "${modifier}+Ctrl+Shift+a" = "exec $HOME/.scripts/autoclick/autoclick.sh";
        "${modifier}+f2" = "exec google-chrome-stable";
        "${modifier}+Shift+e" = "exec ${nautilus}";
        "${modifier}+c" = "exec ${alacritty} -t 'Octave' --class AlacrittyFloatingOctave --command octave";
        "${modifier}+l" = "exec ${swaylock}";
        "Print" = "exec ${grimshot} --notify copy area";
        "Shift+Print" = "exec ${grimshot} --notify copy window";
        "${modifier}+Shift+Return" = "exec ${alacritty} -t 'fish' --class AlacrittyFloatingOctave";
        "${modifier}+Shift+r" = "exec ${alacritty} -t 'nix rebuild switch' --class AlacrittyFloatingNixRebuild --command sudo nixos-rebuild switch --flake /dotfiles";

        # audio
        "Shift+XF86AudioMute" = "exec pactl set-default-sink alsa_output.usb-Logitech_Logitech_G633_Gaming_Headset_00000000-00.analog-stereo";
        "Shift+XF86AudioLowerVolume" = "exec pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra";
        "Shift+XF86AudioRaiseVolume" = "exec pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo";
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "Ctrl+m" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "${modifier}+Ctrl+m" = "exec pavucontrol";
        "${modifier}+Ctrl+Shift+m" = "exec pulseeffects";
        "${modifier}+q" = "split toggle";
        "${modifier}+minus" = "move scratchpad";
        "${modifier}+equal" = "scratchpad show";

        # move containers without moving focus
        "${modifier}+Ctrl+1" = "move container to workspace 1";
        "${modifier}+Ctrl+2" = "move container to workspace 2";
        "${modifier}+Ctrl+3" = "move container to workspace 3";
        "${modifier}+Ctrl+4" = "move container to workspace 4";
        "${modifier}+Ctrl+5" = "move container to workspace 5";
        "${modifier}+Ctrl+6" = "move container to workspace 6";
        "${modifier}+Ctrl+7" = "move container to workspace 7";
        "${modifier}+Ctrl+8" = "move container to workspace 8";
        "${modifier}+Ctrl+9" = "move container to workspace 9";

        # move containers with focus
        "${modifier}+Shift+1" = "move container to workspace 1; workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2; workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3; workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4; workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5; workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6; workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7; workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8; workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9; workspace 9";
      };
      floating.criteria = [
        { title = "Files Transfer*"; }
        { app_id = "event started"; }
        { title = "GWE*"; }
        { title = "Steam Guard*"; }
        { title = "Raindrop.io*"; }
        { title = "Upload*"; }
        { title = "PulseEffects"; }
        { title = "Volume Control"; }
        { app_id = "GParted"; }
        { app_id = "AlacrittyFloatingSelector"; }
        { app_id = "AlacrittyFloatPower"; }
        { app_id = "AlacrittyFloatingOctave"; }
        { app_id = "AlacrittyFloatingNixRebuild"; }
      ];
      window = {
        border = 3;
        commands = [
          { command = "resize set 500 150, move position center"; criteria = { app_id = "AlacrittyFloatingSelector"; }; }
          { command = "resize set 500 150, move position center"; criteria = { app_id = "AlacrittyFloatPower"; }; }
          { command = "resize set 330 100, move position center"; criteria = { app_id = "AlacrittyFloatingNixRebuild"; }; }
          { command = "move scratchpad"; criteria = { app_id = "origin.exe"; }; }
          { command = "move scratchpad"; criteria = { title = "Origin"; }; }
        ];
      };
      colors = {
        focused = {
          border = "#${colorscheme.colors.base0B}";
          childBorder = "#${colorscheme.colors.base0B}";
          indicator = "#${colorscheme.colors.base09}";
          background = "#${colorscheme.colors.base00}";
          text = "#${colorscheme.colors.base05}";
        };
        unfocused = {
          border = "#${colorscheme.colors.base02}";
          childBorder = "#${colorscheme.colors.base02}";
          indicator = "#${colorscheme.colors.base02}";
          background = "#${colorscheme.colors.base00}";
          text = "#${colorscheme.colors.base04}";
        };
        focusedInactive = {
          border = "#${colorscheme.colors.base01}";
          childBorder = "#${colorscheme.colors.base01}";
          indicator = "#${colorscheme.colors.base01}";
          background = "#${colorscheme.colors.base00}";
          text = "#${colorscheme.colors.base04}";
        };
        urgent = {
          border = "#${colorscheme.colors.base0C}";
          childBorder = "#${colorscheme.colors.base0C}";
          indicator = "#${colorscheme.colors.base0C}";
          background = "#${colorscheme.colors.base0C}";
          text = "#${colorscheme.colors.base04}";
        };
      };
    };
  };
  programs.zsh.loginExtra = ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway
    fi
  '';
  programs.fish.loginShellInit = ''
    if test (tty) = /dev/tty1
      exec sway
    end
  '';
  programs.bash.profileExtra = ''
    if [[ "$(tty)" == /dev/tty1 ]]; then
      exec sway
    fi
  '';
}
