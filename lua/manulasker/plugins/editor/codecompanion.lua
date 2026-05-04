-- ============================================================
-- CodeCompanion: AI assistant for Neovim
-- ============================================================
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "zbirenbaum/copilot.lua",
    "Davidyz/VectorCode",
    "cairijun/codecompanion-agentskills.nvim",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI: Toggle chat" },
    { "<leader>aa", "<cmd>CodeCompanionChat<cr>",        mode = { "n", "v" }, desc = "AI: New chat" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>",            mode = { "n", "v" }, desc = "AI: Inline" },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "AI: Actions" },
  },
  config = function()
    require("codecompanion").setup({

      -- ── Adapters ─────────────────────────────────────
      adapters = {
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {})
          end,
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {})
          end,
        },
      },

      -- ── Interactions ──────────────────────────────────
      interactions = {
        chat   = { adapter = "claude_code" },
        inline = { adapter = "copilot" },
        cmd    = { adapter = "claude_code" },
      },

      -- ── Rules (CLAUDE.md, AGENT.md, etc.) ────────────
      rules = {
        project_rules = {
          description = "Project specific rules",
          enabled = function()
            local cwd = vim.fn.getcwd()
            return vim.fn.filereadable(cwd .. "/CLAUDE.md") == 1
            or vim.fn.filereadable(cwd .. "/AGENT.md") == 1
            or vim.fn.filereadable(cwd .. "/AGENTS.md") == 1
            or vim.fn.filereadable(cwd .. "/.cursorrules") == 1
            or vim.fn.filereadable(cwd .. "/.clinerules") == 1
          end,
          files = {
            "CLAUDE.md",
            "AGENT.md",
            "AGENTS.md",
            ".cursorrules",
            ".clinerules",
            { path = ".github", files = "copilot-instructions.md" },
          },
        },
        global_rules = {
          description = "Global personal rules",
          enabled = function()
            return vim.fn.filereadable(vim.fn.expand("~/.claude/CLAUDE.md")) == 1
          end,
          files = {
            "~/.claude/CLAUDE.md",
          },
        },
      },

      -- ── Extensions ───────────────────────────────────
      extensions = {
        agentskills = {
          opts = {
            paths = {
              -- Global skills (always available)
              { vim.fn.expand("~/.config/nvim/skills"), recursive = true },
              -- Project skills (per project)
              { vim.fn.getcwd() .. "/.codecompanion/skills", recursive = true },
            },
          },
        },
        vectorcode = {
          opts = {
            tool_group = {
              enabled  = true,
              collapse = false,
            },
            tool_opts = {
              ["*"] = { require_approval_before = false },
              query = {
                max_num     = { chunk = -1, document = -1 },
                default_num = { chunk = 50, document = 10 },
                no_duplicate = true,
              },
            },
          },
        },
      },

      -- ── Prompt library ───────────────────────────────
      prompt_library = {
        ["Design Pattern Advisor"] = {
          strategy    = "chat",
          description = "Suggest design patterns for selected code",
          opts = {
            alias        = "pattern",
            is_slash_cmd = true,
            modes        = { "v" },
          },
          prompts = {
            {
              role    = "system",
              content = "You are a software architect. Analyze code and suggest design patterns. Never implement code — only suggest approaches, patterns, and key steps.",
            },
            {
              role    = "user",
              content = "Analyze this code and suggest applicable design patterns:\n\n```\n{{selection}}\n```",
            },
          },
        },
        ["Architecture Review"] = {
          strategy    = "chat",
          description = "Review architecture based on SOLID principles",
          opts = {
            alias        = "arch",
            is_slash_cmd = true,
            modes        = { "n", "v" },
          },
          prompts = {
            {
              role    = "system",
              content = "You are a senior software architect. Review code architecture and suggest improvements. Focus on SOLID principles, separation of concerns, and maintainability. Never write code — only explain and suggest.",
            },
            {
              role    = "user",
              content = "Review the architecture of this code:\n\n```\n{{selection}}\n```",
            },
          },
        },
        ["Explain Code"] = {
          strategy    = "chat",
          description = "Explain what the selected code does",
          opts = {
            alias        = "explain",
            is_slash_cmd = true,
            modes        = { "v" },
            auto_submit  = true,
          },
          prompts = {
            {
              role    = "user",
              content = "Explain what this code does step by step:\n\n```\n{{selection}}\n```",
            },
          },
        },
        ["Debug Advisor"] = {
          strategy    = "chat",
          description = "Help understand what might be wrong",
          opts = {
            alias        = "debug",
            is_slash_cmd = true,
            modes        = { "n", "v" },
          },
          prompts = {
            {
              role    = "system",
              content = "You are a debugging expert. Explain what might be wrong and why, suggest approaches to fix it, but do not write the fix yourself.",
            },
            {
              role    = "user",
              content = "Help me understand what might be wrong here:\n\n```\n{{selection}}\n```",
            },
          },
        },
      },

      -- ── Display ──────────────────────────────────────
      display = {
        chat = {
          window = {
            layout = "vertical",
            width  = 0.35,
          },
        },
        action_palette = {
          show_preset_prompts = true,
        },
      },

      -- ── Opts ─────────────────────────────────────────
      opts = {
        system_prompt = function()
          return [[
          You are an expert software architect and senior developer acting as a technical advisor.

          Your role is to:
          - Answer questions about the codebase and how it works
          - Suggest design patterns and architectural approaches
          - Explain concepts, best practices, and trade-offs
          - Help with debugging by explaining what might be wrong and why
          - Give ideas and direction — NOT implement code

          When asked to implement something:
          - Explain the approach and design pattern to use
          - Describe the key steps and considerations
          - Point out potential pitfalls
          - Let the developer write the actual code

          Always be concise and direct. Prefer explanations over code blocks.
          ]]
        end,
      },
    })

    -- ── VectorCode setup ──────────────────────────────────
    require("vectorcode").setup({
      async_opts = {
        debounce        = 1500,
        events          = { "BufWritePost", "BufReadPost" },
        run_on_register = false,
      },
    })

    -- ── Dynamic project prompts ───────────────────────────
    -- Loads .codecompanion/prompts.lua from project root when changing dirs
    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        local prompt_file = vim.fn.getcwd() .. "/.codecompanion/prompts.lua"
        if vim.fn.filereadable(prompt_file) == 1 then
          local ok, project_prompts = pcall(dofile, prompt_file)
          if ok and project_prompts then
            local config = require("codecompanion.config")
            for name, prompt in pairs(project_prompts) do
              config.prompt_library[name] = prompt
            end
            vim.notify("CodeCompanion: project prompts loaded", vim.log.levels.INFO)
          end
        end
      end,
    })
  end,
}
