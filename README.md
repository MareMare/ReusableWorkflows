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
