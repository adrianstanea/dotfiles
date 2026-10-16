# GitHub account per directory tree for the gh CLI (git uses the same rules
# through git-credential-gh-account; see .chezmoidata/github.yaml).

typeset -gA zsh_gh_account_tokens
typeset -g zsh_gh_account_current=''

# Export GH_TOKEN for the account that owns the current directory.
zsh_gh_account_sync() {
  (( $+commands[git-credential-gh-account] )) || return 0
  local account token
  account=$(git-credential-gh-account resolve "$PWD" 2>/dev/null) || return 0
  [[ $account == "$zsh_gh_account_current" ]] && return 0

  token=${zsh_gh_account_tokens[$account]:-}
  if [[ -z $token ]]; then
    token=$(git-credential-gh-account token "$account" 2>/dev/null)
    [[ -n $token ]] && zsh_gh_account_tokens[$account]=$token
  fi

  zsh_gh_account_current=$account
  if [[ -n $token ]]; then
    export GH_TOKEN=$token
  else
    unset GH_TOKEN
  fi
}

# Show which account the current directory uses.
gh-whoami() {
  git-credential-gh-account whoami "$@" || return
  if [[ -n ${GH_TOKEN:-} ]]; then
    print "gh:       GH_TOKEN for $zsh_gh_account_current"
  else
    print "gh:       gh active account (no GH_TOKEN)"
  fi
}

# Log into every configured account that gh does not know yet.
gh-accounts-login() {
  local account
  for account in ${(f)"$(git-credential-gh-account accounts)"}; do
    if git-credential-gh-account token "$account" >/dev/null 2>&1; then
      print "gh: $account is already logged in"
      continue
    fi
    # --insecure-storage keeps tokens in ~/.config/gh/hosts.yml, so containers that
    # mount ~/.config/gh see them and a locked keyring can't block git.
    print "gh: log in as $account (pick that account in the browser; answer No to \"Authenticate Git\")"
    env -u GH_TOKEN -u GITHUB_TOKEN gh auth login --hostname github.com --git-protocol https --web --insecure-storage || return
  done
  zsh_gh_account_tokens=()
  zsh_gh_account_current=''
  zsh_gh_account_sync
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd zsh_gh_account_sync
zsh_gh_account_sync
