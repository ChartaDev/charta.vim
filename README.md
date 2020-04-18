# Charta.vim

This is [Charta](https://www.charta.dev)'s official vim plugin.

It allows you to create code documentation, maps & tours straight for your editor.

#### Instalation with Vundle:

Add the following lines to your `.vimrc`:

```
Bundle 'ChartaDev/charta.vim'
```

#### Requirements:

- `curl` must be installed and available in your PATH.

## Bindings:

The following bindings are set four you:

```vim
nnoremap <Leader>ca :ChartaAddNode<CR> " Add node in normal mode
vnoremap <Leader>ca :ChartaAddNode<CR> " Add node in visual mode (multiple lines)
```

If you would like to set your own bindings, you can skip the default ones with:

```
let g:Charta_no_bindings = 1
```

## Available commands:

- `ChartaSetTour <tour url or id>` - Sets target Charta to edit
- `ChartaCurrentTour` - Prints current Charta id.
- `ChartaAddNode` - Adds a code snippet to the current Charta.
