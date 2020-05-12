let s:charta_hostname="http://localhost:4000"
let s:charta_api_url=s:charta_hostname . "/api/v1/tours"

if !exists('s:charta_current_tour')
  let s:charta_current_tour=""
endif

if !exists('g:charta_api_token')
  let g:charta_api_token=""
endif

" Implementation {{{
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
  silent execute "!which open && open " . l:tour_url
  silent execute "!which xdg-open && xdg-open " . l:tour_url
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
  let l:full_path = expand('%:p')
  let l:payload = {'line': a:firstline, 'contents': l:contents, 'path': @%, 'editor': 'vim', 'full_path': l:full_path}

  let l:response = charta#client#add_node(s:charta_current_tour, payload)

  if response['status'] == 200
    echo "Node added."
  else
    echo "Could not add node - " . response['content']['error']
  end
endfunction
" }}}
" Public API {{{

command! ChartaConfigureEditor :echo v:servername
command! ChartaShowTour :echo <SID>print_current_tour_id()
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
