import os

# Create base directories
os.makedirs("/home/channaveeragouda/Anti-G/AutomotiveCluster/assets/icons", exist_ok=True)

# Define SVGs
svgs = {
    "assets/car_blueprint.svg": """<svg width="150" height="350" xmlns="http://www.w3.org/2000/svg">
  <rect x="25" y="20" width="100" height="310" rx="30" fill="transparent" stroke="#00FFFF" stroke-width="3"/>
  <rect x="35" y="100" width="80" height="40" rx="5" fill="transparent" stroke="#00FFFF" stroke-width="2"/>
  <rect x="35" y="240" width="80" height="30" rx="5" fill="transparent" stroke="#00FFFF" stroke-width="2"/>
  <rect x="30" y="150" width="90" height="80" fill="transparent" stroke="#00FFFF" stroke-width="1" opacity="0.5"/>
</svg>""",
    "assets/icons/weather_sunny.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <circle cx="16" cy="16" r="6" fill="#FFD700"/>
  <path d="M16 4v4m0 16v4M4 16h4m16 0h4m-17-7.5l2.8 2.8m8.4 8.4l2.8 2.8M7.5 24.5l2.8-2.8m8.4-8.4l2.8-2.8" stroke="#FFD700" stroke-width="2" stroke-linecap="round"/>
</svg>""",
    "assets/icons/tire_pressure.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 6A10 10 0 0 0 6 15v10h20V15A10 10 0 0 0 22 6Z" fill="none" stroke="red" stroke-width="2"/>
  <circle cx="16" cy="22" r="2" fill="red"/>
  <path d="M16 10v8" stroke="red" stroke-width="2"/>
</svg>""",
    "assets/icons/door_outline.svg": """<svg width="40" height="40" xmlns="http://www.w3.org/2000/svg">
  <rect x="8" y="4" width="24" height="32" fill="none" stroke="red" stroke-width="2" rx="2"/>
  <line x1="8" y1="20" x2="16" y2="20" stroke="red" stroke-width="2"/>
</svg>""",
    "assets/icons/seatbelt.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <circle cx="16" cy="10" r="4" fill="none" stroke="red" stroke-width="2"/>
  <path d="M10 20l12-10m-6 12l2-10" stroke="red" stroke-width="2"/>
  <path d="M8 26c0-6 4-8 8-8s8 2 8 8" fill="none" stroke="red" stroke-width="2"/>
</svg>""",
    "assets/icons/parking_brake.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <circle cx="16" cy="16" r="10" fill="none" stroke="red" stroke-width="2"/>
  <path d="M4 16a14 14 0 0 0 4 8m16-8a14 14 0 0 1-4 8" stroke="red" stroke-width="2"/>
  <text x="16" y="21" font-family="Arial" font-size="14" font-weight="bold" fill="red" text-anchor="middle">P</text>
</svg>""",
    "assets/icons/indicator_left.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M22 16H8m0 0l6-6m-6 6l6 6" stroke="#00FF00" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""",
    "assets/icons/indicator_right.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M10 16h14m0 0l-6-6m6 6l-6 6" stroke="#00FF00" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""",
    "assets/icons/high_beam.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <path d="M14 10c4 0 8 2 8 6s-4 6-8 6V10z" fill="none" stroke="#0000FF" stroke-width="2"/>
  <path d="M6 10h4m-4 6h4m-4 6h4" stroke="#0000FF" stroke-width="2"/>
</svg>""",
    "assets/icons/battery_icon.svg": """<svg width="32" height="32" xmlns="http://www.w3.org/2000/svg">
  <rect x="6" y="10" width="20" height="12" rx="2" fill="none" stroke="cyan" stroke-width="2"/>
  <path d="M26 14v4" stroke="cyan" stroke-width="2"/>
</svg>"""
}

for path, content in svgs.items():
    with open(f"/home/channaveeragouda/Anti-G/AutomotiveCluster/{path}", "w") as f:
        f.write(content)

print("SVGs generated.")
