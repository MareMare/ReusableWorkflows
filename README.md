# ReusableWorkflows
A repository of reusable workflows for personal use.

個人的に使用する再利用可能なワークフローのリポジトリです。

## `ci.net6.yml`
.NET6 Build & UnitTests のための再利用可能なワークフローです。

<details>
<summary>呼び出し例:</summary>
<div>

```yml
jobs:
  dotnet-build-test:
    strategy:
      fail-fast: false
      matrix:
        include:
          - os: ubuntu-latest
            osName: Linux
          - os: windows-latest
            osName: Windows
    name: Test on ${{ matrix.osName }}
    permissions:
      contents: read
    uses: MareMare/ReusableWorkflows/.github/workflows/ci.net6.yml@main
    with:
      runner-os: ${{ matrix.os }}
      working-directory: src
      testing-directory: src
      run-unittest: 'true'
      unittest-filter: 'Category!=local'
```

完全な例は [call-ci.net6.yml](/.github/workflows/call-ci.net6.yml) を参照。

</details>

## `ci.net7.yml`
.NET7 Build & UnitTests のための再利用可能なワークフローです。

<details>
<summary>呼び出し例:</summary>
<div>

```yml
jobs:
  dotnet-build-test:
    strategy:
      fail-fast: false
      matrix:
        include:
          - os: ubuntu-latest
            osName: Linux
          - os: windows-latest
            osName: Windows
    name: Test on ${{ matrix.osName }}
    permissions:
      contents: read
    uses: MareMare/ReusableWorkflows/.github/workflows/ci.net7.yml@main
    with:
      runner-os: ${{ matrix.os }}
      working-directory: src
      testing-directory: src
      run-unittest: 'true'
      unittest-filter: 'Category!=local'
```

完全な例は [call-ci.net7.yml](/.github/workflows/call-ci.net7.yml) を参照。

</details>


## あとで試してみようかな

> **Note**
> どうやら private repo 内のワークフローやアクションを利用できるようになったみたい。
> * [GitHub Actions \- Sharing actions and reusable workflows from private repositories is now GA \| GitHub Changelog](https://github.blog/changelog/2022-12-14-github-actions-sharing-actions-and-reusable-workflows-from-private-repositories-is-now-ga/)
> * [リポジトリの GitHub Actions の設定を管理する \- GitHub Docs](https://docs.github.com/ja/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository)
>
> あとで試してみます。
> 
