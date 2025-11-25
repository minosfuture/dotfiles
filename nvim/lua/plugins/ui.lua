return {
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    keys = function()
      return {
        { "<leader>bq", "<Cmd>BufferLinePickClose<CR>" },
        { "<leader>bn", "<Cmd>BufferLineCycleNext<CR>" },
        { "<leader>bp", "<Cmd>BufferLineCyclePrev<CR>" },
      }
    end,
    opts = {
      options = {
        separator_style = "slant",
        always_show_bufferline = true,
      },
      highlights = {
        fill = {
          bg = {
            attribute = "bg",
            highlight = "StatusLine",
          },
        },
        separator = {
          fg = {
            attribute = "bg",
            highlight = "StatusLine",
          },
        },
        separator_selected = {
          fg = {
            attribute = "bg",
            highlight = "StatusLine",
          },
        },
        separator_visible = {
          fg = {
            attribute = "bg",
            highlight = "StatusLine",
          },
        },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>uh",
        function()
          require("telescope").load_extension("notify")
          require("telescope").extensions.notify.notify()
        end,
        desc = "View messages history",
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      winbar = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 3,
          },
        },
        lualine_b = {},
        lualine_c = {
          {
            "filetype", colored = true, icon_only = true, icon = { align = "left" },
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      inactive_winbar = {
        lualine_a = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            path = 3,
          },
        },
        lualine_b = {
          {
            "filetype",
            colored = true,
            icon_only = true,
            icon = { align = "left" },
          },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
