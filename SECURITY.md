# Security, safety, and data boundary

Healthy Eaters is a local-only portfolio prototype. It stores a child profile, sensory settings, food-exposure progress, and rewards through Defold `sys.save`. It has no backend, user accounts, telemetry, advertising SDK, or production Bluetooth connection. The smart-plate adapter is a deterministic product boundary backed by simulated device events today.

This project is not a medical device, diagnostic tool, feeding-therapy program, or source of individualized nutrition advice.

## Report a vulnerability

Use GitHub's private vulnerability reporting for this repository when it is available. Otherwise, open a GitHub issue with a synthetic, minimal reproduction. Relevant reports include unintended data transmission, unsafe persistence or migration, input handling that exposes a child's data, and future native Bluetooth-boundary issues.

Never include a child's name, health history, sensory profile, meal record, or other identifying data. Use the default fictional profile and synthetic state values.
