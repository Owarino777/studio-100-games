#!/usr/bin/env python3
"""Reuse the actual native touch recipe, on the new package and qualified dp profiles."""
import verify_littoral_android as recipe

recipe.PACKAGE = "org.studio100games.switchworks.postal.ui"

if __name__ == "__main__":
    recipe.run(apk_path=recipe.p.GAME / "build/android/switchworks-postal-ui-debug.apk",
               output_root=recipe.p.GAME / "artifacts/ui-ux-refonte-2026-11-16",
               density_profiles=True, extra_ui_states=True)
