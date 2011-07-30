if has("gui_running")
  set background=dark
  colorscheme solarized
  set guioptions=aiA " Disable toolbar, menu bar, scroll bars
  set guifont=Monaco:h12
endif " has("gui_running")

if has("gui_macvim")
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :tabnew<CR>:CommandT<CR>
"  map <D-b> :CommandTBuffer<CR>
endif
