{
  pkgs,
  config,
  ...
}: {
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  # Ensure that secret service is loaded in order to get stored credentials
  systemd.user.services.nextcloud-client.Unit.After = ["pass-secret-service.service"];

  xdg.configFile."Nextcloud/sync-exclude.lst".text = ''
    # This file contains fixed global exclude patterns

    *~
    ~$*
    .~lock.*
    ~*.tmp
    ]*.~*
    ]Icon\r*
    ].DS_Store
    ].ds_store
    *.textClipping
    ._*
    ]Thumbs.db
    ]photothumb.db
    System Volume Information

    .*.sw?
    .*.*sw?

    ].TemporaryItems
    ].Trashes
    ].DocumentRevisions-V100
    ].Trash-*
    .fseventd
    .apdisk
    .Spotlight-V100

    .directory

    *.part
    *.filepart
    *.crdownload

    *.kate-swp
    *.gnucash.tmp-*

    .synkron.*
    .sync.ffs_db
    .symform
    .symform-store
    .fuse_hidden*
    *.unison
    .nfs*

    # (default) metadata files created by Syncthing
    .stfolder
    .stignore
    .stversions

    My Saved Places.


    *.sb-*

    # Temporary latex files
    ]*.aux
    ]*.fdb_latexmk
    ]*.fls
    ]*.out
    ]*.bbl
    ]*.bcf
    ]*.blg
    ]*.toc
    ]*.synctex.gz
    ]*.run.xml
    ]*.nav
    ]*.snm
    ]*.synctex(busy)

    # Temporary backup files
    ]*.bak

    # Python virtual environments
    ].venv/
  '';

  home.persistence."/persist/${config.home.homeDirectory}".directories = [".config/Nextcloud" "Cloud"];
}
