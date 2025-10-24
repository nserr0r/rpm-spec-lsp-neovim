# 🧩 rpm-spec-lsp-neovim

Конфигурация LSP-клиента **Neovim** для работы с rpm-spec-lsp — языковым сервером, обеспечивающим поддержку **RPM SPEC-файлов**: подсветку, автодополнение, диагностику и форматирование.

---

## 🚀 Назначение

Плагин регистрирует сервер `rpm-spec-lsp` в системе LSP Neovim и подключает его к файлам с расширением `.spec`.  
Вся логика и функциональность реализованы на стороне сервера.

---

## ⚙️ Установка

1. Установи бинарь сервера **rpm-spec-lsp** (из исходников или пакета).
2. Установи плагин **nvim-lspconfig** (через `packer`, `lazy.nvim` или любую другую систему).
3. Скопируй файл `rpm-spec-lsp-neovim.lua` в `~/.config/nvim/lua/lsp/`.
4. Добавь `require("lsp.rpm-spec-lsp-neovim").setup()` в `init.lua`.

Или создай конфиг для lazy.nvim:

```bash
mkdir -p ~/.config/nvim/lua/plugins && \
cat > ~/.config/nvim/lua/plugins/rpm-spec-lsp-neovim.lua <<'EOF_LAZY'
return {
  {
    "nserr0r/rpm-spec-lsp-neovim",
    lazy = false,
    build = false,
    config = function()
      require("lsp.rpm-spec-lsp-neovim").setup()
    end,
  },
}
EOF_LAZY
```

---

## 🪄 Команды

Список доступных команд формируется **LSP-сервером**.  
Клиент получает и регистрирует их автоматически.

---

## ⌨️ Горячие клавиши

По умолчанию горячих клавиш нет.  
Если нужно вызвать смену профиля, добавь в `init.lua`:

```
vim.keymap.set("n", "<leader>rp", function()
    vim.lsp.buf.execute_command({ command = "rpm-spec.changeProfile" })
end, { desc = "Сменить профиль SPEC LSP" })

```

---

## 🧠 Требования

- **nvim-lspconfig**
- Установленный `rpm-spec-lsp`

---

## 👤 Автор

🪪 Alexander Arsentev  
📧 nserr0r@gmail.com  
🔗 https://github.com/nserr0r

---

## 📜 Лицензия

Проект распространяется под лицензией **Apache-2.0**
