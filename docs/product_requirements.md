# Healthy Eaters Product Requirements

## Goal

Healthy Eaters helps children with Autism Spectrum Disorder gradually expand their diets through a smart plate, real-time intake tracking, sensory-friendly challenges, education, and positive reinforcement.

## Target Users

- Children with ASD who experience selective eating, food neophobia, sensory sensitivities, or rigid meal routines.
- Parents, caregivers, therapists, and educators who need measurable progress and low-pressure intervention tools.

## Core Loop

1. Choose a healthy meal or recommended food.
2. Pair with the smart plate.
3. Track food intake in real time using weight sensors.
4. Show child-friendly progress feedback during the meal.
5. Award points, badges, challenge progress, and game tokens when the target is reached.
6. Let the child spend tokens on mini-games after the food goal is completed.
7. Award points from completed mini-games.
8. Let points unlock buddy customization, plate themes, food facts, garden seeds, titles, and celebration animations.
9. Record the food in the glossary and update exposure history.
10. Show parent-facing insights and next food recommendations.

## App Features

- Gamified reward system with points, levels, badges, streaks, game tokens, and gradual food challenges.
- Token-gated game arcade where children can spend earned tokens after completing meal goals.
- Points shop for safe digital rewards, including buddy outfits, plate decorations, virtual garden seeds, food fact cards, titles, and celebration animations.
- Food glossary that records consumed foods and teaches nutritional/cultural facts.
- Personalized recommendations based on food history, sensory preferences, nutrient gaps, and recent successes.
- Nutritional education through animations, mini-games, and short food facts.
- Parent dashboard with real-time meal data, progress summaries, and challenge customization.
- Encouragement messaging from caregivers.
- Real-time Bluetooth feedback from the smart plate.

## Token Game System

- Children earn tokens only after completing food goals or approved exposure challenges.
- Tokens unlock mini-games, short play sessions, cosmetics, characters, or special challenges.
- Parents can set token rewards, game limits, and which games are available.
- Games should connect back to healthy eating, nutrition, sensory exploration, or food confidence.
- The first 10 simple games are Food Match, Garden Catch, Plate Builder, Texture Sort, Color Plate, Memory Meal, Food Maze, Snack Tap, Recipe Order, and Nutrient Quest.

## Points Shop

- Completed games award points.
- Points unlock customization and collection rewards, not real food rewards.
- Children can customize their food buddy, decorate their plate world, unlock food facts, grow a virtual garden, earn titles, and choose celebration animations.
- Parents should eventually be able to disable categories or set daily limits.

## Smart Plate Features

- Load cells measure food weight changes during a meal.
- Microcontroller processes readings and sends data over Bluetooth.
- LED indicators show progress, such as green for completed and red for incomplete.
- Optional vibration or voice prompts reinforce progress when a threshold is reached.
- Future food type recognition using image recognition or additional sensors.

## Sensory-Friendly Requirements

- Challenges should be gradual: look, smell, touch, lick, bite, then eat.
- Parents should be able to mark sensitivities for texture, smell, color, taste, and routine disruption.
- Recommendations should avoid overwhelming changes and prefer small steps from familiar foods.
- Rewards should reinforce effort, not pressure the child to finish everything.

## Prototype Milestones

1. Wire simulated smart plate data into a complete meal session.
2. Add basic GUI screens for home, meal progress, glossary, and parent dashboard.
3. Save meal history, points, tokens, badges, exposures, and child sensory profile.
4. Add a game arcade screen where tokens are spent to start mini-games.
5. Add a points shop screen where game points unlock customization and collectibles.
6. Add food challenge types and recommendation logic.
7. Add Firebase or backend sync for parent monitoring.
8. Replace simulated BLE with real smart plate Bluetooth integration.
9. Add education content and playable mini-games.
10. Add food type recognition and nutrient analysis.
