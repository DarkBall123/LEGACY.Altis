# extDB3 для LEGACY.Altis (опционально)

Миссия хранит прогресс (сектора, лодауты, ассеты, трофейные ящики,
финансы, репутацию) через слой `DZ_fnc_store*` (см.
`functions/fn_storeInit.sqf`). Бэкенда два:

- **profileNamespace** (по умолчанию) — работает везде, ничего ставить
  не нужно. Данные живут в `*.vars.Arma3Profile` профиля сервера.
  Если хостинг чистит профиль между рестартами — прогресс теряется,
  и тогда нужен extDB3.
- **extDB3** — реальная БД. Включается автоматически, если расширение
  отвечает на `9:VERSION` при старте сервера.

Эти файлы **не входят в PBO** и деплоятся на игровой сервер вручную.

## Установка

1. Скачать `@extDB3` (https://github.com/SteezCram/extDB3 или форк под
   вашу платформу) и положить в корень сервера. Запускать сервер с
   `-servermod=@extDB3`.
2. `extdb3-conf.ini.example` → скопировать в корень сервера как
   `extdb3-conf.ini`. Рекомендуемый Type = SQLite (MySQL не нужен).
3. `sql_custom/legacy_store.ini` → положить в `@extDB3/sql_custom_v2/`.
4. Создать таблицу из `schema.sql` (для SQLite:
   `sqlite3 legacy_altis.sqlite3 < schema.sql`).
5. Перезапустить сервер и проверить RPT:
   - `[DZ_STORE] backend=extdb3` — расширение найдено;
   - `[DZ_STORE] Migrated N keys from profileNamespace to extDB3` —
     одноразовый импорт старых данных (только если БД пуста);
   - `[DZ_STORE] backend=profile` — расширение не найдено/не настроено,
     миссия продолжает работать на profileNamespace.

## Диагностика

- `[DZ_STORE] extDB3 database setup failed (...)` — проверить секцию
  `[legacy_altis]` в `extdb3-conf.ini`.
- `[DZ_STORE] extDB3 protocol setup failed (...)` — проверить, что
  `legacy_store.ini` лежит в `@extDB3/sql_custom_v2/`. Синтаксис опций
  SQL_CUSTOM при ошибках сверять с вики extDB3 вашей версии.
- `[DZ_STORE] DB write failed for '...' — mirrored to profileNamespace`
  — БД отвалилась посреди сессии; записи дублируются в профиль, данные
  не теряются, но бэкенды расходятся (см. ниже).
- `[DZ_STORE] WARNING: storage backend changed since last run` — на
  прошлом старте был другой бэкенд: данные могли разойтись. Решить,
  какой источник истинный, и при необходимости очистить таблицу
  `kv_store` (тогда при следующем старте пройдёт повторная миграция из
  профиля).

## Формат данных

Таблица `kv_store(k, i, v)`: ключ (lower-case), номер чанка, чанк
сериализованного значения. Значения — SQF-массивы, сериализованные
`str` и экранированные для colon-протокола (`~`→`~t`, `:`→`~c`,
`"`→`~q`, `'`→`~a`), порезанные по 8000 символов.
