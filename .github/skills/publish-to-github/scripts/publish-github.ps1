param(
    [string]$ServiceDirectory,
    [string]$RepoUrl,
    [string]$ServiceName
)

cd $ServiceDirectory

git init
git config user.name "Bot"
git config user.email "bot@automated.dev"

git add .

git commit -m "Initial commit: $ServiceName microservice"

git remote add origin $RepoUrl
git branch -M main
git push -u origin main