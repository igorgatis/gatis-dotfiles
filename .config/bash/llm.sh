export LLM_USER_PATH=~/.config/io.datasette.llm

function _concise_llm() {
  llm -t concise "$@"
}

alias ll=_concise_llm

function llm-commit() {
  title="$(git diff main | llm 'Generate PR title with maximum 72 cols')"
  git commit -m "$title"
}

