{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  modulesPath,
  ...
}:
let
  zed-fhs = pkgs.buildFHSUserEnv {
    name = "zed";
    targetPkgs = pkgs: with pkgs-unstable; [ zed-editor ];
    runScript = "zed";
  };
in
{
  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.05";
  home.username = "k3ys";
  home.homeDirectory = "/home/k3ys";
  home.packages =
    with pkgs;
    [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      act
      tree
      python3Full
      vlc
      slack
      spotify
      terraform
      nixpkgs-fmt
      nixfmt-rfc-style
      zoom-us
      fly
      mattermost-desktop
      telegram-desktop
      chromium
      lua-language-server
      lazygit
      lazydocker
      libreoffice-qt
      google-cloud-sdk
      htop
      meld
      direnv
      obs-studio
      ripgrep
      fd
      nixd
      obsidian
      nix-output-monitor
      dbeaver-bin
      vesktop
      element-desktop
      terraform-ls
      pyright
      clang
      clang-tools
      ansible
	  nodejs_22
    ]
    ++ [
      pkgs-unstable.firefox
      pkgs-unstable.discord
      pkgs-unstable.vscode
      pkgs-unstable.sparrow
      pkgs-unstable.vagrant
      pkgs-unstable.stremio
      pkgs-unstable.alacritty
      pkgs-unstable.rust-analyzer
	  pkgs-unstable.zed-editor
    ];

  programs.tmux = {
    enable = true;
    mouse = true;
    plugins = with pkgs; [ { plugin = tmuxPlugins.yank; } ];
    extraConfig = ''
              # Scroll History
              set -g history-limit 30000

              # Set ability to capture on start and restore on exit window data when running an application
              setw -g alternate-screen on

              # Lower escape timing from 500ms to 50ms for quicker response to scroll-buffer access.
              set -s escape-time 50
      	set-option -g default-terminal "tmux-256color"
              	'';
  };

  programs.zsh = {
    enable = true;
    completionInit = ""; # speed up zsh start time
    shellAliases = {
      vim = "nvim";
      tf = "terraform";
    };
    syntaxHighlighting.enable = true;
    plugins = with pkgs; [
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      plugins = [
        "git"
        "z"
        "direnv"
      ];
    };
    initExtra = ''
      export LC_ALL=en_IN.UTF-8
      export LANG=en_IN.UTF-8
    '';
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Rishi Kumar";
    userEmail = "rsi.dev17@gmail.com";
    ignores = [
      "*~"
      "*.swp"
      ".vscode"
    ];
  };
  imports = [ ./modules/nvim.nix ];

  nixpkgs.config = {
    allowUnfree = true;
  };
}
