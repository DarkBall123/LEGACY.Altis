/*
 * Paste this entire script into the browser console while the ArkHoster
 * "Управление модами" page is open. Select the Arma 3 Launcher HTML preset
 * when prompted. The script searches for every Workshop mod, waits for the
 * matching result, clicks "Добавить", and continues after a short delay.
 *
 * Stop an active run with: window.arkHosterModImporter.stop()
 */
(async () => {
  "use strict";

  const INTERVAL_MS = 3000;
  const READY_TIMEOUT_MS = 15000;
  const RESULT_TIMEOUT_MS = 20000;
  const state = { stopped: false, mods: [] };

  window.arkHosterModImporter?.stop?.();
  window.arkHosterModImporter = {
    stop() {
      state.stopped = true;
      console.warn("[ArkHoster import] Остановка запрошена");
    },
    get mods() {
      return [...state.mods];
    },
  };

  const delay = (milliseconds) =>
    new Promise((resolve) => setTimeout(resolve, milliseconds));

  const choosePreset = () =>
    new Promise((resolve, reject) => {
      const picker = document.createElement("input");
      picker.type = "file";
      picker.accept = ".html,.htm,text/html";
      picker.style.display = "none";
      picker.addEventListener(
        "change",
        () => {
          const [file] = picker.files;
          picker.remove();
          if (file) resolve(file);
          else reject(new Error("HTML-файл не выбран"));
        },
        { once: true },
      );
      document.body.appendChild(picker);
      picker.click();
    });

  const extractMods = (html) => {
    const preset = new DOMParser().parseFromString(html, "text/html");
    const links = preset.querySelectorAll(
      'tr[data-type="ModContainer"] a[href*="steamcommunity.com/sharedfiles/filedetails"]',
    );
    const unique = new Map();

    for (const link of links) {
      try {
        const url = new URL(link.href);
        const id = url.searchParams.get("id");
        if (!/^\d+$/.test(id || "")) continue;
        const row = link.closest('tr[data-type="ModContainer"]');
        const title =
          row?.querySelector('[data-type="DisplayName"]')?.textContent?.trim() ||
          `Workshop ${id}`;
        unique.set(id, { id, title, url: url.href });
      } catch (error) {
        console.warn("[ArkHoster import] Пропущена некорректная ссылка", link.href, error);
      }
    }
    return [...unique.values()];
  };

  const waitForSearchReady = async () => {
    const deadline = Date.now() + READY_TIMEOUT_MS;
    while (Date.now() < deadline) {
      const input = document.querySelector("#search_mods");
      const button = document.querySelector("#buttonSearch");
      if (input && button && !button.disabled) return { input, button };
      await delay(200);
    }
    throw new Error("Поля #search_mods или кнопки #buttonSearch нет/она заблокирована");
  };

  const rowHasModId = (row, id) =>
    [...row.querySelectorAll("td")].some(
      (cell) => cell.textContent.trim() === id,
    );

  const isAlreadyAdded = (id) =>
    [...document.querySelectorAll("#block_EnabledModsList tr")].some((row) =>
      rowHasModId(row, id),
    );

  const waitForAddButton = async (id) => {
    const deadline = Date.now() + RESULT_TIMEOUT_MS;
    while (Date.now() < deadline) {
      if (state.stopped) return null;
      if (isAlreadyAdded(id)) return "already-added";

      const matchingRow = [
        ...document.querySelectorAll("#block_AvailableList tr"),
      ].find((row) => rowHasModId(row, id));
      const addButton = matchingRow?.querySelector(
        'button[onclick*="addModInPreInstall("]',
      );
      if (addButton && !addButton.disabled) return addButton;
      await delay(250);
    }
    throw new Error(`Не найдена кнопка «Добавить» для Workshop ID ${id}`);
  };

  try {
    const file = await choosePreset();
    state.mods = extractMods(await file.text());
    if (!state.mods.length) {
      throw new Error("В выбранном HTML не найдены ссылки Steam Workshop");
    }

    console.log(`[ArkHoster import] Найдено модов: ${state.mods.length}`);
    for (const [index, mod] of state.mods.entries()) {
      if (state.stopped) break;

      if (isAlreadyAdded(mod.id)) {
        console.log(
          `[ArkHoster import] ${index + 1}/${state.mods.length}: уже добавлен — ${mod.title} (${mod.id})`,
        );
        continue;
      }

      const { input, button } = await waitForSearchReady();
      const valueSetter = Object.getOwnPropertyDescriptor(
        HTMLInputElement.prototype,
        "value",
      ).set;
      valueSetter.call(input, mod.id);
      input.dispatchEvent(new InputEvent("input", { bubbles: true, data: mod.id }));
      input.dispatchEvent(new Event("change", { bubbles: true }));
      button.click();

      console.log(`[ArkHoster import] Поиск: ${mod.title} (${mod.id})`);
      const addButton = await waitForAddButton(mod.id);
      if (addButton === null) break;
      if (addButton === "already-added") {
        console.log(
          `[ArkHoster import] ${index + 1}/${state.mods.length}: уже добавлен — ${mod.title} (${mod.id})`,
        );
      } else {
        addButton.click();
        console.log(
          `[ArkHoster import] ${index + 1}/${state.mods.length}: добавлен — ${mod.title} (${mod.id})`,
        );
      }
      if (index + 1 < state.mods.length) await delay(INTERVAL_MS);
    }

    console.log(
      state.stopped
        ? "[ArkHoster import] Остановлено пользователем"
        : "[ArkHoster import] Добавление всех модов завершено",
    );
  } catch (error) {
    console.error("[ArkHoster import] Ошибка:", error);
  }
})();
