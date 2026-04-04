{ inputs, config, pkgs, pkgs-stable, ... }:

{
  # Базовая настройка git (если ещё не настроено)
  programs.git = {
    enable = true;
  
    # Новый синтаксис (вместо userName/userEmail)
    settings = {
      user = {
        name = "emptyinside1";
        email = "morevdaniil162@gmail.com";
      };
      core.editor = "nvim";
      pull.rebase = true;
      init.defaultBranch = "main";
      extraConfig = {
        credential.helper = "store";  # Сохраняет в ~/.git-credentials
      }; 

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        amend = "commit --amend --no-edit";
      };
    };
  };
}
