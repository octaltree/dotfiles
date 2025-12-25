
alias ls='ls --color=auto'
alias ll='ls -al --color | less -R'
alias ssx='TERM=xterm-256color ssh -XC'
alias ssh='TERM=xterm-256color ssh'
alias opn='xdg-open'
alias mv='mv -i'
alias d='docker'
alias nv='nvim'
alias ca='cargo'
alias enja='trans en:ja'
alias jaen='trans ja:en'
alias rmcolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"'
alias rmpac='paccache -k 2 -r && paccache -ruk0'

alias ad='git add'
alias br='git branch'
alias co='git checkout'
alias cl='git clone'
alias ci='git commit'
alias di='git diff'
alias fe='git fetch'
alias lg='git log --color --all --graph --decorate'
alias li='git log --color --first-parent --graph --decorate --abbrev-commit'
alias pu='git push'
alias re='git remote'
alias rp='git rev-parse'
alias rpr='git rev-parse --show-toplevel'
alias so='git show'
alias st='git status'
alias reb='git rebase'
alias dim='git difftool --tool vimdiff --no-prompt'

# Claudeでコミットメッセージを生成してコミット
function cmm() {
  # stagedな変更があるか確認
  if git diff --staged --quiet; then
    echo "Error: ステージングされた変更がありません" >&2
    echo "まず 'git add' で変更をステージングしてください" >&2
    return 1
  fi

  # stagedな差分を取得
  local diff=$(git diff --staged)

  # Claudeでコミットメッセージを生成
  echo "コミットメッセージを生成中..."
  local commit_msg=$(echo "$diff" | claude -p "以下のgit diffからコミットメッセージを生成してください。
ルール:
- 1行目: 変更の要約（50文字以内、日本語可）
- Conventional Commits形式（feat:, fix:, refactor:, docs:, chore: など）を使用
- 複数の変更がある場合は主要な変更を1行目に、詳細を空行後に箇条書き
- コミットメッセージのみを出力（説明や前置きは不要）

diff:
")

  if [[ -z "$commit_msg" ]]; then
    echo "Error: コミットメッセージの生成に失敗しました" >&2
    return 1
  fi

  echo "----------------------------------------"
  echo "$commit_msg"
  echo "----------------------------------------"

  # コミット実行
  git commit -m "$commit_msg"
}

function mkdcd(){
  mkdir "$1" && cd "$1"
}

function linestat(){
  git log --numstat --pretty="%H" --author='octaltree' --no-merges | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d (+%d, -%d)\n", plus+minus, plus, minus)}'
}

function wt() {
  local FZF_DEFAULT_OPTS="--height ~40% --min-height 15 --reverse --border"
  case "$1" in
    list)
      local project_root=$(git rev-parse --show-toplevel 2>/dev/null)
      local relative_path=""
      if [[ -n "$project_root" ]]; then
        relative_path=$(realpath --relative-to="$project_root" "$PWD")
        [[ "$relative_path" == "." ]] && relative_path=""
      fi

      local selected=$(git worktree list | fzf | awk '{print $1}')
      if [[ -n "$selected" ]]; then
        if [[ -n "$relative_path" ]]; then
          cd "$selected/$relative_path"
        else
          cd "$selected"
        fi
      fi
      ;;
    rm)
      local project_root=$(git rev-parse --show-toplevel 2>/dev/null)
      local relative_path=""
      if [[ -n "$project_root" ]]; then
        relative_path=$(realpath --relative-to="$project_root" "$PWD")
        [[ "$relative_path" == "." ]] && relative_path=""
      fi

      local selected=$(git worktree list | tail -n +2 | fzf)
      if [[ -n "$selected" ]]; then
        local worktree_path=$(echo "$selected" | awk '{print $1}')
        local branch_name=$(echo "$selected" | awk '{print $3}' | sed 's/\[//g' | sed 's/\]//g')

        # Get the main worktree before removing
        local main_worktree=$(git worktree list | head -n1 | awk '{print $1}')
        # cd to main worktree first (can't remove worktree while inside it)
        if [[ -n "$main_worktree" ]]; then
          if [[ -n "$relative_path" ]]; then
            cd "$main_worktree/$relative_path"
          else
            cd "$main_worktree"
          fi
        fi

        # Remove the worktree
        git worktree remove "$worktree_path"

        # Check if branch has no unique commits (already merged into any other branch)
        if git branch --merged | grep -q "^\s*$branch_name$"; then
          git branch -d "$branch_name"
        fi
      fi
      ;;
    add)
      if [[ -z "$2" ]]; then
        echo "Usage: wt add <branch-name>"
        return 1
      fi
      local branch_name="$2"
      local project_root=$(git rev-parse --show-toplevel)
      local relative_path=$(realpath --relative-to="$project_root" "$PWD")
      [[ "$relative_path" == "." ]] && relative_path=""
      local repo_name=$(basename "$project_root")
      local worktree_name="${repo_name}_${branch_name}"

      # Calculate the new worktree path relative to project root's parent
      local worktree_path="${project_root}/../${worktree_name}"

      # Create worktree without changing directory
      git worktree add -b "$worktree_name" "$worktree_path"

      # Navigate to the same relative path in the new worktree
      if [[ -n "$relative_path" ]]; then
        cd "$worktree_path/${relative_path}"
      else
        cd "$worktree_path"
      fi
      ;;
    *)
      echo "Usage: wt {list|rm|add <branch-name>}"
      ;;
  esac
}
