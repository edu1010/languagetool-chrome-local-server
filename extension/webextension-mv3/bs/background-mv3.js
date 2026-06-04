importScripts("../share/tools.js", "../share/markup.js", "common.js");

chrome.runtime.setUninstallURL("https://languagetool.org/webextension/uninstall.php");

function createContextMenu() {
  chrome.commands.getAll(function(commands) {
    let shortcut = "";
    if (commands && commands.length && commands.length > 0 && commands[0].shortcut) {
      shortcut = commands[0].shortcut;
    }
    const title = shortcut ? chrome.i18n.getMessage("contextMenuItemWithShortcut", shortcut) : chrome.i18n.getMessage("contextMenuItem");
    chrome.contextMenus.removeAll(function() {
      chrome.contextMenus.create({"title": title, "contexts":["selection", "editable"], "id": "contextLT"});
    });
  });
}

chrome.runtime.onInstalled.addListener(createContextMenu);

chrome.contextMenus.onClicked.addListener(function() {
  if (chrome.action && chrome.action.openPopup) {
    chrome.action.openPopup(function() {});
  }
});

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  switch (request.action) {
    case "openNewTab": {
      chrome.tabs.create({ url: request.url });
      return false;
    }
    case "getActiveTab": {
      chrome.tabs.query({ active: true, currentWindow: true }, tabs => {
        sendResponse({ action: request.action, tabs });
      });
      return true;
    }
    default: {
      if (request.tabId) {
        chrome.tabs.sendMessage(request.tabId, request, response => {
          sendResponse(response);
        });
        return true;
      }
      sendResponse({ action: `unknown action ${request.action}` });
      return false;
    }
  }
});

chrome.runtime.onConnect.addListener(function(port) {
  if (port.name !== "LanguageTool") {
    return;
  }
  port.onMessage.addListener((msg) => {
    if (msg.action === "checkText") {
      const { markupList, metaData } = msg.data;
      getCheckResult(markupList, metaData, response => {
        port.postMessage({
          action: "checkText",
          success: true,
          result: JSON.parse(response)
        });
      }, (errorMessage) => {
        port.postMessage({
          action: "checkText",
          success: false,
          errorMessage
        });
      });
    }
  });
});
