# The Design System: Editorial Cartography

## 1. Overview & Creative North Star
**The Creative North Star: "The Modern Wayfinder"**

This design system is not a utility; it is a premium curation tool. It rejects the "utility-first" aesthetic of standard data-tracking apps in favor of a **High-End Editorial** experience. We aim to transform cold metadata—coordinates, timestamps, and flight numbers—into a rich, cinematic narrative.

The "Modern Wayfinder" aesthetic relies on **intentional asymmetry** and **tonal depth**. Rather than placing elements in a rigid, boxed grid, we use overlapping layers and extreme typographic scale to guide the eye. Imagine a luxury travel magazine meets a high-tech flight deck: sophisticated, breathable, and authoritative.

---

## 2. Colors & Surface Logic
The palette is rooted in the deep authority of Navy and the kinetic energy of Teal. However, the secret to a "custom" feel lies in how we layer these tones.

### The "No-Line" Rule
**Explicit Instruction:** 1px solid borders for sectioning are strictly prohibited. 
Visual boundaries must be achieved exclusively through:
*   **Tonal Shifts:** Placing a `surface-container-low` section against a `surface` background.
*   **Negative Space:** Using the Spacing Scale to create "islands" of content.
*   **Shadow Transitions:** Subtle, diffused depth rather than hard strokes.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of fine paper or frosted glass.
*   **Base:** `surface` (#f9f9f9) is your canvas.
*   **Layout Sections:** Use `surface-container` (#eeeeee) for large structural areas.
*   **Interactive Cards:** Use `surface-container-lowest` (#ffffff) to make content "pop" forward naturally.
*   **Floating Elements:** Use `primary-container` (#1a237e) for high-impact metadata overlays, ensuring the `on-primary-container` text is legible.

### The "Glass & Gradient" Rule
To elevate the experience above a standard template:
*   **Glassmorphism:** For overlays (like map legends or video controls), use semi-transparent `surface` colors with a `backdrop-filter: blur(20px)`.
*   **Signature Textures:** Apply a subtle linear gradient from `primary` (#000666) to `primary-container` (#1a237e) for hero CTAs. This creates a "deep ink" effect that feels more premium than a flat fill.

---

## 3. Typography
We utilize a pairing of **Plus Jakarta Sans** for expressive displays and **Manrope** for technical data.

*   **Display (Plus Jakarta Sans):** Used for city names and trip titles. The `display-lg` (3.5rem) should be used with tight letter-spacing to create a "masthead" feel.
*   **Headlines (Plus Jakarta Sans):** `headline-md` (1.75rem) serves as the primary anchor for metadata sections.
*   **Body & Labels (Manrope):** `body-md` (0.875rem) handles the heavy lifting of travel logs. Its geometric clarity ensures legibility even at small sizes.
*   **Data Labels (Manrope):** `label-sm` (0.6875rem) in `all-caps` with 5% letter-spacing should be used for technical metadata (e.g., "LAT/LONG", "ALTITUDE").

---

## 4. Elevation & Depth
Hierarchy is conveyed through **Tonal Layering**, not structural lines.

*   **The Layering Principle:** Depth is "stacked." A card (`surface-container-lowest`) sitting on a sidebar (`surface-container-low`) creates a soft, natural lift.
*   **Ambient Shadows:** For "floating" video players or modals, use a shadow with a 40px-60px blur at 6% opacity. Use a tint of `primary` for the shadow color to avoid a "dirty" grey look.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use `outline-variant` (#c6c5d4) at **15% opacity**. It should be felt, not seen.
*   **Roundedness:** Stick to the `md` (0.75rem/12px) for cards and `full` (9999px) for pill buttons to maintain the "travel-inspired" softness.

---

## 5. Components

### Buttons
*   **Primary:** Gradient fill (`primary` to `primary-container`), `full` roundedness, `title-sm` typography.
*   **Secondary:** `surface-container-highest` background with `primary` text. No border.
*   **Tertiary:** Ghost style; text only in `secondary` (#006b5c) with an underline that appears only on hover.

### Cards & Lists
*   **Rule:** Never use divider lines. 
*   **Data Lists:** Group metadata using `spacing-4` (1rem) gaps. Use `surface-container-low` as a background for every second item to create a "zebra" effect without harsh lines.
*   **Travel Cards:** Use `xl` (1.5rem) corner radius for image-heavy cards to create a modern, cinematic frame.

### Media Controls (Short-Form Video)
*   **Controls:** Floating glassmorphic bar using `backdrop-blur` and a `surface` fill at 70% opacity.
*   **Icons:** Use vibrant `secondary` (#00BFA5) for active states (Play/Pause) to mimic glowing map markers.

### Metadata Chips
*   **Selection Chips:** Use `secondary-fixed` (#68fadd) for active filters to provide a high-contrast "vibrant map" energy against the `primary` navy.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical margins (e.g., a wider left margin than right) for headers to mimic editorial layouts.
*   **Do** lean into the `tertiary` (#380b00) tones for error states or "Stop" locations; it feels more sophisticated than a standard bright red.
*   **Do** use `primary-fixed-dim` (#bdc2ff) for secondary text on dark backgrounds to maintain a high-end "monotone" look.

### Don't
*   **Don't** use 100% black (#000000). Always use `on-surface` (#1a1c1c) for text to keep the "ink on paper" feel.
*   **Don't** use standard 4px corners. Stay within the `8px-12px` (sm/md) range to maintain the friendly, travel-inspired softness.
*   **Don't** crowd the interface. If a screen feels busy, increase the spacing from `spacing-4` to `spacing-8`. Space is a luxury; use it.