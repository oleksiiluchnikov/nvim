return {

    require("formatter.filetypes.lua").stylua,
    function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
            return nil
        end

        return {
            exe = "stylua",
            args = {
                "--search-parent-directories",
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--",
                "-",
            },
            stdin = true,
        }
    end,
}
