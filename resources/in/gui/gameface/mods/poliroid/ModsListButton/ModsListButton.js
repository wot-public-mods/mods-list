
// Determines if the button should work in standalone mode (login screen)
// by checking if #root has 'standalone' attribute, otherwise integrates into lobby
const standalone = document.getElementById("root")?.hasAttribute("standalone") || false;

// Import required libraries
import { MediaContext } from "../../libs/media.js";
import { ModelObserver } from "../../libs/model.js";
import { playSound } from "../../libs/sound.js";
import { showPopover, showTooltip, hideTooltip } from "../../libs/views.js";

// Initialize media context (provides screen size and scale info)
const media = MediaContext(standalone);

// Create model observer
const model = ModelObserver(standalone ? 0 : "ModsListButton");

/**
 * Updates the style and state of the mods button based on screen dimensions,
 * scale factor, and whether there are active alerts.
 */
const updateButton = () => {
    // Find button element in DOM
    const button = document.querySelector(".modsButton");
    if (!button) return;

    // Hide button if there are no mods
    button.style.display = model.model.modsCount > 0 ? "block" : "none";

    // Check current layout conditions
    const isMediumScreen = media.width > 1366;
    const isHighlighted = model.model.alerts;

    // Decide icon size and sprite offset depending on state
    const layout = isHighlighted
        ? media.scale > 1
            ? { width: 128, height: 128, x: 200, y: 300 }
            : isMediumScreen
              ? { width: 64, height: 64, x: 225, y: 160 }
              : { width: 48, height: 48, x: 230, y: 60 }
        : media.scale > 1
          ? { width: 64, height: 64, x: 40, y: 230 }
          : isMediumScreen
            ? { width: 32, height: 32, x: 55, y: 140 }
            : { width: 24, height: 24, x: 60, y: 60 };

    // Apply icon layout (sprite position + size)
    const image = button.querySelector(".modsIcon");
    if (image) {
        image.style.backgroundPositionX = `-${layout.x}px`;
        image.style.backgroundPositionY = `-${layout.y}px`;
        image.style.width = `${layout.width}px`;
        image.style.height = `${layout.height}px`;
    }

    // Update alert bubble visibility and value
    const buble = button.querySelector(".modsBuble");
    if (buble) {
        buble.style.opacity = isHighlighted ? 1 : 0;
        buble.querySelector(".modsBubleValue").textContent = model.model.alerts;
    }

    // In login window skip positioning logic
    if (standalone) {
        return;
    }

    // Adjust right margin depending on user custom scale
    // (only for fractional scale between 1x and 2x)
    if (media.scale > 1 && media.scale < 2) {
        const offset = media.width * media.scale < 1366 ? 30 : 15;
        const padding = 6 + offset / media.scale;
        button.style.marginRight = `${padding}rem`;
    } else {
        button.style.marginRight = "6rem";
    }
};

/**
 * Creates and returns a configured mods button element
 * (including icon, bubble, events, and interactivity).
 */
const createButton = () => {
    // Create main button container
    const button = document.createElement("div");
    button.className = "modsButton";

    // Handle button click
    button.addEventListener("click", () => {
        model.model.onButtonClick({ standalone });
        playSound("play");
        hideTooltip();
        showPopover(button, "ModsListPopover");
    });

    // Handle hover (tooltip + sound)
    button.addEventListener("mouseenter", () => {
        playSound("highlight");
        showTooltip(model.model.title, model.model.description);
    });

    // Handle hover (tooltip)
    button.addEventListener("mouseleave", () => {
        hideTooltip();
    });

    // Create icon sprite holder
    const image = document.createElement("div");
    image.className = "modsIcon";

    // Create bubble (alerts indicator)
    const buble = document.createElement("div");
    buble.className = "modsBuble";

    const bubleWrapper = document.createElement("div");
    bubleWrapper.className = "modsBubleWrapper";
    buble.appendChild(bubleWrapper);

    const bubleValue = document.createElement("div");
    bubleValue.className = "modsBubleValue";
    bubleWrapper.appendChild(bubleValue);

    button.appendChild(image);
    button.appendChild(buble);

    return button;
};

// Initialize UI logic once the engine is fully ready
engine.whenReady.then(() => {
    // Keep button in sync with media changes (resize/scale)
    media.onUpdate(() => {
        updateButton();
    });
    media.subscribe();

    // Keep button in sync with model changes (alerts count etc.)
    model.onUpdate(() => {
        updateButton();
    });
    model.subscribe();

    // Case 1: Standalone (login screen) -> attach button to media-wrapper
    if (standalone) {
        const wrapper = document.querySelector(
            "div.media-wrapper"
        );
        wrapper.appendChild(createButton());
        updateButton();
        return;
    }

    // Case 2: Lobby -> attach button to footer menu
    // Use MutationObserver to re-attach if UI is rebuilt
    const observer = new MutationObserver(() => {
        const gameMenuButton = document.querySelector(
            'div[data-test-id="menu"]',
        );
        const footerSection = gameMenuButton?.parentNode;
        if (
            gameMenuButton &&
            footerSection &&
            !footerSection.querySelector(".modsButton")
        ) {
            footerSection.insertBefore(createButton(), gameMenuButton);
            updateButton();
        }
    });

    observer.observe(document.body, { childList: true, subtree: true });
});
