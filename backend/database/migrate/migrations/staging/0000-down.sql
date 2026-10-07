DELETE FROM users
WHERE email = 'playwright@example.com'
  AND current_setting('app.environment') = 'staging';