if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    mise activate fish | source
    thefuck --alias | source
end
