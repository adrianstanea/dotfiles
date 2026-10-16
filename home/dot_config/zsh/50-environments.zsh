# Explicit SDK environment activation commands.

setup_ROS2() {
  local setup_file=/opt/ros/humble/local_setup.zsh
  [[ -r $setup_file ]] || { print "ROS2 setup not found: $setup_file" >&2; return 1; }

  source "$setup_file"
  (( $+commands[register-python-argcomplete3] )) || {
    print "register-python-argcomplete3 is not available" >&2
    return 1
  }
  eval "$(register-python-argcomplete3 ros2)"
  eval "$(register-python-argcomplete3 colcon)"

  export UROS_WS=${UROS_WS:-$HOME/git-repos/Adrian-Stanea/ROS2/micro-ros/}
  export ADI_ROS2=${ADI_ROS2:-$HOME/git-repos/adi-innersource/ros2_ws/src/adi_ros2}
  export LIBGL_ALWAYS_SOFTWARE=1
  export MAKEFLAGS=-l2
}
alias ros2-env='setup_ROS2'

setup_zephyr() {
  export ZEPHYR_BASE=${ZEPHYR_BASE:-$HOME/analog/cfs/1.1.0/SDK/zephyr/zephyr}
  local environment_file=$ZEPHYR_BASE/zephyr-env.sh
  [[ -r $environment_file ]] || { print "Zephyr environment not found: $environment_file" >&2; return 1; }

  source "$environment_file"
  if [[ -r $ZEPHYR_BASE/../.venv/bin/activate ]]; then
    source "$ZEPHYR_BASE/../.venv/bin/activate"
  fi
  export ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-$HOME/analog/cfs/1.1.0/Tools/zephyr-sdk}

  zsh_add_path "$ZEPHYR_BASE/../../../Tools/openocd/bin"
  local directory
  for directory in "$ZEPHYR_BASE/../../../Tools/"*/bin; do
    [[ -d $directory ]] && zsh_add_path "$directory"
  done
}

setup_CFS() {
  export CFS_HOME=${CFS_HOME:-$HOME/analog/cfs/2.3.0}
  [[ -d $CFS_HOME ]] || { print "CodeFusion Studio not found: $CFS_HOME" >&2; return 1; }

  zsh_add_path "$CFS_HOME/Utils/cfsutil/bin"
  local directory
  for directory in "$CFS_HOME/Tools/"*/bin; do
    [[ -d $directory ]] && zsh_add_path "$directory"
  done
}

setup_MAXIM_SDK() {
  export MAXIM_PATH=${MAXIM_PATH:-$HOME/MaximSDK}
  [[ -r $MAXIM_PATH/setenv.sh ]] || { print "Maxim SDK not found: $MAXIM_PATH" >&2; return 1; }

  export MAXIM_LIBRARIES=${MAXIM_LIBRARIES:-$MAXIM_PATH/Libraries}
  source "$MAXIM_PATH/setenv.sh"
}

alias zephyr-env='setup_zephyr'
alias maxim-env='setup_MAXIM_SDK'
alias cfs-env='setup_CFS'
