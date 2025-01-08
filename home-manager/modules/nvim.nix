{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  fonts.fontconfig.enable = true;
  programs.neovim = {
    enable = true;
    extraConfig = ''
      			set number relativenumber
      			filetype off
      			set shiftwidth=4
      			set tabstop=4
      			set wrap
      			set linebreak
      			set noincsearch
      			set ignorecase
      			set history=1000
      			set wildmenu
      			set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
      			set guifont=UbuntuMono
      			set cursorcolumn
      			set noshowmode
      			set hlsearch
      			set mouse=a
      			set cursorline
      			let mapleader = " "
      			set nobackup
      			set nowritebackup
      			set spelllang=en_us
      			set spell
      			set t_Co=0
      			set foldmethod=syntax
      			set foldlevel=10
      			set foldclose=all
      			set background=dark
      			set nospell
      			let g:autoformat_autoindent = 0
      			let g:autoformat_retab = 0
      			let g:autoformat_remove_trailing_spaces = 0
      			let g:airline_theme='minimalist'
      			nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>
      			nnoremap <Down> gj
      			nnoremap <Up> gk
      			vnoremap <Down> gj
      			vnoremap <Up> gk
      			inoremap <Down> <C-o>gj
      			inoremap <Up> <C-o>gk
      			colorscheme tokyonight
      			let g:airline_powerline_fonts = 1
      			'';
    extraLuaConfig = ''
      			dofile('/Users/rishi/.config/nix-darwin/home-manager/modules/lua/config/telescope.lua')
      			dofile('/Users/rishi/.config/nix-darwin/home-manager/modules/lua/config/lsp-zero.lua')
      			dofile('/Users/rishi/.config/nix-darwin/home-manager/modules/lua/config/tree-sitter.lua')
      			dofile('/Users/rishi/.config/nix-darwin/home-manager/modules/lua/config/ufo.lua')
      			'';
    plugins = with pkgs.vimPlugins; [
      auto-pairs
      vim-airline
      vim-airline-themes
      playground
      vim-smoothie
      tokyonight-nvim
      vim-cursorword
      papercolor-theme
      nvim-treesitter.withAllGrammars

      # lsp bullshit
      lsp-zero-nvim
      nvim-lspconfig
      nvim-cmp
      luasnip
      cmp-nvim-lsp

      lspkind-nvim

      # telescope
      telescope-live-grep-args-nvim
      telescope-nvim
      plenary-nvim

      # folds
      nvim-ufo
    ];
  };
}
