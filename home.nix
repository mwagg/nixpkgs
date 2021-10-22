{ config, pkgs, ... }:
{
  home = {
    username = "mike";
    homeDirectory = "/Users/mike";

    packages = with pkgs; [
      ripgrep
      htop
      bat
      nix-prefetch-github
      fd
      tldr
      awscli
      bitwarden-cli
      gh
      terraform
      postgresql
      direnv
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    stateVersion = "21.11";
  };

  programs = {
    home-manager.enable = true;

    fish = import ./fish.nix { pkgs = pkgs; };
    neovim = import ./neovim.nix { pkgs = pkgs; };

    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          line-numbers = true;
          syntax-theme = "GitHub";
        };
      };
      userEmail = "michael@guerillatactics.co.uk";
      userName = "mwagg";
      extraConfig = {
        core = {
          whitespace = "tab-in-indent,tabwidth=2";
        };
      };
      aliases = {
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
      };
    };

    autojump = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    gpg = {
      enable = true;
    };
  };

  xdg.configFile."kitty/kitty.conf".source = ./config/kitty/kitty.conf;
}
