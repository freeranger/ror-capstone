(function() {
  "use strict";

  angular
    .module("spa-demo", [
      "ui.router",
      "spa-demo.foos",
      "spa-demo.cities"
    ]);
})();