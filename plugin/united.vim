
"
" united.vim
"
" Author: Henrik Kjelsberg (http://github.com/hkjels/)
" Version: 0.0.1
" License: MIT
"

if exists('g:loaded_united')
  finish
else
  let g:loaded_united = 1
endif

" Module dependencies -------------------------------------------------- {{{
  NeoBundle 'Shougo/unite.vim', {'depends': [
  \    ['Shougo/vimproc.vim', {'build': {'mac': 'make -f make_mac.mak'}}]
  \  ]}
  NeoBundle 'Shougo/unite-help', {'unite_sources': 'help'}
  NeoBundle 'h1mesuke/unite-outline'
  NeoBundle 'osyo-manga/unite-quickfix'
  NeoBundle 'thinca/vim-unite-history'
" }}}

" Unite settings ------------------------------------------------------- {{{
  let s:bundle=neobundle#get('unite.vim')
  function! s:bundle.hooks.on_source(bundle)
    let g:unite_enable_start_insert = 1
    let g:unite_source_file_rec_max_cache_files = 0

    let s:unite_affects = 'file,file/new,buffer,file_rec,file_rec/async'
    let s:unite_ignore = '/^\%(.git\|.DS_Store\|components\|node_modules\|.jpg\|.png\|.gif\)$/'
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#custom#source(s:unite_affects, 'max_candidates', 0)
    call unite#custom#source(s:unite_affects, 'ignore_pattern', s:unite_ignore)

    if executable('ag')
      let g:unite_source_grep_command = 'ag'
    elseif executable('ack')
      let g:unite_source_grep_command = 'ack'
    else
      let g:unite_source_grep_command = 'grep'
    endif
    let g:unite_source_grep_default_opts = '--nogroup --nocolor --column --smart-case'
    let g:unite_source_grep_recursive_opt = ''

    augroup Unite
      autocmd!
      autocmd FileType unite nunmap <buffer> E
      autocmd FileType unite noremap <buffer><silent><expr> E unite#do_action('vsplit')
    augroup END

    nnoremap <c-p>      :Unite -buffer-name=files file_rec/async:!<cr>
    nnoremap <c-y>      :Unite -buffer-name=history history/yank:!<cr>
    nnoremap <leader>b  :Unite -buffer-name=buffers buffer:!<cr>
    nnoremap <leader>o  :Unite -buffer-name=outline outline<cr>
    nnoremap <leader>/  :Unite -buffer-name=search -no-quit grep:.<cr>
    nnoremap <leader>h  :Unite -buffer-name=history history<cr>
  endfunction
  unlet s:bundle
" }}}

