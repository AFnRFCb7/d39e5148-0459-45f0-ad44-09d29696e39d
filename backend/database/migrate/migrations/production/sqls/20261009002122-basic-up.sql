CREATE TABLE "health-check" (
    marker TEXT NOT NULL
);
INSERT INTO "health-check" (marker) VALUES ('4066203055180760') ;
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    admin BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ;
CREATE TABLE user_auth_providers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider TEXT NOT NULL,
    provider_user_id TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_auth_providers_provider_identity_unique
        UNIQUE (provider, provider_user_id),
    CONSTRAINT user_auth_providers_user_provider_unique
        UNIQUE (user_id, provider)
);
