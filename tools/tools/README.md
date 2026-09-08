# Project tooling

The reusable project workflow is pinned as a Git submodule at:

```text
tools/tool.scad-project
```

Do not copy the implementation into this project.

Initialize the tool and all configured project externals from the repository
root:

```powershell
.\bootstrap.ps1
```

or:

```bash
bash ./bootstrap.sh
```
