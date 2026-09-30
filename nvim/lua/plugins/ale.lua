return {
  "dense-analysis/ale",
  config = function()
    local g = vim.g

    -- ALE ships a haml-lint linter but no fixer, so register one.
    -- haml-lint prints the corrected source to stdout when using --stdin + --stderr.
    vim.cmd([[
      function! HamlLintFix(buffer) abort
        return {
        \ 'command': 'haml-lint --auto-correct-only --stderr --stdin %s',
        \}
      endfunction
    ]])
    vim.fn["ale#fix#registry#Add"]("hamllint", "HamlLintFix", { "haml" }, "Fix HAML files with haml-lint --auto-correct")

    g.ale_fix_on_save = 1
    g.ale_linters_explicit = 1
    g.ale_linters = {
      haml = { "hamllint" },
    }
    g.ale_fixers = {
      haml = { "hamllint" },
    }
  end,
}
