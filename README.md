Deploy a [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform/) app using GitHub Actions.

 - Auto-deploy your app from source on commit, while allowing you to run tests or perform other operations before.
 - Auto-sync your in-repo `.do/app.yaml` on commit.

## Example

https://github.com/snormore/sample-golang/tree/action

Add your `.do/app.yaml`:

**Note that you should not configure `deploy_on_push: true` for this workflow.**

```yaml
name: sample-golang
services:
- name: web
  git:
    repo_clone_url: https://github.com/snormore/sample-golang.git
    branch: main
```

Create a `.github/workflows/main.yml`:

```yaml
on:
  push:
    branches:
      - action
jobs:
  deploy:
    runs-on: ubuntu-latest
    name: Deploy App
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Deploy app
      id: deploy
      uses: snormore/doctl-app-deploy-action@main
      env:
        DIGITALOCEAN_ACCESS_TOKEN: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}
```
