{ pkgs }:
{
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
}
