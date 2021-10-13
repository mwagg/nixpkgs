{ config, pkgs, ...}:

let
surround-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "surround-nvim";
    src = pkgs.fetchFromGitHub {
        owner = "blackCauldron7";
        repo = "surround.nvim";
        rev = "f8edab6bb4b5c682860cf6022707c7aeec03a536";
        sha256 = "6FhzyC2oVb1QUDSwPzeIbCohnn8d9zmUvi8+poNiTN8=";
        fetchSubmodules = true;
    };
};
in
{
    home = {
        username = "mike";
        homeDirectory = "/Users/mike";

        packages = with pkgs; [
            ripgrep
                htop
                bat
                nix-prefetch-github
        ];

        stateVersion = "21.11";
    };

    programs = {
        home-manager.enable = true;

        fish = {
            enable = true;
        };

        neovim = {
            enable = true;

            extraConfig = with pkgs; ''
                source ${pkgs.substituteAll {
                    src = ./config/neovim/theme.vim;
                }}
            luafile ${pkgs.substituteAll {
                src = ./config/neovim/lua/init.lua;
            }}
            luafile ${pkgs.substituteAll {
                src = ./config/neovim/lua/lsp.lua;
                rnix_lsp = rnix-lsp;
                terraform_ls = terraform-ls;
                yaml_ls = nodePackages.yaml-language-server;
                ts_ls = nodePackages.typescript-language-server;
                prettier = nodePackages.prettier;
                eslint = nodePackages.eslint;
                efm = efm-langserver;
                luaform = luaformatter;
                shfmt = shfmt;
                shellcheck = shellcheck;
                solargraph = rubyPackages.solargraph;
                elm = elmPackages.elm-language-server;
            }}
            '';

            plugins = with pkgs.vimPlugins; [
                dracula-vim
                    nvim-lspconfig
                    popfix
                    lspsaga-nvim
                    nvim-treesitter
                    nvim-peekup
                    plenary-nvim
                    telescope-nvim
                    telescope-project-nvim
                    nvim-web-devicons
                    indent-blankline-nvim-lua
                    kommentary
                    nvim-autopairs
                    nvim-tree-lua
                    feline-nvim
                    neogit
                    diffview-nvim
                    nvim-bqf
                    vim-vsnip
                    nvim-cmp
                    cmp-nvim-lsp
                    cmp-buffer
                    gitsigns-nvim
                    vim-strip-trailing-whitespace
                    surround-nvim
                    ];
        };
    };
}
