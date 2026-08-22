import os

svgs = {
    # Engine Warning -> Orange/Yellow
    "assets/icons/engine_warning.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M6 14v8h4v4h12v-4h4v-8l-2-2h-16z" fill="none" stroke="#FFCC00" stroke-width="2"/>
  <path d="M10 10h12v4H10z" stroke="#FFCC00" stroke-width="2"/>
</svg>""",

    # Oil Warning -> Red (Critical)
    "assets/icons/oil_warning.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M8 18h16l-2-6h-6l-2-4H8l-2 4v4l2 2z" fill="none" stroke="#FF3333" stroke-width="2"/>
  <path d="M24 16h4c1 0 2 1 2 2s-1 2-2 2h-4" fill="none" stroke="#FF3333" stroke-width="2"/>
  <circle cx="8" cy="24" r="1.5" fill="#FF3333"/>
</svg>""",

    # Seatbelt -> Red (Critical Warning)
    "assets/icons/seatbelt.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <circle cx="16" cy="10" r="4" fill="none" stroke="#FF3333" stroke-width="2"/>
  <path d="M10 20l12-10m-6 12l2-10" stroke="#FF3333" stroke-width="2"/>
  <path d="M8 26c0-6 4-8 8-8s8 2 8 8" fill="none" stroke="#FF3333" stroke-width="2"/>
</svg>""",

    # Tire Pressure -> Orange/Yellow (Advisory)
    "assets/icons/tire_pressure.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 6A10 10 0 0 0 6 15v10h20V15A10 10 0 0 0 22 6Z" fill="none" stroke="#FFCC00" stroke-width="2"/>
  <circle cx="16" cy="22" r="2" fill="#FFCC00"/>
  <path d="M16 10v8" stroke="#FFCC00" stroke-width="2"/>
</svg>""",

    # Lane Assist -> Green when active (Advisory)
    "assets/icons/lane_assist.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 6l-4 20m16-20l4 20" stroke="#00FFCC" stroke-width="2" stroke-dasharray="4 4" fill="none"/>
  <rect x="12" y="12" width="8" height="12" rx="2" fill="none" stroke="#00FFCC" stroke-width="2"/>
</svg>""",

    # Steering Warning -> Red (Critical)
    "assets/icons/steering_warning.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <circle cx="16" cy="16" r="12" fill="none" stroke="#FF3333" stroke-width="2"/>
  <circle cx="16" cy="16" r="4" fill="none" stroke="#FF3333" stroke-width="2"/>
  <path d="M16 6v4m0 12v4" stroke="#FF3333" stroke-width="2"/>
</svg>"""
}

os.makedirs("/home/channaveeragouda/Anti-G/AutomotiveCluster/assets/icons", exist_ok=True)
for path, content in svgs.items():
    with open(f"/home/channaveeragouda/Anti-G/AutomotiveCluster/{path}", "w") as f:
        f.write(content)

print("Icons repainted.")
