# Supabase setup

This folder contains the database schema for the Gmail integration.

## Safe setup

1. Open your Supabase project.
2. Open **SQL Editor**.
3. Create a new query.
4. Copy/paste `schema.sql` and run it.
5. Confirm the tables `applications`, `gmail_connections`, `gmail_messages`, and `application_events` exist.

## Important security rules

- Never put Supabase service-role keys in the browser.
- Never commit Google OAuth client secrets to GitHub.
- Gmail access will use OAuth and the `gmail.readonly` scope.
- OAuth tokens must be stored server-side only.

The next backend step will add the OAuth callback and Gmail polling/processing function. Do not create a Google redirect URI until that endpoint is deployed, because the exact callback URL depends on the deployed function.
