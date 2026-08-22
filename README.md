# Healthy Eaters

[![CI](https://github.com/emoon0108/HealthyEaters/actions/workflows/ci.yml/badge.svg)](https://github.com/emoon0108/HealthyEaters/actions/workflows/ci.yml)
[![Project page](https://img.shields.io/badge/project-live-2f7653)](https://emoon0108.github.io/HealthyEaters/)

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
| Reliability | Headless Lua domain tests plus a pinned Defold project build in CI |

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
- Repo-local illustrated 2D food assets

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

## Verification

The domain suite exercises storage migration, meal milestones, reward accounting, token-gated games, purchases, recommendations, Bito progression, and mission claims without requiring the editor:

```bash
lua5.4 tests/run.lua
```

CI also compiles the complete project with the checksum-verified Defold 1.12.4 `bob.jar`, catching invalid resources and engine-level build failures that unit tests cannot see.

## Current Status

Healthy Eaters is a playable prototype. The smart plate is simulated, but the code is structured so real Bluetooth/native plate integration can replace the simulator later.

Automated checks cover the portable Lua domain modules and a full Defold build. Editor interaction, visual behavior, persistence across a real app restart, and the simulated plate callback timing still require a manual smoke test. Real-device BLE validation remains future work.

## Safety and privacy boundary

The prototype stores its child profile, sensory settings, food-exposure history, and rewards only in Defold's local `sys.save` storage. It has no backend, account system, analytics tracker, advertising SDK, or real Bluetooth connection. The included plate adapter generates simulated weights on-device.

Healthy Eaters is not a medical device, diagnostic tool, feeding-therapy program, or source of individualized nutrition advice. A clinician or registered dietitian should guide real feeding concerns. Avoid entering a child's full name or sensitive health information on a shared device.

See [SECURITY.md](SECURITY.md) for safe disclosure guidance. Do not put real child or health data in a bug report.

For a fuller feature inventory, see [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md).
