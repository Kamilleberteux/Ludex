# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/dev              # Start development server
bin/setup            # Initial setup (installs deps, creates & migrates DB)
bin/ci               # Run full CI pipeline (rubocop, brakeman, bundler-audit, tests)
bin/rails test       # Run unit tests
bin/rails test:system # Run system tests (Capybara + Selenium)
bin/rails test test/models/game_test.rb  # Run a single test file
bin/rubocop          # Lint Ruby code (Omakase style, 120 char max line length)
bin/rails db:seed    # Populate DB from public/products_export_1.csv
bin/rails db:seed:replant  # Reset and reseed DB
```

## Architecture

Rails 8.1 app using the Hotwire stack (Turbo + Stimulus) with PostgreSQL. No JavaScript bundler — assets use Propshaft + ImportMap. Bootstrap 5.3 + SASS for styling.

### Data Model

- **User** — Devise authentication (email/password, remember me, reset token)
- **Game** — Board game catalog: name, description, age_player, nb_players, play_time_minutes, price, release_date, theme, video_url, image URLs, is_cooperative, level
- **Collection** — User-owned lists of games (has `is_default` flag)
- **CollectionGame** — Join table linking Games to Collections

Seed data loads from `public/products_export_1.csv`.

### Key Controllers

- **GamesController** — `index` supports filtering via params (query, theme, nb_players, age_player, max_price, sort); `show` displays game detail
- **CollectionsController** — Lists user's collections; `add_game` adds a game to a collection
- **PagesController** — Home page

All controllers use `before_action :authenticate_user!` (Devise) except public-facing pages.

### Frontend

- Hotwire (Turbo + Stimulus) for reactivity without a JS build step
- Stimulus controllers live in `app/javascript/`
- Shared partials in `app/views/shared/` (navbar, forms)
- Devise views customized under `app/views/devise/`

### CI Pipeline

Defined in `config/ci.rb` and run via GitHub Actions (`.github/workflows/ci.yml`):
1. Brakeman (security scan)
2. Bundler-audit (gem vulnerabilities)
3. Importmap audit (JS dependencies)
4. RuboCop (style)
5. Unit tests + system tests
6. DB seed verification
