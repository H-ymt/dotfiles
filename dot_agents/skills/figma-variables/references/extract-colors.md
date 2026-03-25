# カラー抽出スニペット

> Part of the [figma-variables skill](../SKILL.md). ページ内の全 SOLID カラーを収集するスニペット。

## ページ内の全 SOLID カラーを収集

ページ名は実際の対象に置き換えること。

```js
const page = figma.root.children.find(p => p.name === "ページ名");
await figma.setCurrentPageAsync(page);

const colorMap = {};
function rgbToHex(c) {
  const r = Math.round(c.r * 255);
  const g = Math.round(c.g * 255);
  const b = Math.round(c.b * 255);
  return "#" + [r, g, b].map(v => v.toString(16).padStart(2, "0")).join("");
}

page.findAll(n => {
  if ("fills" in n && Array.isArray(n.fills)) {
    for (const f of n.fills) {
      if (f.type === "SOLID" && f.visible !== false) {
        const hex = rgbToHex(f.color);
        if (!colorMap[hex]) colorMap[hex] = { count: 0, nodes: [], source: "fill" };
        colorMap[hex].count++;
        if (colorMap[hex].nodes.length < 3) colorMap[hex].nodes.push(n.name);
      }
    }
  }
  if ("strokes" in n && Array.isArray(n.strokes)) {
    for (const s of n.strokes) {
      if (s.type === "SOLID" && s.visible !== false) {
        const hex = rgbToHex(s.color);
        if (!colorMap[hex]) colorMap[hex] = { count: 0, nodes: [], source: "stroke" };
        colorMap[hex].count++;
      }
    }
  }
  return false;
});

return Object.entries(colorMap)
  .sort((a, b) => b[1].count - a[1].count)
  .map(([hex, info]) => ({ hex, ...info }));
```

## 出力例

```json
[
  { "hex": "#1a1a2e", "count": 47, "nodes": ["Header", "Card/Title", "Nav"], "source": "fill" },
  { "hex": "#e94560", "count": 23, "nodes": ["CTA Button", "Alert Icon"], "source": "fill" },
  { "hex": "#16213e", "count": 12, "nodes": ["Sidebar"], "source": "fill" }
]
```
