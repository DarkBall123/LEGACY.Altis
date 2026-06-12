-- Key-value store schema for the LEGACY.Altis persistence layer.
-- One row per value chunk (values longer than ~8000 chars are split by
-- the mission; see fn_storeInit.sqf).
--
-- MySQL / MariaDB:
CREATE TABLE IF NOT EXISTS kv_store (
    k VARCHAR(191) NOT NULL,
    i INT          NOT NULL DEFAULT 0,
    v MEDIUMTEXT   NOT NULL,
    PRIMARY KEY (k, i)
);

-- SQLite variant (extDB3 creates the file automatically; run this once
-- e.g. with `sqlite3 legacy_altis.sqlite3 < schema.sql`):
-- CREATE TABLE IF NOT EXISTS kv_store (
--     k TEXT NOT NULL,
--     i INTEGER NOT NULL DEFAULT 0,
--     v TEXT NOT NULL,
--     PRIMARY KEY (k, i)
-- );
