return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			"stevearc/conform.nvim",
			{
				"b0o/SchemaStore.nvim",
				lazy = true,
				version = false,
			},
		},
		config = function()
			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end
			local lspconfig = require("lspconfig")

			local servers = {
				bashls = true,
				gopls = {
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				jsonls = {
					server_capabilities = {
						documentFormattingProvider = false,
					},
					settings = {
						json = {
							schemas = require("schemastore").json.schemas({
								select = {
									"Renovate",
									"GitHub Workflow Template Properties",
									"AWS CloudFormation",
								},
							}),
							validate = { enable = true },
						},
					},
				},
				lua_ls = true,
				pylsp = {
					settings = {
						pylsp = {
							plugins = {
								pyflakes = { enabled = false },
								pycodestyle = { enabled = false },
								autopep8 = { enabled = false },
								yapf = { enabled = false },
								pylsp_mypy = { enabled = false },
								pylsp_black = { enabled = false },
								pylsp_isort = { enabled = false },
							},
						},
					},
				},
				ruff = {
					commands = {
						RuffAutoFix = {
							function()
								vim.lsp.buf.execute_command({
									command = "ruff.applyAutofix",
									arguments = {
										{ uri = vim.uri_from_bufnr(0) },
									},
								})
							end,
							description = "Ruff: Format imports",
						},
						RuffOrganizeImports = {
							function()
								vim.lsp.buf.execute_command({
									command = "ruff.applyOrganizeImports",
									arguments = {
										{ uri = vim.uri_from_bufnr(0) },
									},
								})
							end,
						},
					},
				},
				terraformls = {},
				marksman = {},
				groovyls = {
					cmd = {
						"java",
						"-jar",
						"/home/wildkarrde/lsps/groovy-language-server/build/libs/groovy-language-server-all.jar",
					},
					on_attach = on_attach,
					filetypes = { "groovy" },
					settings = {
						groovy = {
							java = {
								home = { "/usr/java/jdk-21-oracle-x64" },
							},
							classpath = {
								"/home/wildkarrde/lsps/groovy-language-server/build/libs/groovy-language-server-all.jar",
								"/home/wildkarrde/lsps/groovy-language-server/build/libs/groovy-language-server.jar",
							},
						},
					},
				},
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == "table" then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup()
			local ensure_installed = {
				"stylua",
				"lua_ls",
				"delve",
			}

			vim.list_extend(ensure_installed, servers_to_install)

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			require("blink.cmp").setup({
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "markdown" },
					providers = {
						markdown = {
							name = "RenderMarkdown",
							module = "render-markdown.integ.blink",
							fallbacks = { "lsp" },
						},
					},
				},
			})

			--Autoformatting setup
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					terraform = { "terraform_fmt" },
					json = { "fixjson" },
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = false,
						quiet = true,
					})
				end,
			})
		end,
	},
}
