" json

function! charta#json#parse(json)
  " Kindly stolen from:
  " https://github.com/mattn/webapi-vim/blob/master/autoload/webapi/json.vim
  let json = iconv(a:json, "utf-8", &encoding)
  if substitute(substitute(substitute(
    \ json,
    \ '\\\%(["\\/bfnrt]\|u[0-9a-fA-F]\{4}\)', '\@', 'g'),
    \ '"[^\"\\\n\r]*\"\|true\|false\|null\|-\?\d\+'
    \ . '\%(\.\d*\)\?\%([eE][+\-]\{-}\d\+\)\?', ']', 'g'),
    \ '\%(^\|:\|,\)\%(\s*\[\)\+', '', 'g') !~ '^[\],:{} \t\n]*$'
    throw json
  endif
  let json = join(split(json, "\n"), "")
  let json = substitute(json, '\\x22\|\\u0022', '\\"', 'g')
  if v:version >= 703 && has('patch780')
    let json = substitute(json, '\\u\(\x\x\x\x\)', '\=iconv(nr2char(str2nr(submatch(1), 16), 1), "utf-8", &encoding)', 'g')
  else
    let json = substitute(json, '\\u\(\x\x\x\x\)', '\=s:nr2enc_char("0x".submatch(1))', 'g')
  endif

  let [null,true,false] = [0,1,0]
  sandbox let ret = eval(json)

  return ret
endfunction

function! charta#json#encode(object)
  if type(a:object) == type('')
    let l:str = substitute(a:object, "[\001-\031\"\\\\]", '\=printf("\\u%04x", char2nr(submatch(0)))', 'g')
    return '"' . l:str . '"'
  elseif type(a:object) == type([])
    return '['.join(map(copy(a:object), 'charta#json#encode(v:val)'),', ').']'
  elseif type(a:object) == type({})
    let pairs = []
    for key in keys(a:object)
      call add(pairs, charta#json#encode(key) . ': ' . charta#json#encode(a:object[key]))
    endfor
    return '{' . join(pairs, ', ') . '}'
  else
    return string(a:object)
  endif
endfunction

