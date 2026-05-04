return {
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    init_options = {
        clangdFileStatus = true,
    },
}
