# Optional developer tools and corporate certificate configuration.

export BUN_INSTALL=${BUN_INSTALL:-$HOME/.bun}
zsh_add_path "$BUN_INSTALL/bin"

zsh_load_nvm() {
  [[ -n ${NVM_LOADED:-} ]] && return 0
  export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
  if [[ -r $NVM_DIR/nvm.sh ]]; then
    source "$NVM_DIR/nvm.sh"
    export NVM_LOADED=1
  else
    print "zsh: NVM was not found at $NVM_DIR" >&2
    return 1
  fi
}

nvm() {
  zsh_load_nvm || return
  nvm "$@"
}

zsh_nvm_command() {
  local command_name=$1
  shift
  zsh_load_nvm || return
  command "$command_name" "$@"
}

node() { zsh_nvm_command node "$@"; }
npm() { zsh_nvm_command npm "$@"; }
npx() { zsh_nvm_command npx "$@"; }

zsh_setup_ca() {
  local ca_bundle=/usr/local/share/ca-certificates/nscacert_combined.crt
  [[ -r $ca_bundle ]] || return 0

  export REQUESTS_CA_BUNDLE=$ca_bundle
  export PIP_CERT=$ca_bundle
  export SSL_CERT_FILE=$ca_bundle
  export SSL_CERT_DIR=/etc/ssl/certs
  export CURL_CA_BUNDLE=$ca_bundle
  export GIT_SSL_CAINFO=$ca_bundle
  export NODE_EXTRA_CA_CERTS=$ca_bundle
  export AWS_CA_BUNDLE=$ca_bundle
  export CARGO_HTTP_CAINFO=$ca_bundle
  export HTTPLIB2_CA_CERTS=$ca_bundle
  export WEBSOCKET_CLIENT_CA_BUNDLE=$ca_bundle
  export RUBY_SSL_CERT_FILE=$ca_bundle
}

git-clone-sub() {
  local usage='Usage: git-clone-sub <repo-url> <directory>... [--branch <branch>]'
  if (( $# < 2 )); then
    print -u2 "$usage"
    return 2
  fi

  local repo_url=$1
  local branch=''
  local directory
  local common_path
  local relative_directory
  local directory_index=1
  local repo_name
  local -a directories filter_args sparse_paths
  shift

  while (( $# )); do
    case $1 in
      --branch)
        shift
        if (( $# != 1 )) || [[ -z $1 ]]; then
          print -u2 "$usage"
          return 2
        fi
        branch=$1
        shift
        ;;
      --branch=*)
        branch=${1#--branch=}
        if [[ -z $branch ]] || (( $# != 1 )); then
          print -u2 "$usage"
          return 2
        fi
        shift
        ;;
      -* )
        print -u2 "$usage"
        return 2
        ;;
      *)
        directories+=("$1")
        shift
        ;;
    esac
  done

  if [[ -z $repo_url ]] || (( ${#directories[@]} == 0 )); then
    print -u2 "$usage"
    return 2
  fi

  for directory in "${directories[@]}"; do
    if [[ -z $directory || $directory == /* || $directory == . || $directory == ./* || $directory == */./* || $directory == */. || $directory == .. || $directory == ../* || $directory == */../* || $directory == */.. || $directory == *//* || $directory == */ ]]; then
      print -u2 'git-clone-sub: provide relative directory paths without dot segments'
      return 2
    fi

    if (( directory_index == 1 )); then
      common_path=$directory
    else
      while [[ $directory != "$common_path" && $directory != "$common_path/"* && $common_path != "$directory/"* ]]; do
        if [[ $common_path == */* ]]; then
          common_path=${common_path%/*}
        else
          common_path=''
          break
        fi
      done
      if [[ $common_path == "$directory/"* ]]; then
        common_path=$directory
      fi
      if [[ -z $common_path ]]; then
        print -u2 'git-clone-sub: multiple directories must share a parent path'
        return 2
      fi
    fi
    (( directory_index += 1 ))
  done

  repo_name=${common_path:t}
  if ! command -v git-filter-repo >/dev/null 2>&1; then
    print -u2 'git-clone-sub: git-filter-repo is required; install it with: pipx install git-filter-repo'
    return 127
  fi

  if [[ -n $branch ]]; then
    command git clone --no-local --filter=blob:none --no-checkout --single-branch --branch "$branch" "$repo_url" "$repo_name" || return
  else
    command git clone --no-local --filter=blob:none --no-checkout --single-branch "$repo_url" "$repo_name" || return
  fi

  if [[ -z $branch ]]; then
    branch=$(command git -C "$repo_name" symbolic-ref --short HEAD) || return
  fi

  for directory in "${directories[@]}"; do
    sparse_paths+=("$directory/*")
  done
  command git -C "$repo_name" sparse-checkout set --no-cone "${sparse_paths[@]}" || return
  command git -C "$repo_name" checkout --force "$branch" || return

  if (( ${#directories[@]} == 1 )); then
    filter_args=(--subdirectory-filter "${directories[1]}")
  else
    for directory in "${directories[@]}"; do
      filter_args+=(--path "$directory")
      relative_directory=${directory#"$common_path"/}
      filter_args+=(--path-rename "$directory/:$relative_directory/")
    done
  fi

  command git -C "$repo_name" filter-repo --force "${filter_args[@]}" || return
  command git -C "$repo_name" remote add upstream "$repo_url" || return
  command git -C "$repo_name" config extensions.partialClone upstream || return
  command git -C "$repo_name" config remote.upstream.promisor true || return
  command git -C "$repo_name" config remote.upstream.partialclonefilter blob:none || return
  command git -C "$repo_name" checkout --force "$branch" || return
  command git -C "$repo_name" sparse-checkout disable || return
  cd -- "$repo_name"
}

zsh_setup_ca
