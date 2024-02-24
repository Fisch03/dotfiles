----------------- CONFIG ----------------- 

-- set leader to be space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- no folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99

-- auto indenting
vim.opt.cindent = true

-- Set completeopt to have a better completion experience
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.opt.completeopt = "menuone,noinsert,noselect"

-- min lines above/below cursor to keep in view
vim.opt.scrolloff = 2

-- dont wrap lines
vim.opt.wrap = false

-- always show signcolumn
vim.opt.signcolumn = 'yes'

-- relative lines
vim.opt.relativenumber = true
vim.opt.number = true

-- split direction
vim.opt.splitright = true
vim.opt.splitbelow = true

-- infinite undoes
vim.opt.undofile = true

-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = 'list:longest'
-- don't suggest these files:
vim.opt.wildignore = '*.png,*.jpg,*.gif,*.o'

-- tab width
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- case-insensitive search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')
--- and using a smarter algorithm
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

----------------- VISUAL ----------------- 

vim.api.nvim_set_hl(0, "NormalFloat", { bg="NONE" } )
vim.api.nvim_set_hl(0, "Pmenu", { bg="NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg="NONE" })

local border_style = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border_style
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = border_style
  }
)

vim.diagnostic.config{
  float={border=border_style}
}

----------------- KEYBINDS ----------------- 

-- ctrl+j and ctrl+k as esc
vim.keymap.set('n', '<C-j>', '<Esc>')
vim.keymap.set('i', '<C-j>', '<Esc>')
vim.keymap.set('v', '<C-j>', '<Esc>')
vim.keymap.set('s', '<C-j>', '<Esc>')
vim.keymap.set('x', '<C-j>', '<Esc>')
vim.keymap.set('c', '<C-j>', '<Esc>')
vim.keymap.set('o', '<C-j>', '<Esc>')
vim.keymap.set('l', '<C-j>', '<Esc>')
vim.keymap.set('t', '<C-j>', '<Esc>')

vim.keymap.set('n', '<C-k>', '<Esc>')
vim.keymap.set('i', '<C-k>', '<Esc>')
vim.keymap.set('v', '<C-k>', '<Esc>')
vim.keymap.set('s', '<C-k>', '<Esc>')
vim.keymap.set('x', '<C-k>', '<Esc>')
vim.keymap.set('c', '<C-k>', '<Esc>')
vim.keymap.set('o', '<C-k>', '<Esc>')
vim.keymap.set('l', '<C-k>', '<Esc>')
vim.keymap.set('t', '<C-k>', '<Esc>')

-- jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

-- no arrow keys --- force yourself to use the home row
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')

-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')

----------------- PLUGINS ----------------- 

-- lazy bootstrapping
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
	{
		'itchyny/lightline.vim',
		lazy = false, -- also load at start since it's UI
	    dependencies = { "mengelbrecht/lightline-bufferline" },
		config = function()
			-- no need to also show mode in cmd line when we have bar
			vim.o.showmode = false
			vim.g.lightline = {
                -- separator = { left = '', right = '' },
                separator = { left = '', right = '' },
                -- subseparator = { left = '', right = '' },
                -- subseparator = { left = '', right = '' },
                colorscheme = 'lightline_transparent',
				active = {
					left = {
						{ 'mode', 'paste' },
						{ 'readonly', 'filename', 'modified' }
					},
					right = {
						{ 'lineinfo' },
						{ 'percent' },
						{ 'fileencoding', 'filetype' }
					},
				},
                tabline = {
                    left = {
                        { 'buffers' }
                    },
                    right = {}
                },
                component_expand = {
                    buffers = 'lightline#bufferline#buffers'
                },
                component_type = {
                    buffers = 'tabsel'
                }
			}

            vim.o.showtabline = 2
		end
	},
    {
        -- quick navigation
        "ggandor/leap.nvim",
        config = function()
            vim.keymap.set('n', 's', function ()
                require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
            end)
        end
    },
    {
        -- automatically move to project root
        "notjedi/nvim-rooter.lua",
        config = function()
            require('nvim-rooter').setup()
        end
    },
    {
        -- file search
        "nvim-telescope/telescope.nvim", branch = '0.1.x',
        keys = {
            "<leader>ff",
            "<leader>fg",
            "<leader>fb",
            "<leader>fh"
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    },
    {
        "neovim/nvim-lspconfig", 
        config = function()
            require('lspconfig.ui.windows').default_options = {
                border = border_style
            }

            local lspconfig = require('lspconfig') 

            lspconfig.rust_analyzer.setup {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        imports = {
                            group = {
                                enable = false
                            },
                        },
                    }
                }
            }
            
            lspconfig.ccls.setup {}

            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                -- vim.keymap.set('n', '<space>wl', function()
                --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                --end, opts)
                --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
              end,
            })
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require('copilot').setup({
                suggestion = { enabled = false },
                panel = { enabled = false }
            })
        end
    },
    {
        -- code completion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lsp",
            {
                "zbirenbaum/copilot-cmp",
                config = function()
                    require('copilot_cmp').setup()
                end
            },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-2),
                    ['<C-f>'] = cmp.mapping.scroll_docs(2),
                    -- ['<C-Space>'] = cmp.mapping.complete(),
                    -- ['<C-e>'] = cmp.mapping.abort(),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                }),
                window = {
                    completion = {
                        border = border_style,
                    },
                    documentation = {
                        border = border_style,
                    }
                }
            })

            -- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
        end
    },
    {
        -- function signatures
        "ray-x/lsp_signature.nvim",
        config = function()
            require('lsp_signature').setup({
                doc_lines = 0,
                hint_enable = false
            })
        end
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            window = {
                border = border_style
            }
        },
        config = function()
            require('fidget').setup()
        end
    },
    {
        "m4xshen/autoclose.nvim", 
        config = function()
            require('autoclose').setup({
                options = {
                    disable_when_touch = true,
                    pair_spaces = true
                }
            })
        end
    },
    
    ----- LANGUAGES -----
    {
        "cespare/vim-toml",
        ft = { "toml" }
    },
    {
        -- rust
        "rust-lang/rust.vim",
        ft = { "rust" },
        config = function()
            vim.g.rustfmt_autosave = 1
			vim.g.rustfmt_emit_files = 1
			vim.g.rustfmt_fail_silently = 0
			vim.g.rust_clip_command = 'wl-copy'
        end
    },
    {
		'plasticboy/vim-markdown',
		ft = { "markdown" },
		config = function()
			-- never ever fold!
			vim.g.vim_markdown_folding_disabled = 1
			-- support front-matter in .md files
			vim.g.vim_markdown_frontmatter = 1
			-- 'o' on a list item should insert at same level
			vim.g.vim_markdown_new_list_item_indent = 0
		end
	},
})
