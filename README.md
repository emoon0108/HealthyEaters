# Healthy Eaters

Healthy Eaters is a Defold/Lua prototype for autism-aware nutrition support. It combines gradual food exposure, a simulated smart plate, low-stimulation interface settings, token-gated mini-games, and parent-facing progress concepts.

The project is designed around one idea: eating practice should feel safe, measurable, and encouraging instead of pressured.

## Engineering snapshot

| Concern | Approach |
| --- | --- |
| Sensory accessibility | Atkinson Hyperlegible, a low-stimulation mode, calmer language, and restrained transitions |
| State model | Separate Lua modules for meals, rewards, recommendations, games, tasks, and storage |
| Hardware boundary | Simulated BLE smart-plate adapter that can be replaced by a native integration |
| Progress loop | Four exposure steps, local persistence, tokens, badges, streaks, and parent-facing summaries |
| Product scope | Playable prototype with ten mini-games and explicit simulated-hardware labeling |

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

Current verification is manual in the Defold editor: launch `main/main.collection`, complete a meal flow, reopen the app to confirm persistence, and exercise Low-Stim mode plus the simulated plate connection. Automated Lua coverage and real-device BLE validation are future work.

For a fuller feature inventory, see [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md).
