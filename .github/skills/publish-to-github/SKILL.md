---
name: publish-to-github
description: "Publish generated code to GitHub"
---

## Purpose
Create a repository and publish the code following the exact requested flow.

## Required flow (strict)

1. Call `mcp_github_create_repository` with:
   - owner
   - repo
   - private
   - description

   Save the returned repository URL.

2. Execute script in "../publish-to-github/scripts/publish-github.ps1" with parameters:
   - ServiceDirectory: path to the generated service code
   - RepoUrl: URL of the created GitHub repository
   - ServiceName: name of the microservice (for commit message)

3. Verify using `mcp_github_get_file_contents` if needed.

## Notes

- If the repository already exists, retry with a suffix:
  - `-v2`
  - `-service`
  - `-api`