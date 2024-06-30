local which_key = require('which-key')
local icons = require('lib.icons')

local setup = {
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 30,
        },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        },
    },
    key_labels = {
        ['<leader>'] = icons.ui.Rocket,
        ['<space>'] = '<spc>',
        ['<Tab>'] = '<tab>',
    },
    icons = {
        breadcrumb = icons.ui.ArrowOpen,
        separator = icons.ui.Arrow,
        group = '',
    },
    popup_mappings = {
        scroll_down = '<c-d>',
        scroll_up = '<c-u>',
    },
    window = {
        border = 'shadow',
        position = 'bottom',
        margin = { 0, 0, 0, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 10,
    },
    layout = {
        height = { min = 5, max = 26 },
        width = { min = 20, max = 50 },
        spacing = 6,
        align = 'center',
    },
    ignore_missing = false,
    hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' },
    show_help = true,
    show_keys = true,
    triggers = 'auto',
    triggers_nowait = {
        -- marks
        '`',
        "'",
        'g`',
        "g'",
        -- registers
        '"',
        '<c-r>',
        -- spelling
        'z=',
    },
    triggers_blacklist = {
        i = { 'j', 'j' },
        v = { 'j', 'j' },
    },
}

local i = {
    [' '] = 'Whitespace',
    ['"'] = 'Balanced "',
    ["'"] = "Balanced '",
    ['`'] = 'Balanced `',
    ['('] = 'Balanced (',
    [')'] = 'Balanced ) including white-space',
    ['>'] = 'Balanced > including white-space',
    ['<lt>'] = 'Balanced <',
    [']'] = 'Balanced ] including white-space',
    ['['] = 'Balanced [',
    ['}'] = 'Balanced } including white-space',
    ['{'] = 'Balanced {',
    ['?'] = 'User Prompt',
    _ = 'Underscore',
    a = 'Argument',
    b = 'Balanced ), ], }',
    c = 'Class',
    f = 'Function',
    o = 'Block, conditional, loop',
    q = 'Quote `, ", \'',
    t = 'Tag',
}

local a = vim.deepcopy(i)
for k, v in pairs(a) do
    a[k] = v:gsub(' including.*', '')
end

local ic = vim.deepcopy(i)
local ac = vim.deepcopy(a)

for key, name in pairs({ n = 'Next', l = 'Last' }) do
    i[key] = vim.tbl_extend('force', { name = 'Inside ' .. name .. ' textobject' }, ic)
    a[key] = vim.tbl_extend('force', { name = 'Around ' .. name .. ' textobject' }, ac)
end

local opts = {
    mode = 'n',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

local mappings = {
    a = {
        name = icons.ui.Copilot .. 'AI',
        c = { '<cmd>CopilotChatToggle<cr>', 'Copilot Chat' },
        d = { '<cmd>CopilotChatDocs<cr>', 'Docs' },
        e = { '<cmd>CopilotChatExplain<cr>', 'Explain' },
        f = { '<cmd>CopilotChatFix<cr>', 'Fix' },
        F = { '<cmd>CopilotChatFixDiagnostic<cr>', 'Fix Diagnostic' },
        g = { '<cmd>CopilotChatCommit<cr>', 'Commit' },
        G = { '<cmd>CopilotChatCommitStaged<cr>', 'Commit Staged' },
        l = { '<cmd>CopilotChatLoad<cr>', 'Load Chat' },
        o = { '<cmd>CopilotChatOptimize<cr>', 'Optimize' },
        r = { '<cmd>CopilotChatReview<cr>', 'Review' },
        s = { '<cmd>CopilotChatSave<cr>', 'Save Chat' },
        t = { '<cmd>CopilotChatTests<cr>', 'Tests' },
    },
    b = {
        name = icons.ui.Bug .. 'Debug',
        b = { '<cmd>DapToggleBreakpoint<cr>', 'Breakpoint' },
        c = { '<cmd>DapContinue<cr>', 'Continue' },
        i = { '<cmd>DapStepInto<cr>', 'Into' },
        l = { "<cmd>lua require'dap'.run_last()<cr>", 'Last' },
        o = { '<cmd>DapStepOver<cr>', 'Over' },
        O = { '<cmd>DapStepOut<cr>', 'Out' },
        r = { '<cmd>DapToggleRepl<cr>', 'Repl' },
        R = { '<cmd>DapRestartFrame<cr>', 'Restart Frame' },
        t = { '<cmd>DapUIToggle<cr>', 'Debugger' },
        x = { '<cmd>DapTerminate<cr>', 'Exit' },
    },
    c = {
        name = icons.ui.Neovim .. 'Code',
        c = { '<cmd>CccHighlighterToggle<cr>', 'Highlight Colors' },
        d = { '<cmd>RootDir<cr>', 'Root Directory' },
        f = { '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format File' },
        F = { '<cmd>retab<cr>', 'Fix Tabs' },
        h = { '<cmd>Hardtime toggle<cr>', 'Hardtime' },
        l = { '<cmd>:g/^\\s*$/d<cr>', 'Clean Empty Lines' },
        m = { '<cmd>MarkdownPreviewToggle<cr>', 'Markdown Preview' },
        n = { '<cmd>Telescope notify<cr>', 'Notifications' },
        o = { '<cmd>Dashboard<cr>', 'Dashboard' },
        p = { '<cmd>CccPick<cr>', 'Pick Color' },
        P = { '<cmd>CccConvert<cr>', 'Convert Color' },
        r = { '<cmd>Telescope reloader<cr>', 'Reload Module' },
        R = { '<cmd>ReloadConfig<cr>', 'Reload Configs' },
        x = { '<cmd>%SnipRun<cr>', 'Run File' },
    },
    d = {
        name = icons.ui.Database .. 'Database',
        b = { '<cmd>DBToggle<cr>', 'DB Explorer' },
        j = { '<cmd>lua require("dbee").next()<cr>', 'DB Next' },
        k = { '<cmd>lua require("dbee").prev()<cr>', 'DB Prev' },
        s = { '<cmd>lua require("dbee").store("csv", "buffer", { extra_arg = 0 })<cr>', 'To CSV' },
        S = { '<cmd>lua require("dbee").store("json", "buffer", { extra_arg = 0 })<cr>', 'To JSON' },
        t = { '<cmd>lua require("dbee").store("table", "buffer", { extra_arg = 0 })<cr>', 'To Table' },
    },
    e = {
        name = icons.ui.Pencil .. 'Edit',
        a = { '<cmd>b#<cr>', 'Alternate File' },
        c = { '<cmd>e $MYVIMRC<cr>', 'Config' },
        d = { '<cmd>lua require("telescope.builtin").find_files({cwd = vim.fn.stdpath("config")})<cr>', 'Config Dir' },
        e = { '<cmd>NvimTreeToggle<cr>', 'Explorer' },
        f = { 'gf', 'File Under Cursor' },
        l = { '<cmd>e ~/.config/shell/local.sh<cr>', 'Local Config' },
        m = { '<cmd>e README.md<cr>', 'Readme' },
        n = { '<cmd>enew<cr>', 'New File' },
        z = { '<cmd>e $ZDOTDIR/.zshrc<cr>', 'Zsh Config' },
    },
    f = {
        name = icons.ui.Telescope .. 'Find',
        a = { '<cmd>lua require("telescope").extensions.menufacture.find_files()<cr>', 'All Files' },
        b = { '<cmd>Telescope buffers<cr>', 'Buffers' },
        c = { '<cmd>Telescope git_bcommits<cr>', 'File Commits' },
        f = { '<cmd>lua require("telescope").extensions.menufacture.git_files()<cr>', 'Find files' },
        g = { '<cmd>lua require("telescope").extensions.menufacture.live_grep()<cr>', 'Find Text' },
        l = { '<cmd>Telescope loclist<cr>', 'Location List' },
        m = { '<cmd>Telescope git_status<cr>', 'Modified files' },
        o = { '<cmd>Telescope live_grep grep_open_files=true<cr>', 'Find in Open Files' },
        p = { '<cmd>Telescope resume<cr>', 'Last Search' },
        q = { '<cmd>Telescope quickfix<cr>', 'Quickfix' },
        r = { '<cmd>Telescope oldfiles<cr>', 'Recent Files' },
        s = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Fuzzy Find in File' },
        t = { '<cmd>Telescope<cr>', 'Panel' },
        u = { '<cmd>Telescope undo<cr>', 'Undo History' },
        w = { '<cmd>lua require("telescope").extensions.menufacture.grep_string()<cr>', 'Find Word' },
    },
    g = {
        name = icons.git.Octoface .. 'Git',
        a = { '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk' },
        A = { '<cmd>Gitsigns stage_buffer<cr>', 'Stage Buffer' },
        b = { "<cmd>lua require('gitsigns').blame_line({full = true})<cr>", 'Blame' },
        c = { '<cmd>Telescope git_commits<cr>', 'Find Commits' },
        C = { '<cmd>CoAuthor<cr>', 'Co-Authors' },
        d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff' },
        f = { '<cmd>Git<cr>', 'Fugitive Panel' },
        g = { '<cmd>Fterm lazygit<cr>', 'Lazygit' },
        i = { '<cmd>Gitsigns preview_hunk<cr>', 'Hunk Info' },
        j = { '<cmd>Gitsigns next_hunk<cr>', 'Next Hunk' },
        k = { '<cmd>Gitsigns prev_hunk<cr>', 'Prev Hunk' },
        l = { '<cmd>Git log<cr>', 'Log' },
        p = { '<cmd>Git pull<cr>', 'Pull' },
        P = { '<cmd>Git push<cr>', 'Push' },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk' },
        R = { '<cmd>Gitsigns reset_buffer<cr>', 'Reset Buffer' },
        s = { '<cmd>Telescope git_branches<cr>', 'Switch Branch' },
        S = { '<cmd>Telescope git_stash<cr>', 'Stashed Changes' },
        t = {
            name = 'Toggle',
            b = { '<cmd>Gitsigns toggle_current_line_blame<cr>', 'Blame' },
            d = { '<cmd>Gitsigns toggle_deleted<cr>', 'Deleted' },
            l = { '<cmd>Gitsigns toggle_linehl<cr>', 'Line HL' },
            n = { '<cmd>Gitsigns toggle_numhl<cr>', 'Number HL' },
            s = { '<cmd>Gitsigns toggle_signs<cr>', 'Signs' },
            w = { '<cmd>Gitsigns toggle_word_diff<cr>', 'Word Diff' },
        },
        u = { '<cmd>Gitsigns undo_stage_hunk<cr>', 'Undo Stage Hunk' },
        v = { '<cmd>Gitsigns select_hunk<cr>', 'Select Hunk' },
    },
    h = {
        name = icons.ui.Question .. 'Help',
        h = { '<cmd>Telescope help_tags<cr>', 'Help Pages' },
        i = { vim.show_pos, 'Inspect Position' },
        k = { '<cmd>Lspsaga hover_doc<cr>', 'Hover Doc' },
        m = { '<cmd>Telescope man_pages<cr>', 'Man Pages' },
    },
    i = {
        name = icons.ui.Download .. 'Insert',
        d = { "<cmd>put =strftime('## %a %d %b %r')<cr>", 'Date' },
        e = { '<cmd>Telescope symbols<cr>', 'Emojis' },
        f = { "<cmd>put =expand('%:t')<cr>", 'File Name' },
        n = { '<cmd>Nerdy<cr>', 'Nerd Glyphs' },
        P = { '<cmd>put %:p<cr>', 'Absolute Path' },
        p = { '<cmd>put %<cr>', 'Relative Path' },
        r = { '<cmd>Telescope registers<cr>', 'Registers' },
        t = { "<cmd>put =strftime('## %r')<cr>", 'Time' },
    },
    j = {
        name = icons.ui.Jump .. 'Jump',
        c = { '*', 'Word' },
        d = { '<cmd>FlashDiagnostics<cr>', 'Diagnostics' },
        f = { '<cmd>Telescope jumplist<cr>', 'Jumplist' },
        h = { '<C-o>', 'Backward' },
        j = { "<cmd>lua require('flash').remote()<cr>", 'Remote' },
        k = { "<cmd>lua require('flash').treesitter()<cr>", 'Treesitter' },
        l = { '<C-i>', 'Forward' },
        n = {
            "<cmd>lua require('flash').jump({search = { forward = true, wrap = false, multi_window = false },})<cr>",
            'Search Forward',
        },
        N = {
            "<cmd>lua require('flash').jump({search = { forward = false, wrap = false, multi_window = false },})<cr>",
            'Search Backward',
        },
        p = { "<cmd>lua require('flash').jump({continue = true})<cr>", 'Previous Jump' },
        s = { "<cmd>lua require('flash').jump()<cr>", 'Search' },
        t = { "<cmd>lua require('flash').treesitter_search()<cr>", 'Remote Treesitter' },
        w = { '<cmd>lua require("flash").jump({ pattern = vim.fn.expand("<cword>")})<cr>', 'Current Word' },
    },
    k = {
        name = icons.ui.Keyboard .. 'Keys',
        c = { '<cmd>Telescope commands<cr>', 'Commands' },
        h = { '<cmd>Telescope command_history<cr>', 'Command History' },
        k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
        s = { '<cmd>Telescope search_history<cr>', 'Search History' },
    },
    l = {
        name = icons.kind.TypeParameter .. 'LSP',
        a = { '<cmd>Lspsaga code_action<cr>', 'Code Action' },
        d = { '<cmd>Lspsaga peek_definition<cr>', 'Peek Definition' },
        f = { '<cmd>Lspsaga finder<cr>', 'Finder' },
        F = { '<cmd>Telescope lsp_references layout_strategy=vertical<cr>', 'References' },
        g = { '<cmd>Lspsaga goto_definition<cr>', 'Goto Definition' },
        h = { '<cmd>Lspsaga hover_doc<cr>', 'Hover' },
        i = { '<cmd>LspInfo<cr>', 'LSP Info' },
        j = { '<cmd>Lspsaga diagnostic_jump_next<cr>', 'Next Diagnostic' },
        k = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', 'Prev Diagnostic' },
        L = { '<cmd>Lspsaga show_workspace_diagnostics<cr>', 'Workspace Diagnostics' },
        l = { '<cmd>Telescope diagnostics layout_strategy=vertical<cr>', 'File Diagnostics' },
        o = { '<cmd>Lspsaga outline<cr>', 'Outline' },
        p = { '<cmd>Telescope lsp_incoming_calls<cr>', 'Incoming Calls' },
        P = { '<cmd>Telescope lsp_outgoing_calls<cr>', 'Outgoing Calls' },
        q = { '<cmd>LspStop<cr>', 'Stop LSP' },
        Q = { '<cmd>LspRestart<cr>', 'Restart LSP' },
        R = { '<cmd>Lspsaga project_replace<cr>', 'Replace' },
        r = { '<cmd>Lspsaga rename<cr>', 'Rename' },
        s = { '<cmd>Telescope lsp_document_symbols theme=get_ivy<cr>', 'Document Symbols' },
        S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
        T = { '<cmd>Lspsaga goto_type_definition<cr>', 'Goto Type Definition' },
        t = { '<cmd>Lspsaga peek_type_definition<cr>', 'Peek Type Definition' },
    },
    m = {
        name = icons.ui.Bookmark .. 'Marks',
        b = { "<cmd>lua require('telescope').extensions.marks_nvim.bookmarks_list_all()<cr>", 'Bookmarks' },
        d = { "<cmd>lua require('marks').delete_line()<cr>", 'Delete Line' },
        D = { "<cmd>lua require('marks').delete_buf()<cr>", 'Delete Buffer' },
        h = { "<cmd>lua require('marks').next_bookmark()<cr>", 'Next Bookmark' },
        j = { "<cmd>lua require('marks').next()<cr>", 'Next' },
        k = { "<cmd>lua require('marks').prev()<cr>", 'Previous' },
        l = { "<cmd>lua require('marks').prev_bookmark()<cr>", 'Previous Bookmark' },
        m = { '<cmd>Telescope marks<cr>', 'All Marks' },
        P = { "<cmd>lua require('marks').preview()<cr>", 'Preview' },
        s = { "<cmd>lua require('marks').set_next()<cr>", 'Set Next' },
        t = { "<cmd>lua require('marks').toggle()<cr>", 'Toggle' },
        x = { "<cmd>lua require('marks').delete_bookmark()<cr>", 'Delete Bookmark' },

        ['1'] = { "<cmd>lua require('marks').toggle_bookmark1()<cr>", 'Toggle Bookmark 0' },
        ['2'] = { "<cmd>lua require('marks').toggle_bookmark2()<cr>", 'Toggle Bookmark 2' },
        ['3'] = { "<cmd>lua require('marks').toggle_bookmark3()<cr>", 'Toggle Bookmark 3' },
        ['4'] = { "<cmd>lua require('marks').toggle_bookmark4()<cr>", 'Toggle Bookmark 4' },

        n = {
            name = 'Next Bookmark Group',
            ['1'] = { "<cmd>lua require('marks').next_bookmark1()<cr>", 'Next Bookmark 1' },
            ['2'] = { "<cmd>lua require('marks').next_bookmark2()<cr>", 'Next Bookmark 2' },
            ['3'] = { "<cmd>lua require('marks').next_bookmark3()<cr>", 'Next Bookmark 3' },
            ['4'] = { "<cmd>lua require('marks').next_bookmark4()<cr>", 'Next Bookmark 4' },
        },

        p = {
            name = 'Previous Bookmark Group',
            ['1'] = { "<cmd>lua require('marks').prev_bookmark1()<cr>", 'Previous Bookmark 1' },
            ['2'] = { "<cmd>lua require('marks').prev_bookmark2()<cr>", 'Previous Bookmark 2' },
            ['3'] = { "<cmd>lua require('marks').prev_bookmark3()<cr>", 'Previous Bookmark 3' },
            ['4'] = { "<cmd>lua require('marks').prev_bookmark4()<cr>", 'Previous Bookmark 4' },
        },
    },
    n = {
        name = icons.ui.Note .. 'Notes',
        d = { '<cmd>Tdo<cr>', "Today's Todo" },
        e = { '<cmd>TdoEntry<cr>', "Today's Entry" },
        f = { '<cmd>TdoFiles<cr>', 'All Notes' },
        g = { '<cmd>TdoFind<cr>', 'Find Notes' },
        h = { '<cmd>Tdo -1<cr>', "Yesterday's Todo" },
        l = { '<cmd>Tdo 1<cr>', "Tomorrow's Todo" },
        n = { '<cmd>TdoNote<cr>', 'New Note' },
        s = {
            '<cmd>lua require("tdo").run_with("commit " .. vim.fn.expand("%:p")) vim.notify("Committed!")<cr>',
            'Commit Note',
        },
        t = { '<cmd>TdoTodos<cr>', 'Incomplete Todos' },
        x = { '<cmd>TdoToggle<cr>', 'Toggle Todo' },
    },
    o = {
        name = icons.ui.Gear .. 'Options',
        c = { '<cmd>Telescope colorscheme<cr>', 'Colorscheme' },
        h = { '<cmd>Telescope highlights<cr>', 'Highlight Colors' },
        n = { '<cmd>set relativenumber!<cr>', 'Relative Numbers' },
        o = { '<cmd>Telescope vim_options<cr>', 'All Options' },
    },
    p = {
        name = icons.ui.Package .. 'Packages',
        c = { '<cmd>Lazy check<cr>', 'Check' },
        d = { '<cmd>Lazy debug<cr>', 'Debug' },
        i = { '<cmd>Lazy install<cr>', 'Install' },
        l = { '<cmd>Lazy log<cr>', 'Log' },
        m = { '<cmd>Mason<cr>', 'Mason' },
        P = { '<cmd>Lazy profile<cr>', 'Profile' },
        p = { '<cmd>Lazy<cr>', 'Plugins' },
        r = { '<cmd>Lazy restore<cr>', 'Restore' },
        s = { '<cmd>Lazy sync<cr>', 'Sync' },
        u = { '<cmd>Lazy update<cr>', 'Update' },
        x = { '<cmd>Lazy clean<cr>', 'Clean' },
    },
    q = {
        name = icons.ui.Close .. 'Quit',
        a = { '<cmd>qall<cr>', 'Quit All' },
        b = { '<cmd>bw<cr>', 'Close Buffer' },
        d = { '<cmd>bdelete<cr>', 'Delete Buffer' },
        f = { '<cmd>qall!<cr>', 'Force Quit' },
        q = { '<cmd>q<cr>', 'Quit' },
        w = { '<cmd>wq<cr>', 'Write and Quit' },
    },
    r = {
        name = icons.ui.Code .. 'Refactor',
        b = { "<cmd>lua require('spectre').open_file_search()<cr>", 'Replace Buffer' },
        d = { '', 'Go To Definition' },
        e = { "<cmd>lua require('refactoring').refactor('Extract Block')<CR>", 'Extract Block' },
        f = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", 'Extract To File' },
        h = { '', 'List Definition Head' },
        i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
        j = { '', 'Next Usage' },
        k = { '', 'Previous Usage' },
        l = { '', 'List Definition' },
        n = { '', 'Swap Next' },
        p = { '', 'Swap Previous' },
        R = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
        r = { '', 'Smart Rename' },
        S = { "<cmd>lua require('spectre').open()<cr>", 'Replace' },
        s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Replace Word' },
        v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", 'Replace Word' },
    },
    s = {
        name = icons.ui.Windows .. 'Split',
        ['`'] = { '<C-w>p', 'Previous Window' },
        ['-'] = { '<C-w>s', 'Split Below' },
        ['\\'] = { '<C-w>v', 'Split Right' },
        a = { '<cmd>vsplit<cr>', 'Vertical Split' },
        c = { '<cmd>tabclose<cr>', 'Close Tab' },
        d = { '<C-w>c', 'Close Window' },
        f = { '<cmd>tabfirst<cr>', 'First Tab' },
        h = { '<C-w>h', 'Move Left' },
        j = { '<C-w>j', 'Move Down' },
        k = { '<C-w>k', 'Move Up' },
        l = { '<C-w>l', 'Move Right' },
        p = { '<cmd>NavigatorPrevious<cr>', 'Previous Pane' },
        s = { '<cmd>split<cr>', 'Horizontal Split' },
    },
    t = {
        name = icons.ui.Terminal .. 'Terminal',
        ['`'] = { '<cmd>Sterm<cr>', 'Horizontal Terminal' },
        c = { '<cmd>Sterm bundle exec rails console<cr>', 'Rails Console' },
        n = { '<cmd>Sterm node<cr>', 'Node' },
        p = { '<cmd>Sterm bpython<cr>', 'Python' },
        r = { '<cmd>Sterm irb<cr>', 'Ruby' },
        s = { '<cmd>Sterm<cr>', 'Horizontal Terminal' },
        t = { '<cmd>Fterm<cr>', 'Terminal' },
        v = { '<cmd>Vterm<cr>', 'Vertical Terminal' },
    },
    u = {
        name = icons.ui.Test .. 'Test',
        F = { '<cmd>lua require("neotest").run.run()<cr>', 'Run Current Test' },
        f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', 'Run Test' },
        o = { '<cmd>Neotest output-panel<cr>', 'Test Output' },
        O = { '<cmd>Neotest summary<cr>', 'Test Summary' },
    },
    v = {
        name = icons.ui.Star .. 'Select',
        B = { 'vab', 'Around Bracket' },
        b = { 'vib', 'Bracket' },
        P = { 'vap', 'Around Para' },
        p = { 'vip', 'Paragraph' },
        Q = { 'vaq', 'Around Quote' },
        q = { 'viq', 'Quote' },
    },
    w = {
        name = icons.kind.File .. 'Writing',
        c = { '<cmd>set spell!<cr>', 'Spellcheck' },
        f = { "<cmd>lua require'utils'.sudo_write()<cr>", 'Force Write' },
        j = { ']s', 'Next Misspell' },
        k = { '[s', 'Prev Misspell' },
        q = { '<cmd>wq<cr>', 'Write and Quit' },
        s = { '<cmd>Telescope spell_suggest<cr>', 'Suggestions' },
        t = { '<cmd>Twilight<cr>', 'Twilight' },
        w = { '<cmd>w<cr>', 'Write and Quit' },
        z = { '<cmd>ZenMode<cr>', 'ZenMode' },
    },
    x = { '<cmd>x<cr>', icons.ui.SignOut .. 'Save and Quit' },
    y = {
        name = icons.ui.Clipboard .. 'Yank',
        a = { '<cmd>%y+<cr>', 'Copy Whole File' },
        f = { '<cmd>CopyFileName<cr>', 'File Name' },
        g = { '<cmd>lua require"gitlinker".get_buf_range_url()<cr>', 'Copy Git URL' },
        P = { '<cmd>CopyAbsolutePath<cr>', 'Absolute Path' },
        p = { '<cmd>CopyRelativePath<cr>', 'Relative Path' },
    },
}

local vopts = {
    mode = 'v',
    prefix = '<leader>',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

local vmappings = {
    a = {
        name = icons.ui.Copilot .. 'AI',
        c = { '<cmd>CopilotChatToggle<cr>', 'Copilot Chat' },
        d = { '<cmd>CopilotChatDocs<cr>', 'Docs' },
        e = { '<cmd>CopilotChatExplain<cr>', 'Explain' },
        f = { '<cmd>CopilotChatFix<cr>', 'Fix' },
        F = { '<cmd>CopilotChatFixDiagnostic<cr>', 'Fix Diagnostic' },
        g = { '<cmd>CopilotChatCommit<cr>', 'Commit' },
        G = { '<cmd>CopilotChatCommitStaged<cr>', 'Commit Staged' },
        o = { '<cmd>CopilotChatOptimize<cr>', 'Optimize' },
        r = { '<cmd>CopilotChatReview<cr>', 'Review' },
        t = { '<cmd>CopilotChatTests<cr>', 'Tests' },
    },
    c = {
        name = icons.ui.Neovim .. 'Code',
        i = { ':sort i<cr>', 'Sort Case Insensitive' },
        S = { ':sort!<cr>', 'Sort Desc' },
        s = { ':sort<cr>', 'Sort Asc' },
        u = { ':!uniq<cr>', 'Unique' },
        x = { "<esc><cmd>'<,'>SnipRun<cr>", 'Run Code' },
    },
    g = {
        name = icons.git.Octoface .. 'Git',
        a = { '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk' },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk' },
    },
    j = {
        name = icons.ui.Jump .. 'Jump',
        d = { '<cmd>FlashDiagnostics<cr>', 'Diagnostics' },
        j = { "<cmd>lua require('flash').remote()<cr>", 'Remote' },
        k = { "<cmd>lua require('flash').treesitter()<cr>", 'Treesitter' },
        n = {
            "<cmd>lua require('flash').jump({search = { forward = true, wrap = false, multi_window = false },})<cr>",
            'Search Forward',
        },
        N = {
            "<cmd>lua require('flash').jump({search = { forward = false, wrap = false, multi_window = false },})<cr>",
            'Search Backward',
        },
        p = { "<cmd>lua require('flash').jump({continue = true})<cr>", 'Previous Jump' },
        s = { "<cmd>lua require('flash').jump()<cr>", 'Search' },
        t = { "<cmd>lua require('flash').treesitter_search()<cr>", 'Remote Treesitter' },
        w = { '<cmd>lua require("flash").jump({ pattern = vim.fn.expand("<cword>")})<cr>', 'Current Word' },
    },
    l = {
        name = icons.kind.TypeParameter .. 'LSP',
        a = '<cmd><C-U>Lspsaga range_code_action<CR>',
    },
    r = {
        name = icons.ui.Code .. 'Refactor',
        r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
        e = { "<esc><cmd>lua require('refactoring').refactor('Extract Function')<CR>", 'Extract Function' },
        f = { "<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", 'Extract To File' },
        v = { "<esc><cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
        i = { "<esc><cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
    },
    y = {
        name = icons.ui.Clipboard .. 'Yank',
        g = { '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>', 'Copy Git URL' },
    },
}

local no_leader_opts = {
    mode = 'n',
    prefix = '',
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = true,
}

local no_leader_mappings = {
    K = { '<cmd>Lspsaga hover_doc<cr>', 'LSP Hover' },
    Q = { '<cmd>qall!<cr>', 'Force Quit!' },
    U = { '<cmd>redo<cr>', 'Redo' },

    ['<S-h>'] = { '<cmd>bprevious<cr>', 'Previous Buffer' },
    ['<S-l>'] = { '<cmd>bnext<cr>', 'Next Buffer' },

    ['<C-f>'] = { '<cmd>Telescope find_files<cr>', 'Find Files' },
    ['<C-g>'] = { '<cmd>Fterm lazygit<cr>', 'Lazygit' },

    ['<C-h>'] = { '<C-w>h', 'Move Left' },
    ['<C-j>'] = { '<C-w>j', 'Move Down' },
    ['<C-k>'] = { '<C-w>k', 'Move Up' },
    ['<C-l>'] = { '<C-w>l', 'Move Right' },
    ['<C-\\>'] = { '<C-w>p', 'Previous Pane' },

    ['<C-Up>'] = { '<cmd>resize +10<cr>', 'Increase window height' },
    ['<C-Down>'] = { '<cmd>resize -10<cr>', 'Decrease window height' },
    ['<C-Left>'] = { '<cmd>vertical resize -10<cr>', 'Decrease window width' },
    ['<C-Right>'] = { '<cmd>vertical resize +10<cr>', 'Increase window width' },

    ['['] = {
        name = icons.ui.ArrowLeft .. 'Previous',
        b = { '<cmd>bprevious<cr>', 'Buffer' },
        B = { '<cmd>bfirst<cr>', 'First Buffer' },
        d = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', 'Diagnostic' },
        e = { 'g;', 'Edit' },
        g = { '<cmd>Gitsigns prev_hunk<cr>', 'Git Hunk' },
        j = { '<C-o>', 'Jump' },
    },
    [']'] = {
        name = icons.ui.ArrowRight .. 'Next',
        b = { '<cmd>bnext<cr>', 'Buffer' },
        B = { '<cmd>blast<cr>', 'Buffer' },
        d = { '<cmd>Lspsaga diagnostic_jump_next<cr>', 'Diagnostic' },
        e = { 'g,', 'Edit' },
        g = { '<cmd>Gitsigns next_hunk<cr>', 'Git Hunk' },
        j = { '<C-i>', 'Jump' },
    },
}

if vim.fn.exists('$TMUX') == 1 then
    local tmux_mappings = {
        ['<C-h>'] = { '<cmd>NavigatorLeft<cr>', 'Move Left' },
        ['<C-j>'] = { '<cmd>NavigatorDown<cr>', 'Move Down' },
        ['<C-k>'] = { '<cmd>NavigatorUp<cr>', 'Move Up' },
        ['<C-l>'] = { '<cmd>NavigatorRight<cr>', 'Move Right' },
        ['<C-\\>'] = { '<cmd>NavigatorPrevious<cr>', 'Previous Pane' },
    }
    no_leader_mappings = vim.tbl_extend('force', no_leader_mappings, tmux_mappings)
end

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(no_leader_mappings, no_leader_opts)
which_key.register({ mode = { 'o', 'x' }, i = i, a = a })
