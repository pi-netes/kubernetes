" File: my-jellybeans.vim
" Author: Ondrej Kulaty aka rubick
" Description: This file is used to customize stokc jellybeans color sheme

hi clear
if exists("syntax_on")
  syntax reset
endif

"Load the 'base' colorscheme - the one you want to alter
runtime colors/one.vim

"Override the name of the base colorscheme with the name of this custom one
let g:colors_name = "my-one"

"hi Statement cterm=Bold
"hi Normal ctermfg=white 
"hi StatusLine ctermbg=24 ctermfg=white
"hi StatusLineNC ctermbg=235 ctermfg=250
hi Search ctermbg=darkblue ctermfg=lightgreen cterm=Bold

"dark lavender
"hi Operator    ctermfg=105 
"hi Statement   ctermfg=105  
"hi Function    ctermfg=111  
"hi Function    ctermfg=173  

"cyan
"hi Boolean     ctermfg=38   
"yellow
hi Boolean     ctermfg=221   

"orange
"hi Conditional ctermfg=173  
"
"yellow
hi Conditional ctermfg=221  


"medium bold orange
"hi Comment     ctermfg=30  
hi Comment     ctermfg=8  

"green
"hi String      ctermfg=120

"bolder orange
hi Number      ctermfg=208  
hi Float       ctermfg=208  

hi Pmenu        ctermbg=236 ctermfg=255
hi Pmenusel     ctermbg=30 ctermfg=120
"hi Include     ctermfg=37  

" For transparent background
hi NonText ctermbg=none
hi Normal ctermbg=none
hi LineNr ctermbg=none
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi CursorLine guibg=black
