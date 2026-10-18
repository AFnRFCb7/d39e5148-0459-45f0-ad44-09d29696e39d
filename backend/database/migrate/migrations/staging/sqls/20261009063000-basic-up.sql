-- The Playwright password for both users is playwright
INSERT INTO users (email, password_hash, admin)
VALUES
    (
        'playwright-regular@example.com',
        '$2y$10$MjWEhImHupVLGJrNKILUDedNPUnhPio/cEuRBqj687SK5/ECfYPwK',
        FALSE
    ),
    (
        'playwright-admin@example.com',
        '$2y$10$MjWEhImHupVLGJrNKILUDedNPUnhPio/cEuRBqj687SK5/ECfYPwK',
        TRUE
    );