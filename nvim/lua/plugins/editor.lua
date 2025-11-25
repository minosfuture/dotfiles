return {
  {
    "mhinz/vim-signify",
    init = function(_)
      vim.g.signify_skip = { vcs = { deny = { "git" } } }
    end,
    config = function(_, _)
      vim.api.nvim_set_hl(0, "SignifySignAdd", { link = "GitSignsAdd" })
      vim.api.nvim_set_hl(0, "SignifySignChange", { link = "GitSignsChange" })
      vim.api.nvim_set_hl(
        0,
        "SignifySignChangeDelete",
        { link = "GitSignsChange" }
      )
      vim.api.nvim_set_hl(0, "SignifySignDelete", { link = "GitSignsDelete" })
      vim.api.nvim_set_hl(
        0,
        "SignifySignDeleteFirstLine",
        { link = "GitSignsDelete" }
      )

      vim.g.signify_sign_add = "▎"
      vim.g.signify_sign_change = "▎"
      vim.g.signify_sign_delete = ""
      vim.g.signify_sign_delete_first_line = ""
      vim.g.signify_sign_change_delete = ""
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>p",
        function()
          require('telescope.builtin').find_files()
        end,
        desc = "Find Files",
      },
    },
  },

  {
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    }
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = "junegunn/fzf",
    build = 'make',
  },

  {
		"ntpeters/vim-better-whitespace",
		init = function()
			vim.g.better_whitespace_enabled = 0
		end,
	},

  {
    "nvimtools/none-ls.nvim",
    --event = "LazyFile",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        --nls.builtins.formatting.fish_indent,
        --nls.builtins.diagnostics.fish,
        --nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt.with({
          extra_args = { "-i", "2", "-ci" },
        }),
      })
    end,
  },
}
