let s:charta_hostname="https://www.charta.dev"
let s:charta_api_url=s:charta_hostname . "/api/v1/tours"
let s:charta_current_tour=""

" Utilities {{{

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

" }}}

function! s:set_tour_id(...)
  if a:0 == 1 && !empty(a:1)
    let l:tour_id=a:1
  else
    let l:tour_id=input("Enter Charta URL (leave empty to cancel):")

    if empty(l:tour_id)
      return
    endif
  end

  let l:tour_id = split(l:tour_id, "/")[-1] " Allow passing in URL

  let s:charta_current_tour=l:tour_id
  let l:tour_url=s:charta_hostname . "/tours/" . s:charta_current_tour
  silent execute "!open " . l:tour_url
endfunction

function! s:print_current_tour_id()
  if empty(s:charta_current_tour)
    echo "No currently active tour. Use :ChartaSetTour to choose one."
  else
    echo "Tour ID:" . s:charta_current_tour
  endif
endfunction

function! s:add_node() range
  if empty(s:charta_current_tour)
    call s:set_tour_id()
    if empty(s:charta_current_tour)
      return
    endif
  endif
  let l:lines = getline(a:firstline, a:lastline)
  let l:contents = join(l:lines, "\n")

  let l:endpoint = s:charta_api_url . "/" . s:charta_current_tour . "/add_node"
  let l:headers ="-H 'Content-Type: application/json' -H 'Accept: application/json'"
  let l:method ="-X PUT"
  let l:payload = {'line': a:firstline, 'contents': l:contents, 'path': @%}
  let l:data = "--data " . shellescape(s:to_json(payload), 1)
  let l:cmd = join(["curl", l:headers, l:method, l:data, l:endpoint], " ")

  echo "Node added."
  silent execute "!" . l:cmd
endfunction

" Public API {{{

command! ChartaConfigureEditor :echo v:servername
command! ChartaCurrentTour :echo <SID>print_current_tour_id()
command! -nargs=? ChartaSetTour :call <SID>set_tour_id(<q-args>)
command! -range ChartaAddNode <line1>,<line2>call <SID>add_node()

" }}}
" Bindings {{{

if !exists('g:Charta_no_bindings')
  let g:Charta_no_bindings=0
endif

if g:Charta_no_bindings == 0
  nnoremap <Leader>ca :ChartaAddNode<CR>
  vnoremap <Leader>ca :ChartaAddNode<CR>
endif

" }}}
