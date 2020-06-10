#!/bin/bash

INSTALLATION_DIR="${LINTERDIR}"
CURR_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if branch has been pushed
if ! git rev-parse --abbrev-ref --symbolic-full-name '@{u}' &>/dev/null; then
  # Get revision id of first branch checkout
  LAST_PUSH=$(git reflog show "${CURR_BRANCH}" | tail -1 | awk '{print $1}')
else
  # Get ref to remote tracking of current branch
  LAST_PUSH=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}')
fi

# Get difference between local and remote
CHANGED=$(git diff --dirstat=files --diff-filter=ACM HEAD "${LAST_PUSH}" | awk '{print $2}')

. $(dirname "$0")/utils/chalk.sh

function main() {
  bannerInfo "Running linter on project"
  if ! runLinter; then
    echo
    boxError "Lint failed"
    exit 1
  fi

  echo
  bannerInfo "Running tests on pushed changes"
  if ! runTests; then
    boxError "Some tests failed. Aborting..."
    exit 1
  fi
}

function runLinter() {
  TMP_DIR=$PWD

  cd "$INSTALLATION_DIR" || return 1
  for dir in $CHANGED; do
    # Ignore directory if there are no Go files
    if ! ls "${dir}"/*.go &>/dev/null; then continue; fi

    # Ignore srcClean, srcGlobal, and cmd
    if [[ $dir =~ ^(srcClean|srcGlobal|cmd).* ]]; then continue; fi

    # Mark as linted
    linted=true

    echo
    h2Warn "Linting: $dir"

    if golangci-lint run --new-from-rev="${LAST_PUSH}" "$dir"; then
      echo -e "$(bold "$(success "OK")")"
    else
      fail=true
    fi
  done
  cd "$TMP_DIR" || return 1

  if [ $fail ]; then
    return 1
  fi

  if [ ! $linted ]; then
    echo -e "$(bold "$(warn "No Go files to be linted")")"
  else
    echo
    boxSuccess "Lint successful"
  fi
}

function runTests() {
  echo 'mode: count' >profile.cov

  # Change working directory to project repo
  cd "${INSTALLATION_DIR}" || exit 1

  for dir in $(find . -maxdepth 10 -not -path './.git*' -not -path '*/_*' -not -path './vendor*' -not -path '**/cmd*' -not -path '**/srcClean*' -type d); do
    # Ignore directory if there are no Go files
    if ! ls "${dir}"/*.go &>/dev/null; then continue; fi

    # Mark Go files as being tested
    tested=true

    # Ignore if current directory is repo
    if [[ $dir == "." ]]; then continue; fi

    echo
    h2Warn "Testing: $dir"

    file_name="$dir/temp_test.go"
    first_file=$(find "$dir"/*.go | head -1)

    # create dummy file to trigger go test
    cat "$first_file" | grep -m 1 "package " >$file_name

    go test -short -covermode=count -coverprofile="$dir/profile.tmp" "./$dir"

    # if test fail exit with status 1
    if [[ $? != 0 ]]; then
      if [ -f "$dir/profile.tmp" ]; then
        rm "$dir/profile.tmp"
      fi

      if [ -f $file_name ]; then
        rm "$file_name"
      fi

      if [ -f profile.cov ]; then
        rm "profile.cov"
      fi

      boxError "TEST FAILED!!! -> $dir"
      return 1
    elif [ -f "$dir"/profile.tmp ]; then
      cat "$dir"/profile.tmp | tail -n +2 >>profile.cov
      rm "$dir"/profile.tmp
      rm "$file_name"
    fi
  done

  # remove all mock file -- for now, anything having "mock" in their path or filename will be excluded
  cat profile.cov | grep -v "mock" >profile_clear.cov

  total_coverage_percent=$(go tool cover -func profile_clear.cov | tail -n 1 | awk '{print $3}')
  total_coverage_number=${total_coverage_percent%\%}

  if [ $tested ]; then
    echo
    boxSuccess "Test Coverage: ${total_coverage_number}%"
  else
    echo -e "$(bold "$(warn "No Go files to be tested")")"
    echo
  fi

  # Remove temporary files
  rm profile_clear.cov profile.cov

  cd "${TMP_DIR}" || exit 1
}

main
