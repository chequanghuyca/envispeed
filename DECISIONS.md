# Envispeed — chỉ mục quy tắc gõ

Các quyết định hành vi và mã Dxx được giữ để đối chiếu với `Tools/autoswitch/rules/`. Việc đổi thương hiệu không thay đổi thuật toán, ngưỡng nhận diện hay dữ liệu của engine.

Tài liệu này là chỉ mục kỹ thuật, không phải lịch sử quản lý dự án. Bản đầy đủ trước khi dọn repo được lưu trong bản sao ngoài workspace. Thông báo nguồn gốc và giấy phép thành phần được giữ tại `ACKNOWLEDGEMENTS.md`.

| Mã | Hành vi / phạm vi |
|---|---|
| D59 | ":" and ";" after a space stay where they are (phone keyboards) |
| D58 | "docs" in Vietnamese mode is English |
| D57 | Backspace over punctuation lost the word before it |
| D56 | Telex style: Telex, Simple Telex 1, Simple Telex 2 |
| D55 | Linux: an Arch Linux package |
| D54 | Linux: pre-edit in apps that never report the text around the cursor |
| D53 | Teencode spelling (engine, off by default) |
| D52 | Two keys that deleted the character before the word |
| D51 | ← → back to the same spot keeps the word |
| D50 | Backspace on a toned letter takes all its keys |
| D49 | Backspace never reopens a word from before a language switch |
| D48 | Lowercase "os" in Vietnamese is "ó" |
| D46 | Linux: no per-website memory, no automatic install (approved) |
| D45 | Linux catches up with the Mac app |
| D44 | Windows catches up with the Mac (parity pass) |
| D43 | Ứng dụng macOS: định danh, giao diện và phạm vi tính năng |
| D42 | Acronyms don't flip the word before them |
| D41 | A lone all-caps word converts when Telex marks it |
| D40 | "sê" is not a Vietnamese word |
| D39 | DD counts as one capital (Đ) |
| D38 | Ứng dụng macOS: định danh, giao diện và phạm vi tính năng |
| D37 | Capitalised names mid-sentence: tried, not shipped |
| D36 | Ứng dụng macOS: định danh, giao diện và phạm vi tính năng |
| D35 | Look forward: the next word can flip a word put back to English |
| D34 | Longer context for ties: word pairs beat D22; triples not worth it |
| D33 | Words after digits |
| D32 | Backspace undo, then typing on |
| D31 | Website in English; brand guideline |
| D30 | Word pairs decide ties |
| D29 | Tuning set vs locked test set, mixed across topics |
| D28 | Web Vietnamese data; Early Switch rejected |
| D27 | Chat frequencies and VietMix fixes (Mac + iOS engine) |
| D26 | Auto-correct and the suggestion strip on iOS |
| D25 | Fat-finger model on iOS |
| D24 | Performance is locked by tests |
| D23 | Capitals, Caps Lock Vietnamese and Wi-Fi |
| D22 | Ties: frequency ratio decides, a clearly English neighbor guards |
| D21 | Pause auto switch for 5 seconds after a manual switch |
| D20 | Words after ( and ", and no Backspace undo for multi-word fixes |
| D19 | Doubled tone key: Telex result by default, the dictionary decides at the end of the word |
| D18 | "mĩ" + x gives "mix", not "mixx" |
| D17 | Doubled tone key restores every key; no vanishing text |
| D16 | Auto update |
| D15 | Per-site memory off by default, (?) on every option, debug menu hidden |
| D14 | Quotes and apostrophes end a word |
| D13 | Catch "thí makes" one word sooner |
| D12 | Typing log is an opt-in debug feature; credits in the About window |
| D11 | Cửa sổ gọn và nguồn phát hành ứng dụng |
| D10 | Ứng dụng macOS: định danh, giao diện và phạm vi tính năng |
| D9 | Typos must not flip the language |
| D8 | Tuning with a mixed-text typing simulation |
| D7 | Typing log to measure and tune auto-switch |
| D6 | Auto-switch must not touch programming words |
| D5 | Auto-switch language from correction behavior |
| D4 | Learned (neural-network) switching |
| D3 | Smart switch remembers the language per website |
| D2 | Take the good parts of upstream PR #333 |
| D1 | The app stops typing until restarted |
