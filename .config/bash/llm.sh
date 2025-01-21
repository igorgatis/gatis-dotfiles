export LLM_USER_PATH=~/.config/io.datasette.llm

function _concise_llm() {
  llm -t concise "$@"
}

alias llm=_concise_llm

