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

- `local_vimrc`

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

Features
-------

### local\_vimrc

Source specified vimrc file when you edit a buffer.

It behaves like [thinca/vim-localrc](https://github.com/thinca/vim-localrc).

```
[*.md]
local_vimrc = .local.vimrc
```

Options
-------

### g:editorconfig_warn_unsupported_properties

Set this if you want to be warned if unsupported properties are used.

```vim
let g:editorconfig_warn_unsupported_properties = 1
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

