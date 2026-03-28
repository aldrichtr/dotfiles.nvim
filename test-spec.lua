
spec = {
  {
    { "xiantang/darcula-dark.nvim",
      name = "darcula",
      opts = {
        opt = {
          integrations = {
            dap_nvim = true,
            lsp_semantics_token = true,
            lualine = true,
            nvim_cmp = true,
            telescope = false
          }
        }
      }
    },
    { "chama-chomo/grail",
      opts = {}
    },
    { "savq/melange-nvim",
      lazy = false,
      name = "melange"
    },
    { "no-clown-fiesta/no-clown-fiesta.nvim",
      opts = {}
    },
    { "rose-pine/neovim",
      name = "rose-pine"
    }
  },
  {
    { "stevearc/aerial.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
      init = <function 1>,
      opts = {
        backends = { "treesitter", "lsp" },
        default_direction = "left",
        keymaps = {
          ["<2-LeftMouse>"] = "actions.jump",
          ["<C-j>"] = "actions.down_and_scroll",
          ["<C-k>"] = "actions.up_and_scroll",
          ["<C-s>"] = "actions.jump_split",
          ["<C-v>"] = "actions.jump_vsplit",
          ["<CR>"] = "actions.jump",
          ["?"] = "actions.show_help",
          H = "actions.tree_close_recursive",
          L = "actions.tree_open_recursive",
          O = "actions.tree_toggle_recursive",
          ["[["] = "actions.prev_up",
          ["]]"] = "actions.next_up",
          ["g?"] = "actions.show_help",
          h = "actions.tree_close",
          l = "actions.tree_open",
          o = "actions.tree_toggle",
          p = "actions.scroll",
          q = "actions.close",
          zA = "actions.tree_toggle_recursive",
          zC = "actions.tree_close_recursive",
          zM = "actions.tree_close_all",
          zO = "actions.tree_open_recursive",
          zR = "actions.tree_open_all",
          zX = "actions.tree_sync_folds",
          za = "actions.tree_toggle",
          zc = "actions.tree_close",
          zm = "actions.tree_decrease_fold_level",
          zo = "actions.tree_open",
          zr = "actions.tree_increase_fold_level",
          zx = "actions.tree_sync_folds",
          ["{"] = "actions.prev",
          ["}"] = "actions.next"
        },
        link_folds_to_tree = false,
        link_tree_to_folds = true,
        manage_folds = false,
        placement = "edge"
      }
    }, { "m4xshen/autoclose.nvim",
    event = "InsertEnter",
    opts = {
      keys = {
        ['"'] = {
          close = true,
          escape = true,
          pair = '""'
        },
        ["'"] = {
          close = true,
          escape = true,
          pair = "''"
        },
        ["("] = {
          close = true,
          escape = false,
          pair = "()"
        },
        [")"] = {
          close = false,
          escape = true,
          pair = "()"
        },
        [">"] = {
          close = false,
          escape = true,
          pair = "<>"
        },
        ["["] = {
          close = true,
          escape = false,
          pair = "[]"
        },
        ["]"] = {
          close = false,
          escape = true,
          pair = "[]"
        },
        ["`"] = {
          close = true,
          escape = true,
          pair = "``"
        },
        ["{"] = {
          close = true,
          escape = false,
          pair = "{}"
        },
        ["}"] = {
          close = false,
          escape = true,
          pair = "{}"
        }
      },
      options = {
        auto_indent = true,
        disable_command_mode = false,
        disable_when_touch = false,
        disabled_filetypes = { "text" },
        pair_spaces = false,
        touch_regex = "[%w(%[{]"
      }
    }
  }, { "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = <function 2>,
  lazy = false,
  opts = <function 3>,
  version = "*"
}, { "hrsh7th/nvim-cmp",
branch = "main",
config = <function 4>,
dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "saadparwaiz1/cmp_luasnip" },
event = { "InsertEnter", "CmdlineEnter" },
init = <function 5>,
opts = <function 6>,
version = false
    }, { "max397574/colortils.nvim",
    cmd = "Colortils",
    opts = {}
  }, { "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt",
      lsp_format = "fallback"
    }
  }
}
      }, { "nvimdev/dashboard-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VimEnter",
      opts = {
        config = {
          shortcut = { {
            action = "Lazy update",
            desc = "󰊳 Update",
            group = "@property",
            key = "u"
          }, {
            action = "Telescope find_files {cwd = vim.env.HOME}",
            desc = "Files",
            group = "Label",
            icon = " ",
            icon_hl = "@variable",
            key = "f"
          }, {
            action = "Telescope dotfiles",
            desc = " dotfiles",
            group = "Number",
            key = "d"
          }, {
            action = "Telescope projects",
            desc = " projects",
            group = "Number",
            key = "p"
          } },
          week_header = {
            enable = true
          }
        },
        theme = "hyper"
      }
    }, { "lewis6991/gitsigns.nvim",
    event = { "BufReadPre" },
    opt = {
      attach_to_untracked = false,
      auto_attach = true,
      current_line_blame = false,
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      current_line_blame_opts = {
        delay = 1000,
        ignore_whitespace = false,
        use_focus = true,
        virt_text = true,
        virt_text_pos = "eol",
        virt_text_priority = 100
      },
      linehl = false,
      max_file_length = 40000,
      numhl = false,
      preview_config = {
        border = "single",
        col = 1,
        relative = "cursor",
        row = 0,
        style = "minimal"
      },
      sign_priority = 6,
      signcolumn = true,
      signs = {
        add = {
          text = "┃"
        },
        change = {
          text = "┃"
        },
        changedelete = {
          text = "~"
        },
        delete = {
          text = "_"
        },
        topdelete = {
          text = "‾"
        },
        untracked = {
          text = "┆"
        }
      },
      signs_staged = {
        add = {
          text = "┃"
        },
        change = {
          text = "┃"
        },
        changedelete = {
          text = "~"
        },
        delete = {
          text = "_"
        },
        topdelete = {
          text = "‾"
        },
        untracked = {
          text = "┆"
        }
      },
      signs_staged_enable = true,
      update_debounce = 100,
      watch_gitdir = {
        follow_files = true
      },
      word_diff = false
    }
  }, { "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  event = { "BufReadPre" },
  keys = <function 7>
}, { "OXY2DEV/helpview.nvim",
dependencies = { "nvim-treesitter/nvim-treesitter" },
lazy = false
  }, { "3rd/image.nvim" }, { "lukas-reineke/indent-blankline.nvim",
  config = <function 8>,
  event = "BufReadPre",
  main = "ibl"
}, { "folke/lazydev.nvim",
dependencies = { "Bilal2453/luvit-meta" },
ft = "lua",
opts = {
  library = { {
    path = "luvit-meta/library",
    words = { "vim%.uv" }
  } }
}
        }, { "antosha417/nvim-lsp-file-operations",
        config = <function 9>,
        dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" }
      }, { "neovim/nvim-lspconfig",
      config = <function 10>,
      dependencies = { "antosha417/nvim-lsp-file-operations" },
      event = "BufReadPre"
    }, { "onsails/lspkind.nvim" }, { "arkav/lualine-lsp-progress" }, { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      extensions = { "lazy", "neo-tree", "quickfix", "aerial", "toggleterm", "trouble" },
      inactive_winbar = <1>{
        lualine_a = { { "filetype",
        colored = true,
        icon = {
          align = "left"
        },
        icon_only = true
      }, { "filename",
      file_status = true,
      newfile_status = true,
      path = 1,
      shorting_target = 40,
      symbols = {
        modified = "⭘",
        newfile = "new",
        readonly = "",
        unnamed = "untitled"
      }
    } }
  },
  options = {
    always_divide_middle = true,
    always_show_tabline = true,
    component_separators = {
      left = "",
      right = ""
    },
    disabled_filetypes = { "neo-tree", "aerial" },
    globalstatus = true,
    icons_enabled = true,
    ignore_focus = { "neo-tree", "aerial" },
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    },
    section_separators = {
      left = "",
      right = ""
    },
    theme = "auto"
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { { "branch", { "diff",
    colored = true,
    diff_color = {
      added = "LuaLineDiffAdd",
      modified = "LuaLineDiffChange",
      removed = "LuaLineDiffDelete"
    },
    source = <function 11>,
    symbols = {
      added = "+",
      modified = "~",
      removed = "-"
    }
  } } },
  lualine_x = { { "datetime",
  style = "%A - %d %B %H:%M"
}, { "encoding" } },
lualine_y = { "searchcount", "progress" },
lualine_z = { "aerial", "location" }
            },
            winbar = <table 1>
          }
        }, { "L3MON4D3/LuaSnip",
        build = false,
        init = <function 12>,
        opts = {
          enable_autosnippets = true,
          ext_base_prio = 300,
          ext_prio_increase = 1,
          keep_roots = true,
          link_children = true,
          link_roots = true
        },
        version = "v2.*"
      }, { "Bilal2453/luvit-meta" }, { "OXY2DEV/markview.nvim",
      deps = {},
      ft = { "markdown" },
      opts = {}
    }, { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim", "3rd/image.nvim" },
    keys = <function 13>,
    opts = <function 14>
  }, { "folke/neoconf.nvim",
  opts = {}
}, { "danymat/neogen",
opt = {
  snippet_engine = "luasnip"
},
version = "*"
  }, { "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" }
}, { "folke/noice.nvim",
dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
lazy = false,
opts = {
  lsp = {
    override = {
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true
    }
  },
  presets = {
    bottom_search = false,
    command_palette = true,
    inc_rename = false,
    long_message_to_split = true,
    lsp_doc_border = false
  }
}
    }, { "MunifTanjim/nui.nvim" }, { "rcarriga/nvim-notify",
    lazy = false
  }, { "elentok/open-link.nvim",
  cmd = { "OpenLink", "PasteImage" },
  init = <function 15>,
  lazy = false
}, { "chipsenkbeil/org-roam.nvim",
dependencies = { { "nvim-orgmode/orgmode",
tag = "0.7.0"
          } },
          opts = {
            directory = "~/Dropbox/org"
          },
          tag = "0.2.0"
        }, { "nvim-orgmode/orgmode",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-orgmode/telescope-orgmode.nvim", "nvim-orgmode/org-bullets.nvim" },
        event = "VeryLazy",
        opts = {
          org_agenda_files = "~/Dropbox/org/**",
          org_default_notes_file = "~/Dropbox/org/inbox.org"
        }
      }, { "nvim-lua/plenary.nvim" }, { "TheLeoP/powershell.nvim",
      cond = false,
      opts = {
        bundle_path = "",
        capabilities = {
          general = {
            positionEncodings = { "utf-8", "utf-16", "utf-32" }
          },
          textDocument = {
            callHierarchy = {
              dynamicRegistration = false
            },
            codeAction = {
              codeActionLiteralSupport = {
                codeActionKind = {
                  valueSet = { "", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports" }
                }
              },
              dataSupport = true,
              dynamicRegistration = true,
              isPreferredSupport = true,
              resolveSupport = {
                properties = { "edit", "command" }
              }
            },
            codeLens = {
              dynamicRegistration = false,
              resolveSupport = {
                properties = { "command" }
              }
            },
            completion = {
              completionItem = {
                commitCharactersSupport = false,
                deprecatedSupport = true,
                documentationFormat = { "markdown", "plaintext" },
                preselectSupport = false,
                resolveSupport = {
                  properties = { "additionalTextEdits", "command" }
                },
                snippetSupport = true,
                tagSupport = {
                  valueSet = { 1 }
                }
              },
              completionItemKind = {
                valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
              },
              completionList = {
                itemDefaults = { "editRange", "insertTextFormat", "insertTextMode", "data" }
              },
              contextSupport = true,
              dynamicRegistration = false
            },
            declaration = {
              linkSupport = true
            },
            definition = {
              dynamicRegistration = true,
              linkSupport = true
            },
            diagnostic = {
              dynamicRegistration = false,
              tagSupport = {
                valueSet = { 1, 2 }
              }
            },
            documentHighlight = {
              dynamicRegistration = false
            },
            documentSymbol = {
              dynamicRegistration = false,
              hierarchicalDocumentSymbolSupport = true,
              symbolKind = {
                valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
              }
            },
            foldingRange = {
              dynamicRegistration = false,
              foldingRange = {
                collapsedText = true
              },
              foldingRangeKind = {
                valueSet = { "comment", "imports", "region" }
              },
              lineFoldingOnly = true
            },
            formatting = {
              dynamicRegistration = true
            },
            hover = {
              contentFormat = { "markdown", "plaintext" },
              dynamicRegistration = true
            },
            implementation = {
              linkSupport = true
            },
            inlayHint = {
              dynamicRegistration = true,
              resolveSupport = {
                properties = { "textEdits", "tooltip", "location", "command" }
              }
            },
            publishDiagnostics = {
              dataSupport = true,
              relatedInformation = true,
              tagSupport = {
                valueSet = { 1, 2 }
              }
            },
            rangeFormatting = {
              dynamicRegistration = true,
              rangesSupport = true
            },
            references = {
              dynamicRegistration = false
            },
            rename = {
              dynamicRegistration = true,
              prepareSupport = true
            },
            semanticTokens = {
              augmentsSyntaxTokens = true,
              dynamicRegistration = false,
              formats = { "relative" },
              multilineTokenSupport = false,
              overlappingTokenSupport = true,
              requests = {
                full = {
                  delta = true
                },
                range = false
              },
              serverCancelSupport = false,
              tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
              tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "decorator" }
            },
            signatureHelp = {
              dynamicRegistration = false,
              signatureInformation = {
                activeParameterSupport = true,
                documentationFormat = { "markdown", "plaintext" },
                parameterInformation = {
                  labelOffsetSupport = true
                }
              }
            },
            synchronization = {
              didSave = true,
              dynamicRegistration = false,
              willSave = true,
              willSaveWaitUntil = true
            },
            typeDefinition = {
              linkSupport = true
            }
          },
          window = {
            showDocument = {
              support = true
            },
            showMessage = {
              messageActionItem = {
                additionalPropertiesSupport = true
              }
            },
            workDoneProgress = true
          },
          workspace = {
            applyEdit = true,
            configuration = true,
            didChangeConfiguration = {
              dynamicRegistration = false
            },
            didChangeWatchedFiles = {
              dynamicRegistration = true,
              relativePatternSupport = true
            },
            inlayHint = {
              refreshSupport = true
            },
            semanticTokens = {
              refreshSupport = true
            },
            symbol = {
              dynamicRegistration = false,
              symbolKind = {
                valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
              }
            },
            workspaceEdit = {
              resourceOperations = { "rename", "create", "delete" }
            },
            workspaceFolders = true
          }
        },
        init_options = vim.empty_dict(),
        root_dir = <function 16>,
        settings = vim.empty_dict(),
        shell = "pwsh"
      }
    }, { "DrKJeff16/project.nvim",
    cmd = { "Project", "ProjectAdd", "ProjectConfig", "ProjectDelete", "ProjectExport", "ProjectFzf", "ProjectHealth", "ProjectHistory", "ProjectImport", "ProjectLog", "ProjectPicker", "ProjectRecents", "ProjectRoot", "ProjectSession", "ProjectSnacks", "ProjectTelescope" },
    dependencies = { { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  }, "wsdjeg/picker.nvim", "folke/snacks.nvim", "ibhagwan/fzf-lua" },
  opts = {}
}, { "hiphish/rainbow-delimiters.nvim",
config = <function 17>,
event = "BufReadPre"
}, { "tpope/vim-repeat",
lazy = false
      }, { "tiagovla/scope.nvim",
      lazy = false,
      opts = <function 18>
    }, { "kylechui/nvim-surround",
    event = "VeryLazy"
  }, { "abecodes/tabout.nvim",
  lazy = false,
  opts = {
    act_as_shift_tab = true,
    act_as_tab = true,
    backwards_tabkey = "<S-Tab>",
    completion = false,
    default_shift_tab = "<C-d>",
    default_tab = "<C-t>",
    enable_backwards = true,
    exclude = {},
    ignore_beginning = true,
    tabkey = "<Tab>",
    tabouts = { {
      close = "'",
      open = "'"
    }, {
      close = '"',
      open = '"'
    }, {
      close = "`",
      open = "`"
    }, {
      close = ")",
      open = "("
    }, {
      close = "]",
      open = "["
    }, {
      close = "}",
      open = "{"
    } }
  }
}, { "nvim-orgmode/telescope-orgmode.nvim",
config = <function 19>,
dependencies = { "nvim-orgmode/orgmode", "nvim-telescope/telescope.nvim" },
event = "VeryLazy"
      }, { "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
      opts = {
        pickers = {
          find_files = {
            theme = "dropdown"
          }
        }
      },
      version = "*"
    }, { "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {
      colors = {
        default = { "Identifier", "#7C3AED" },
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        hint = { "DiagnosticHint", "#10B981" },
        info = { "DiagnosticInfo", "#2563EB" },
        test = { "Identifier", "#FF00FF" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" }
      },
      gui_style = {
        bg = "NONE",
        fg = "BOLD"
      },
      highlight = {
        after = "fg",
        before = "",
        comments_only = true,
        exclude = {},
        keyword = "wide",
        max_line_len = 400,
        multiline = true,
        multiline_context = 10,
        multiline_pattern = "^."
      },
      keywords = {
        NOTE = {
          alt = { "INFO" },
          color = "hint",
          icon = " "
        },
        TODO = {
          color = "info",
          icon = " "
        }
      },
      merge_keywords = true,
      search = {
        args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
        command = "rg",
        pattern = "\\b(KEYWORDS):"
      },
      sign_priority = 8,
      signs = true
    }
  }, { "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm" },
  config = true,
  opts = <function 20>,
  version = "*"
}, { "nvim-treesitter/nvim-treesitter-textobjects",
branch = "main",
dependencies = { "nvim-treesitter/nvim-treesitter" },
keys = <function 21>,
opts = {
  select = {
    include_surrounding_whitespace = false,
    lookahead = true,
    selection_modes = {
      ["@class.outer"] = "<c-v>",
      ["@function.outer"] = "V",
      ["@parameter.outer"] = "v"
    }
  }
}
      }, { "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      init = <function 22>,
      lazy = false,
      opts = {
        auto_install = true,
        ensure_installed = { "bash", "lua", "powershell", "yaml" },
        highlight = {
          additional_vim_regex_highlighting = { "markdown" },
          enable = true
        },
        ignore_install = {},
        indent = {
          enable = true
        },
        modules = {},
        parser_install_dir = "C:/Users/aldrichtr/AppData/Local/tree-sitter",
        sync_install = true
      }
    }, { "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {}
  }, { "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  init = <function 23>,
  opts = {
    provider_selector = <function 24>
  }
}, { "sheerun/vim-polyglot",
lazy = false
      }, { "nvim-tree/nvim-web-devicons",
      opts = {
        color_icons = true,
        default = true,
        strict = true
      }
    }, { "folke/which-key.nvim",
    event = "VeryLazy",
    opts = <function 25>
  }, { "s1n7ax/nvim-window-picker",
  event = "VeryLazy",
  name = "window-picker",
  version = "2.*"
} } }
    }
