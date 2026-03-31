# Monsy

Monsy is a social habit-tracking iOS app where friends grow a shared Monstera plant.

This branch sets up the foundation for:
- Apple Sign-In-first onboarding
- nickname and profile photo selection
- habit creation with 5-digit join codes
- joining challenges by code
- habit photo verification and all-member approvals
- Monstera growth progression with 16 levels plus dying states
- Supabase-first data modeling

## What is in this scaffold
- A SwiftUI app structure organized by feature and core service layers
- Growth, approval, and join code logic extracted into reusable services
- A Supabase migration file that models the core entities
- Placeholder Monstera asset naming for the 16 growth levels and dying state

## Project setup
This repo uses an XcodeGen project definition so the app structure can be generated locally.

1. Install XcodeGen if needed
2. Generate the project
   - xcodegen generate
3. Open the generated Xcode project and run the Monsy app target

## Core product rules captured in this scaffold
- Habit creation produces a random 5-digit join code
- A challenge does not start until it has at least 2 users
- A verification photo only counts when every member approves it
- Monstera growth is mapped to 16 levels and scales with the goal length
- If streaks break, the plant can enter a dying state and level down, then recover when the streak resumes

## Supabase
The initial schema lives in:
- supabase/migrations/0001_initial_schema.sql

## Asset placeholders
Placeholder asset names are listed in:
- Monsy/Resources/MonsteraLevels/README.md

## Next steps
- Wire the views to Supabase auth and database calls
- Add actual iOS asset catalogs and final Monstera art
- Replace sample state with real habit/session data
- Add photo upload persistence and approval notifications
