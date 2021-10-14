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
}
