vim-editorconfig
================

Yet another Vim plugin for [EditorConfig](http://editorconfig.org)

Description
-----------

### Supported Properties

- `charset`
- `end_of_line`
- `indent_size`
- `indent_style`
- `insert_final_newline`
- `max_line_length`
- `root`
- `tab_width`
- `trim_trailing_whitespace`

Properties below are enabled only in this plugin:

- `c_include_path`
- `spell_enabled`
- `spell_language`

V.S.
----

- [editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)

[editorconfig-vim](https://github.com/editorconfig/editorconfig-vim) is official vim plugin for EditorConfig.
This requires `if_python` interface or external python interpreter.

[vim-editorconfig](https://github.com/sgur/vim-editorconfig) is written in pure vimscript.
You can use editorconfig without any external interfaces such as `if_python`.

Usage
-----

 1. Install the plugin
 2. Locate `.editorconfig`
 3. Edit some files

Options
-------

### g:editorconfig\_blacklist

Exclude regexp patterns for filetypes or filepaths

```vim
let g:editorconfig_blacklist = {
    \ 'filetype': ['git.*', 'fugitive'],
    \ 'pattern': ['\.un~$']}
```

### g:editorconfig\_root\_chdir

Automatically `:lcd` If `root = true` exists in `.editorconfig`.

### g:editorconfig\_verbose

Show verbose messages

```vim
let g:editorconfig_verbose = 1 " 0 by default
```

Install
-------

Use your favorite plugin manager.

License
-------

MIT License

Author
------

sgur

