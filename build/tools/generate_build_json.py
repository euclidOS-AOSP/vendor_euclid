#!/usr/bin/env python3

import json
import hashlib
import os
import time
import sys

def calculate_hash(file_path, algo):
    h = hashlib.new(algo)
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(8192), b""):
            h.update(chunk)
    return h.hexdigest()

def get_prop_from_build_prop(out_dir, prop_name):
    build_prop = os.path.join(out_dir, "system", "build.prop")
    if not os.path.isfile(build_prop):
        return ""

    with open(build_prop, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if line.startswith(prop_name + "="):
                return line.split("=", 1)[1]

    return ""

def main():
    if len(sys.argv) < 2:
        print("Usage: ./generate_build_json.py <ROM_ZIP_PATH>")
        sys.exit(1)

    rom_path = sys.argv[1]
    if not os.path.isfile(rom_path):
        print("Error: ROM zip not found")
        sys.exit(1)

    # out/target/product/<device>
    out_dir = os.path.dirname(rom_path)

    # File-based values
    filename = os.path.basename(rom_path)
    size = os.path.getsize(rom_path)
    timestamp = int(time.time())
    md5 = calculate_hash(rom_path, "md5")
    sha256 = calculate_hash(rom_path, "sha256")

    # Read ALL authoritative values from build.prop
    device = get_prop_from_build_prop(out_dir, "ro.product.system.device")
    oem = get_prop_from_build_prop(out_dir, "ro.product.system.brand")
    version = get_prop_from_build_prop(out_dir, "ro.euclid.version")
    maintainer = get_prop_from_build_prop(out_dir, "ro.maintainer.name")

    # Device download page
    download = f"https://www.euclidos.org/downloads/{device}/"

    data = {
        "maintainer": maintainer,
        "oem": oem,
        "device": device,
        "version": version,
        "filename": filename,
        "download": download,
        "timestamp": timestamp,
        "md5": md5,
        "sha256": sha256,
        "size": size,
        "telegram": "TELEGRAM_USERNAME",
        "support": "https://t.me/YOURCHATSUPPORT"
    }

    # ROM root (script must be run from ROM root)
    rom_root = os.getcwd()

    # official_devices/builds
    builds_dir = os.path.join(rom_root, "official_devices", "builds")
    os.makedirs(builds_dir, exist_ok=True)

    output_path = os.path.join(builds_dir, f"{device}.json")

    with open(output_path, "w") as f:
        json.dump(data, f, indent=2)

    print(f"✔ JSON generated at: {output_path}")

if __name__ == "__main__":
    main()
