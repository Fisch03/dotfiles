---------------- CONFIG -----------------

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

-- make gitgutter changes appear sooner
vim.opt.updatetime = 100

----------------- VISUAL -----------------

-- clear backgrounds for transparency
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

-- selection
vim.api.nvim_set_hl(0, "CursorLine", { bold = true })

-- borders
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

vim.diagnostic.config {
    float = { border = border_style }
}

-- keep diagnostics while in insert mode
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = true,
    }
)

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
vim.keymap.set('n', '<left>', ':bp<cr>', { silent = true })
vim.keymap.set('n', '<right>', ':bn<cr>', { silent = true })

-- clear search highlight automatically
vim.keymap.set('', '<CR>', ':noh<CR><CR>', { silent = true })
vim.keymap.set('n', 'i', ':noh<CR>i', { silent = true })

-- move to next underscore
vim.keymap.set('n', '<leader>u', 'ct_')

----------------- AUTOCOMMANDS -----------------
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        pattern = '*',
        command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
    }
)

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

require("lazy").setup({
    ----- VISUAL -----
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine_transparent = require('lualine_transparent')

            require('lualine').setup({
                options = {
                    theme = lualine_transparent,
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '|', right = '|' },
                    disabled_filetypes = { 'Trouble' }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'filename' },
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = { 'diagnostics' },
                    lualine_z = { 'location' }
                },
                tabline = {
                    lualine_a = { 'buffers' },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { 'encoding' },
                    lualine_y = { 'diff' },
                    lualine_z = { 'branch' }
                }
            })
        end
    },
    {
        -- lsp progress
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    border = border_style,
                    align = "top"
                }
            }
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "LspAttach",
        opts = {
            auto_open = true,
            height = 8,
        },

    },
    {
        -- git diff markers
        "lewis6991/gitsigns.nvim",
        config = function()
            vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "NONE" })

            vim.api.nvim_set_hl(0, "GitSignsAdd", { ctermfg = "Green" })
            vim.api.nvim_set_hl(0, "GitSignsChange", { ctermfg = "DarkGray" })
            vim.api.nvim_set_hl(0, "GitSignsDelete", { ctermfg = "Red" })

            require('gitsigns').setup()
        end
    },
    {
        -- git ui
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        -- file search
        "nvim-telescope/telescope.nvim",
        branch = '0.1.x',
        keys = {
            "<leader>ff",
            "<leader>fg",
            "<leader>fb",
            "<leader>fh"
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                config = function()
                    require('telescope').load_extension('fzf')
                end
            },
        },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    },

    ----- LSP / COMPLETION -----
    {
        -- bracket autoclosing
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
    {
        -- function signatures
        "ray-x/lsp_signature.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        event = "LspAttach",
        config = function()
            require('lsp_signature').setup({
                doc_lines = 0,
                hint_enable = false
            })
        end
    },
    {
        "aznhe21/actions-preview.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        event = "LspAttach",
        config = function()
            require('actions-preview').setup()

            vim.keymap.set({ 'n', 'v' }, '<leader>a', require('actions-preview').code_actions)
        end

    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require('mason').setup()

            require('lspconfig.ui.windows').default_options = {
                border = border_style
            }

            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            local on_attach = function(_, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

                vim.api.nvim_create_autocmd('BufWritePre', {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end
                })

                local opts = { buffer = bufnr }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
                -- vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)

                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            end

            local lspconfig = require('lspconfig')

            -- ccls not in mason
            lspconfig.ccls.setup {
                on_attach = on_attach,
            }

            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup({
                ensure_installed = {
                    "rust_analyzer",
                    "lua_ls"
                }
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup {
                        on_attach = on_attach,
                    }
                end,

                ["rust_analyzer"] = function()
                    lspconfig.rust_analyzer.setup {
                        on_attach = on_attach,
                        settings = {
                            ["rust_analyzer"] = {
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
                end,

                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup {
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = {
                                        'vim'
                                    }
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true)
                                },
                                telemetry = {
                                    enable = false
                                }
                            }
                        }
                    }
                end
            })
        end
    },

    ----- COMPLETION -----
    {
        "Saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            require('crates').setup()
        end
    },
    {
        "micangl/cmp-vimtex",
        dependencies = { "hrsh7th/nvim-cmp" },
        ft = { "tex" },
    },
    {
        -- copilot
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        cmd = "Copilot",
        config = function()
            require('copilot').setup({
                -- but only really used together with cmp
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
            "hrsh7th/vim-vsnip", -- stuff breaks sometimes otherwise...

            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",

            "FelipeLema/cmp-async-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "petertriho/cmp-git",
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
                sources = cmp.config.sources(
                    {
                        { name = 'copilot' },
                        { name = 'nvim_lsp' },
                        { name = 'async_path' },
                    },
                    {
                        { name = 'buffer' },
                    }
                ),
                window = {
                    completion = {
                        border = border_style,
                    },
                    documentation = {
                        border = border_style,
                    }
                }
            })

            -- completions for git commits
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' },
                }, {
                    { name = 'buffer' },
                })
            })

            -- completions for .toml
            cmp.setup.filetype('toml', {
                sources = {
                    { name = 'crates' },
                    { name = 'async_path' },
                    { name = 'buffer' }
                }
            })

            -- completion for .tex files
            cmp.setup.filetype('tex', {
                sources = {
                    { name = 'vimtex' },
                    { name = 'async_path' },
                    { name = 'buffer' }
                }
            })

            -- completions for : commands
            cmp.setup.cmdline(':', {
                sources = {
                    { name = 'async_path' },
                    { name = 'cmdline_history' }
                }
            })
            -- completions for search
            cmp.setup.cmdline('/', {
                sources = {
                    { name = 'buffer' },
                    { name = 'cmdline_history' }
                }
            })
            -- completions everywhere else in vim
            for _, cmd_type in ipairs({ '?', '@' }) do
                cmp.setup.cmdline(cmd_type, {
                    sources = {
                        { name = 'cmdline_history' },
                    },
                })
            end
        end
    },

    ----- LANGUAGES -----
    {
        "cespare/vim-toml",
        ft = { "toml" }
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

    ----- MISC -----
    {
        -- automatically move to project root
        "notjedi/nvim-rooter.lua",
        config = function()
            require('nvim-rooter').setup()
        end
    },
    {
        -- comment toggle
        "numToStr/Comment.nvim",
        lazy = false,
        opts = {
            toggler = {
                line = "<leader>cc",
                block = "<leader>bc"
            },
            opleader = {
                line = "<leader>c",
                block = "<leader>b"
            }
        }
    },
    {
        -- move lines
        "matze/vim-move"
    },
    {
        -- quick navigation
        "ggandor/leap.nvim",
        config = function()
            vim.keymap.set('n', 's', function()
                require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
            end)
        end
    },
    {
        "andweeb/presence.nvim",
        lazy = false,
        config = function()
            require('presence'):setup({
                neovim_image_text = ":3",

                blacklist = {
                    "work"
                },

                editing_text = "editing %s",
                file_explorer_text = "browsing files",
                git_commit_text = "committing changes",
                plugin_manager_text = "managing plugins",
                reading_text = "reading %s",
                workspace_text = "working on %s",
                line_number_text = "line %s out of %s",
            })
        end
    },
})
