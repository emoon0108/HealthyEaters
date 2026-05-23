# Healthy Eaters Mini-Games

All games are food-themed and designed for short, token-gated play sessions after a child completes a meal goal.

| Game | Cost | Time | Simple Goal |
| --- | ---: | ---: | --- |
| Food Match | 1 | 75s | Send food crates into matching group gates on a sorting dock. |
| Garden Catch | 1 | 75s | Move a basket with the mouse to catch falling healthy foods while avoiding dessert decoys. |
| Plate Builder | 2 | 90s | Add food pieces to a large plate workshop and complete a balanced build. |
| Texture Sort | 1 | 75s | Test foods in texture lab trays for crunchy, soft, smooth, and chewy clues. |
| Color Plate | 1 | 75s | Fill a rainbow plate by choosing foods that match each color prompt. |
| Memory Meal | 1 | 90s | Flip a 12-card food board and remember where matching pairs are hidden. |
| Food Maze | 2 | 90s | Move Bito through a maze, collect ingredients, and reach the plate exit. |
| Snack Tap | 1 | 60s | Tap healthy snacks as they pop up on the counter and avoid sweet decoys. |
| Recipe Order | 2 | 90s | Assemble a real recipe strip by tapping each step in order. |
| Nutrient Quest | 3 | 100s | Follow a power path and collect food gems for body powers. |

## Design Notes

- Games should be calm, colorful, and low-pressure.
- Sessions should be long enough to feel meaningful but still short enough to avoid taking over mealtime.
- Prototype games now use score targets, lives, timers, randomized objects, and fast feedback instead of static quiz screens.
- Several cabinets have their own interaction model: falling-object catching, memory cards, directional maze movement, recipe sequencing, and snack popups.
- Nutrition prompts are framed as action objectives inside the scene, so the child sorts, builds, collects, flips, moves, or assembles rather than answering a plain Q&A card.
- Garden Catch has its own active play loop: healthy foods fall from the sky, desserts are clearly marked as avoid items, and the child moves a basket to catch only the good foods.
- Games should reward effort and food curiosity, not perfection.
- Parents should eventually be able to enable, disable, or set limits for each game.
- The parent operations dashboard now models how food challenges could be launched from a QR/session code and monitored through a live meal status pipeline before tokens unlock the arcade.
