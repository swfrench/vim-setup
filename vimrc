" set up pathogen
call pathogen#infect()

" set colorscheme
colorscheme molokai

" setup statusline, including fugitive
set laststatus=2
set statusline=%<%f\ %h%m%r\ %{fugitive#statusline()}%=%-14.([%l/%L,%c]%)\ %P

" line numbering
set number

" highlight search
set hlsearch

" syntastic
"let g:syntastic_c_include_dirs = ["../include","include"]

" for gvim only (heavier)
if has("gui_running")
  " neocomplcache
  let g:acp_enableAtStartup = 0
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_min_syntax_length = 3
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
endif

" key mapping maps
inoremap jk <esc>
