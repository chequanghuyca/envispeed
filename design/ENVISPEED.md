# Envispeed identity

Owner-supplied original artwork: `Envispeed-logo.png` (2026-11-06). The original is preserved without redrawing. Asset catalogs and `Envispeed.icns` contain standard macOS sizes derived from it.

- Name: **Envispeed**, one word, capital E.
- Tagline: **Gõ tự nhiên. Làm việc liền mạch.**
- Wordmark: **Envi** in the system foreground color, **speed** in the terracotta accent; SF Rounded bold.
- Accent: light `#B8381F`, dark `#FF8C61`, derived from the logo's warm palette. System label/background colors keep light and dark modes readable.
- Layout: native controls, generous spacing, a subtle warm header, clear current-language and permission states.
- Small menu-bar state: V / E in a template icon, so the active language stays readable in a few pixels. The full supplied logo is used in app icon, onboarding, settings and About.
- Voice: short Vietnamese sentences, clear behavior, no unmeasured accuracy or performance claims.

Regenerate icons after replacing the source artwork:

```sh
xcrun swift Tools/macos/generate-icons.swift
iconutil -c icns build/Envispeed.iconset -o design/Envispeed.icns
```

These are the active identity guidelines for the Envispeed macOS app.
