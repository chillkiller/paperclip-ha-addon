# Assets for Paperclip AI Add-on

## Required Assets

### icon.png
- **Size**: 128x128 pixels
- **Format**: PNG with transparency
- **Purpose**: Add-on icon in Home Assistant Add-on Store
- **Location**: `/paperclip_ha_addon/icon.png`

### logo.png
- **Size**: 128x128 pixels
- **Format**: PNG with transparency
- **Purpose**: Add-on logo in Home Assistant sidebar
- **Location**: `/paperclip_ha_addon/logo.png`

## Design Guidelines

### Color Scheme
- Primary: #4A90E2 (Blue)
- Secondary: #50E3C2 (Teal)
- Accent: #F5A623 (Orange)
- Background: #FFFFFF (White)
- Text: #333333 (Dark Gray)

### Icon Design
The icon should represent:
- AI/Robotics theme
- Multi-agent concept
- Professional and modern look
- Clear at small sizes

### Logo Design
The logo should be:
- Simple and recognizable
- Consistent with icon design
- Professional appearance
- Clear at small sizes

## Placeholder Instructions

Until custom assets are created, you can:

1. **Use Home Assistant Default Icon**
   - The add-on will use the default icon if `icon.png` is missing
   - Configured in `config.yaml`: `panel_icon: "mdi:robot-outline"`

2. **Create Custom Assets**
   - Use design tools like Figma, Adobe Illustrator, or Inkscape
   - Follow the size and format requirements above
   - Save as `icon.png` and `logo.png` in the add-on directory

3. **Use Open Source Icons**
   - Material Design Icons: https://materialdesignicons.com/
   - Search for: robot, ai, automation, agent
   - Convert PNG to required size

## Asset Sources

### Recommended Icon Sources
- Material Design Icons: https://materialdesignicons.com/
- Flaticon: https://www.flaticon.com/
- IconFinder: https://www.iconfinder.com/
- Noun Project: https://thenounproject.com/

### Free Icon Resources
- Material Icons (Google): https://fonts.google.com/icons
- Heroicons: https://heroicons.com/
- Feather Icons: https://feathericons.com/

## Asset Creation Tools

### Online Tools
- Canva: https://www.canva.com/
- Figma: https://www.figma.com/
- Photopea: https://www.photopea.com/

### Desktop Tools
- Adobe Illustrator (Paid)
- Inkscape (Free, Open Source)
- GIMP (Free, Open Source)

## Asset Optimization

### PNG Optimization
- Use tools like TinyPNG: https://tinypng.com/
- Optimize for web use
- Keep file size under 50KB

### Color Palette
```css
--primary: #4A90E2;
--secondary: #50E3C2;
--accent: #F5A623;
--background: #FFFFFF;
--text: #333333;
```

## Asset Testing

### Test Checklist
- [ ] Icon displays correctly in Add-on Store
- [ ] Logo displays correctly in sidebar
- [ ] Images are clear at 128x128 size
- [ ] Transparency works correctly
- [ ] File size is reasonable (< 50KB)
- [ ] Colors match design guidelines

### Testing Steps
1. Add assets to `/paperclip_ha_addon/` directory
2. Restart Home Assistant
3. Check Add-on Store for icon
4. Check sidebar for logo
5. Verify appearance on different devices

## Asset Versioning

When updating assets:
1. Keep backup of original assets
2. Update version in `config.yaml`
3. Test new assets thoroughly
4. Update CHANGELOG.md
5. Commit changes with descriptive message

## Asset Licensing

### Important Notes
- Ensure assets have appropriate licenses
- Credit asset sources if required
- Check commercial use permissions
- Document asset licenses in this file

### Recommended Licenses
- MIT License
- Apache License 2.0
- Creative Commons (CC0, CC BY, CC BY-SA)
- SIL Open Font License (for icon fonts)

## Current Status

- [ ] icon.png - **MISSING** (Using default MDI icon)
- [ ] logo.png - **MISSING** (Using default MDI icon)

## Next Steps

1. Design or source appropriate icon and logo
2. Create PNG files at 128x128 pixels
3. Optimize file sizes
4. Test in Home Assistant
5. Update this file with asset sources and licenses

---

**Last Updated**: 2026-04-21
**Version**: 1.0.0