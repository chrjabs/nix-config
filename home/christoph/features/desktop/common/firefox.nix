{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  programs.browserpass.enable = true;
  programs.firefox = {
    enable = true;

    profiles =
      let
        common = {
          # Disable irritating first-run stuff
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # Don't ask for download dir
          "browser.download.useDownloadDir" = false;

          # Disable restore after crash
          "browser.sessionstore.resume_from_crash" = false;

          # Disable crappy home activity stream page
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
          "browser.newtabpage.blocked" = lib.genAttrs [
            # Youtube
            "26UbzFJ7qT9/4DhodHKA1Q=="
            # Facebook
            "4gPpjkxgZzXPVtuEoAL9Ig=="
            # Wikipedia
            "eV8/WsSLxHadrTL1gAxhug=="
            # Reddit
            "gLv0ja2RYVgxKdp0I5qwvA=="
            # Amazon
            "K00ILysCaEq8+bEqV/3nuw=="
            # Twitter
            "T9nJot5PurhJSy8n038xGA=="
          ] (_: 1);

          # Disable some telemetry
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Disable fx accounts
          "identity.fxaccounts.enabled" = false;
          # Disable "save password" prompt
          "signon.rememberSignons" = false;
          # Harden
          "privacy.trackingprotection.enabled" = true;
          "dom.security.https_only_mode" = true;
          # Layout
          "browser.uiCustomization.state" = builtins.toJSON {
            currentVersion = 20;
            newElementCount = 5;
            dirtyAreaCache = [
              "nav-bar"
              "PersonalToolbar"
              "toolbar-menubar"
              "TabsToolbar"
              "widget-overflow-fixed-list"
            ];
            placements = {
              PersonalToolbar = [ "personal-bookmarks" ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
              ];
              nav-bar = [
                "back-button"
                "forward-button"
                "stop-reload-button"
                "urlbar-container"
                "downloads-button"
                "ublock0_raymondhill_net-browser-action"
                "_testpilot-containers-browser-action"
                "reset-pbm-toolbar-button"
                "unified-extensions-button"
              ];
              toolbar-menubar = [ "menubar-items" ];
              unified-extensions-area = [ ];
              widget-overflow-fixed-list = [ ];
            };
            seen = [
              "save-to-pocket-button"
              "developer-button"
              "ublock0_raymondhill_net-browser-action"
              "_testpilot-containers-browser-action"
            ];
          };
          "browser.toolbars.bookmarks.visibility" = "never";
        };
      in
      {
        christoph = {
          id = 0;
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
            order = [
              "ddg"
              "google"
            ];
            engines = {
              "bing".metaData.hidden = true;
            };
          };
          extensions.packages = with pkgs.inputs.firefox-addons; [
            ublock-origin
            browserpass
          ];
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Search Wikipedia";
                keyword = "wiki";
                url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
              }
              {
                name = "YouTube Subs";
                keyword = "ya";
                url = "https://www.youtube.com/feed/subscriptions";
              }
              {
                name = "Search YouTube";
                keyword = "y";
                url = "https://www.youtube.com/results?search_query=%s";
              }
              {
                name = "GitHub";
                keyword = "gh";
                url = "https://github.com/%s";
              }
              {
                name = "Own GitHub By Repo";
                keyword = "ghc";
                url = "https://github.com/chrjabs/%s";
              }
              {
                name = "Toggl";
                keyword = "t";
                url = "https://toggl.com/app/timer";
              }
              {
                name = "Todoist";
                keyword = "td";
                url = "https://firefox.todoist.com/app/upcoming#";
              }
              {
                name = "Nix Packages";
                keyword = "np";
                url = "https://search.nixos.org/packages?channel=unstable&query=%s";
              }
              {
                name = "Home Manager Options";
                keyword = "hm";
                url = "https://home-manager-options.extranix.com/&query=%s&release=release-24.05";
              }
              {
                name = "Rust stdlib documentation search";
                keyword = "rsstd";
                url = "https://doc.rust-lang.org/stable/std/index.html?search=%s";
              }
              {
                name = "C++ stdlib documentation search";
                keyword = "cppstd";
                url = "https://duckduckgo.com/?sites=cppreference.com&q=%s";
              }
              {
                name = "dblp search";
                keyword = "dblp";
                url = "https://dblp.org/search?q=%s";
              }
              {
                name = "google scholar search";
                keyword = "gs";
                url = "https://scholar.google.com/scholar?q=%s";
              }
              {
                name = "ctan search";
                keyword = "ctan";
                url = "https://ctan.org/search?phrase=%s";
              }
            ];
          };
          settings = {
            "browser.startup.homepage" = "about:home";
          }
          // common;
        };

        whatsapp = {
          id = 1;
          settings = {
            "browser.startup.homepage" = "https://web.whatsapp.com";
          }
          // common;
        };

        ssh-proxy = {
          id = 2;
          settings = {
            "browser.startup.homepage" = "about:home";

            # Proxy
            "network.proxy.type" = 1;
            "network.proxy.socks" = "localhost";
            "network.proxy.socks_port" = 8080;
          }
          // common;
        };
      };
  };

  stylix.targets.firefox.profileNames = [ "christoph" ];

  home = {
    persistence = {
      "/persist/${config.home.homeDirectory}".directories = [
        {
          directory = ".mozilla/firefox";
          method = "bindfs";
        }
      ];
    };
  };

  xdg = {
    mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
    desktopEntries = {
      whatsapp = {
        name = "WhatsApp";
        genericName = "WhatApp Web Interface";
        comment = "Read and send WhatsApp messages from a browser";
        exec = "firefox -P whatsapp";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        type = "Application";
      };
    };
  };
}
