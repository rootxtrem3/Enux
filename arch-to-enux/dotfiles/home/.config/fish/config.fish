if status is-interactive
    oh-my-posh init fish --config ~/.posh-theme/craver.omp.json | source

    alias ls="eza --icons --group-directories-first"
    alias ll="eza --icons --group-directories-first -l --git"
    alias la="eza --icons --group-directories-first -la --git"
    alias lt="eza --icons --group-directories-first --tree --level=2"
end

function ghostty
    env LIBGL_ALWAYS_SOFTWARE=1 /usr/bin/ghostty $argv
end
