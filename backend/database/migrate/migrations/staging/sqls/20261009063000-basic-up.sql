-- The Playwright password for both users is playwright
INSERT INTO users (email, password_hash, admin)
VALUES
    (
        'playwright-english@example.com',
        '$2b$10$8magse9B2Gbj49hFHjiuSeGu8za6gGmPucg4.3MZjVe6pQLnO/gPC',
        FALSE
    ),
    (
        'playwright-chinese@example.com',
        '$2b$10$8magse9B2Gbj49hFHjiuSeGu8za6gGmPucg4.3MZjVe6pQLnO/gPC',
        FALSE
    ),
    (
        'playwright-admin@example.com',
        '$2b$10$M8LHn9MJroOdspbmsV/m9uib5zJOEhWC/3WLiatsprmp9hqfhBRT6',
        TRUE
    );