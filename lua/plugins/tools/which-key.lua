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
    e = { '<cmd>NvimTreeToggle<cr>', icons.documents.OpenFolder .. 'Explorer' },
    q = { '<cmd>q<cr>', icons.ui.Close .. 'Quit' },
    w = { '<cmd>w<cr>', icons.ui.Save .. 'Save' },
    x = { '<cmd>x<cr>', icons.ui.Pencil .. 'Write and Quit' },
    a = {
        name = icons.kind.Field .. 'Actions',
        d = { '<cmd>bdelete<cr>', 'Close Buffer' },
        c = { '<cmd>CccHighlighterToggle<cr>', 'Highlight Colors' },
        h = { '<cmd>Hardtime toggle<cr>', 'Hardtime' },
        m = { '<cmd>MarkdownPreviewToggle<cr>', 'Markdown Preview' },
        q = { '<cmd>qa!<cr>', icons.ui.Power .. 'Force Quit!' },
        r = { '<cmd>%SnipRun<cr>', 'Run File' },
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
        name = icons.ui.NeoVim .. 'Config',
        c = { '<cmd>CopilotChatToggle<cr>', 'Copilot Chat' },
        C = { '<cmd>CccConvert<cr>', 'Convert Color' },
        d = { '<cmd>RootDir<cr>', 'Root Directory' },
        f = { '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format File' },
        F = { '<cmd>retab<cr>', 'Fix Tabs' },
        l = { '<cmd>:g/^\\s*$/d<cr>', 'Clean Empty Lines' },
        n = { '<cmd>set relativenumber!<cr>', 'Relative Numbers' },
        p = { '<cmd>CccPick<cr>', 'Pick Color' },
        r = { '<cmd>Telescope reloader<cr>', 'Reload Module' },
        R = { '<cmd>ReloadConfig<cr>', 'Reload Configs' },
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
    f = {
        name = icons.ui.Telescope .. 'Find',
        a = { '<cmd>lua require("telescope").extensions.menufacture.find_files()<cr>', 'All Files' },
        b = { '<cmd>Telescope buffers<cr>', 'Buffers' },
        c = { '<cmd>Telescope git_bcommits<cr>', 'File Commits' },
        f = { '<cmd>lua require("telescope").extensions.menufacture.git_files()<cr>', 'Find files' },
        g = { '<cmd>lua require("telescope").extensions.menufacture.live_grep()<cr>', 'Find Text' },
        l = { '<cmd>Telescope loclist<cr>', 'Location List' },
        r = { '<cmd>Telescope oldfiles<cr>', 'Recent Files' },
        p = { '<cmd>Telescope resume<cr>', 'Last Search' },
        q = { '<cmd>Telescope quickfix<cr>', 'Quickfix' },
        s = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Fuzzy Find in File' },
        S = { '<cmd>Telescope live_grep grep_open_files=true<cr>', 'Find in Open Files' },
        t = { '<cmd>Telescope<cr>', 'Panel' },
        u = { '<cmd>Telescope undo<cr>', 'Undo History' },
        w = { '<cmd>lua require("telescope").extensions.menufacture.grep_string()<cr>', 'Find Word' },
    },
    g = {
        name = icons.git.Octoface .. 'Git',
        a = { '<cmd>Gitsigns stage_hunk<cr>', 'Stage Hunk' },
        A = { '<cmd>Gitsigns stage_buffer<cr>', 'Stage Buffer' },
        b = { '<cmd>Gitsigns blame_line<cr>', 'Blame' },
        B = { '<cmd>Telescope git_branches<cr>', 'Branches' },
        c = { '<cmd>Telescope git_commits<cr>', 'Commits' },
        C = { '<cmd>CoAuthor<cr>', 'Co-Authors' },
        f = { '<cmd>Git<cr>', 'Fugitive' },
        d = { '<cmd>Gitsigns preview_hunk<cr>', 'Preview Hunk' },
        D = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff' },
        g = { '<cmd>Fterm lazygit<cr>', 'Lazygit' },
        j = { '<cmd>Gitsigns next_hunk<cr>', 'Next Hunk' },
        k = { '<cmd>Gitsigns prev_hunk<cr>', 'Prev Hunk' },
        l = { '<cmd>Git pull<cr>', 'Pull' },
        p = { '<cmd>Git push<cr>', 'Push' },
        r = { '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk' },
        R = { '<cmd>Gitsigns reset_buffer<cr>', 'Reset Buffer' },
        s = { '<cmd>Telescope git_status<cr>', 'Changed files' },
        S = { '<cmd>Telescope git_stash<cr>', 'Stashed Changes' },
        t = {
            name = 'Git Toggle',
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
        h = { '<cmd>Telescope help_tags<cr>', 'Help' },
        i = { vim.show_pos, 'Inspect Position' },
        m = { '<cmd>Telescope man_pages<cr>', 'Man Pages' },
        n = { '<cmd>Telescope notify<cr>', 'Notifications' },
    },
    i = {
        name = icons.ui.Pencil .. 'Insert',
        d = { "<cmd>put =strftime('## %a %d %b %r')<cr>", 'Date' },
        e = { '<cmd>Telescope symbols<cr>', 'Emojis' },
        f = { "<cmd>put =expand('%:t')<cr>", 'File Name' },
        n = { '<cmd>Nerdy<cr>', 'Nerd Glyphs' },
        p = { '<cmd>put %<cr>', 'Relative Path' },
        P = { '<cmd>put %:p<cr>', 'Absolute Path' },
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
        name = icons.ui.Telescope .. 'Keys',
        k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
        c = { '<cmd>Telescope commands<cr>', 'Commands' },
        h = { '<cmd>Telescope command_history<cr>', 'Command History' },
    },
    l = {
        name = icons.ui.Gear .. 'LSP',
        a = { '<cmd>Lspsaga code_action<cr>', 'Code Action' },
        d = { '<cmd>Lspsaga peek_definition<cr>', 'Peek Definition' },
        f = { '<cmd>Lspsaga finder<cr>', 'Finder' },
        F = { '<cmd>Telescope lsp_references layout_strategy=vertical<cr>', 'References' },
        g = { '<cmd>Lspsaga goto_definition<cr>', 'Goto Definition' },
        h = { '<cmd>Lspsaga hover_doc<cr>', 'Hover' },
        i = { '<cmd>LspInfo<cr>', 'LSP Info' },
        j = { '<cmd>Lspsaga diagnostic_jump_next<cr>', 'Next Diagnostic' },
        k = { '<cmd>Lspsaga diagnostic_jump_prev<cr>', 'Prev Diagnostic' },
        l = { '<cmd>Telescope diagnostics layout_strategy=vertical<cr>', 'File Diagnostics' },
        L = { '<cmd>Lspsaga show_workspace_diagnostics<cr>', 'Workspace Diagnostics' },
        o = { '<cmd>Lspsaga outline<cr>', 'Outline' },
        p = { '<cmd>Telescope lsp_incoming_calls<cr>', 'Incoming Calls' },
        P = { '<cmd>Telescope lsp_outgoing_calls<cr>', 'Outgoing Calls' },
        r = { '<cmd>Lspsaga rename<cr>', 'Rename' },
        R = { '<cmd>Lspsaga project_replace<cr>', 'Replace' },
        s = { '<cmd>Telescope lsp_document_symbols theme=get_ivy<cr>', 'Document Symbols' },
        S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
        t = { '<cmd>Lspsaga peek_type_definition<cr>', 'Peek Type Definition' },
        T = { '<cmd>Lspsaga goto_type_definition<cr>', 'Goto Type Definition' },
    },
    m = {
        name = icons.ui.Bookmark .. 'Marks',
        m = { '<cmd>Telescope marks<cr>', 'All Marks' },
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
        name = icons.ui.SignOut .. 'Open',
        c = { '<cmd>e $MYVIMRC<cr>', 'Config' },
        d = { '<cmd>Dashboard<cr>', 'Dashboard' },
        n = { '<cmd>enew<cr>', 'New File' },
        o = { '<cmd>b#<cr>', icons.ui.History .. 'Other File' },
    },
    p = {
        name = icons.ui.Package .. 'Packages',
        c = { '<cmd>Lazy check<cr>', 'Check' },
        d = { '<cmd>Lazy debug<cr>', 'Debug' },
        p = { '<cmd>Lazy<cr>', 'Plugins' },
        P = { '<cmd>Lazy profile<cr>', 'Profile' },
        m = { '<cmd>Mason<cr>', 'Mason' },
        i = { '<cmd>Lazy install<cr>', 'Install' },
        l = { '<cmd>Lazy log<cr>', 'Log' },
        r = { '<cmd>Lazy restore<cr>', 'Restore' },
        s = { '<cmd>Lazy sync<cr>', 'Sync' },
        u = { '<cmd>Lazy update<cr>', 'Update' },
        x = { '<cmd>Lazy clean<cr>', 'Clean' },
    },
    r = {
        name = icons.diagnostics.Hint .. 'Refactor',
        b = { "<cmd>lua require('spectre').open_file_search()<cr>", 'Replace Buffer' },
        e = { "<cmd>lua require('refactoring').refactor('Extract Block')<CR>", 'Extract Block' },
        f = { "<cmd>lua require('refactoring').refactor('Extract Block To File')<CR>", 'Extract To File' },
        i = { "<cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
        n = { '', 'Swap Next' },
        p = { '', 'Swap Previous' },
        r = { '', 'Smart Rename' },
        d = { '', 'Go To Definition' },
        h = { '', 'List Definition Head' },
        l = { '', 'List Definition' },
        j = { '', 'Next Usage' },
        k = { '', 'Previous Usage' },
        R = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
        S = { "<cmd>lua require('spectre').open()<cr>", 'Replace' },
        s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], 'Replace Word' },
        v = { "<cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
        w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", 'Replace Word' },
    },
    s = {
        name = icons.ui.Windows .. 'Split',
        [','] = { '<cmd>NavigatorPrevious<cr>', 'Previous Split' },
        ['-'] = { '<C-w>s', 'Split Below' },
        ['\\'] = { '<C-w>v', 'Split Right' },
        c = { '<cmd>tabclose<cr>', 'Close Tab' },
        d = { '<C-w>c', 'Close Window' },
        f = { '<cmd>tabfirst<cr>', 'First Tab' },
        h = { '<C-w>h', 'Move Left' },
        j = { '<C-w>j', 'Move Down' },
        k = { '<C-w>k', 'Move Up' },
        l = { '<C-w>l', 'Move Right' },
        L = { '<cmd>tablast<cr>', 'Last Tab' },
        o = { '<cmd>tabnext<cr>', 'Next Tab' },
        O = { '<cmd>tabprevious<cr>', 'Previous Tab' },
        p = { '<C-w>p', 'Previous Window' },
        q = { '<cmd>bw<cr>', 'Close Current Buf' },
        s = { '<cmd>split<cr>', 'Horizontal Split File' },
        t = { '<cmd>tabnew<cr>', 'New Tab' },
        v = { '<cmd>vsplit<cr>', 'Vertical Split File' },
        W = { "<cmd>lua require'utils'.sudo_write()<cr>", 'Force Write' },
        w = { '<cmd>w<cr>', 'Write' },
        x = { '<cmd>x<cr>', 'Write and Quit' },
    },
    t = {
        name = icons.ui.Terminal .. 'Terminal',
        ['`'] = { '<cmd>Sterm<cr>', 'Horizontal Terminal' },
        n = { '<cmd>Sterm node<cr>', 'Node' },
        p = { '<cmd>Sterm bpython<cr>', 'Python' },
        r = { '<cmd>Sterm irb<cr>', 'Ruby' },
        s = { '<cmd>Sterm<cr>', 'Horizontal Terminal' },
        t = { '<cmd>Fterm<cr>', 'Terminal' },
        v = { '<cmd>Vterm<cr>', 'Vertical Terminal' },
    },
    u = {
        name = icons.ui.Test .. 'Test',
        f = { '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', 'Run Test' },
        F = { '<cmd>lua require("neotest").run.run()<cr>', 'Run Current Test' },
        o = { '<cmd>Neotest output-panel<cr>', 'Test Output' },
        O = { '<cmd>Neotest summary<cr>', 'Test Summary' },
    },
    v = {
        name = icons.ui.Clipboard .. 'Visual',
        p = { 'vip', 'Paragraph' },
        P = { 'vap', 'Around Para' },
        q = { 'viq', 'Quote' },
        Q = { 'vaq', 'Around Quote' },
        b = { 'vib', 'Bracket' },
        B = { 'vab', 'Around Bracket' },
    },
    y = {
        name = icons.ui.Clipboard .. 'Yank',
        a = { '<cmd>%y+<cr>', 'Copy Whole File' },
        f = { '<cmd>CopyFileName<cr>', 'File Name' },
        p = { '<cmd>CopyRelativePath<cr>', 'Relative Path' },
        P = { '<cmd>CopyAbsolutePath<cr>', 'Absolute Path' },
        g = { '<cmd>lua require"gitlinker".get_buf_range_url()<cr>', 'Copy Git URL' },
    },
    z = {
        name = icons.ui.Clipboard .. 'Writing',
        j = { '[s', 'Next Misspell' },
        k = { ']s', 'Prev Misspell' },
        c = { '<cmd>set spell!<cr>', 'Spellcheck' },
        s = { '<cmd>Telescope spell_suggest<cr>', 'Suggestions' },
        t = { '<cmd>Twilight<cr>', 'Twilight' },
        z = { '<cmd>ZenMode<cr>', 'ZenMode' },
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
        name = icons.kind.Field .. 'Actions',
        -- Sort lines
        s = { "<cmd>'<, '>%sort<cr>", 'Sort Asc' },
        S = { "<cmd>'<, '>%sort!<cr>", 'Sort Desc' },
    },
    c = {
        c = { '<cmd>CopilotChatToggle<cr>', 'Copilot Chat' },
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
        name = icons.ui.Gear .. 'LSP',
        a = '<cmd><C-U>Lspsaga range_code_action<CR>',
    },
    r = {
        name = icons.diagnostics.Hint .. 'Refactor',
        r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", 'Refactor Commands' },
        e = { "<esc><cmd>lua require('refactoring').refactor('Extract Function')<CR>", 'Extract Function' },
        f = { "<esc><cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", 'Extract To File' },
        v = { "<esc><cmd>lua require('refactoring').refactor('Extract Variable')<CR>", 'Extract Variable' },
        i = { "<esc><cmd>lua require('refactoring').refactor('Inline Variable')<CR>", 'Inline Variable' },
    },
    s = { "<esc><cmd>'<,'>SnipRun<cr>", icons.ui.Play .. 'Run Code' },
    q = { '<cmd>q<cr>', icons.ui.Close .. 'Quit' },
    Q = { '<cmd>qa!<cr>', icons.ui.Power .. 'Force Quit!' },
    x = { '<cmd>x<cr>', icons.ui.Pencil .. 'Write and Quit' },
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
    ['<S-h>'] = { '<cmd>bprevious<cr>', 'Previous Buffer' },
    ['<S-l>'] = { '<cmd>bnext<cr>', 'Next Buffer' },

    ['<C-h>'] = { '<C-w>h', 'Move Left' },
    ['<C-j>'] = { '<C-w>j', 'Move Down' },
    ['<C-k>'] = { '<C-w>k', 'Move Up' },
    ['<C-l>'] = { '<C-w>l', 'Move Right' },

    ['<C-Up>'] = { '<cmd>resize +10<cr>', 'Increase window height' },
    ['<C-Down>'] = { '<cmd>resize -10<cr>', 'Decrease window height' },
    ['<C-Left>'] = { '<cmd>vertical resize -10<cr>', 'Decrease window width' },
    ['<C-Right>'] = { '<cmd>vertical resize +10<cr>', 'Increase window width' },

    ['<C-f>'] = { '<cmd>Telescope find_files<cr>', 'Find Files' },
    ['<C-g>'] = { '<cmd>Fterm lazygit<cr>', 'Lazygit' },

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

    K = { '<cmd>Lspsaga hover_doc<cr>', 'LSP Hover' },
    U = { '<cmd>redo<cr>', 'Redo' },
}

if vim.fn.exists('$TMUX') == 1 then
    local tmux_mappings = {
        ['<C-h>'] = { '<cmd>NavigatorLeft<cr>', 'Move Left' },
        ['<C-j>'] = { '<cmd>NavigatorDown<cr>', 'Move Down' },
        ['<C-k>'] = { '<cmd>NavigatorUp<cr>', 'Move Up' },
        ['<C-l>'] = { '<cmd>NavigatorRight<cr>', 'Move Right' },
        ['<C-m>'] = { '<cmd>NavigatorPrevious<cr>', 'Goto Previous' },
    }
    no_leader_mappings = vim.tbl_extend('force', no_leader_mappings, tmux_mappings)
end

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(no_leader_mappings, no_leader_opts)
which_key.register({ mode = { 'o', 'x' }, i = i, a = a })
