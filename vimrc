set nocompatible

"let g:pathogen_disabled = ["tagbar", "vim-align", "vim-bufexplorer", "vim-colors-solarized", "vim-javascript", "vim-matchit", "vim-rails", "vim-ruby", "vim-surround", "yaml-vim"]
let g:pathogen_disabled = ["nerdtree"]
let g:slime_target = "tmux"

call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on
set exrc
set secure

function! OpenWithSpecs(...)
	let l:file_globs=a:000
  for glob in file_globs
    for filename in split(glob(glob), "\n")
      let l:specname = 
            \ substitute(filename, "^app/\\(.*\\).rb$", "spec/\\1_spec.rb", "")
      exec 'tabedit '.specname
      exec 'rightbelow vsplit '.filename
    endfor
  endfor
endfunction

function! OpenSpecFor(filename)
  let l:filename=a:filename
  let l:specname = 
        \ substitute(filename, "^app/\\(.*\\).rb$", "spec/\\1_spec.rb", "")
  exec 'leftbelow vsplit '.specname
endfunction

command! -complete=file -nargs=+ SpecEdit call OpenWithSpecs(<f-args>)
cabbrev spe SpecEdit

" Core keymappings
:nore <Space> :
" Cycle through buffers using Ctrl-n and Ctrl-m for previous and next
:nnoremap <C-m> :bnext<CR>
:nnoremap <C-n> :bprev<CR>
" Cycle through tabs using Ctrl-j and Ctrl-k
:nnoremap <C-k> :tabnext<CR>
:nnoremap <C-j> :tabprev<CR>
" Window splitting
:map <C-/> :vs<CR>
:map <C-.> :sp<CR>
" JOOOOOOOOOOBBBBBBBSSSSS!!!!!
:imap § #
" File tree shortcuts
:imap <F4> <ESC>:NERDTreeToggle<CR>
:map <F4> :NERDTreeToggle<CR>
" Comment/uncomment blocks
:map \c :s/^/#/<CR>
:map \u :s/^#//<CR>
" Ctags
" Broken (because cword doesn't include !? in ruby) but possibly better
" if fixable?
":map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
:map <C-\> :vsp <CR><C-W><C-W><C-]>
" Paste mode toggle
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>

" Tabularize mappings
" Uses zero-width negative lookahead to prevent splitting up hashrockets:
autocmd VimEnter * if exists(":Tabularize") | exe "nmap <Leader>a= :Tabularize /=>\@!<CR>" | endif
autocmd VimEnter * if exists(":Tabularize") | exe "vmap <Leader>a= :Tabularize /=>\@!<CR>" | endif
" Exclude ':' char from match to prevent colons being columnized:
autocmd VimEnter * if exists(":Tabularize") | exe "nmap <Leader>a: :Tabularize /:\zs<CR>" | endif
autocmd VimEnter * if exists(":Tabularize") | exe "vmap <Leader>a: :Tabularize /:\zs<CR>" | endif

" Command abbreviations
cabbrev te tabedit

" Editing and display variables
set bs=2          " minimal restrictions on backspace
set tabstop=2     " set tab character to 2 characters
set expandtab     " turn tabs into whitespace
set shiftwidth=2  " indent width for autoindent
set showtabline=2 " always show tab line
set laststatus=2  " always show status line
set visualbell    " turn off beeping
set showmatch     " show matching paren on entry
set number        " show line numbers
set ruler
if exists("&colorcolumn")
  set colorcolumn=80
endif
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ %cC\ (%p%%)]

" Colorschemes
colorscheme solarized
set background=dark
