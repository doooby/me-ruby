#!/usr/bin/env sh -e

readonly remote_name="release_v0.9"
readonly remote_url="git@github.com:doooby/me-ruby.git"
readonly remote_release_branch="release_v0.9"

log_error () {
  echo -e "\e[0;31;49m${1}\e[0m"
}

check_is_remote_present () {
  git remote -v | grep "$remote_name" || (
    git remote add "$remote_name" "$remote_url"
    git remote set-url --push origin http://localhost/dummy_path.no
  )
  return 0
}

check_is_remote_valid () {
  # readonly expected_text="$remote_name $remote_url (fetch)"
  # readonly text2="`echo "$expected_text" | tr -d ' '`"
  # echo "$text2"
  # git remote -v | grep "$text2" || (
  #   log_error "invalid remote. expected: ${expected_text}"
  #   exit 1
  # )
}

echo "checking remote"
check_is_remote_present
check_is_remote_valid

git fetch "$remote_name" "$remote_release_branch"
git merge "${remote_name}/${remote_release_branch}"

echo "done"
exit 0
