# Charta.vim

This is [Charta](https://www.charta.dev)'s official vim plugin.

It allows you to create code documentation, maps & tours straight for your editor.

#### Instalation with Vundle:

Add the following lines to your `.vimrc`:

```
Bundle 'ChartaDev/vim'
```

#### Requirements:

- `curl` must be installed.

## Default bindings:

- `<Leader>cs` - Sets current Charta to edit
- `<Leader>ca` - Adds snippet to charta (current line or visual selection)

If you want to set up your own bindings, then add to your vimrc:

```
let g:Charta_no_bindings = 1
```

And then set your bindings to:

- ```noremap <Leader>cs :call Charta_set_current_tour``` - Set current charta id
- ```noremap <Leader>ca :call Charta_set_current_tour``` - Add snippet in normal mode
- ```vnoremap <Leader>cs :call Charta_set_current_tour``` - Add snippet in visual mode
