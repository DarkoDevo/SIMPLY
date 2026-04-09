# MakuluFramework

This folder is now a standalone WoW addon.

## What Changed

- [`Base.lua`](w:/SIMPLY/MakuluFramework/Base.lua) now binds the addon table and `_G.MakuluFramework` together, so existing rotation code can keep using the same global names.
- [`MakuluFramework.toc`](w:/SIMPLY/MakuluFramework/MakuluFramework.toc) controls addon load order.
- `AutoBundle` can now export rotations in `addon` mode without re-embedding the whole framework as TMW global snippets.

## Maintaining The TOC

The source of truth is [`AutoBundle/AddonFiles.json`](w:/SIMPLY/AutoBundle/AddonFiles.json). If you add, remove, or reorder framework files, resync the TOC with:

```powershell
python .\AutoBundle\AddonBuilder.py
```

## Packaging

To stage a clean addon folder outside the repo:

```powershell
python .\AutoBundle\AddonBuilder.py --out .\AutoBundle\release
```

To stage an obfuscated addon build:

```powershell
python .\AutoBundle\AddonBuilder.py --out .\AutoBundle\release --encrypt
```

That keeps the repo readable for development while still giving you a release path for protected builds.
