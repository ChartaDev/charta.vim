let g:charta_hostname="https://www.charta.dev"
let g:charta_api_url=g:charta_hostname . "/api/v1/tours"
let g:charta_current_tour=""

function! s:to_json(object)
  if type(a:object) == type('')
    let l:str = substitute(a:object, "[\001-\031\"\\\\]", '\=printf("\\u%04x", char2nr(submatch(0)))', 'g')
    return '"' . l:str . '"'
  elseif type(a:object) == type([])
    return '['.join(map(copy(a:object), 's:to_json(v:val)'),', ').']'
  elseif type(a:object) == type({})
    let pairs = []
    for key in keys(a:object)
      call add(pairs, s:to_json(key) . ': ' . s:to_json(a:object[key]))
    endfor
    return '{' . join(pairs, ', ') . '}'
  else
    return string(a:object)
  endif
endfunction

function! s:get_visual_selection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! Charta_set_current_tour()
  let g:charta_current_tour=input("Enter Charta Id:")
  let l:tour_url=g:charta_hostname . "/tours/" . g:charta_current_tour
  silent execute "!open " . l:tour_url
endfunction

function! s:add_node(contents)
  if empty(g:charta_current_tour)
    call Charta_set_current_tour()
    return
  endif

  let l:endpoint = g:charta_api_url . "/" . g:charta_current_tour . "/add_node"
  let l:headers ="-H 'Content-Type: application/json' -H 'Accept: application/json'"
  let l:method ="-X PUT"
  let l:payload = {'line': line('.'), 'contents': a:contents, 'path': @%}
  let l:data = "--data " . shellescape(s:to_json(payload), 1)
  let l:cmd = join(["curl", l:headers, l:method, l:data, l:endpoint], " ")

  echo "Node added."
  silent execute "!" . l:cmd
endfunction

function! Charta_add_node()
  let l:contents = getline(".")
  call s:add_node(l:contents)
endfunction

function! Charta_add_node_visual()
  let l:contents = s:get_visual_selection()
  call s:add_node(l:contents)
endfunction

function! Charta_show_socket()
  echo v:servername
endfunction

noremap <Leader>cs :call Charta_set_current_tour()<CR>
noremap <Leader>ca :call Charta_add_node()<CR>
vnoremap <Leader>ca :<c-u>call Charta_add_node_visual()<CR>
