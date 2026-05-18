# Healthy Eaters

Healthy Eaters is a Defold/Lua prototype for autism-aware nutrition support. It combines gradual food exposure, a simulated smart plate, low-stimulation interface settings, token-gated mini-games, and parent-facing progress concepts.

The project is designed around one idea: eating practice should feel safe, measurable, and encouraging instead of pressured.

## Live Project Page

View the GitHub Pages overview:

https://emoon0108.github.io/HealthyEaters/

## Highlights

- Simulated smart-plate connection with friendly calibration and weight updates
- Step-based meal challenge flow: look, interact, taste, and complete
- Rewards system with points, game tokens, streaks, badges, and inventory state
- Ten food-themed mini-games connected to meal progress
- Sensory-aware Low-Stim mode for calmer colors, language, and transitions
- Food glossary with exposure tracking and recommendation hooks
- Parent information screen with early Food IEP-style insights
- Local persistence through Defold `sys.save`

## Why It Matters

Many nutrition and habit apps focus on compliance. Healthy Eaters focuses on curiosity, confidence, and gradual exposure. The current prototype models how a child could be rewarded for small, meaningful steps while giving parents a clearer view of progress patterns.

## Tech Stack

- Defold
- Lua
- Local state persistence
- BLE-ready smart-plate abstraction
- Generated and hand-authored 2D game assets

## Project Structure

```text
main/       Defold scenes, scripts, and UI controllers
modules/    Food tracking, rewards, recommendations, storage, games, BLE stubs
assets/     Fonts, sound effects, and visual assets
docs/       Product notes, mini-game design, rewards model, and project page
scripts/    Asset generation helper scripts
```

## Run Locally

Open the folder in Defold, then run the main collection from:

```text
main/main.collection
```

## Current Status

Healthy Eaters is a playable prototype. The smart plate is simulated, but the code is structured so real Bluetooth/native plate integration can replace the simulator later.

For a fuller feature inventory, see [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md).
