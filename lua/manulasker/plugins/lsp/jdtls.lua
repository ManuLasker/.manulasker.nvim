return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
        local jdtls      = require("jdtls")
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
        local java_bin   = vim.fn.expand("~/.sdkman/candidates/java/current/bin/java")

        -- ── Paths ────────────────────────────────────────
        local function get_jdtls()
            local jdtls_path  = mason_path .. "/jdtls"
            local lombok_path = mason_path .. "/lombok-nightly"
            local launcher    = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
            local os_config   = jdtls_path .. "/config_linux"
            local lombok      = lombok_path .. "/lombok.jar"
            return launcher, os_config, lombok
        end

        -- ── Debug & test bundles ──────────────────────────
        local function get_bundles()
            local java_debug = mason_path .. "/java-debug-adapter"
            local bundles = {
                vim.fn.glob(java_debug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
            }
            local java_test = mason_path .. "/java-test"
            vim.list_extend(bundles, vim.split(vim.fn.glob(java_test .. "/extension/server/*.jar", true), "\n"))
            return bundles
        end

        -- ── Workspace ────────────────────────────────────
        local function get_workspace()
            local home         = os.getenv("HOME")
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
            return home .. "/code/workspace/" .. project_name
        end

        local launcher, os_config, lombok = get_jdtls()
        local workspace_dir               = get_workspace()
        local bundles                     = get_bundles()
        local root_dir                    = vim.fs.root(0, {
            ".git",
            "mvnw",
            "gradlew",
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
        })

        -- ── Extended capabilities ─────────────────────────
        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        -- ── cmd ──────────────────────────────────────────
        local cmd = {
            java_bin,
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx2g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. lombok,
            "-jar", launcher,
            "-configuration", os_config,
            "-data", workspace_dir,
        }

        -- ── Settings ─────────────────────────────────────
        local settings = {
            java = {
                format = {
                    enabled = true,
                    settings = {
                        url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
                    },
                },
                eclipse         = { downloadSource = true },
                maven           = { downloadSources = true },
                signatureHelp   = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                saveActions     = { organizeImports = true },
                completion = {
                    favoriteStaticMembers = {
                        "org.junit.jupiter.api.Assertions.*",
                        "org.mockito.Mockito.*",
                    },
                    filteredTypes = {
                        "com.sun.*",
                        "io.micrometer.shaded.*",
                        "java.awt.*",
                        "jdk.*",
                        "sun.*",
                    },
                    importOrder = {
                        "com", "lombok", "org",
                        "jakarta", "javax", "java",
                        "", "#",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold   = 9999,
                        staticThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    },
                    hashCodeEquals = { useJava7Objects = true },
                    useBlocks      = true,
                },
                configuration = {
                    runtimes = {
                        { name = "JavaSE-25", path = os.getenv("JAVA_HOME") },
                    },
                    updateBuildConfiguration = "interactive",
                },
                referencesCodeLens = { enabled = true },
                inlayHints         = { parameterNames = { enabled = "all" } },
            },
        }

        -- ── on_attach ─────────────────────────────────────
        local on_attach = function(_, bufnr)
            -- Enable codelens (new API, replaces deprecated refresh)
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
            -- Debugger setup
            require("jdtls.dap").setup_dap_main_class_configs()
            require("manulasker.plugins.lsp.dap-configs.java").setup()

            -- Java-specific keymaps
            local opts = function(desc)
                return { buffer = bufnr, desc = "Java: " .. desc }
            end
            vim.keymap.set("n", "<leader>jo",  jdtls.organize_imports,                    opts("Organize imports"))
            vim.keymap.set("n", "<leader>jv",  jdtls.extract_variable,                    opts("Extract variable"))
            vim.keymap.set("n", "<leader>jc",  jdtls.extract_constant,                    opts("Extract constant"))
            vim.keymap.set("v", "<leader>jm",  function() jdtls.extract_method(true) end, opts("Extract method"))
            vim.keymap.set("n", "<leader>jtm", jdtls.test_nearest_method,                 opts("Test nearest method"))
            vim.keymap.set("n", "<leader>jtc", jdtls.test_class,                          opts("Test class"))
        end

        -- ── Config ───────────────────────────────────────
        local config = {
            name         = "jdtls",
            cmd          = cmd,
            root_dir     = root_dir,
            settings     = settings,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            init_options = {
                bundles                    = bundles,
                extendedClientCapabilities = extendedClientCapabilities,
            },
            on_attach    = on_attach,
        }

        -- ── Start on java buffers ─────────────────────────
        vim.api.nvim_create_autocmd("FileType", {
            pattern  = "java",
            callback = function()
                jdtls.start_or_attach(config)
            end,
        })
    end,
}
