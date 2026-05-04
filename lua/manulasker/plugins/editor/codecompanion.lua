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
    "ravitemer/codecompanion-history.nvim"
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>",   mode = "n", desc = "AI: Toggle chat" },
    { "<leader>ac", ":'<,'>CodeCompanionChat Toggle<cr>",  mode = "v", desc = "AI: Toggle chat" },
    { "<leader>aa", "<cmd>CodeCompanionChat<cr>",          mode = "n", desc = "AI: New chat" },
    { "<leader>aa", ":'<,'>CodeCompanionChat<cr>",         mode = "v", desc = "AI: New chat" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>",              mode = "n", desc = "AI: Inline" },
    { "<leader>ai", ":'<,'>CodeCompanion<cr>",             mode = "v", desc = "AI: Inline" },
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>",       mode = "n", desc = "AI: Actions" },
    { "<leader>ap", ":'<,'>CodeCompanionActions<cr>",      mode = "v", desc = "AI: Actions" },
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
              { vim.fn.expand("~/.agents/skills"), recursive = true },
              -- Project skills (per project)
              { vim.fn.getcwd() .. "/.agents/skills", recursive = true },
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
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = false,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 10,
            -- Picker interface (auto resolved to a valid picker)
            picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = "copilot", -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = "gpt-4.1", -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
              },
            },

            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          }
        }
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
