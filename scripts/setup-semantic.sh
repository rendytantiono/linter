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

    echo
    echo
    h2Info "Installing requirements"
    if ! initSemanticCommit; then
        boxError "Failed to install requirements"
        exit 1
    fi

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


function initSemanticCommit() {
    SCRIPTS="${INSTALLATION_DIR}/scripts"
    ORIGINSCRIPT="${PWD}/scripts"
    if [ -e "${INSTALLATION_DIR}/.git/hooks/commit-msg" ]; then
        echo -e "$(warn "Commit message symlink already exists, skipping...")"
    elif ! curl --fail -o .git/hooks/commit-msg https://raw.githubusercontent.com/hazcod/semantic-commit-hook/master/commit-msg \ && chmod 500 .git/hooks/commit-msg && cp "${PWD}/.git/hooks/commit-msg" "${INSTALLATION_DIR}/.git/hooks/" ; then   
        echo -e "$(error "Failed to install commit-msg hooks")"
        return 1
    else
        echo -e "$(success "Commit-message setup successful")"
    fi

}