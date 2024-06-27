function fish_user_key_bindings

    # Autocomplete on Ctrl-f
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
    
    # Exit edit mode on "jj" is pressed
    bind -M insert -m default jj backward-char force-repaint

end
