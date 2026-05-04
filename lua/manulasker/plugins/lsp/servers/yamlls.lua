return {
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
            },
            validate = true,
            hover = true,
            completion = true,
        },
    },
}
