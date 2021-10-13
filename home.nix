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

        sessionVariables = {
            EDITOR = "nvim";
        };

        stateVersion = "21.11";
    };

    programs = {
        home-manager.enable = true;

        fish = {
            enable = true;

            plugins = [
                {
                  name = "nix-env";
                  src = pkgs.fetchFromGitHub {
                    owner = "lilyball";
                    repo = "nix-env.fish";
                    rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
                    sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
                  };
                }
              ];

            shellAliases = {
                gs = "git status $argv";
                ga = "git add $argv";
                gc = "git commit -vq $argv";
                gsk = "git add -u .";
            };

            functions = {
                redshift = ''
                set port (random 10000 20000)
                ssh -f -o ExitOnForwardFailure=yes -L $port:redshift.eporta-internal:5439 bastion sleep 10
                set -x PGPASSWORD (aws ssm get-parameter --name "/prod/redshift/password" --with-decryption --output text | awk '{print $6}')
                psql -h localhost -p $port -U app_redshift analytics
                '';
                rebase = ''
                if contains '* master' (git branch)
                    printf "\e[031mDon't run me on master!\n\e[0m"
                    return 1
                end

                git fetch
                git rebase origin/master
                printf "\e[032mYou are now "(git rev-list origin/master.. --count)" commit(s) ahead of origin/master\n\e[0m"
                '';
            };
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
