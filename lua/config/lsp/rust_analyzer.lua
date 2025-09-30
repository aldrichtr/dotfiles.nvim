local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  local server = lspconfig.rust_analyzer

  server.setup({
    capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities()
    ),
    on_attach = function(client, bufnr) vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end,
    settings = {
      ['rust-analyzer'] = {
        -- --------------------------------------------------------------------------------
        -- #region General

        -- Run the check command for diagnostics on save.
        checkOnSave = true,

        -- Disable project auto-discovery in favor of explicitly specified set
        -- of projects.
        --
        -- Elements must be paths pointing to `Cargo.toml`,
        -- `rust-project.json`, `.rs` files (which will be treated as standalone files) or JSON
        -- objects in `rust-project.json` format.
        linkedProjects = {},

        -- How many worker threads in the main loop. The default `{}` means to pick automatically.
        numThreads = {},

        -- Whether to restart the server automatically when certain settings that require a restart are changed.
        restartServerOnConfigChange = false,

        -- Whether to show the dependencies view.
        showDependenciesExplorer = true,

        -- Whether to show error notifications for failing requests.
        showRequestFailedErrorNotification = true,

        -- Whether to show a notification for unlinked files asking the user to add the corresponding Cargo.toml to the linked projects setting.
        showUnlinkedFileNotification = true,

        -- Whether to show the test explorer.
        testExplorer = false,

        -- #endregion General
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Runnables

        runnables = {
          -- Command to be executed instead of 'cargo' for runnables.
          command = {},

          -- Additional arguments to be passed to cargo for runnables such as
          -- tests or binaries. For example, it may be `--release`.
          extraArgs = {},

          -- Environment variables passed to the runnable launched using `Test` or `Debug` lens or `rust-analyzer.run` command.
          extraEnv = {},

          -- Additional arguments to be passed through Cargo to launched tests, benchmarks, or
          -- doc-tests.
          --
          -- Unless the launched target uses a
          -- [custom test harness](https:--doc.rust-lang.org/cargo/reference/cargo-targets.html#the-harness-field),
          -- they will end up being interpreted as options to
          -- [`rustc`'s built-in test harness ("libtest")](https:--doc.rust-lang.org/rustc/tests/index.html#cli-arguments).
          extraTestBinaryArgs = {
            '--show-output',
          },

          -- Problem matchers to use for `rust-analyzer.run` command, eg `["$rustc", "$rust-panic"]`.
          problemMatcher = {
            '$rustc',
          },
        }, -- end 'runnables'

        -- #endregion Runnables
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Server

        -- Action to run when clicking the extension status bar item.
        --  - stopServer: Stop Server
        --  - openLogs: Open Logs
        statusBar = {
          clickAction = 'openLogs',
        },

        server = {
          -- Extra environment variables that will be passed to the rust-analyzer executable. Useful for passing e.g. `RA_LOG` for debugging.
          extraEnv = {},

          -- Path to rust-analyzer executable (points to bundled binary by default).
          path = {},
        },

        -- Log level is now controlled by the [Developer: Set Log Level...](command:workbench.action.setLogLevel) command.  You can set the
        -- log level for the current session and also the default log level from there. This is also available by clicking the gear icon on
        -- the OUTPUT tab when Rust Analyzer Client is visible or by passing the --log rust-lang.rust-analyzer:debug parameter to VS Code.
        -- Enable logging of VS Code extensions itself.
        trace = {
          extension = false,

          -- Trace requests to the rust-analyzer (this is usually overly verbose and not recommended for regular users).
          --  - off: No traces
          --  - messages: Error only
          --  - verbose: Full log
          server = 'off',
        },
        -- #endregion Server
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Debug

        debug = {
          -- Preferred debug engine.
          --  - auto: First try to use
          --    [CodeLLDB](https:--marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb),
          --    if it's not installed try to use
          --    [MS C++ tools](https:--marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools).
          --  - vadimcn.vscode-lldb: Use [CodeLLDB](https:--marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)
          --  - ms-vscode.cpptools: Use [MS C++ tools](https:--marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
          engine = 'auto',

          -- Optional settings passed to the debug engine. Example: `{ "lldb" = { "terminal" ="external"} }`
          engineSettings = {},

          -- Whether to open up the `Debug Panel` on debugging start.
          openDebugPane = false,

          -- Optional source file mappings passed to the debug engine.
          sourceFileMap = 'auto',
        },

        -- #endregion Debug
        -- --------------------------------------------------------------------------------

        typing = {
          -- Whether to insert closing angle brackets when typing an opening angle bracket of a generic argument list.
          autoClosingAngleBrackets = {
            enable = true,
          },
          -- Whether to prefix newlines after comments with the corresponding comment prefix.
          continueCommentsOnNewline = true,
        },

        -- --------------------------------------------------------------------------------
        -- #region Diagnostics
        diagnostics = {
          -- List of rust-analyzer diagnostics to disable.
          disabled = {},

          -- Whether to show native rust-analyzer diagnostics.
          enable = true,

          -- Whether to show experimental rust-analyzer diagnostics that might
          -- have more false positives than usual.
          experimental = {
            enable = false,
          },

          -- Whether to show the main part of the rendered rustc output of a diagnostic message.
          previewRustcOutput = false,

          -- Map of prefixes to be substituted when parsing diagnostic file paths.
          -- This should be the reverse mapping of what is passed to `rustc` as `--remap-path-prefix`.
          remapPrefix = {},

          -- Whether to run additional style lints.
          styleLints = {
            enable = false,
          },

          -- Whether to show diagnostics using the original rustc error code. If this is false, all rustc diagnostics will have the code 'rustc(Click for full compiler diagnostics)'
          useRustcErrorCode = false,

          -- List of warnings that should be displayed with hint severity.
          --
          -- The warnings will be indicated by faded text or three dots in code
          -- and will not show up in the `Problems Panel`.
          warningsAsHint = {},

          -- List of warnings that should be displayed with info severity.
          --
          -- The warnings will be indicated by a blue squiggly underline in code
          -- and a blue icon in the `Problems Panel`.
          warningsAsInfo = {},
        },
        -- #endregion Diagnostics
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Assist

        -- Whether to insert #[must_use] when generating `as_` methods
        -- for enum variants.
        assist = {
          emitMustUse = false,

          -- Placeholder expression to use for missing expressions in assists.
          --  - todo: Fill missing expressions with the `todo` macro
          --  - default: Fill missing expressions with reasonable defaults, `new` or `default` constructors.
          expressionFillDefault = 'todo',

          -- Enable borrow checking for term search code assists. If set to false, also there will be more suggestions, but some of them may not borrow-check.
          termSearch = {
            borrowcheck = true,

            -- Term search fuel in "units of work" for assists (Defaults to 1800).
            fuel = 1800,
          },
        },

        -- #endregion Assist
        -- --------------------------------------------------------------------------------

        -- Warm up caches on project load.
        cachePriming = {
          enable = true,

          -- How many worker threads to handle priming caches. The default `0` means to pick automatically.
          numThreads = 'physical',
        },

        -- --------------------------------------------------------------------------------
        -- #region Cargo
        cargo = {
          -- Pass `--all-targets` to cargo invocation.
          allTargets = true,

          -- Automatically refresh project info via `cargo metadata` on
          -- `Cargo.toml` or `.cargo/config.toml` changes.
          autoreload = true,

          -- Run build scripts (`build.rs`) for more precise code analysis.
          buildScripts = {
            enable = true,

            -- Specifies the invocation strategy to use when running the build scripts command.
            -- If `per_workspace` is set, the command will be executed for each Rust workspace with the
            -- workspace as the working directory.
            -- If `once` is set, the command will be executed once with the opened project as the
            -- working directory.
            -- This config only has an effect when `rust-analyzer.cargo.buildScripts.overrideCommand`
            -- is set.
            --  - per_workspace: The command will be executed for each Rust workspace with the workspace as the working directory.
            --  - once: The command will be executed once with the opened project as the working directory.
            invocationStrategy = 'per_workspace',

            -- Override the command rust-analyzer uses to run build scripts and
            -- build procedural macros. The command is required to output json
            -- and should therefore include `--message-format=json` or a similar
            -- option.
            --
            -- If there are multiple linked projects/workspaces, this command is invoked for
            -- each of them, with the working directory being the workspace root
            -- (i.e., the folder containing the `Cargo.toml`). This can be overwritten
            -- by changing `rust-analyzer.cargo.buildScripts.invocationStrategy`.
            --
            -- By default, a cargo invocation will be constructed for the configured
            -- targets and features, with the following base command line:
            --
            -- ```bash
            -- cargo check --quiet --workspace --message-format=json --all-targets --keep-going
            -- ```
            -- .
            overrideCommand = {},

            -- Rerun proc-macros building/build-scripts running when proc-macro
            -- or build-script sources change and are saved.
            rebuildOnSave = true,

            -- Use `RUSTC_WRAPPER=rust-analyzer` when running build scripts to
            -- avoid checking unnecessary things.
            useRustcWrapper = true,
          },
          -- List of cfg options to enable with the given values.
          cfgs = {
            debug_assertions = {},
            miri = {},
          },

          -- Extra arguments that are passed to every cargo invocation.
          extraArgs = {},

          -- Extra environment variables that will be set when running cargo, rustc
          -- or other commands within the workspace. Useful for setting RUSTFLAGS.
          extraEnv = {},

          -- List of features to activate.
          --
          -- Set this to `"all"` to pass `--all-features` to cargo.
          features = {},

          -- Whether to pass `--no-default-features` to cargo.
          noDefaultFeatures = false,

          -- Relative path to the sysroot, or "discover" to try to automatically find it via
          -- "rustc --print sysroot".
          --
          -- Unsetting this disables sysroot loading.
          --
          -- This option does not take effect until rust-analyzer is restarted.
          sysroot = 'discover',

          -- Relative path to the sysroot library sources. If left unset, this will default to
          -- `{cargo.sysroot}/lib/rustlib/src/rust/library`.
          --
          -- This option does not take effect until rust-analyzer is restarted.
          sysrootSrc = {},

          -- Compilation target override (target triple).
          target = {},

          -- Optional path to a rust-analyzer specific target directory.
          -- This prevents rust-analyzer's `cargo check` and initial build-script and proc-macro
          -- building from locking the `Cargo.lock` at the expense of duplicating build artifacts.
          --
          -- Set to `true` to use a subdirectory of the existing target directory or
          -- set to a path relative to the workspace to use that path.
          targetDir = {},
        },
        -- #endregion Cargo
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Check

        -- Check all targets and tests (`--all-targets`). Defaults to
        -- `rust-analyzer.cargo.allTargets`.
        check = {
          allTargets = {},

          -- Cargo command to use for `cargo check`.
          command = {},

          -- Extra arguments for `cargo check`.
          extraArgs = {},

          -- Extra environment variables that will be set when running `cargo check`.
          -- Extends `rust-analyzer.cargo.extraEnv`.
          extraEnv = {},

          -- List of features to activate. Defaults to
          -- `rust-analyzer.cargo.features`.
          --
          -- Set to `"all"` to pass `--all-features` to Cargo.
          features = {},

          -- List of `cargo check` (or other command specified in `check.command`) diagnostics to ignore.
          --
          -- For example for `cargo check`: `dead_code`, `unused_imports`, `unused_variables`,...
          ignore = {},

          -- Specifies the invocation strategy to use when running the check command.
          -- If `per_workspace` is set, the command will be executed for each workspace.
          -- If `once` is set, the command will be executed once.
          -- This config only has an effect when `rust-analyzer.check.overrideCommand`
          -- is set.
          --  - per_workspace: The command will be executed for each Rust workspace with the workspace as the working directory.
          --  - once: The command will be executed once with the opened project as the working directory.
          invocationStrategy = 'per_workspace',

          -- Whether to pass `--no-default-features` to Cargo. Defaults to
          -- `rust-analyzer.cargo.noDefaultFeatures`.
          noDefaultFeatures = {},

          -- Override the command rust-analyzer uses instead of `cargo check` for
          -- diagnostics on save. The command is required to output json and
          -- should therefore include `--message-format=json` or a similar option
          -- (if your client supports the `colorDiagnosticOutput` experimental
          -- capability, you can use `--message-format=json-diagnostic-rendered-ansi`).
          --
          -- If you're changing this because you're using some tool wrapping
          -- Cargo, you might also want to change
          -- `rust-analyzer.cargo.buildScripts.overrideCommand`.
          --
          -- If there are multiple linked projects/workspaces, this command is invoked for
          -- each of them, with the working directory being the workspace root
          -- (i.e., the folder containing the `Cargo.toml`). This can be overwritten
          -- by changing `rust-analyzer.check.invocationStrategy`.
          --
          -- If `$saved_file` is part of the command, rust-analyzer will pass
          -- the absolute path of the saved file to the provided command. This is
          -- intended to be used with non-Cargo build systems.
          -- Note that `$saved_file` is experimental and may be removed in the future.
          --
          -- An example command would be:
          --
          -- ```bash
          -- cargo check --workspace --message-format=json --all-targets
          -- ```
          -- .
          overrideCommand = {},

          -- Check for specific targets. Defaults to `rust-analyzer.cargo.target` if empty.
          --
          -- Can be a single target, e.g. `"x86_64-unknown-linux-gnu"` or a list of targets, e.g.
          -- `["aarch64-apple-darwin", "x86_64-apple-darwin"]`.
          --
          -- Aliased as `nSave.targets"`.
          targets = {},

          -- Whether `--workspace` should be passed to `cargo check`.
          -- If false, `-p <package>` will be passed instead.
          workspace = true,
        },

        -- #endregion Check
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Completion

        completion = {
          -- Whether to automatically add a semicolon when completing unit-returning functions.
          --
          -- In `match` arms it completes a comma instead.
          addSemicolonToUnit = true,

          -- Toggles the additional completions that automatically add imports when completed.
          -- Note that your client must specify the `additionalTextEdits` LSP client capability to truly have this feature enabled.
          autoimport = {
            enable = true,
          },

          -- Toggles the additional completions that automatically show method calls and field accesses
          -- with `self` prefixed to them when inside a method.
          autoself = {
            enable = true,
          },

          -- Whether to add parenthesis and argument snippets when completing function.
          --  - fill_arguments: Add call parentheses and pre-fill arguments.
          --  - add_parentheses: Add call parentheses.
          --  - none: Do no snippet completions for callables.
          callable = {
            snippets = 'fill_arguments',
          },

          -- Whether to show full function/method signatures in completion docs.
          fullFunctionSignatures = {
            enable = false,
          },

          -- Whether to omit deprecated items from autocompletion. By default they are marked as deprecated but not hidden.
          hideDeprecated = false,

          -- Maximum number of completions to return. If `None`, the limit is infinite.
          limit = {},

          -- Whether to show postfix snippets like `dbg`, `if`, `not`, etc.
          postfix = {
            enable = true,
          },

          -- Enables completions of private items and fields that are defined in the current workspace even if they are not visible at the current position.
          privateEditable = {
            enable = false,
          },
          -- Custom completion snippets.
          snippets = {
            custom = {
              ['Arc::new'] = {
                postfix = 'arc',
                body = 'Arc::new(${receiver})',
                requires = 'std::sync::Arc',
                description = 'Put the expression into an `Arc`',
                scope = 'expr',
              },
              ['Rc::new'] = {
                postfix = 'rc',
                body = 'Rc::new(${receiver})',
                requires = 'std::rc::Rc',
                description = 'Put the expression into an `Rc`',
                scope = 'expr',
              },
              ['Box::pin'] = {
                postfix = 'pinbox',
                body = 'Box::pin(${receiver})',
                requires = 'std::boxed::Box',
                description = 'Put the expression into a pinned `Box`',
                scope = 'expr',
              },
              ['Err'] = {
                postfix = 'err',
                body = 'Err(${receiver})',
                description = 'Wrap the expression in a `Result::Err`',
                scope = 'expr',
              },
              ['Some'] = {
                postfix = 'some',
                body = 'Some(${receiver})',
                description = 'Wrap the expression in an `Option::Some`',
                scope = 'expr',
              },
              ['Ok'] = {
                postfix = 'ok',
                body = 'Ok(${receiver})',
                description = 'Wrap the expression in a `Result::Ok`',
                scope = 'expr',
              },
            },
          },
          termSearch = {
            -- Whether to enable term search based snippets like `Some(foo.bar().baz())`.
            enable = false,
            -- Term search fuel in "units of work" for autocompletion (Defaults to 1000).
            fuel = 1000,
          },
        },
        -- #endregion Completion
        -- --------------------------------------------------------------------------------

        files = {
          -- These directories will be ignored by rust-analyzer. They are
          -- relative to the workspace root, and globs are not supported. You may
          -- also need to add the folders to Code's `files.watcherExclude`.
          excludeDirs = {},

          -- Controls file watching implementation.
          --  - client: Use the client (editor) to watch files for changes
          --  - server: Use server-side file watching
          watcher = 'client',
        },

        -- --------------------------------------------------------------------------------
        -- #region Highlighting

        highlightRelated = {
          -- Enables highlighting of related references while the cursor is on `break`, `loop`, `while`, or `for` keywords.
          breakPoints = {
            enable = true,
          },

          -- Enables highlighting of all captures of a closure while the cursor is on the `|` or move keyword of a closure.
          closureCaptures = {
            enable = true,
          },

          -- Enables highlighting of all exit points while the cursor is on any `return`, `?`, `fn`, or return type arrow (`->`).
          exitPoints = {
            enable = true,
          },

          -- Enables highlighting of related references while the cursor is on any identifier.
          references = {
            enable = true,
          },

          -- Enables highlighting of all break points for a loop or block context while the cursor is on any `async` or `await` keywords.
          yieldPoints = {
            enable = true,
          },
        },
        -- #endregion Highlighting
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Hover
        hover = {
          actions = {
            -- Whether to show HoverActions in Rust files.
            enable = true,

            -- Whether to show `Debug` action. Only applies when
            -- `rust-analyzer.hover.actions.enable` is set.
            debug = {
              enable = true,
            },

            -- Whether to show `Go to Type Definition` action. Only applies when
            -- `rust-analyzer.hover.actions.enable` is set.
            gotoTypeDef = {
              enable = true,
            },

            -- Whether to show `Implementations` action. Only applies when
            -- `rust-analyzer.hover.actions.enable` is set.
            implementations = {
              enable = true,
            },

            -- Whether to show `References` action. Only applies when
            -- `rust-analyzer.hover.actions.enable` is set.
            references = {
              enable = false,
            },

            -- Whether to show `Run` action. Only applies when
            -- `rust-analyzer.hover.actions.enable` is set.
            run = {
              enable = true,
            },
          },
          documentation = {
            -- Whether to show documentation on hover.
            enable = true,

            -- Whether to show keyword hover popups. Only applies when
            -- `rust-analyzer.hover.documentation.enable` is set.
            keywords = {
              enable = true,
            },
          },

          -- Use markdown syntax for links on hover.
          links = {
            enable = true,
          },

          memoryLayout = {
            -- How to render the align information in a memory layout hover.
            alignment = 'hexadecimal',

            -- Whether to show memory layout data on hover.
            enable = true,

            -- How to render the niche information in a memory layout hover.
            niches = false,

            -- How to render the offset information in a memory layout hover.
            offset = 'hexadecimal',

            -- How to render the size information in a memory layout hover.
            size = 'both',
          },

          show = {
            -- How many variants of an enum to display when hovering on. Show none if empty.
            enumVariants = 5,

            -- How many fields of a struct, variant or union to display when hovering on. Show none if empty.
            fields = 5,

            -- How many associated items of a trait to display when hovering a trait.
            traitAssocItems = {},
          },
        },

        -- #endregion Hover
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Imports
        imports = {
          granularity = {
            -- Whether to enforce the import granularity setting for all files. If set to false rust-analyzer will try to keep import styles consistent per file.
            enforce = false,

            -- How imports should be grouped into use statements.
            --  - preserve: Do not change the granularity of any imports and preserve the original structure written by the developer.
            --  - crate: Merge imports from the same crate into a single use statement. Conversely, imports from different crates are split into separate statements.
            --  - module: Merge imports from the same module into a single use statement. Conversely, imports from different modules are split into separate statements.
            --  - item: Flatten imports so that each has its own use statement.
            --  - one: Merge all imports into a single use statement as long as they have the same visibility and attributes.
            group = 'crate',
          },

          group = {
            -- Group inserted imports by the [following order](https:--rust-analyzer.github.io/manual.html#auto-import). Groups are separated by newlines.
            enable = true,
          },

          merge = {
            -- Whether to allow import insertion to merge new imports into single path glob imports like `use std::fmt::*;`.
            glob = true,
          },

          -- Prefer to unconditionally use imports of the core and alloc crate, over the std crate.
          preferNoStd = false,

          -- Whether to prefer import paths containing a `prelude` module.
          preferPrelude = false,

          -- The path structure for newly inserted paths to use.
          --  - plain: Insert import paths relative to the current module, using up to one `super` prefix if the parent module contains the requested item.
          --  - self: Insert import paths relative to the current module, using up to one `super` prefix if the parent module contains the requested item.
          --          Prefixes `self` in front of the path if it starts with a module.
          --  - crate: Force import paths to be absolute by always starting them with `crate` or the extern crate name they come from.
          prefix = 'plain',

          -- Whether to prefix external (including std, core) crate imports with `::`. e.g. "use ::std::io::Read;".
          prefixExternPrelude = false,
        },
        -- #endregion Imports
        -- --------------------------------------------------------------------------------

        -- --------------------------------------------------------------------------------
        -- #region Inlay hints

        inlayHints = {
          -- Whether to show inlay type hints for binding modes.
          bindingModeHints = {
            enable = false,
          },

          -- Whether to show inlay type hints for method chains.
          chainingHints = {
            enable = true,
          },

          -- Whether to show inlay hints after a closing-bracket to indicate what item it belongs to.
          closingBraceHints = {
            enable = true,

            -- Minimum number of lines required before the closing-bracket until the hint is shown (set to 0 or 1
            -- to always show them).
            minLines = 25,
          },
          closureCaptureHints = {
            -- Whether to show inlay hints for closure captures.
            enable = false,
          },

          -- Whether to show inlay type hints for return types of closures.
          --  - always: Always show type hints for return types of closures.
          --  - never: Never show type hints for return types of closures.
          --  - with_block: Only show type hints for return types of closures with blocks.
          closureReturnTypeHints = {
            enable = 'never',
          },

          -- Closure notation in type and chaining inlay hints.
          --  - impl_fn: `impl_fn`: `impl FnMut(i32, u64) -> i8`
          --  - rust_analyzer: `rust_analyzer`: `|i32, u64| -> i8`
          --  - with_id: `with_id`: `{closure#14352}`, where that id is the unique number of the closure in r-a internals
          --  - hide: `hide`: Shows `...` for every closure type
          closureStyle = 'impl_fn',

          -- Whether to show enum variant discriminant hints.
          --  - always: Always show all discriminant hints.
          --  - never: Never show discriminant hints.
          --  - fieldless: Only show discriminant hints on fieldless enum variants.
          discriminantHints = {
            enable = 'never',
          },
          expressionAdjustmentHints = {
            -- Whether to show inlay hints for type adjustments.
            --  - always: Always show all adjustment hints.
            --  - never: Never show adjustment hints.
            --  - reborrow: Only show auto borrow and dereference adjustment hints.
            enable = 'never',

            -- Whether to hide inlay hints for type adjustments outside of `unsafe` blocks.
            hideOutsideUnsafe = false,

            -- Whether to show inlay hints as postfix ops (`.*` instead of `*`, etc).
            --  - prefix: Always show adjustment hints as prefix (`*expr`).
            --  - postfix: Always show adjustment hints as postfix (`expr.*`).
            --  - prefer_prefix: Show prefix or postfix depending on which uses less parenthesis, preferring prefix.
            --  - prefer_postfix: Show prefix or postfix depending on which uses less parenthesis, preferring postfix.
            mode = 'prefix',
          },
          -- Whether to show const generic parameter name inlay hints.
          genericParameterHints = {
            const = {
              enable = true,
            },

            -- Whether to show generic lifetime parameter name inlay hints.
            lifetime = {
              enable = false,
            },

            -- Whether to show generic type parameter name inlay hints.
            type = {
              enable = false,
            },
          },

          -- Whether to show implicit drop hints.
          implicitDrops = {
            enable = false,
          },
          -- Whether to show inlay type hints for elided lifetimes in function signatures.
          --  - always: Always show lifetime elision hints.
          --  - never: Never show lifetime elision hints.
          --  - skip_trivial: Only show lifetime elision hints if a return type is involved.
          lifetimeElisionHints = {
            enable = 'never',

            -- Whether to prefer using parameter names as the name for elided lifetime hints if possible.
            useParameterNames = false,
          },
          -- Maximum length for inlay hints. Set to {} to have an unlimited length.
          maxLength = 25,

          -- Whether to show function parameter name inlay hints at the call
          -- site.
          parameterHints = {
            enable = true,
          },

          -- Whether to show exclusive range inlay hints.
          rangeExclusiveHints = {
            enable = false,
          },

          -- Whether to show inlay hints for compiler inserted reborrows.
          -- This setting is deprecated in favor of #rust-analyzer.inlayHints.expressionAdjustmentHints.enable#.
          --  - always: Always show reborrow hints.
          --  - never: Never show reborrow hints.
          --  - mutable: Only show mutable reborrow hints.
          reborrowHints = {
            enable = 'never',
          },
          -- Whether to render leading colons for type hints, and trailing colons for parameter hints.
          renderColons = true,

          -- Whether to show inlay type hints for variables.
          typeHints = {
            enable = true,
            -- Whether to hide inlay type hints for `let` statements that initialize to a closure.
            -- Only applies to closures with blocks, same as `rust-analyzer.inlayHints.closureReturnTypeHints.enable`.
            hideClosureInitialization = false,

            -- Whether to hide inlay type hints for constructors.
            hideNamedConstructor = false,
          },
        },
        -- #endregion Inlay hints
        -- --------------------------------------------------------------------------------

        interpret = {
          -- Enables the experimental support for interpreting tests.
          tests = false,
        },

        -- Join lines merges consecutive declaration and initialization of an assignment.
        joinLines = {
          joinAssignments = true,

          -- Join lines inserts else between consecutive ifs.
          joinElseIf = true,

          -- Join lines removes trailing commas.
          removeTrailingComma = true,

          -- Join lines unwraps trivial blocks.
          unwrapTrivialBlock = true,
        },

        -- --------------------------------------------------------------------------------
        -- #region Lens
        lens = {
          -- Whether to show `Debug` lens. Only applies when
          -- `rust-analyzer.lens.enable` is set.
          debug = {
            enable = true,
          },

          -- Whether to show CodeLens in Rust files.
          enable = true,

          -- Whether to show `Implementations` lens. Only applies when
          -- `rust-analyzer.lens.enable` is set.
          implementations = {
            enable = true,
          },
          -- Where to render annotations.
          --  - above_name: Render annotations above the name of the item.
          --  - above_whole_item: Render annotations above the whole item, including documentation comments and attributes.
          location = 'above_name',

          -- Whether to show `References` lens for Struct, Enum, and Union.
          -- Only applies when `rust-analyzer.lens.enable` is set.
          references = {
            adt = {
              enable = false,
            },
            -- Whether to show `References` lens for Enum Variants.
            -- Only applies when `rust-analyzer.lens.enable` is set.
            enumVariant = {
              enable = false,
            },
            -- Whether to show `Method  lens. Only applies when
            -- `rust-analyzer.lens.enable` is set.
            method = {
              enable = false,
            },

            -- Whether to show ` lens for Trait.
            -- Only applies when `rust-analyzer.lens.enable` is set.
            trait = {
              enable = false,
            },
            -- Whether to show `Run` lens. Only applies when
            -- `rust-analyzer.lens.enable` is set.
            run = {
              enable = true,
            },
          },
        },
        -- #endregion Lens
        -- --------------------------------------------------------------------------------

        -- Number of syntax trees rust-analyzer keeps in memory. Defaults to 128.
        lru = {
          capacity = {},

          -- Sets the LRU capacity of the specified queries.
          query = {
            capacities = {},
          },
        },

        -- Whether to show `can't find Cargo.toml` error message.
        notifications = {
          cargoTomlNotFound = true,
        },

        -- Expand attribute macros. Requires `rust-analyzer.procMacro.enable` to be set.
        procMacro = {
          attributes = {
            enable = true,
          },

          enable = true,
          -- Enable support for procedural macros, implies `rust-analyzer.cargo.buildScripts.enable`.

          -- These proc-macros will be ignored when trying to expand them.
          --
          -- This config takes a map of crate names with the exported proc-macro names to ignore as values.
          ignored = {},

          -- Internal config, path to proc-macro server executable.
          server = {},
        },

        -- Exclude imports from find-all-references.
        references = {
          excludeImports = false,

          -- Exclude tests from find-all-references.
          excludeTests = false,
        },

        -- Path to the Cargo.toml of the rust compiler workspace, for usage in rustc_private
        -- projects, or "discover" to try to automatically find it if the `rustc-dev` component
        -- is installed.
        --
        -- Any project which uses rust-analyzer with the rustcPrivate
        -- crates must set `[package.metadata.rust-analyzer] rustc_private=true` to use it.
        --
        -- This option does not take effect until rust-analyzer is restarted.
        rustc = {
          source = {},
        },

        -- Additional arguments to `rustfmt`.
        rustfmt = {
          extraArgs = {
            '+nightly',
          },

          -- Advanced option, fully override the command rust-analyzer uses for
          -- formatting. This should be the equivalent of `rustfmt` here, and
          -- not that of `cargo fmt`. The file contents will be passed on the
          -- standard input and the formatted result will be read from the
          -- standard output.
          overrideCommand = nil,

          -- Enables the use of rustfmt's unstable range formatting command for the
          -- `textDocument/rangeFormatting` request. The rustfmt option is unstable and only
          -- available on a nightly build.
          rangeFormatting = {
            enable = true,
          },
        },
        -- Inject additional highlighting into doc comments.
        --
        -- When enabled, rust-analyzer will highlight rust source in doc comments as well as intra
        -- doc links.
        semanticHighlighting = {
          doc = {
            comment = {
              inject = {
                enable = true,
              },
            },
          },

          -- Whether the server is allowed to emit non-standard tokens and modifiers.
          nonStandardTokens = true,

          -- Use semantic tokens for operators.
          --
          -- When disabled, rust-analyzer will emit semantic tokens only for operator tokens when
          -- they are tagged with modifiers.
          operator = {
            enable = true,

            -- Use specialized semantic tokens for operators.
            --
            -- When enabled, rust-analyzer will emit special token types for operator tokens instead
            -- of the generic `operator` token type.
            specialization = {
              enable = true,
            },
          },

          -- Use semantic tokens for punctuation.
          --
          -- When disabled, rust-analyzer will emit semantic tokens only for punctuation tokens when
          -- they are tagged with modifiers or have a special role.
          punctuation = {
            enable = true,

            -- When enabled, rust-analyzer will emit a punctuation semantic token for the `!` of macro
            -- calls.
            separate = {
              macro = {
                bang = true,
              },
            },
            -- Use specialized semantic tokens for punctuation.
            --
            -- When enabled, rust-analyzer will emit special token types for punctuation tokens instead
            -- of the generic `punctuation` token type.
            specialization = {
              enable = true,
            },
          },

          -- Use semantic tokens for strings.
          --
          -- In some editors (e.g. vscode) semantic tokens override other highlighting grammars.
          -- By disabling semantic tokens for strings, other grammars can be used to highlight
          -- their contents.
          strings = {
            enable = true,
          },
        },

        -- Show full signature of the callable. Only shows parameters if disabled.
        --  - full: Show the entire signature.
        --  - parameters: Show only the parameters.
        signatureInfo = {
          detail = 'full',

          -- Show documentation.
          documentation = {
            enable = true,
          },
        },

        -- Enables automatic discovery of projects using [`DiscoverWorkspaceConfig::command`].
        --
        -- [`DiscoverWorkspaceConfig`] also requires setting `progress_label` and `files_to_watch`.
        -- `progress_label` is used for the title in progress indicators, whereas `files_to_watch`
        -- is used to determine which build system-specific files should be watched in order to
        -- reload rust-analyzer.
        --
        -- Below is an example of a valid configuration:
        -- ```json
        -- "workspace.discoverConfig" = {
        --         "command" = [
        --                 "rust-project",
        --                 "develop-json"
        --         ],
        --         "progressLabel" = ",
        --         "filesToWatch" = [
        --                 "BUCK"
        --         ]
        -- }
        -- ```
        --
        -- ## On `DiscoverWorkspaceConfig::command`
        --
        -- **Warning**: This format is provisional and subject to change.
        --
        -- [`DiscoverWorkspaceConfig::command`] *must* return a JSON object
        -- corresponding to `DiscoverProjectData::Finished`:
        --
        -- ```norun
        -- #[derive(Debug, Clone, Deserialize, Serialize)]
        -- #[serde(tag = "kind")]
        -- #[serde(rename_all = "snake_case")]
        -- enum DiscoverProjectData {
        --         Finished { buildfile: Utf8PathBuf, project: ProjectJsonData },
        --         Error { error: String, source: Option<String> },
        --         Progress { message: String },
        -- }
        -- ```
        --
        -- As JSON, `DiscoverProjectData::Finished` is:
        --
        -- ```json
        -- {
        --         -- the internally-tagged representation of the enum.
        --         "kind" = "finished",
        --         -- the file used by a non-Cargo build system to define
        --         -- a package or target.
        --         "buildfile" = "BUILD",
        --         -- the contents of a rust-project.json, elided for brevity
        --         "project" = {
        --                 "sysroot" = "foo",
        --                 "crates" = []
        --         }
        -- }
        -- ```
        --
        -- It is encouraged, but not required, to use the other variants on
        -- `DiscoverProjectData` to provide a more polished end-user experience.
        --
        -- `DiscoverWorkspaceConfig::command` may *optionally* include an `{arg}`,
        -- which will be substituted with the JSON-serialized form of the following
        -- enum:
        --
        -- ```norun
        -- #[derive(PartialEq, Clone, Debug, Serialize)]
        -- #[serde(rename_all = "camelCase")]
        -- pub enum DiscoverArgument {
        --      Path(AbsPathBuf),
        --      Buildfile(AbsPathBuf),
        -- }
        -- ```
        --
        -- The JSON representation of `DiscoverArgument::Path` is:
        --
        -- ```json
        -- {
        --         "path" = "src/main.rs"
        -- }
        -- ```
        --
        -- Similarly, the JSON representation of `DiscoverArgument::Buildfile` is:
        --
        -- ```
        -- {
        --         "buildfile" = "BUILD"
        -- }
        -- ```
        --
        -- `DiscoverArgument::Path` is used to find and generate a `rust-project.json`,
        -- and therefore, a workspace, whereas `DiscoverArgument::buildfile` is used to
        -- to update an existing workspace. As a reference for implementors,
        -- buck2's `rust-project` will likely be useful:
        -- https:--github.com/facebook/buck2/tree/main/integrations/rust-project.
        workspace = {
          discoverConfig = {},

          -- Workspace symbol search kind.
          --  - only_types: Search for types only.
          --  - all_symbols: Search for all symbols kinds.
          symbol = {
            search = {
              kind = 'only_types',

              -- Limits the number of items returned from a workspace symbol search (Defaults to 128).
              -- Some clients like vs-code issue new searches on result filtering and don't require all results to be returned in the initial search.
              -- Other clients requires all results upfront and might require a higher limit.
              limit = 128,

              -- Workspace symbol search scope.
              --  - workspace: Search in current workspace only.
              --  - workspace_and_dependencies: Search in current workspace and dependencies.
              scope = 'workspace',
            },
          },
        }, -- end 'workspace'
      }, -- end 'rust-analyzer
    }, -- end 'settings'
  }) -- end 'setup'
end

return M