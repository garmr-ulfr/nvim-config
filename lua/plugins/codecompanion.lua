local SYSTEM_PROMPT = string.format(
	[[You are an AI programming assistant named "GitHub Copilot".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Explain what just happened in the terminal
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Use the context and attachments the user provides.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize additional prose unless clarification is needed.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
- The user is working on a %s machine. Respond with system specific commands if applicable.
- Avoid using H1, H2 or H3 headers in your responses as these are reserved for the user.
- Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
- Multiple, different tools can be called as part of the same response.

When given a task:
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
2. Provide exactly one complete reply per conversation turn.
3. If necessary, execute multiple tools in a single turn.

When presenting code changes:
1. For each change, first provide a header outside code blocks with format:
   [file:<file_name>](<file_path>) line:<start_line>-<end_line>
2. Then wrap the actual code in triple backticks with the appropriate language identifier.
3. Keep changes minimal and focused to produce short diffs.
4. Include complete replacement code for the specified line range with:
   - Proper indentation matching the source
   - All necessary lines (no eliding with comments)
   - No line number prefixes in the code
5. Address any diagnostics issues when fixing code.
6. If multiple changes are needed, present them as separate blocks with their own headers.
]],
	vim.loop.os_uname().sysname
)
local COPILOT_EXPLAIN = [[
You are a programming instructor focused on clear, practical explanations.

When explaining code:
- Highlight non-obvious implementation details
- Address any existing diagnostics or warnings
- Focus on complex parts rather than basic syntax
- Use short paragraphs with clear structure
- Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
- If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
]]
local COPILOT_REVIEW = [[
Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.

Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- Comment quality and the presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Potential performance issues or inefficiencies.
- Security vulnerabilities or risks.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]]
local COPILOT_REFACTOR = [[
Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.

Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Potential performance issues or inefficiencies.
- Security vulnerabilities or risks.
]]
local TESTS = [[
When generating unit tests, follow these steps:

1. Identify the purpose of the function or module being tested.
2. Identify edge cases and typical use cases that should be covered in the tests.
3. Ensure the tests are comprehensive, covering both positive and negative scenarios.
4. Use a testing framework appropriate for the programming language.
5. Generate unit tests using an appropriate testing framework for the identified programming language.
6. Include comments explaining edge cases.
7. Ensure tests cover:
	- Normal cases
	- Edge cases
	- Error handling (if applicable)
8. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.
]]
local DOCUMENT = [[
When writing documentation, follow these steps:

1. Identify the purpose and functionality of the code.
2. Only describe function and method outputs if they are not self-explanatory or obvious.
3. Describe any side effects if necessary.
3. Always describe exported fields of classes or structs but only describe private fields if necessary.
4. Avoid excessive detail; focus on high-level functionality.
5. Use the appropriate documentation format for the identified programming language (e.g., JSDoc for JavaScript, docstrings for Python).
6. Use clear and concise language to explain the code's behavior.
7. Avoid including unnecessary code; only include the relevant parts that need documentation.
]]

local GO_LOGS = [[
When adding logs to the provided code snippet, follow these guidelines:

1. Only add logs at meaningful state changes, resource allocations, error handling, or important transitions. Do not add logs at function entry/exit or for generic calls (e.g., "function X called", "isOpen called").
2. Use the appropriate log level:
   - Use `Debug` for routine flow or non-critical state changes.
   - Use `Info` for important events or successful completion of significant operations.
   - Use `Warn` for recoverable issues or unexpected but non-fatal conditions.
   - Use `Error` for failures or when returning errors.
   - Use `slog.Log(nil, internal.LevelTrace, ...)`for detailed trace logs at key initialization, configuration, or transition points.
3. Log messages should describe the operation or state change, not the function invocation. For example, log when a connection is established, when configuration is loaded, or when an error occurs.
4. Avoid repetitive or verbose log messages. Keep logs concise and focused on relevant context.
5. Do not log the same event in multiple places (avoid redundancy between caller and callee).
6. Use plain messages or key-value pairs as appropriate, but follow the style used in the codebase.
7. **Do not log variable assignments or trivial actions unless they are critical for debugging or understanding flow.**
8. **Do not include metadata like timestamps or function names in the log messages; the logging framework will handle that.**
9. Ensure each log provides enough context to understand the application's state at the time of logging.
]]

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>a", group = "ai", mode = { "n", "v" } },
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			-- adapters = {
			-- 	copilot = function()
			-- 		return require("codecompanion.adapters").extend("copilot", {
			-- 			schema = {
			-- 				model = {
			-- 					default = "gpt-5",
			-- 				},
			-- 			},
			-- 		})
			-- 	end,
			-- },
			strategies = {
				-- CHAT STRATEGY ----------------------------------------------------------
				chat = {
					adapter = "copilot",
					roles = {
						llm = function(adapter)
							return adapter.formatted_name .. " "
						end,
						user = "Me 󰮠",
					},
					completion_provider = "cmp",
					keymaps = {
						close = {
							modes = {
								n = "<leader>q",
								i = "<C-c>",
							},
							index = 4,
							callback = "keymaps.close",
							description = "Close Chat",
						},
						stop = {
							modes = {
								n = "<leader>s",
								i = "<C-s>",
							},
							index = 5,
							callback = "keymaps.stop",
							description = "Stop Chat",
						},
					},
					tools = {
						opts = {
							wait_timeout = 10 * 60 * 1000
						}
					},
				},
				inline = { adapter = "copilot", completion_provider = "cmp" },
				agent = { adapter = "copilot", completion_provider = "cmp" },
			},
			-- -- PROMPT LIBRARIES ---------------------------------------------------------
			prompt_library = {
				["Explain"] = {
					strategy = "chat",
					description = "Explain how code in a buffer works",
					opts = {
						is_default = true,
						modes = { "v" },
						short_name = "explain",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_EXPLAIN,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return "explain how the following code works:\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Explain Code"] = {
					strategy = "chat",
					description = "Explain the following code",
					opts = {
						short_name = "explain-code",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_EXPLAIN,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = "explain how this code works.",
						},
					},
				},
				["Review"] = {
					strategy = "chat",
					description = "Review the provided code snippet.",
					opts = {
						modes = { "v" },
						short_name = "review",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_REVIEW,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return
									 "review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Review Code"] = {
					strategy = "chat",
					description = "Review code and provide suggestions for improvement.",
					opts = {
						short_name = "review-code",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_REVIEW,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content =
							"review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.",
						},
					},
				},
				["Refactor"] = {
					strategy = "inline",
					description = "Refactor the provided code snippet.",
					opts = {
						modes = { "v" },
						short_name = "refactor",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_REFACTOR,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return "refactor the following code to improve its clarity and readability:\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Refactor Code"] = {
					strategy = "chat",
					description = "Refactor the provided code snippet.",
					opts = {
						short_name = "refactor-code",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "system",
							content = COPILOT_REFACTOR,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = "refactor the following code to improve its clarity and readability.",
						},
					},
				},
				["Tests"] = {
					strategy = "chat",
					description = "Generate unit tests for the provided code snippet.",
					opts = {
						short_name = "tests",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "system",
							content = TESTS,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = "generate unit tests for the following code.",
						},
					},
				},
				["Commit Message"] = {
					strategy = "chat",
					description = "Generate a commit message for staged change",
					opts = {
						short_name = "commit",
						auto_submit = true,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "user",
							content = function()
								return
									 "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
									 .. "\n\n```\n"
									 .. vim.fn.system("git diff --no-ext-diff --staged")
									 .. "\n```"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Inline Document"] = {
					strategy = "inline",
					description = "Add documentation for code.",
					opts = {
						modes = { "v" },
						short_name = "inline-doc",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "system",
							content = DOCUMENT,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return
									 "provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Document"] = {
					strategy = "chat",
					description = "Write documentation for code.",
					opts = {
						modes = { "v" },
						short_name = "doc",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "system",
							content = DOCUMENT,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return
									 "brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Naming"] = {
					strategy = "inline",
					description = "Give betting naming for the provided code snippet.",
					opts = {
						modes = { "v" },
						short_name = "naming",
						auto_submit = true,
						user_prompt = false,
						stop_context_insertion = true,
					},
					prompts = {
						{
							role = "user",
							content = function(context)
								local code = require("codecompanion.helpers.actions").get_code(context.start_line,
									context.end_line)

								return "provide better names for the following variables and functions:\n\n```"
									 .. context.filetype
									 .. "\n"
									 .. code
									 .. "\n```\n\n"
							end,
							opts = {
								contains_code = true,
							},
						},
					},
				},
				["Better Naming"] = {
					strategy = "chat",
					description = "Give betting naming for the provided code snippet.",
					opts = {
						short_name = "better-naming",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "user",
							content = "provide better names for the following variables and functions.",
						},
					},
				},
				["Go Logs"] = {
					strategy = "chat",
					description = "Add logs to the provided code snippet.",
					opts = {
						short_name = "go-logs",
						auto_submit = false,
						is_slash_cmd = true,
					},
					prompts = {
						{
							role = "system",
							content = GO_LOGS,
							opts = {
								visible = false,
							},
						},
						{
							role = "user",
							content = "add log statements to the provided code.",
						},
					},
				},
			},
			-- -- DISPLAY OPTIONS ----------------------------------------------------------
			display = {
				action_palette = {
					provider = "telescope",
					opts = {
						show_default_actions = true, -- Show default actions in the action palette
						show_default_prompt_library = true, -- Show default prompt library in the action palette
					}
				},
				chat = {
					window = {
						layout = "vertical", -- float|vertical|horizontal|buffer
						position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
						border = "single",
						height = 0.8,
						width = 0.45,
						relative = "editor",
						full_height = true,
						opts = {
							breakindent = true,
							cursorcolumn = false,
							cursorline = false,
							foldcolumn = "0",
							linebreak = true,
							list = false,
							numberwidth = 1,
							signcolumn = "no",
							spell = false,
							wrap = true,
						},
					},
					auto_scroll = true, -- Automatically scroll down and place the cursor at the end
					-- show_settings = true,
					fold_context = true,
				},
				icons = {
					chat_context = "",
				},
				diff = {
					enabled = true,
					-- provider = providers.diff, -- mini_diff|default
				},
			},
			-- -- EXTENSIONS ------------------------------------------------------
			-- extensions = {},
			-- -- GENERAL OPTIONS ----------------------------------------------------------
			opts = {
				log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
				-- If this is false then any default prompt that is marked as containing code
				-- will not be sent to the LLM. note that whilst I have made every
				-- effort to ensure no code leakage, using this is at your own risk
				send_code = true,
				system_prompt = SYSTEM_PROMPT,
			},
		},
		keys = {
			{
				"<leader>aa",
				"<cmd>CodeCompanionActions<cr>",
				desc = "Code Companion - Actions",
			},
			{
				"<leader>av",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "Code Companion - Toggle",
				mode = { "n", "v" },
			},
			-- Some common usages with visual mode
			{
				"<leader>ae",
				"<cmd>CodeCompanion /explain<cr>",
				desc = "Code Companion - Explain code",
				mode = "v",
			},
			{
				"<leader>af",
				"<cmd>CodeCompanion /fix<cr>",
				desc = "Code Companion - Fix code",
				mode = "v",
			},
			{
				"<leader>al",
				"<cmd>CodeCompanion /lsp<cr>",
				desc = "Code Companion - Explain LSP diagnostic",
				mode = { "n", "v" },
			},
			{
				"<leader>at",
				"<cmd>CodeCompanion /tests<cr>",
				desc = "Code Companion - Generate unit test",
				mode = "v",
			},
			{
				"<leader>am",
				"<cmd>CodeCompanion /commit<cr>",
				desc = "Code Companion - Git commit message",
			},
			-- Custom prompts
			{
				"<leader>ad",
				"<cmd>CodeCompanion /inline-doc<cr>",
				desc = "Code Companion - Inline document code",
				mode = "v",
			},
			{
				"<leader>aD",
				"<cmd>CodeCompanion /doc<cr>",
				desc = "Code Companion - Document code",
				mode = "v"
			},
			{
				"<leader>ar",
				"<cmd>CodeCompanion /refactor<cr>",
				desc = "Code Companion - Refactor code",
				mode = "v",
			},
			{
				"<leader>aR",
				"<cmd>CodeCompanion /review<cr>",
				desc = "Code Companion - Review code",
				mode = "v",
			},
			{
				"<leader>an",
				"<cmd>CodeCompanion /naming<cr>",
				desc = "Code Companion - Better naming",
				mode = "v",
			},
			-- Quick chat
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CodeCompanion " .. input)
					end
				end,
				desc = "Code Companion - Quick chat",
			},
		},
	},
}
