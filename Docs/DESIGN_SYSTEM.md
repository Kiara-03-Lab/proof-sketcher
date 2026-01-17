# Proof Sketcher Design System

> **Version:** 1.0.0  
> **Last Updated:** 2026-01-17  
> **Purpose:** Design tokens, component guidelines, and accessibility standards for Proof Sketcher UI components

---

## Color Tokens

### Base Colors

- **White**: `#FFFFFF` — primary background
- **Gray-100**: `#F5F5F5` — subtle backgrounds
- **Gray-300**: `#D1D5DB` — borders, dividers
- **Gray-500**: `#6B7280` — placeholder text
- **Gray-700**: `#374151` — secondary text
- **Gray-900**: `#111827` — primary text

### Accent Colors

- **Red**: `#DC2626` — primary CTA, errors, destructive actions
- **Orange**: `#F97316` — secondary CTA, highlights, badges
- **Green**: `#16A34A` — success states
- **Blue**: `#2563EB` — links, info states

---

## Color Hierarchy

Use color intentionally to create clear visual hierarchy:

- **White/Gray → Structure (80–90%)**: Use neutral grays for backgrounds, text, and borders to establish the foundational layout
- **Red → Action/Danger (sparingly)**: Reserve red for primary calls-to-action and critical/destructive actions
- **Orange → Support/Promotion**: Use orange for secondary actions, highlights, and promotional badges
- **Green → Success/Confirmation**: Apply green to success messages and confirmation states
- **Blue → Links/Info**: Use blue for hyperlinks and informational states

**Key principle:** If everything pops, nothing matters. Use accent colors purposefully and sparingly.

---

## Component States

All interactive components should support these standard states:

### Default State
Base appearance with no user interaction

### Hover State
**Visual change:** 10% darker shade or subtle opacity shift  
**Cursor:** Pointer for clickable elements

### Active/Pressed State
**Visual change:** 20% darker shade  
**Applies to:** Buttons, clickable cards, interactive elements during click/press

### Disabled State
**Background:** Gray-300 (`#D1D5DB`)  
**Text color:** Gray-500 (`#6B7280`)  
**Cursor:** Default (no pointer)  
**Opacity:** Optional 60% on entire element

### Focus State
**Ring:** 2px solid border/outline  
**Color:** Blue (`#2563EB`) or inherit current component color  
**Offset:** 2px from element edge  
**Required:** All interactive elements must have visible focus state for accessibility

---

## Button Rules

### Primary CTA Button
- **Background:** Red (`#DC2626`)
- **Text color:** White (`#FFFFFF`)
- **Use case:** Main action on page (e.g., "Submit Proof", "Create Theorem")
- **Limit:** Only one primary button per section/action group

### Secondary CTA Button
- **Background:** Orange (`#F97316`)
- **Text color:** White (`#FFFFFF`)
- **Use case:** Supporting actions (e.g., "Save Draft", "Add Milestone")

### Tertiary Button
- **Background:** Transparent
- **Border:** 1px solid Gray-300 (`#D1D5DB`)
- **Text color:** Gray-900 (`#111827`)
- **Use case:** Low-emphasis actions (e.g., "Cancel", "Skip")

### Destructive Button
- **Style 1 (Outlined):** Red (`#DC2626`) border, transparent background, red text
- **Style 2 (Filled):** Red background, white text
- **Use case:** Dangerous actions requiring confirmation (e.g., "Delete Proof", "Clear All")
- **Context:** Use outlined for initial state, filled for confirmation dialogs

### Button Constraints
- **Never use red and orange buttons in the same action group** — creates visual confusion about priority
- **Touch targets:** Minimum 44×44px for accessibility
- **Padding:** At least `sm` (8px) vertical, `md` (16px) horizontal

---

## Typography

### Font Family
**Primary:** System font stack or specify: `Inter`, `Noto Sans`, or similar
```css
font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica', 'Arial', sans-serif;
```

### Type Scale

| Element | Size | Weight | Color | Use Case |
|---------|------|--------|-------|----------|
| **H1** | 2rem (32px) | Bold (700) | Gray-900 | Page titles |
| **H2** | 1.5rem (24px) | Semibold (600) | Gray-900 | Section headers |
| **H3** | 1.25rem (20px) | Medium (500) | Gray-900 | Subsection headers |
| **Body** | 1rem (16px) | Regular (400) | Gray-900 | Default text |
| **Secondary** | 0.875rem (14px) | Regular (400) | Gray-700 | Supporting text, labels |
| **Caption** | 0.75rem (12px) | Regular (400) | Gray-500 | Metadata, timestamps |

### Line Height
- **Headings:** 1.2
- **Body text:** 1.5
- **Code blocks:** 1.6

---

## Spacing Scale

**Base unit:** 4px

| Token | Value | Use Case |
|-------|-------|----------|
| `xs` | 4px | Tight spacing, icon padding |
| `sm` | 8px | Small gaps, compact layouts |
| `md` | 16px | Default spacing between elements |
| `lg` | 24px | Section spacing |
| `xl` | 32px | Large section breaks |
| `2xl` | 48px | Major section dividers |

**Application:**
- Use consistent spacing tokens throughout
- Avoid arbitrary pixel values
- Stack spacing: prefer margin-bottom over margin-top for consistency

---

## Borders & Radius

### Borders
- **Default color:** Gray-300 (`#D1D5DB`)
- **Default width:** 1px
- **Focus/Active:** Blue (`#2563EB`) or accent color, 2px

### Border Radius

| Token | Value | Use Case |
|-------|-------|----------|
| `sm` | 4px | Buttons, inputs, small cards |
| `md` | 8px | Cards, modals, panels |
| `lg` | 12px | Large cards, feature sections |
| `full` | 9999px | Pills, tags, circular buttons |

---

## Shadows/Elevation

Use shadows sparingly to indicate elevation and interactivity:

| Level | CSS Value | Use Case |
|-------|-----------|----------|
| **sm** | `0 1px 2px rgba(0,0,0,0.05)` | Subtle lift for inputs, small cards |
| **md** | `0 4px 6px rgba(0,0,0,0.1)` | Default cards, dropdowns |
| **lg** | `0 10px 15px rgba(0,0,0,0.1)` | Modals, popovers, floating panels |

**Guidelines:**
- Don't stack multiple shadow levels on same element
- Shadows should be subtle and consistent with light source (top-down)
- Consider removing shadows in dark mode

---

## Form Inputs

### Default State
- **Background:** White (`#FFFFFF`)
- **Border:** 1px solid Gray-300 (`#D1D5DB`)
- **Text color:** Gray-900 (`#111827`)
- **Placeholder:** Gray-500 (`#6B7280`)
- **Padding:** `sm` (8px) vertical, `md` (16px) horizontal

### Focus State
- **Border:** 2px solid Blue (`#2563EB`)
- **Ring:** Optional 2px Blue ring with offset
- **Text color:** Gray-900 (`#111827`)

### Error State
- **Border:** 2px solid Red (`#DC2626`)
- **Error message:** Red text below input, 0.875rem size
- **Icon:** Optional error icon (red) at input end

### Success State
- **Border:** 2px solid Green (`#16A34A`) (optional)
- **Use sparingly:** Only when explicit confirmation is helpful

### Disabled State
- **Background:** Gray-100 (`#F5F5F5`)
- **Border:** Gray-300 (`#D1D5DB`)
- **Text color:** Gray-500 (`#6B7280`)
- **Cursor:** Not-allowed

---

## Links

### Default State
- **Color:** Blue (`#2563EB`)
- **Underline:** Optional (recommended for body text, optional for navigation)
- **Font weight:** Inherit from parent

### Hover State
- **Color:** Darker blue (darken by ~10%)
- **Underline:** Always show on hover
- **Cursor:** Pointer

### Visited State
- **Color:** Optional purple or same as default
- **Context-dependent:** Use visited state for documentation links, skip for app navigation

### Active/Pressed State
- **Color:** Even darker blue (darken by ~20%)

**Accessibility note:** Never use color alone to indicate links in body text — always include underline or another visual indicator.

---

## Icons

### Default Icons (Non-interactive)
- **Color:** Gray-700 (`#374151`)
- **Size:** 16px or 20px (match adjacent text size)

### Interactive Icons
- **Color:** Inherit from parent button/link color
- **Hover:** Same state changes as parent component

### Decorative Icons
- **Color:** Gray-500 (`#6B7280`)
- **Use case:** Non-essential visual enhancement
- **Accessibility:** Add `aria-hidden="true"` to decorative icons

**Guidelines:**
- Use consistent icon set (e.g., Heroicons, Lucide, Feather)
- Icons should have 1:1 aspect ratio
- Provide text alternatives for meaningful icons

---

## Accessibility

### Contrast Requirements
- **Normal text (< 18px):** Minimum 4.5:1 contrast ratio
- **Large text (≥ 18px or ≥ 14px bold):** Minimum 3:1 contrast ratio
- **UI components:** Minimum 3:1 contrast ratio

### Color Usage
- **Never rely on color alone** to convey information
- Always pair color with text labels, icons, or patterns
- Test designs in grayscale to ensure information hierarchy remains clear

### Focus Indicators
- **All interactive elements** must have visible focus state
- Focus indicators must have 3:1 contrast against background
- Never remove focus outlines without providing alternative focus indicators

### Color Blindness
- Test all designs with protanopia (red-blind) and deuteranopia (green-blind) simulators
- Red-green combinations should always include additional indicators (icons, labels, patterns)

### Touch Targets
- **Minimum size:** 44×44px for all interactive elements
- **Spacing:** Minimum 8px between adjacent touch targets

### Screen Readers
- Use semantic HTML (`<button>`, `<a>`, `<nav>`, etc.)
- Provide descriptive `aria-label` for icon-only buttons
- Use proper heading hierarchy (`<h1>` → `<h2>` → `<h3>`)

---

## Dark Mode

### Color Swaps
- **Background:** Swap White (`#FFFFFF`) ↔ Gray-900 (`#111827`)
- **Text:** Swap Gray-900 (`#111827`) ↔ White (`#FFFFFF`)
- **Borders:** Use Gray-700 (`#374151`) instead of Gray-300

### Accent Colors
- **Red:** Use lighter variant `#EF4444` (reduce intensity)
- **Orange:** Use lighter variant `#FB923C` (reduce intensity)
- **Green:** Use lighter variant `#22C55E` (maintain visibility)
- **Blue:** Use lighter variant `#3B82F6` (maintain visibility)

### Shadows
- **Reduce intensity** or remove shadows entirely
- If needed, use subtle shadows with lighter colors: `0 4px 6px rgba(255,255,255,0.05)`

### Testing
- **Re-test contrast ratios** in dark mode
- Ensure all text meets WCAG AA standards
- Check that focus indicators remain visible

---

## Hard Rules

### ❌ Prohibited Patterns

1. **No colored large backgrounds**
   - Large sections (> 50% viewport) must use White/Gray tones
   - Accent colors only for small components (buttons, badges, alerts)

2. **No red + orange in same action group**
   - Mixing primary (red) and secondary (orange) CTAs creates confusion
   - Choose one accent color per action group

3. **No color as sole information carrier**
   - Always pair color with text, icons, or patterns
   - Example: Error states must have red border AND error text/icon

4. **No focus outline removal without replacement**
   - Removing `:focus` outline without alternative is accessibility violation
   - If custom focus style, ensure 3:1 contrast

5. **No text smaller than 12px**
   - Minimum 12px (0.75rem) for captions
   - Prefer 14px (0.875rem) minimum for body text

### ✅ Best Practices

1. **If everything pops, nothing matters**
   - Use accent colors sparingly (< 20% of UI)
   - Let whitespace and typography carry the design

2. **Consistency over customization**
   - Use design tokens; avoid one-off values
   - If you need a new token, consider if it's truly necessary

3. **Progressive enhancement**
   - Design for grayscale first, add color last
   - Ensure functionality works without JavaScript

4. **Test early, test often**
   - Use browser DevTools to simulate color blindness
   - Test keyboard navigation on every feature
   - Validate HTML and accessibility with automated tools

---

## Implementation Notes

### CSS Custom Properties Example

```css
:root {
  /* Colors */
  --color-white: #FFFFFF;
  --color-gray-100: #F5F5F5;
  --color-gray-300: #D1D5DB;
  --color-gray-500: #6B7280;
  --color-gray-700: #374151;
  --color-gray-900: #111827;
  --color-red: #DC2626;
  --color-orange: #F97316;
  --color-green: #16A34A;
  --color-blue: #2563EB;
  
  /* Spacing */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;
  --space-2xl: 48px;
  
  /* Border Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
}

/* Dark mode overrides */
@media (prefers-color-scheme: dark) {
  :root {
    --color-white: #111827;
    --color-gray-900: #FFFFFF;
    --color-red: #EF4444;
    --color-orange: #FB923C;
    --color-green: #22C55E;
    --color-blue: #3B82F6;
  }
}
```

### Usage Example

```css
.button-primary {
  background-color: var(--color-red);
  color: var(--color-white);
  padding: var(--space-sm) var(--space-md);
  border-radius: var(--radius-sm);
  font-size: 1rem;
  font-weight: 500;
}

.button-primary:hover {
  background-color: #B91C1C; /* 10% darker */
}

.button-primary:active {
  background-color: #991B1B; /* 20% darker */
}

.button-primary:focus {
  outline: 2px solid var(--color-blue);
  outline-offset: 2px;
}

.button-primary:disabled {
  background-color: var(--color-gray-300);
  color: var(--color-gray-500);
  cursor: not-allowed;
}
```

---

## Changelog

### Version 1.0.0 (2026-01-17)
- Initial design system specification
- Defined color tokens and hierarchy
- Established component states and button rules
- Documented typography, spacing, and accessibility standards
- Added dark mode guidelines and hard rules

---

## References

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [ColorBlind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)

---

*Designed for clarity, built for mathematicians* 📐
