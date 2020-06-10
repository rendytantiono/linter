function bold() {
  printf "\e[1m%s" "$1"
}

function success() {
  printf "\e[92m%s\e[0m" "$1"
}

function warn() {
  printf "\e[93m%s\e[0m" "$1"
}

function info() {
  printf "\e[94m%s\e[0m" "$1"
}

function error() {
  printf "\e[1m\e[91m%s\e[0m" "$1"
}

function bgSuccess() {
  printf "\e[1m\e[42m\e[97m%s\e[0m" "$1"
}

function bgWarn() {
  printf "\e[1m\e[43m\e[97m%s\e[0m" "$1"
}

function bgInfo() {
  printf "\e[1m\e[44m\e[97m%s\e[0m" "$1"
}

function bgError() {
  printf "\e[1m\e[41m\e[97m%s\e[0m" "$1"
}

function boxSuccess() {
  len=${#1}
  line="$(printf "%0.s─" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(success "┌$line┐")")"
  echo -e  "$(bold "$(success "│ ${1} │")")"
  echo -e  "$(bold "$(success "└$line┘")")"
}

function boxWarn() {
  len=${#1}
  line="$(printf "%0.s─" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(warn "┌$line┐")")"
  echo -e  "$(bold "$(warn "│ ${1} │")")"
  echo -e  "$(bold "$(warn "└$line┘")")"
}

function boxInfo() {
  len=${#1}
  line="$(printf "%0.s─" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(info "┌$line┐")")"
  echo -e  "$(bold "$(info "│ ${1} │")")"
  echo -e  "$(bold "$(info "└$line┘")")"
}

function boxError() {
  len=${#1}
  line="$(printf "%0.s─" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(error "┌$line┐")")"
  echo -e  "$(bold "$(error "│ ${1} │")")"
  echo -e  "$(bold "$(error "└$line┘")")"
}

function bannerSuccess() {
  len=${#1}
  line="$(printf "%0.s═" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(success "$line")")"
  echo -e  "$(bold "$(success " ${1} ")")"
  echo -e  "$(bold "$(success "$line")")"
}

function bannerWarn() {
  len=${#1}
  line="$(printf "%0.s═" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(warn "$line")")"
  echo -e  "$(bold "$(warn " ${1} ")")"
  echo -e  "$(bold "$(warn "$line")")"
}

function bannerInfo() {
  len=${#1}
  line="$(printf "%0.s═" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(info "$line")")"
  echo -e  "$(bold "$(info " ${1} ")")"
  echo -e  "$(bold "$(info "$line")")"
}

function bannerError() {
  len=${#1}
  line="$(printf "%0.s═" $(seq 1 $((len + 2))))"
  echo -e  "$(bold "$(error "$line")")"
  echo -e  "$(bold "$(error " ${1} ")")"
  echo -e  "$(bold "$(error "$line")")"
}

function h2Info() {
  echo -e  "$(bold "$(info "${1}")")"
  echo -e  "$(bold "$(info "$(printf "%0.s═" $(seq 1 $((${#1} + 2))))")")"
}

function h2Error() {
  echo -e  "$(bold "$(error "${1}")")"
  echo -e  "$(bold "$(error "$(printf "%0.s═" $(seq 1 $((${#1} + 2))))")")"
}

function h2Success() {
  echo -e  "$(bold "$(success "${1}")")"
  echo -e  "$(bold "$(success "$(printf "%0.s═" $(seq 1 $((${#1} + 2))))")")"
}

function h2Warn() {
  echo -e  "$(bold "$(warn "${1}")")"
  echo -e  "$(bold "$(warn "$(printf "%0.s═" $(seq 1 $((${#1} + 2))))")")"
}

function h3Info() {
  echo -e  "$(bold "$(info "========== ${1} ==========")")"
}

function h3Error() {
  echo -e  "$(bold "$(error "========== ${1} ==========")")"
}

function h3Success() {
  echo -e  "$(bold "$(success "========== ${1} ==========")")"
}

function h3Warn() {
  echo -e  "$(bold "$(warn "========== ${1} ==========")")"
}
