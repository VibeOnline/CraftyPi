# Available Symbols in CraftOS

This is the definitive list of all characters available in the CraftOS environment. The agent **MUST ONLY** use these characters in its output. Any character not appearing in this list—including emojis, fancy unicode symbols, or extended ASCII not listed here—will not be rendered correctly and may lead to corrupted display or BIOS-level artifacts.

When generating strings or code intended to be printed to the terminal, the agent should use the **code format** (e.g., `\0`, `\14`) rather than the literal symbol. This ensures that the correct character is emitted regardless of the LLM's encoding or the environment's font handling.

The list below provides the mapping between the standard representation and the internal CraftOS character code.

## Control and Graphic Symbols (0-31)

| Symbol | Code | Description |
| :--- | :--- | :--- |
| `NUL` | `\0` | Null character |
| `☺` | `\1` | Smiling face |
| `☻` | `\2` | Slightly smiling face |
| `♥` | `\3` | Heart |
| `♦` | `\4` | Diamond |
| `♣` | `\5` | Club |
| `♠` | `\6` | Spade |
| `•` | `\7` | Bullet point |
| `◘` | `\8` | Inverted bullet |
| `♂` | `\11` | Male symbol |
| `♀` | `\12` | Female symbol |
| `♪` | `\14` | Eighth note |
| `♫` | `\15` | Beamed eighth notes |
| `►` | `\16` | Right-pointing triangle (arrow) |
| `◄` | `\17` | Left-pointing triangle (arrow) |
| `↕` | `\18` | Up-down arrow |
| `‼` | `\19` | Double exclamation mark |
| `¶` | `\20` | Paragraph sign |
| `§` | `\21` | Section sign |
| `▬` | `\22` | Horizontal bar/dash |
| `↨` | `\23` | Up-down arrow (alternative) |
| `↑` | `\24` | Up arrow |
| `↓` | `\25` | Down arrow |
| `→` | `\26` | Right arrow |
| `←` | `\27` | Left arrow |
| `∟` | `\28` | Right angle (corner) |
| `↔` | `\29` | Left-right arrow |
| `▲` | `\30` | Upward triangle |
| `▼` | `\31` | Downward triangle |

## Standard Punctuation and Symbols (32-126)

| Symbol | Code | Description |
| :--- | :--- | :--- |
| `SP` | `\32` | Space |
| `!` | `\33` | Exclamation mark |
| `"` | `\34` | Double quote |
| `#` | `\35` | Hash / Number sign |
| `$` | `\36` | Dollar sign |
| `%` | `\37` | Percent sign |
| `&` | `\38` | Ampersand |
| `'` | `\39` | Single quote / Apostrophe |
| `(` | `\40` | Left parenthesis |
| `)` | `\41` | Right parenthesis |
| `*` | `\42` | Asterisk |
| `+` | `\43` | Plus sign |
| `,` | `\44` | Comma |
| `-` | `\45` | Hyphen / Minus sign |
| `.` | `\46` | Period / Dot |
| `/` | `\47` | Forward slash |
| `:` | `\58` | Colon |
| `;` | `\59` | Semicolon |
| `<` | `\60` | Less-than sign |
| `=` | `\61` | Equals sign |
| `>` | `\62` | Greater-than sign |
| `?` | `\63` | Question mark |
| `@` | `\64` | At symbol |
| `[` | `\91` | Left square bracket |
| `\` | `\92` | Backslash |
| `]` | `\93` | Right square bracket |
| `^` | `\94` | Caret / Circumflex |
| `_` | `\95` | Underscore |
| `\`` | `\96` | Backtick / Grave accent |
| `{` | `\123` | Left curly brace |
| `|` | `\124` | Vertical bar / Pipe |
| `}` | `\125` | Right curly brace |
| `~` | `\126` | Tilde |

## Extended Character Set (127-255)

These characters include UI elements, box-drawing symbols, and extended Latin characters.

| Symbol | Code | Description |
| :--- | :--- | :--- |
| `🮙` | `\127` | Delete / Control character |
| `EMQ` | `\128` | Custom UI element |
| `🬀` to `🬏` | `\129`-\`\144` | Box-drawing / UI elements |
| `🬐` to `🬗` | `\145`-\`\153` | Box-drawing / UI elements |
| `🬘` to `🬝` | `\154`-\`\159` | Box-drawing / UI elements |
| `▌` | `\149` | Left half-block |
| `NBSP` | `\160` | Non-breaking space |
| `¡` | `\161` | Inverted exclamation mark |
| `¢` | `\162` | Cent sign |
| `£` | `\163` | Pound sign |
| `¤` | `\164` | Currency sign |
| `¥` | `\165` | Yen sign |
| `¦` | `\166` | Broken bar |
| `§` | `\167` | Section sign |
| `¨` | `\168` | Diaeresis / Umlaut |
| `©` | `\169` | Copyright symbol |
| `ª` | `\170` | Feminine ordinal indicator |
| `«` | `\171` | Left-pointing double angle quotation mark |
| `¬` | `\172` | Not sign |
| `SHY` | `\173` | Soft hyphen |
| `®` | `\174` | Registered trademark symbol |
| `¯` | `\175` | Macron |
| `°` | `\176` | Degree symbol |
| `±` | `\177` | Plus-minus sign |
| `²` | `\178` | Superscript two |
| `³` | `\179` | Superscript three |
| `´` | `\180` | Acute accent |
| `µ` | `\181` | Micro sign |
| `¶` | `\182` | Paragraph sign |
| `·` | `\183` | Middle dot |
| `¸` | `\184` | Cedilla |
| `¹` | `\185` | Superscript one |
| `º` | `\186` | Masculine ordinal indicator |
| `»` | `\187` | Right-pointing double angle quotation mark |
| `¼` | `\188` | Quarter fraction |
| `½` | `\189` | Half fraction |
| `¾` | `\190` | Three-quarters fraction |
| `¿` | `\191` | Inverted question mark |
| `À` to `ÿ` | `\192`-\`\255` | Extended Latin characters (Accented) |
