document.addEventListener("DOMContentLoaded", function () {
  if (typeof mermaid === "undefined") return;

  mermaid.initialize({ startOnLoad: false, theme: "default" });

  mermaid.run().then(function () {
    document.querySelectorAll(".mermaid svg").forEach(function (svg) {
      // Strip Mermaid's inline max-width constraint
      svg.style.maxWidth = "none";
      svg.style.cursor = "pointer";
      svg.setAttribute("title", "Click to expand");

      // Click to open fullscreen lightbox (pan-zoom lives there, not inline)
      svg.addEventListener("click", function () {
        openDiagramLightbox(svg);
      });
    });
  });
});

function openDiagramLightbox(sourceSvg) {
  // Overlay
  var overlay = document.createElement("div");
  overlay.style.cssText =
    "position:fixed; inset:0; z-index:9999; background:rgba(0,0,0,0.65);" +
    "display:flex; align-items:center; justify-content:center; padding:2rem;";

  // Container for SVG
  var container = document.createElement("div");
  container.style.cssText =
    "width:95vw; height:90vh; background:#aba48e; border:3px solid #249e96;" +
    "border-radius:12px; overflow:hidden; position:relative;";

  // Clone SVG so we don't disturb the inline one
  var clone = sourceSvg.cloneNode(true);
  clone.style.width = "100%";
  clone.style.height = "100%";
  clone.style.maxWidth = "none";
  clone.style.cursor = "grab";
  clone.removeAttribute("title");

  // Close button
  var closeBtn = document.createElement("button");
  closeBtn.textContent = "\u00D7";
  closeBtn.style.cssText =
    "position:absolute; top:0.5rem; right:0.75rem; z-index:10;" +
    "background:none; border:none; color:#e94560; font-size:2rem;" +
    "cursor:pointer; line-height:1;";

  // Hint text
  var hint = document.createElement("div");
  hint.textContent = "Scroll/double-click to zoom \u00B7 Drag to pan \u00B7 ESC to close";
  hint.style.cssText =
    "position:absolute; bottom:0.5rem; left:50%; transform:translateX(-50%);" +
    "color:#666; font-size:0.75rem; pointer-events:none; white-space:nowrap;";

  container.appendChild(clone);
  container.appendChild(closeBtn);
  container.appendChild(hint);
  overlay.appendChild(container);
  document.body.appendChild(overlay);

  // Initialize pan-zoom on the fullscreen clone with scroll zoom enabled
  var pz = null;
  if (typeof svgPanZoom !== "undefined") {
    pz = svgPanZoom(clone, {
      zoomEnabled: true,
      controlIconsEnabled: true,
      zoomScaleSensitivity: 0.1,
      dblClickZoomEnabled: true,
      mouseWheelZoomEnabled: true,
      fit: true,
      center: true
    });
  }

  function close() {
    if (pz) pz.destroy();
    document.body.removeChild(overlay);
    document.removeEventListener("keydown", onKey);
  }

  function onKey(e) {
    if (e.key === "Escape") close();
  }

  closeBtn.addEventListener("click", close);
  overlay.addEventListener("click", function (e) {
    if (e.target === overlay) close();
  });
  document.addEventListener("keydown", onKey);
}
