Deploy a [DigitalOcean App Platform](https://www.digitalocean.com/products/app-platform/) app using GitHub Actions.

## Example

Create a `.github/workflows/main.yml` with the following contents:

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
