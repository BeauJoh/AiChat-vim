" ============================================================================
" File:         aichat.vim
" Description:  vim-aichat.vim — A VIM plugin to Integrate AiChat CLI tool.
" Author:       Beau Johnston
" Version:      1.0
" License:      MIT
" ============================================================================

" -----------------------------
" Create AiChat buffer with optional lines
" -----------------------------
function! AiChatBuf(lines) abort
  botright new
  setlocal buftype=nofile         " scratch buffer
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal filetype=ai_chat
  setlocal modifiable
  let b:aichat_buf = 1

  " Header
  call append(0, ['=== AI Chat Buffer ===', 'Type your prompt below and run <leader>s (or :AiChatSend)'])

  " Insert initial lines if provided
  if !empty(a:lines)
    call append(2, a:lines)
  endif

  " Folding
  setlocal foldmethod=marker
  setlocal foldmarker={{{,}}}

  " Highlighting
  highlight UserPrompt guifg=Blue ctermfg=Blue
  highlight AIResponse guifg=Green ctermfg=Green

  " Move cursor to end
  execute '$'
  echo "AiChat buffer ready"
endfunction

" -----------------------------
" Send last user prompt to AI
" -----------------------------
function! AiChatSend() abort
  if !exists('b:aichat_buf')
    echoerr "Not an AiChat buffer!"
    return
  endif

  let l:last_line = line('$')
  while l:last_line > 0 && getline(l:last_line) =~ '^\s*$'
    let l:last_line -= 1
  endwhile
  if l:last_line == 0
    echo "Nothing to send"
    return
  endif

  " Find start of last prompt (after previous AI response or header)
  let l:start_line = 1
  for lnum in reverse(range(1, l:last_line))
    if getline(lnum) =~ '^{{{AIResponse}}}$'
      let l:start_line = lnum + 1
      break
    endif
  endfor

  let l:prompt_lines = getline(l:start_line, l:last_line)
  if empty(l:prompt_lines)
    echo "No new prompt to send"
    return
  endif
  let l:prompt = join(l:prompt_lines, "\n")

  " Write prompt to temp file
  let l:temp = tempname()
  call writefile(split(l:prompt, "\n"), l:temp)

  " Call aichat CLI
  let l:cmd = 'aichat < ' . shellescape(l:temp)
  let l:res = system(l:cmd)
  call delete(l:temp)
  if v:shell_error != 0
    echoerr "aichat failed: " . l:res
    return
  endif

  " Append AI response with fold markers
  call append(l:last_line, ['{{{AIResponse}}}'])
  let l:response_lines = split(l:res, "\n")
  call append(l:last_line + 1, l:response_lines)
  call append(l:last_line + 1 + len(l:response_lines), ['}}}'])

  " Highlight user prompt
  for lnum in range(l:start_line, l:last_line)
    call matchaddpos('UserPrompt', [[lnum]])
  endfor

  " Highlight AI response
  for lnum in range(l:last_line + 2, l:last_line + 1 + len(l:response_lines))
    call matchaddpos('AIResponse', [[lnum]])
  endfor

  " Auto-fold previous AI responses except last
  normal! zx
  let l:fold_starts = []
  for lnum in range(1, line('$'))
    if getline(lnum) =~ '^{{{AIResponse}}}$'
      call add(l:fold_starts, lnum)
    endif
  endfor
  if len(l:fold_starts) > 1
    for lnum in l:fold_starts[0 : -2]
      execute lnum
      normal! zc
    endfor
  endif

  " Scroll to latest AI response
  execute '$'
  normal! zz
  echo "AI response appended (previous responses folded)"
endfunction

" -----------------------------
" Command-line range-aware AiChat buffer (linewise only)
" -----------------------------
command! -range -bang -nargs=* AiChatBuf call AiChatBuf((<line1> !=# 0) ? getline(<line1>, <line2>) : [])

command! AiChatSend call AiChatSend()

" -----------------------------
" Helper: open AiChat buffer from visual selection positions
" -----------------------------
function! s:OpenAiChatFromSelection(start_line, start_col, end_line, end_col) abort
  let lines = getline(a:start_line, a:end_line)
  " Trim first and last lines to selection columns
  let lines[0] = lines[0][a:start_col-1:]
  let lines[-1] = lines[-1][:a:end_col-1]
  call AiChatBuf(lines)
endfunction

" -----------------------------
" Mappings
" -----------------------------
" Visual mode: capture positions and open AiChat buffer
xnoremap <silent> <leader>a :<C-U>call <SID>OpenAiChatFromSelection(getpos("'<")[1], getpos("'<")[2], getpos("'>")[1], getpos("'>")[2])<CR>

" Normal mode: open empty AiChat buffer
nnoremap <silent> <leader>a :call AiChatBuf([])<CR>

" Send prompt inside AiChat buffer
autocmd FileType ai_chat nnoremap <buffer> <leader>s :AiChatSend<CR>
