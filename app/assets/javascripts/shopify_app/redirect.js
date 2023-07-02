//= require ./app_bridge_redirect.js

(function () {
  function redirect() {
    var redirectTargetElement = document.getElementById("redirection-target");

    if (!redirectTargetElement) {
      return;
    }

    var targetInfo = JSON.parse(redirectTargetElement.dataset.target);

    var appBridgeUtils = window['app-bridge']['utilities'];

    // IMPORTANT: The code below wasn't working so I followed this tip https://community.shopify.com/c/shopify-apps/recurring-charges-confirmation-url-changing-when-using-app/m-p/2112530

    // if (appBridgeUtils.isShopifyEmbedded()) {
    //   window.appBridgeRedirect(targetInfo.url);
    // } else {
    //   window.top.location.href = targetInfo.url;
    // }
    window.top.location.href = targetInfo.url;
  }

  document.addEventListener("DOMContentLoaded", redirect);

  // In the turbolinks context, neither DOMContentLoaded nor turbolinks:load
  // consistently fires. This ensures that we at least attempt to fire in the
  // turbolinks situation as well.
  redirect();
})();
