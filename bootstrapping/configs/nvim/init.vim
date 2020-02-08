"""""""""""""""""""""""""""""""""""""
"General options
""""""""""""""""""""""""""""""""""""""
filetype off                                                                                                "required
set nocompatible                                                                                            "be iMproved, required
set hidden                                                                                                  
set wildignore+=*/node_modules/*                                                                            "ignore nodemodules for everything
set nofoldenable                                                                                            "turn off folding
set vb t_vb=                                                                                                "disable the beeps
set nowrap                                                                                                  "prevent auto line break
set tw=0                                                                                                    "same as previous
set textwidth=0                                                                                             "this turns off physical line wrapping (ie: automatic insertion of newlines)
set wrapmargin=0                                                                                            "same as previous
set undofile
set cursorline                                                                                              "cursor and colors
set showcmd                                                                                                 "shows things like d2w as you type
set incsearch                                                                                               "real time live search
set nu                                                                                                      "Line numbers
set relativenumber                                                                                          "relative numbers
set ic                                                                                                      "ignore case
set smartcase                                                                                               "unless there is capital in search bar
set hls                                                                                                     "highlight matches
set expandtab                                                                                               "make tabs spaces
set tabstop=2                                                                                               "four spaces is a tab
set shiftwidth=2                                                                                            
set wildmenu                                                                                                "command autocompletion
set wildmode=longest:full,full                                                                              "command autocompletion
set tags=./tags,tags;                                                                                       "set ctags file, current directory first, then parent
set background=dark                                                                                         "dark bg default
let $NVIM_TUI_ENABLE_TRUE_COLOR=1                                                                           "true colors
set termguicolors                                                                                           "true colors
syntax enable                                                                                               "syntax highlighting
colorscheme my-one                                                                                          "Color Scheme

"""""""""""""""""""""""""""""""""""""                                                                       
"Mappings configurationn                                                                                    
""""""""""""""""""""""""""""""""""""""                                                                      
let mapleader = ","                                                                                         "Leader Key (goes before any leader mappings)
"                                                                                                           "| marks the end of the command for vim allowing inline comments

"                                                                                                           "command mode
cmap W w ! sudo tee > /dev/null %|                                                                          "Allow saving of files as sudo when I forgot to start vim using sudo.

"                                                                                                           "visual mode
vnoremap <c-y> "+y|                                                                                         "Yank to clipboard
vnoremap Q :norm @q<cr>|                                                                                    "Apply q macro with Q

"                                                                                                           "insert mode
imap zp <esc>viWs)i|                                                                                        "Surround with parentheses
inoremap <c-e> <esc>A|                                                                                      "Emacs bindings for insert mode
inoremap <c-a> <esc>I|                                                                                      "Emacs bindings for insert mode
inoremap <c-k> <esc>ld$a|                                                                                   "Emacs bindings for insert mode
inoremap <c-f> <right>|                                                                                     "Emacs bindings for insert mode
inoremap <c-b> <left>|                                                                                      "Emacs bindings for insert mode
inoremap <c-n> <down>|                                                                                      "Emacs bindings for insert mode
inoremap <c-p> <up>|                                                                                        "Emacs bindings for insert mode
inoremap <leader>s <esc>:w<CR>|                                                                             "Save file
inoremap jk <esc>l|                                                                                         "Enter normal mode
inoremap <leader>qq <esc>:q!<CR>|                                                                           "Quit without save

"                                                                                                           "normal mode
nmap zp viWs)iprint<esc>|                                                                                   "Surround with print()
nnoremap <expr> { len(getline(line('.')-1)) > 0 ? '{+' : '{-'|                                              "Sane paragraph movements"
nnoremap <expr> } len(getline(line('.')+1)) > 0 ? '}-' : '}+'|                                              "Sane paragraph movements"
nnoremap <c-i> "+p|                                                                                         "Paste from clipboard
nnoremap / q/i|                                                                                             "Use search history
nnoremap ? q?i|                                                                                             "Use reverse search history
nnoremap <M-j> <c-e>|                                                                                       "Scroll down
nnoremap <M-k> <c-y>|                                                                                       "Scroll up
nnoremap <M-CR> i<c-m><esc>|                                                                                "Break current line
nnoremap <Leader>m gqip|                                                                                    "Reformat paragraph
nnoremap <leader>s :w<CR>|                                                                                  "Save file
nnoremap <leader>z :noh<return><esc>|                                                                       "Unhighlight search results
nnoremap <leader>qq :q!<CR>|                                                                                "Quit without save
nnoremap <leader>g za|                                                                                      "Enable code folding
nnoremap <enter> o<esc>|                                                                                    "New line below current line
nnoremap sp a<space><esc>|                                                                                  "Space after cursor
nnoremap N Nzz|                                                                                             "Center backwards search result
nnoremap n nzz|                                                                                             "Center forwards search result
nnoremap <space>s :%s/|                                                                                     "Global find and replace
nnoremap <leader>a =ip|                                                                                     "Align paragraphs
nnoremap cp yap<S-}>p|                                                                                      "Clone paragraph
nnoremap Q @q|                                                                                              "Apply q macro with Q
"                                                                                                           "vimux file types
au bufnewfile,bufread *.tex
    \ nnoremap <Leader>b :w\|:call VimuxRunCommand("clear; xelatex " . bufname("%"))<CR>
au bufnewfile,bufread *.js
    \ nnoremap <Leader>b :w\|:call VimuxRunCommand("clear; node " . bufname("%"))<CR>|
    \ nnoremap K :TernDocBrowse<CR>|
au bufnewfile,bufread *.py
    \ nnoremap <Leader>b :w\|:call VimuxRunCommand("clear; python " . bufname("%"))<CR>

"""""""""""""""""""""""""""""""""""""""""""                                                                 
" Install Vim Plug if not installed                                                                         
"""""""""""""""""""""""""""""""""""""""""""                                                                 
if empty(glob('~/.config/nvim/autoload/plug.vim'))                                                          
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs                                          
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim                                   
  autocmd VimEnter * PlugInstall                                                                            
endif                                                                                                       

call plug#begin()                                                                                           

"""""""""""""""""""""""""""""""""""""""""""                                                                 
"look & feel                                                                                                
"""""""""""""""""""""""""""""""""""""""""""                                                                 
Plug 'wincent/terminus'                                                                                     "thin bar when insert, fat bar when normal
Plug 'vim-airline/vim-airline'                                                                              "bar at bottom of screen
Plug 'vim-airline/vim-airline-themes'                                                                       "color for bottom bar
Plug 'Yggdroot/indentLine'                                                                                  "vertical lines showing where indents start/end

"""""""""""""""""""""""""""""""""""""""""""                                                                 
" auto-completion                                                                                           
"""""""""""""""""""""""""""""""""""""""""""                                                                 
"Plug 'ervandew/supertab'                                                                                    
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }                                               "docs require update post install (note, fails if pynvim not installed when PlugInstall)
    function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
        endfunction"}}}
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ deoplete#manual_complete()
    inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"|                                                "deoplete tab-complete
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"|                                          "deoplete enter selects option
Plug 'wokalski/autocomplete-flow',{ 'for': ['javascript', 'javascript.jsx'] }                               "deoplete source for js
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }                "starts js server for better code completion
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install -g tern' }   "integrates tern with deoplete
Plug 'deoplete-plugins/deoplete-jedi', { 'for': ['python'] }                                                "deoplete source for python
Plug 'lervag/vimtex'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

"""""""""""""""""""""""""""""""""""""""""""
"navigation
"""""""""""""""""""""""""""""""""""""""""""
Plug 'vim-ctrlspace/vim-ctrlspace'
    nnoremap <space>j :CtrlSpaceGoDown<CR>
    nnoremap <space>k :CtrlSpaceGoUp<CR>
    nnoremap gj :tabprevious<CR>
    nnoremap gk :tabnext<CR>
Plug 'rafaqz/ranger.vim'
    nnoremap <leader>rr :RangerEdit<cr>
    nnoremap <leader>rv :RangerVSplit<cr>
    nnoremap <leader>rs :RangerSplit<cr>
    nnoremap <leader>rt :RangerTab<cr>
    nnoremap <leader>ri :RangerInsert<cr>
    nnoremap <leader>ra :RangerAppend<cr>
Plug 'kien/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
    map  <leader>f <Plug>(easymotion-bd-f)|                                                                 "reverse find and easymotion find
    nmap <leader>f <Plug>(easymotion-overwin-f)
    nmap X <Plug>(easymotion-overwin-f2)
    map <Leader>L <Plug>(easymotion-bd-jk)|                                                                 "move to line
    nmap <Leader>L <Plug>(easymotion-overwin-line)
    map  <Leader>w <Plug>(easymotion-bd-w)|                                                                 "move to word
    nmap <Leader>w <Plug>(easymotion-overwin-w)
    map <Leader>l <Plug>(easymotion-lineforward)|                                                           "move to line same column
    map <Leader>j <Plug>(easymotion-j)
    map <Leader>k <Plug>(easymotion-k)
    map <Leader>h <Plug>(easymotion-linebackward)
Plug 'benmills/vimux'
    nnoremap <Leader>p :call VimuxRunCommand("clear; python " . bufname("%"))<CR>
    nnoremap <Leader><space> :VimuxPromptCommand<CR>
    nnoremap <Leader>b :w\|:VimuxRunLastCommand<CR>
    inoremap <Leader>b <esc>:w\|:VimuxRunLastCommand<CR>
    function! VimuxSlime()
     let startl= line("'<")
     let endl= line("'>")
     let lines = getline(startl, endl)
     let cmds = join(lines, ";")
     call VimuxSendText(cmds)
     call VimuxSendKeys("Enter")
    endfunction
    vmap <Leader>vs "vy :call VimuxSlime()<CR>|                                                             "Save selected text v buffer and send that it to tmux
    nmap <Leader>vs vip<Leader>vs|                                                                          "Send current paragraph to tmux
    imap <Leader>vs <esc><Leader>vs|                                                                        "Send current paragraph to tmux

"""""""""""""""""""""""""""""""""""""""""""
"linting and formatting
"""""""""""""""""""""""""""""""""""""""""""
Plug 'sheerun/vim-polyglot'
Plug 'sbdchd/neoformat'
Plug 'w0rp/ale'
Plug 'https://github.com/scrooloose/nerdcommenter.git'
    nmap <leader>cp vip<leader>c<space>|                                                                    "Comment current paragraph
Plug 'kana/vim-surround'
Plug 'jiangmiao/auto-pairs'

"""""""""""""""""""""""""""""""""""""""""""
"js
"""""""""""""""""""""""""""""""""""""""""""
Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'mattn/emmet-vim', { 'for': ['javascript', 'javascript.jsx', 'html'] }
Plug 'prettier/vim-prettier', { 'for': ['javascript', 'javascript.jsx'] }

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""
"options that require plugins to be loaded
"""""""""""""""""""""""""""""""""""""""""""
"let g:python_host_prog = '/full/path/to/neovim2/bin/python'                                                "venv for python2 autocompletion
"let g:python3_host_prog = '/home/'.$USER.'/.config/nvim/nvim-python-env/bin/python3'                        "venv for python3 autocompletion
let g:EasyMotion_startofline = 0                                                                            "keep cursor column when JK motion
let g:airline_powerline_fonts = 1                                                                           "pretty arrows on bottom bar
let g:airline_theme='wombat'                                                                                "color theme of bottom bar

let g:deoplete#sources#ternjs#docs = 1                                                                      "use tern docs
let g:deoplete#sources#ternjs#types = 0                                                                     "use tern type hints
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#filetypes = ['jsx', 'ts', 'js']                                               "filetypes to include with tern
let g:tern#command = ["tern"]                                                                               "allow using tern_for_vim and deoplete-tern at same time
let g:tern#arguments = ["--persistent"]                                                                     "same as previous

let g:deoplete#enable_at_startup = 1                                                                        "turn on deoplete
let g:deoplete#disable_auto_complete = 1                                                                    "don't pop up autocomplete without tab
"let g:deoplete#auto_complete_delay=2000                                                                     "delay before popping up
call deoplete#custom#source('ultisnips', 'rank', 1000)
call deoplete#custom#source('file', 'rank', 1000)

let g:UltiSnipsExpandTrigger="<C-j>"                                                                        "tab to select snippet, but not to expand it
let g:CtrlSpaceDefaultMappingKey = "<C-space> "                                                             "show open windows
let g:prettier#config#trailing_comma = 'all'                                                                "include commas on js arrays

autocmd CompleteDone * silent! pclose!

"autoformat js and python files
augroup fmt
  autocmd!
  autocmd BufWritePre *.js,*.jsx,*.py undojoin | Neoformat
augroup END

" Required:
filetype plugin indent on
