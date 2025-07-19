# gitx-cb: Clone a bare repo, fix fetch config, and add a main branch worktree
# Usage: gitx-cb <remote-url>
# Example: gitx-cb git@github.com:user/repo.git
gitx-cb() {
  # pull args
  local remote_url=$1
  local repo_name=$(basename "$remote_url" .git)
  local repo_dir=$(basename "$remote_url")

  # clean
  rm -rf "$repo_name"
  mkdir "$repo_name"
  cd "$repo_name"

  # clone
  git clone --bare "$remote_url"

  # fetch
  git --git-dir="$repo_dir" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git --git-dir="$repo_dir" fetch

  # add main worktree
  git --git-dir="$repo_dir" worktree add main main

  # set upstream branch for main
  cd "main"
  git branch --set-upstream-to origin/main
  cd ..

  cd ..
}
