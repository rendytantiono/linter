#!/bin/bash

. $(dirname "$0")/utils/chalk.sh

INSTALLATION_DIR="${LINTERDIR}"

function main() {
  boxInfo "Setting up ..."

  echo
  h2Info "Checking requirements"
  if ! checkRequirements; then
    echo -e "$(error "Requirement check failed")"
    exit 1
  fi

  #echo
 # echo
  #h2Info "Initializing config files"
  #if ! initConfig; then
   # boxError "Config initialization failed"
  #  exit 1
  #fi

  echo
  echo
  h2Info "Initializing git hooks"
  if ! initHooks; then
    boxError "Failed to initialize git hooks"
    exit 1
  fi

  echo
  echo
  h2Info "Installing requirements"
  if ! installReqs; then
    boxError "Failed to install requirements"
    exit 1
  fi

  echo
  boxSuccess "All done! Happy coding :D"
}

function checkRequirements() {
  # check go path
  if [ -z "${GOPATH}" ]; then
    echo -e "$(error "GOPATH variable not set, please properly configure your go installation first")"
    return 1
  fi
  if [ -z "${LINTERDIR}" ]; then
    echo -e "$(error "LINTERDIR variable not set, please properly add it in your env variable")"
    return 1
  fi
  echo -e "$(success "Found GOPATH = ${GOPATH}")"
  echo -e "$(success "Found LINTERDIR = ${LINTERDIR}")"

}

function initConfig() {
  if [ -e "/etc/r3" ]; then
    echo -e "$(warn "Config already exists, skipping configuration setup")"
    return 0
  elif ! sudo ln -s "${INSTALLATION_DIR}/files/etc/" "/etc/"; then
    echo -e "$(error "Failed to create symlink for configuration files")"
    return 1
  fi

  echo -e "$(success "Config successfully initialized")"
}

function initHooks() {
  SCRIPTS="${INSTALLATION_DIR}/scripts"
  ORIGINSCRIPT="${PWD}/scripts"
  cp -R "${ORIGINSCRIPT}" "${INSTALLATION_DIR}"
  for f in $(find $SCRIPTS -maxdepth 10 -name "*.sh"); do
    echo -e "$(success "Successfully made $(realpath --relative-to="$SCRIPTS" "$f") executable")"    
    chmod +x "$f"
  done

  if [ -e "${INSTALLATION_DIR}/.git/hooks/utils" ]; then
    echo -e "$(warn "Utils symlink already exists, skipping...")"
  elif ! ln -s "${SCRIPTS}/utils" "${INSTALLATION_DIR}/.git/hooks/utils"; then
    echo -e "$(error "Failed to create symlink for utils folder")"
    return 1
  else
    echo -e "$(success "Utils setup successful")"
  fi

  if [ -e "${INSTALLATION_DIR}/.git/hooks/pre-commit" ]; then
    echo -e "$(warn "Pre-commit symlink already exists, skipping...")"
  elif ! ln -s "${SCRIPTS}/pre-commit.sh" "${INSTALLATION_DIR}/.git/hooks/pre-commit"; then
    echo -e "$(error "Failed to create symlink for pre-commit script")"
    return 1
  else
    echo -e "$(success "Pre-commit setup successful")"
  fi

  if [ -e "${INSTALLATION_DIR}/.git/hooks/pre-push" ]; then
    echo -e "$(warn "Pre-push symlink already exists, skipping...")"
  elif ! ln -s "${SCRIPTS}/pre-push.sh" "${INSTALLATION_DIR}/.git/hooks/pre-push"; then
    echo -e "$(error "Failed to create symlink for pre-push script")"
    return 1
  else
    echo -e "$(success "Pre-push setup successful")"
  fi

  if [ -e "${INSTALLATION_DIR}/.git/hooks/commit-msg" ]; then
    echo -e "$(warn "Commit message symlink already exists, skipping...")"
  elif ! curl --fail -o .git/hooks/commit-msg https://raw.githubusercontent.com/hazcod/semantic-commit-hook/master/commit-msg \
  && chmod 500 .git/hooks/commit-msg && cp "${PWD}/.git/hooks/commit-msg" "${INSTALLATION_DIR}/.git/hooks/" ; then   
    echo -e "$(error "Failed to install commit-msg hooks")"
    return 1
  else
    echo -e "$(success "Commit-message setup successful")"
  fi
}

function installReqs() {
  GOLANGCI_LINT="${GOPATH}/bin/golangci-lint"
  if [ -x "${GOLANGCI_LINT}" ]; then
    echo -e "$(warn "golangci-lint already installed")"
    return 0
  fi

  if ! curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)/bin" v1.21.0; then
    echo -e "$(error "Failed to install golangci-lint")"
    return 1
  fi
}

main
