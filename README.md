# vim-editorconfig

Yet another Vim plugin for [EditorConfig](http://editorconfig.org)

## **Importants**

- [editorconfig/editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)

The official [editorconfig-vim](https://github.com/editorconfig/editorconfig-vim)
has no external dependencies. It doesn't require `if_python` interface anymore.

See [#119](https://github.com/editorconfig/editorconfig-vim/pull/119) for details.

## Description

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
- `spell_language`

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

