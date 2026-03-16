# Quamaa (Flutter + Supabase)

Household spend & pantry OS. Key modules: dashboard, shopping, inventory, budget, stores/quotas, stats, auth (magic link).

## Running locally
1) Create `.env` with `SUPABASE_URL` and `SUPABASE_ANON_KEY` (see `.env.example`).
2) `flutter pub get`
3) `flutter run`

## Supabase schema expectations
- `shopping_items`: id (uuid), name, qty, category, store, expiry, status, auto_add (bool), user_id (uuid).
- `inventory_items`: id, name, qty, expiry, status, user_id.
- `budget_summary`: monthly_cap, spent, user_id.
- `budget_categories`: id, name, spent, cap, user_id.
- `budget_payments`: id, amount, category, user_id (used for optimistic addPayment).
- `store_quotas`: id, name, period, cap, spent, next_due, user_id.
- `store_payments`: id, store_id, amount, user_id (optimistic payment reduces spent).
- Stats views/RPCs:
  - `stats_summary` (remaining_ratio, remaining_caption, user_id)
  - `stats_categories` (label, spent, cap, user_id)
  - `stats_stores` (label, spent, cap, user_id)
  - Alternatively expose a single RPC `get_stats_overview()` returning the above shape.

## RLS policy template
Enable RLS on all tables/views above and add:
```sql
-- Example for shopping_items
create policy "owners read/write shopping_items"
on shopping_items for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
```
Repeat for each table/view. For RPCs, ensure underlying tables enforce RLS.

## Typed models
Generate supabase types and swap into repositories for stronger typing:
```bash
supabase gen types dart --project-id <your-project-id> --schema public > lib/src/core/supabase/types.dart
```
Then import and replace manual map parsing with generated classes.

## Testing
- `test/pull_to_refresh_test.dart` verifies pull-to-refresh on shopping list triggers controller refresh (Riverpod override).
- Run all tests: `flutter test`

## Notes
- Repositories optimistically update state; on Supabase errors, state surfaces the error.
- If Supabase is not configured, demo data is used so the app still runs.
