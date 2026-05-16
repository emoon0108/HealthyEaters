# Healthy Eaters Project Summary

Healthy Eaters is a Defold/Lua prototype for helping children with Autism Spectrum Disorder gradually expand their diets through calm food challenges, simulated smart-plate tracking, positive reinforcement, food education, and parent-facing progress concepts.

## Main Purpose

The app is designed to make eating practice feel safe, measurable, and rewarding. A child completes a food goal, earns game tokens, spends those tokens on short food-themed games, earns points from games, and uses points to unlock digital rewards. The system reinforces food exposure and effort without using pressure-based rewards.

## What The Current App Can Do

### Home And Navigation

- Starts on a colorful intro screen for Healthy Eaters.
- Lets the user navigate to:
  - Home
  - Food challenge / meal tracker
  - Food games
  - Points arcade / rewards area
  - Parent information
- Shows the current wallet balance for points and game tokens.
- Displays child-friendly food, plate, reward, and navigation artwork.

### Meal Tracking

- Starts a food challenge from the home or intro screen.
- Chooses a recommended food automatically from the glossary using low-exposure food history.
- Creates a meal session for the selected food.
- Rewards gradual meal steps instead of only rewarding full completion:
  - Look / identify the food: +5 points
  - Touch or smell / interact with the plate: +5 points
  - Taste / small weight decrease: +10 points
  - Complete the meal target: +25 points and 3 game tokens
- Simulates a connected smart plate through the BLE module.
- Simulates plate weight decreasing over time.
- Converts weight loss into eaten progress.
- Tracks progress toward a 40 gram completion target.
- Updates the UI with:
  - Current challenge food
  - Current plate weight
  - Visual food-path progress
  - Step-ladder status
- Marks the meal complete when the target is reached.
- Prevents the same meal from being rewarded multiple times.

### Smart Plate Prototype

- Includes a platform-neutral BLE interface.
- Simulates a smart plate connection.
- Shows a child-friendly "Magic Calibration" state before tracking starts.
- Sends recurring weight updates.
- Uses friendly disconnect language, such as "Plate is taking a nap."
- Supports callback hooks for:
  - Connected
  - Weight changed
  - Disconnected
- Is structured so real Bluetooth/native smart-plate integration can replace the simulator later.

### Rewards System

- Stores points, tokens, streaks, badges, inventory, meal metrics, and glossary data.
- Awards 25 points and 3 game tokens when a meal challenge is completed.
- Increases meal completion count.
- Increases streak count for completed meals.
- Calculates child level from points.
- Supports badges, including:
  - Taster: 10 completed meals
  - Explorer: 3 new foods tried
- Lets points and tokens be earned and spent through reusable reward functions.

### Token-Gated Mini-Games

- Includes 10 food-themed mini-games:
  - Food Match
  - Garden Catch
  - Plate Builder
  - Texture Sort
  - Color Plate
  - Memory Meal
  - Food Maze
  - Snack Tap
  - Recipe Order
  - Nutrient Quest
- Each game has:
  - Token cost
  - Point reward
  - Duration metadata
  - Description
  - Food/nutrition content
- Requires enough tokens before a game can start.
- Spends tokens when a game session begins.
- Shows a Ready / Set / Go transition before switching into a mini-game.
- Bridges meal progress into game content by letting the food just practiced appear as a game power-up question.
- Runs timed tap-board mini-games with score targets, lives, randomized food pods, countdowns, and fast feedback.
- Uses nutrition question banks as action objectives instead of static quiz cards.
- Gives feedback for correct and incorrect answers.
- Shows score at the end of the game.
- Awards higher game points after completion to match the longer play sessions.

### Points Arcade And Shop Logic

- Documents and models a digital rewards shop.
- Supports shop items such as:
  - Food buddy accessories
  - Plate themes
  - Food fact cards
  - Virtual garden seeds
  - Profile titles
  - Celebration animations
- Allows shop items to be bought with points.
- Prevents duplicate purchases.
- Allows supported item categories to be equipped:
  - Buddy
  - Plate
  - Celebration
  - Title
- Current UI describes the reward categories; the shop module contains the purchase/equip logic.

### Food Glossary

- Initializes default foods:
  - Apple
  - Carrot
  - Yogurt
  - Rice
  - Chicken
- Adds foods to the glossary when they are introduced.
- Tracks exposure count per food.
- Tracks step-level exposure counts for look, interact, taste, and complete.
- Stores food attributes for parent insights and recommendations:
  - Texture
  - Color
  - Smell
  - Temperature
  - Food group
- Increments exposure when a meal is completed.
- Tracks new-food count for badge progress.

### Recommendations

- Recommends foods with the fewest exposures.
- Diversifies recommendations by food group when possible.
- Can avoid certain foods based on stored sensory sensitivity flags.
- Includes an `ai_personalize` hook for future recommendation logic using age, sensitivities, food history, and nutrient gaps.

### Sensory Customization

- Stores a child sensory mode in local state.
- Adds a parent-controlled Low-Stim mode.
- Low-Stim mode uses softer colors, skips intro confetti, slows transition countdowns, and uses calmer completion language.
- Bright mode keeps the original high-engagement visual style.
- Bright mode now includes animated food art, pulsing buttons, colorful screen ribbons, and livelier game screens.

### Data Persistence

- Saves app state locally through Defold `sys.save`.
- Loads existing state on startup.
- Maintains defaults for missing state fields.
- Persists:
  - Child profile basics
  - Sensory sensitivity flags
  - Glossary entries
  - Points
  - Tokens
  - Streak
  - Badges
  - Inventory
  - Equipped items
  - Meal metrics
- Includes a backend/Firebase-ready stub for pushing meal data later.

### Parent-Facing Concepts

- Includes a Parent Info screen describing planned parent tools.
- Shows a simple Food IEP snapshot using completed food attributes:
  - Strongest texture pattern
  - Strongest color pattern
  - Meals completed
  - Foods introduced
- Lets the parent toggle between Bright mode and Low-Stim mode.
- Planned parent capabilities include:
  - Tracking meals completed
  - Reviewing foods explored
  - Setting sensory preferences
  - Choosing food challenges
  - Controlling game tokens and play limits
  - Sending encouragement after meals
- The deeper parent dashboard is currently documented/planned rather than fully implemented.

## Sensory-Friendly Design Goals

The project is built around gradual, low-pressure food exposure. The documented challenge model supports steps such as looking, smelling, touching, licking, biting, and eating. The reward system is intended to celebrate effort and curiosity rather than force completion.

## Current Implementation Status

Implemented in the prototype:

- Defold app shell
- Dynamic child-facing UI
- Simulated smart plate connection
- Magic Calibration and friendly smart-plate status language
- Simulated weight-based meal progress
- Step-ladder meal rewards
- Meal completion rewards
- Persistent local state
- Low-Stim sensory mode
- Food glossary, step-level exposure tracking, and food attributes
- Simple sensory-aware recommendation logic
- Token economy
- Ten mini-game definitions
- Timed playable tap-board mini-games
- Ready / Set / Go game transition
- Plate-to-game food bridge
- More colorful dynamic UI with animated food icons, accent ribbons, and button motion
- Points earning
- Shop data and purchase/equip logic
- Parent info screen with early Food IEP insight summary

Planned or stubbed for future work:

- Real Bluetooth smart-plate integration
- Real load-cell hardware data
- Full parent dashboard
- Parent controls for game limits and reward categories
- Backend/Firebase sync
- More detailed nutrition education content
- Fully interactive versions of each mini-game
- Food type recognition
- Nutrient analysis
- Advanced personalized recommendations

## Core User Loop

1. The child starts a food challenge.
2. The app recommends a food based on exposure history.
3. The smart plate tracks meal progress through weight changes.
4. The child completes the goal.
5. The app awards points and game tokens.
6. The child spends tokens to play food-themed mini-games.
7. Completed games award more points.
8. Points can unlock digital rewards and customization.
9. The glossary records food exposure progress.
10. Parent-facing tools can use the saved progress data.

## Project Structure

- `main/main.script`: app startup, meal session orchestration, simulated BLE callbacks, and reward triggers.
- `main/ui/main.gui_script`: dynamic UI for intro, home, games, game rounds, shop, and parent info.
- `modules/ble.lua`: simulated smart-plate Bluetooth interface.
- `modules/meal.lua`: meal session state and weight-to-progress logic.
- `modules/rewards.lua`: points, tokens, streaks, levels, and badges.
- `modules/games.lua`: game definitions, token spending, sessions, and game rewards.
- `modules/shop.lua`: shop item catalog, purchases, and equip logic.
- `modules/glossary.lua`: food glossary and exposure tracking.
- `modules/recommend.lua`: simple exposure-based recommendations.
- `modules/storage.lua`: local persistence and backend-ready stubs.
- `docs/`: product requirements, mini-game plan, and points shop design.
- `assets/`: child-friendly images, icons, sound effects, and font assets.

## One-Sentence Summary

Healthy Eaters is a sensory-friendly nutrition and smart-plate game prototype that tracks food exposure, rewards meal progress, unlocks short educational games, and lays the foundation for parent monitoring and personalized food recommendations.
