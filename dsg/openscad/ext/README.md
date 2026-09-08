# External OpenSCAD libraries

External CAD libraries are configured in `/project.yml` and managed by the
pinned local project tool.

Current dependency:

```text
lib.scad.clamps
```

Initialize all project externals from the repository root with:

```powershell
.\bootstrap.ps1
```

or, after the tool itself is already available:

```powershell
.\tools\tool.scad-project\scad-project.ps1 externals-init
```
