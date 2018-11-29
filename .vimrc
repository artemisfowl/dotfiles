set nu rnu
set autoindent
set hlsearch
set incsearch
set smartcase
set nocompatible
set noswapfile
set autochdir
set laststatus=2
set colorcolumn=120
set backspace=2
set grepprg=grep\ -nH\ $*
set cursorline

" -------- Bundle Configuration section --------------------
" Set vundle package manager
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" Include Bundles
Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
Bundle 'sjl/gundo.vim'
Bundle 'rking/ag.vim'
Bundle 'godlygeek/tabular'
Bundle 'xolox/vim-session'
Bundle 'xolox/vim-misc'
Bundle 'vim-scripts/Tagbar'
Bundle 'beloglazov/vim-online-thesaurus'
Bundle 'machakann/vim-highlightedyank'

" Gundo plugin configuration
set undodir=~/.vim/tmp/undo//
set undofile
set history=100
set undolevels=100

" Vim-session management settings
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"

" Key mappings
map <silent> <F4> :NERDTreeToggle<CR>
map! <silent> <F4> <ESC>:NERDTreeToggle<CR>

map <silent> <F2> :GundoToggle<CR>
map! <silent> <F-2> <ESC>:GundoToggle<CR>

" Ag Configuration
let g:ag_prg="/usr/bin/ag --column"

set listchars=tab:>~,nbsp:_,trail:.,eol:$,extends:>,precedes:<
noremap <F6> :set list!<CR>

xnoremap < <gv
xnoremap > >gv

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
endfunction

:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

nnoremap <C-K> :call HighlightNearCursor()<CR>

function! HighlightNearCursor() " Function already exists now, not required explicitly
    if !exists("s:highlightcursor")
        match Todo /\k*\%#\k*/
        let s:highlightcursor=1
    else
        match None
        unlet s:highlightcursor
    endif
endfunction

let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
let s:minfontsize = 6
let s:maxfontsize = 16
function! AdjustFontSize(amount)
    if has("gui_gtk2") && has("gui_running")
        let fontname = substitute(&guifont, s:pattern, '\1', '')
        let cursize = substitute(&guifont, s:pattern, '\2', '')
        let newsize = cursize + a:amount
        if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
            let newfont = fontname . newsize
            let &guifont = newfont
        endif
    else
        echoerr "You need to run the GTK2 version of Vim to use this function."
    endif
endfunction

" removing all bells for the GUI mode only
if has("gui_gtk2") && has("gui_running")
	set belloff=all
endif

function! LargerFont()
    call AdjustFontSize(1)
endfunction
command! LargerFont call LargerFont()

function! SmallerFont()
    call AdjustFontSize(-1)
endfunction
command! SmallerFont call SmallerFont()

" Close the preview window when I am out of the edit mode
let g:ycm_autoclose_preview_window_after_insertion = 1

" Some other key mappings for qutting
"nnoremap <F6> :echom bufnr('%')<CR>
inoremap ^H <BS>

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

let g:rustfmt_autosave = 0

" Tagbar configuration
nnoremap <silent> <F7> :Tagbar<CR>

" Jump to shell
nnoremap <silent> <F8> :sh<CR>

let g:tagbar_type_typescript = {
            \ 'ctagstype': 'typescript',
            \ 'kinds': [
            \ 'c:classes',
            \ 'n:modules',
            \ 'f:functions',
            \ 'v:variables',
            \ 'v:varlambdas',
            \ 'm:members',
            \ 'i:interfaces',
            \ 'e:enums',
            \ ]
            \}

" Word Processor mode function
func! WordProcessorMode()
    setlocal smartindent
    setlocal spell spelllang=en_us
endfu

com! WP call WordProcessorMode()

" Putting the OpenSession command to an alias - too much hassle to type this
" big a command
cnoreabbrev os OpenSession

" Adding Thesaurus mode kepmaps
nnoremap <F9> :OnlineThesaurusCurrentWord<CR>
" Adding git custom command in here
cnoreabbrev gs Gstatus
cnoreabbrev gc Gcommit
cnoreabbrev gp Gpush
cnoreabbrev gl Gpull
cnoreabbrev gw Gwrite

" Search down into sub-directories and provide auto-completion for all file
" related tasks
set path+=**

" Update the location list with the error details
let g:ycm_always_populate_location_list = 1

" Make, make clean and the like
let &makeprg = 'if [ -f Makefile ]; then make -C %:p:h $*; else make -C %:p:h/.. $*; fi'
nnoremap <leader>m :silent make!\|redraw!\|cw<CR>

" This shows what you are typing as a command.  I love this!
"set showcmd

" Folding Stuffs
" set foldmethod=marker
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1
set tabpagemax=1000

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
    set spl=en spell
    set nospell
endif

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=a

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Need to set up the clipboard
set clipboard=unnamed
let g:clipbrdDefaultRed = '+'

syntax enable
filetype plugin indent on

colorscheme wombat
" changing the cursorline and cursorcolumn highlight colors
hi CursorLine  cterm=bold ctermbg=grey ctermfg=black "guibg=darkred guifg=white
hi CursorColumn ctermbg=6 ctermbg=grey ctermfg=black

" Changing the highlight colors
hi Search cterm=NONE ctermfg=white ctermbg=blue

" Changing the MatchParen highlight colors
hi MatchParen cterm=bold ctermbg=blue ctermfg=white

map H ^
map L $
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l
map <F8> :sh<CR>
map <F5> :redraw!<CR>

" buffer movement techniques
map <C-n> :bn<CR>
map <C-r> :bp<CR>

" Performing the statuline customisations
function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=[%{StatuslineGit()}]
set statusline+=[\%f]
set statusline+=\ %m
set statusline+=\ %n
set statusline+=\ %r
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c

" Changing the highlighting of the status line
hi StatusLine cterm=bold ctermfg=8 ctermbg=255

"{{{Auto Commands

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
    au!
    autocmd BufReadPost *
                \ if expand("<afile>:p:h") !=? $TEMP |
                \   if line("'\"") > 1 && line("'\"") <= line("$") |
                \     let JumpCursorOnEdit_foo = line("'\"") |
                \     let b:doopenfold = 1 |
                \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
                \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
                \        let b:doopenfold = 2 |
                \     endif |
                \     exe JumpCursorOnEdit_foo |
                \   endif |
                \ endif
    " Need to postpone using "zv" until after reading the modelines.
    autocmd BufWinEnter *
                \ if exists("b:doopenfold") |
                \   exe "normal zv" |
                \   if(b:doopenfold > 1) |
                \       exe  "+".1 |
                \   endif |
                \   unlet b:doopenfold |
                \ endif
augroup END

"}}}

" Make, make clean and the like
let &makeprg = 'if [ -f Makefile ]; then make -C %:p:h $*; else make -C %:p:h/.. $*; fi'
nnoremap <leader>m :silent make!\|redraw!\|cw<CR>

" Setting the color column for specific file types
augroup any
        autocmd FileType * set tabstop=2 colorcolumn=200 shiftwidth=2 nocursorcolumn noexpandtab textwidth=199
augroup END

augroup cc
        autocmd BufRead,BufNewFile *.h,*.c set filetype=c
        autocmd FileType c set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup cp
        autocmd BufRead,BufNewFile *.hpp,*.cpp set filetype=cpp
        autocmd FileType cpp set colorcolumn=120 tabstop=2 shiftwidth=2 nocursorcolumn noexpandtab textwidth=119
augroup END

augroup python
        autocmd BufRead,BufNewFile *.py set filetype=python
        autocmd FileType python set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup go
        autocmd BufRead,BufNewFile *.go set filetype=go
        autocmd FileType go set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup ruby
        autocmd BufRead,BufNewFile *.rb set filetype=ruby
        autocmd FileType ruby set colorcolumn=80 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup tex
        autocmd BufRead,BufNewFile *.tex set filetype=tex
        autocmd FileType tex set colorcolumn=120 tabstop=8 shiftwidth=8 nocursorcolumn noexpandtab textwidth=119
augroup END

augroup em
        autocmd BufRead,BufNewFile *.ino set filetype=arduino
        autocmd FileType arduino set colorcolumn=80 tabstop=2 shiftwidth=2 nocursorcolumn noexpandtab textwidth=79
augroup END

augroup asm
        autocmd BufRead,BufNewFile *.asm set filetype=asm
        autocmd FileType asm set colorcolumn=120 tabstop=2 shiftwidth=2 cursorcolumn noexpandtab textwidth=119
augroup END

" Adding the time addition shortcut
:nnoremap <F10> "=strftime("%a, %d %b %Y %H:%M:%S %z") . ": "<CR>P
:inoremap <F10> <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z") . ": "<CR>

" Setting up F3 to open a terminal with a vertical split
set splitright " open the split on the right hand side always
nnoremap <silent> <F3> :vertical terminal<CR>

if has("autocmd")
    "au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
    au InsertEnter * silent execute "!echo -ne \e[6 q"
    "au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    au InsertLeave * silent execute "!echo -ne \e[2 q"
    "au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
    au InsertLeave * silent execute "!echo -ne \e[2 q"
endif

" CtrlP configuration
set runtimepath^=~/.vim/bundle/ctrlp.vim
" For checking files using CtrlP
let g:ctrlp_show_hidden = 1
" Enabling per session caching
let g:ctrlp_use_caching = 1
" Disabling cache clearing on Vim Exit
let g:ctrlp_clear_cache_on_exit = 0
" Setting the directory for saving the caches
let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp_cache/'
