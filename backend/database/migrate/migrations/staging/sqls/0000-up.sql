-- the playwright password is playwright
INSERT INTO users (email, password_hash)
SELECT
    'playwright@example.com',
    '$2y$10$MjWEhImHupVLGJrNKILUDedNPUnhPio/cEuRBqj687SK5/ECfYPwK';