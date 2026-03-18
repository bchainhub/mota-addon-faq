# FAQ Addon for MOTA

Adds an FAQ accordion component. When language is **enabled**, it uses translations from `content.faq` (heading + faqs). When language is **disabled**, it uses `modules.faq` from your config (same shape). The addon does **not** merge any config — you define `modules.faq` yourself. Uses MOTA addon CLI (e.g. from [dapp-starter](https://github.com/bchainhub/dapp-starter)).

## Requirements

- SvelteKit project with MOTA addon CLI.
- `$lib/helpers/i18n` and `$lib/helpers/siteConfig`.
- For translations when language is enabled: `src/i18n/<lang>/index.ts` (e.g. typesafe-i18n) and the addon’s `_lang` merge.

## Install

From your project root:

```bash
npx addon <repo> faq install
```

Example:

```bash
npx addon bchainhub/mota-addon-faq faq install
```

### What gets added

- **Component** — `src/lib/components/faq/Faq.svelte` and `src/lib/components/faq/index.ts` (exports `Faq`).
- **Translations** — Merged into `src/i18n/en/index.ts` under `content.faq` (heading + faqs array). English sample only; add other locales as needed.

**Config is not added by the addon.** You must add `modules.faq` in your app config (e.g. in `vite.config.ts` or wherever `getSiteConfig()` reads from). It is used when language is disabled and as fallback when `content.faq` is missing.

After install, run your i18n step if needed (e.g. `npx typesafe-i18n --no-watch`).

### Config (you define it)

Add a `faq` block under the `modules` object your app uses (e.g. in `vite.config.ts`):

```ts
// Example: in vite.config.ts (or wherever getSiteConfig() reads from)
modules: {
  faq: {
    heading: 'FAQ',   // optional; default "FAQ" when language disabled
    faqs: [
      { question: 'Question 1?', answer: 'Answer 1.' },
      { question: 'Question 2?', answer: 'Answer 2.' }
    ]
  }
}
```

- **When language is enabled** — The component uses `content.faq` from i18n (heading + faqs). Add/edit translations per locale.
- **When language is disabled** — The component uses `modules.faq.heading` (optional) and `modules.faq.faqs` from this config. Same shape as the translation structure.

### Using the component

FAQ is always shown (no enabled flag). Import and use `<Faq />` in a route:

```svelte
<script lang="ts">
  import { Faq } from '$lib/components/faq';
</script>

<Faq />
```

Or on a dedicated page, e.g. `src/routes/[[lang]]/faq/+page.svelte`:

```svelte
<script lang="ts">
  import { Faq } from '$lib/components/faq';
</script>

<Faq />
```

### Translation shape (when language enabled)

Translations are merged at `content.faq`:

- `content.faq.heading` — Section title (e.g. "FAQ").
- `content.faq.faqs` — Array of `{ question, answer }`. Add more locales and entries as needed.

## Uninstall

From your project root:

```bash
npx addon <repo> faq uninstall
```

### What gets removed

- The `content.faq` translation block from `src/i18n/en/index.ts`.
- `src/lib/components/faq/Faq.svelte` and `src/lib/components/faq/index.ts`.

Your `modules.faq` config is **not** removed; remove it manually if you want.

Optional flags:

```bash
npx addon <repo> faq uninstall --dry-run
npx addon <repo> faq uninstall --no-translations
npx addon <repo> faq uninstall --no-scripts
```

## Addon options

| Flag | Short | Description |
| --- | --- | --- |
| `--cache` | `-c` | Use cache dir for repo. |
| `--dry-run` | `-d` | No writes; scripts and _lang skipped. |
| `--no-translations` | `-nt` | Skip _lang processing. |
| `--no-scripts` | `-ns` | Skip _scripts execution. |

## Pinning a version

Append `#<ref>` to the repo:

```bash
npx addon bchainhub/mota-addon-faq#v1.0.0 faq install
```

## License

Licensed under the MIT License.
