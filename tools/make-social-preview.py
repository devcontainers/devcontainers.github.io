#!/usr/bin/env python3
"""Generate a 1200x630 social preview card for devcontainers.github.io.

Reproduces the site's branding: white background, the project's REAL
devcontainers logo, theme color #2753E3, and the site tagline.
Portable generator: DVC_FONT_DIR -> ./fonts -> ~/.fonts -> system.
"""
import os
import sys
from PIL import Image, ImageDraw, ImageFont

W, H = 1200, 630
THEME = (39, 83, 227)          # #2753E3 from _config.yml
DARK = (23, 26, 38)
GRAY = (95, 105, 128)

def find_font(candidates):
    for c in candidates:
        if os.path.exists(c):
            return c
    return None

def load_font(size, bold=False):
    base = os.environ.get("DVC_FONT_DIR", "")
    dirs = [base, "./fonts", os.path.expanduser("~/.fonts"), "/usr/share/fonts/truetype/dejavu", "/usr/share/fonts/truetype/liberation"]
    if bold:
        names = ["DejaVuSans-Bold.ttf", "LiberationSans-Bold.ttf", "arialbd.ttf"]
    else:
        names = ["DejaVuSans.ttf", "LiberationSans-Regular.ttf", "arial.ttf"]
    for d in dirs:
        for n in names:
            p = os.path.join(d, n)
            if os.path.exists(p):
                return ImageFont.truetype(p, size)
    return ImageFont.load_default()

def main():
    logo_path = sys.argv[1] if len(sys.argv) > 1 else "logo.png"
    out_path = sys.argv[2] if len(sys.argv) > 2 else "social-preview.png"

    img = Image.new("RGB", (W, H), "white")
    draw = ImageDraw.Draw(img)

    # Top brand bar
    draw.rectangle([0, 0, W, 10], fill=THEME)
    # Bottom accent stripe
    draw.rectangle([0, H - 12, W, H], fill=THEME)

    # Logo: load real project logo, place left side
    logo = Image.open(logo_path).convert("RGBA")
    logo.thumbnail((300, 300), Image.LANCZOS)
    lw, lh = logo.size
    img.paste(logo, (90, (H - lh) // 2), logo)

    # Headline
    f_big = load_font(64, bold=True)
    f_mid = load_font(34, bold=True)
    f_small = load_font(30)
    f_url = load_font(30, bold=True)

    x = 440
    draw.text((x, 150), "Development", font=f_big, fill=DARK)
    draw.text((x, 230), "Containers", font=f_big, fill=DARK)

    # Blue underline
    draw.rectangle([x + 4, 322, x + 150, 330], fill=THEME)

    draw.text((x, 360), "An open specification for enriching", font=f_mid, fill=DARK)
    draw.text((x, 410), "containers with development-specific", font=f_mid, fill=DARK)
    draw.text((x, 460), "content and settings.", font=f_mid, fill=DARK)

    draw.text((x, 540), "devcontainers.github.io", font=f_url, fill=THEME)

    img.save(out_path, "PNG")
    print(f"saved {out_path} ({W}x{H})")

if __name__ == "__main__":
    main()
