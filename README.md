# Charta.vim

This is [Charta](https://www.charta.dev)'s official vim plugin.

It allows you to create code documentation, maps & tours straight for your editor.

![preview](https://user-images.githubusercontent.com/2349448/79638545-d6a11f00-817d-11ea-92da-087b77918063.png)

#### Instalation with Vundle:

Add the following lines to your `.vimrc`:

```
Plugin 'ChartaDev/charta.vim'
```

#### Requirements:

- `curl` must be installed and available in your PATH.

## Bindings:

The following bindings are set four you:

```vim
nnoremap <Leader>ca :ChartaAddNode<CR>
vnoremap <Leader>ca :ChartaAddNode<CR>
```

If you would like to set your own bindings, you can skip the default ones with:

```vim
let g:Charta_no_bindings = 1
```

## Available commands:

- `:ChartaSetTour <tour url or id>` - Sets target Charta to edit
- `:ChartaCurrentTour` - Prints current Charta id.
- `:ChartaAddNode` - Adds a code snippet to the current Charta.
