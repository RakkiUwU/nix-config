{ config, pkgs, nixpkgs, hardware, impermanence, nix-colors, nur, ... }: {
  imports = [
    # Importar configuração gerada para os discos
    ./hardware-configuration.nix

    # Importar config para cpu da intel
    hardware.nixosModules.common-cpu-intel

    # Importar config para gpu da nvidia
    hardware.nixosModules.common-gpu-nvidia

    # Importar impermanence (programinha que monta as pastas persistidas)
    impermanence.nixosModules.impermanence
  ];

fileSystems."/data".neededForBoot = true;

nixpkgs.overlays = [ nur.overlay ];

  # Persistir algumas pastas do sistema
  # Pra os timers do systemd e logs funcionarem certo entre reboots
  environment.persistence."/data" = {
    directories = [
      # Logs do sistema
      "/var/log"
      # Coisas do systemd (tempo dos timers, e tal)
      "/var/lib/systemd"

      # TODO: Coloque aqui qualquer pasta do sistema que vc quer persistir na /data
    ];
  };

  # Versão 21.11 do NixOS (rolling, tipo arch)
  system.stateVersion = "21.11";
  # Permitir software proprietário
  nixpkgs.config.allowUnfree = true;

  services = {
    xserver = {
      # X11
      enable = false;
      # Habilitar GDM
      displayManager.gdm.enable = false;
      # Habilitar gnome
      desktopManager.gnome.enable = false;
    };

    # Fazer o promptzinho de senha do gpg funcionar
    dbus.packages = [ pkgs.gcr ];
  };

  nix = {
    # Usar versão unstable do nix
    package = pkgs.nixUnstable;
    # Usar flakes e o comando novo
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      warn-dirty = false
    '';
    # Usar nixpkgs setado na flake
    registry = {
      nixpkgs.flake = nixpkgs;
      nix-colors.flake = nix-colors;
    };
    # Automaticamente otimizar a /nix
    autoOptimiseStore = true;
    # Automaticamente apagar pacotes que não tão em uso
    # (Não apaga automático as gerações antigas do seu sistema,
    # pra apagar elas vc usa sudo nix-collect-garbage -d)
    gc = {
      automatic = true;
      dates = "daily";
    };
  };

  networking = {
    # Nome do pc
    hostName = "rimuru";
    # Networking manager (dhcp e tal)
    networkmanager.enable = true;
  };

  # Inglês com suporte utf8
  i18n.defaultLocale = "en_US.UTF-8";
  # Fuso horário
  time.timeZone = "America/Sao_Paulo";

  boot = {
    # Telinha bonitinha de boot (n fica o tempo inteiro, pq o nix só inicia ela meio tarde, mas enfim)
    plymouth.enable = true;
    # Linux zen
    kernelPackages = pkgs.linuxPackages_zen;
    # Parametros de kernel para ele n printar mil coisas
    kernelParams = [ "quiet" "udev.log_priority=3" ];
    consoleLogLevel = 3;
    # Configs do sysctl
    kernel.sysctl = {
      # Star Citizen
      "vm.max_map_count" = 16777216;
      # League of Legends
      "abi.vsyscall32" = 0;
    };
    # Suporte ao btrfs no boot
    supportedFilesystems = [ "btrfs" "ntfs" ];
    # Configurações do boot loader
    loader = {
      # Não mostrar se não segurar shift
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  programs = {
    dconf.enable = true;
    # Usar gpg como gerenciador de chaves SSH
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Gamemode
    gamemode.enable = true;
    # fuse
    fuse.userAllowOther = true;
    # Configurações globais do fish
    # (precisa aqui pra configuração do usuário ter as completions dos programas do sistema)
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };

  hardware = {
    # Opengl
    opengl.enable = true;
    # OTD
    opentabletdriver.enable = true;
    # PulseAudio
    pulseaudio.enable = true;
    # Desabilitar offload PRIME
    nvidia = {
      prime.offload.enable = false;
      modesetting.enable = true;
      powerManagement.enable = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
