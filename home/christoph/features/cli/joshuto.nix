{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.joshuto = {
    enable = true;

    settings = {
      zoxide_update = true;
      cmd_aliases = {
        cd = "z";
        cdi = "zi";
      };
      preview.preview_script =
        let
          exiftool = "${lib.getExe pkgs.exiftool} -api largefilesupport=1";
          atool = lib.getExe pkgs.atool;
          unrar = lib.getExe pkgs.unrar;
          _7z = lib.getExe pkgs._7zz;
          pdftotext = lib.getExe' pkgs.poppler_utils "pdftotext";
          odt2txt = lib.getExe pkgs.odt2txt;
          xlsx2csv = lib.getExe pkgs.xlsx2csv;
          pandoc = lib.getExe pkgs.pandoc;
          jq = lib.getExe pkgs.jq;
          mediainfo = lib.getExe pkgs.mediainfo;
          catdoc = lib.getExe' pkgs.catdoc "catdoc";
          xls2csv = lib.getExe' pkgs.catdoc "xls2csv";
          bat = lib.getExe config.programs.bat.package;
          file = lib.getExe pkgs.file;
        in
        lib.getExe (
          pkgs.writeShellScriptBin "joshuto-preview"
            # based on joshuto preview script
            # bash
            ''
              IFS=$'\n'

              set -o noclobber -o noglob -o nounset -o pipefail

              FILE_PATH=""
              PREVIEW_WIDTH=10
              PREVIEW_HEIGHT=10

              while [ "$#" -gt 0 ]; do
                  case "$1" in
                  "--path")
                      shift
                      FILE_PATH="$1"
                      ;;
                  "--preview-width")
                      shift
                      PREVIEW_WIDTH="$1"
                      ;;
                  "--preview-height")
                      shift
                      PREVIEW_HEIGHT="$1"
                      ;;
                  esac
                  shift
              done

              handle_extension() {
                  case "''${FILE_EXTENSION_LOWER}" in
                  ## Archive
                  a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
                      rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
                      ${atool} --list -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;
                  rar)
                      ## Avoid password prompt by providing empty password
                      ${unrar} lt -p- -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;
                  7z)
                      ## Avoid password prompt by providing empty password
                      ${_7z} l -p -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## PDF
                  pdf)
                      ## Preview as text conversion
                      ${pdftotext} -l 10 -nopgbrk -q -- "''${FILE_PATH}" - |
                          fmt -w "''${PREVIEW_WIDTH}" && exit 0
                      exit 1
                      ;;


                      ## OpenDocument
                  odt | sxw)
                      ## Preview as text conversion
                      ${odt2txt} "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;
                  ods | odp)
                      ## Preview as text conversion (unsupported by pandoc for markdown)
                      ${odt2txt} "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## XLSX
                  xlsx)
                      ## Preview as csv conversion
                      ## Uses: https://github.com/dilshod/xlsx2csv
                      ${xlsx2csv} -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## HTML
                  htm | html | xhtml)
                      ## Preview as text conversion
                      ${pandoc} -s -t markdown -- "''${FILE_PATH}" | ${bat} -l markdown \
                          --color=always --paging=never \
                          --style=plain \
                          --terminal-width="''${PREVIEW_WIDTH}" && exit 0
                      exit 1
                      ;;

                      ## JSON
                  json | ipynb)
                      ${jq} --color-output . "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
                      ## by file(1).
                  dff | dsf | wv | wvc)
                      ${mediainfo} "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## Markdown
                  md)
                      ${bat} -l markdown --color=always --paging=never --style=plain \
                          --terminal-width="''${PREVIEW_WIDTH}" "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;
                  esac
              }

              handle_mime() {
                  local mimetype="''${1}"

                  case "''${mimetype}" in
                  ## RTF and DOC
                  text/rtf | *msword)
                      ## Preview as text conversion
                      ## note: catdoc does not always work for .doc files
                      ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
                      ${catdoc} -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## DOCX, ePub, FB2 (using markdown)
                      ## You might want to remove "|epub" and/or "|fb2" below if you have
                      ## uncommented other methods to preview those formats
                  *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
                      ## Preview as markdown conversion
                      ${pandoc} -s -t markdown -- "''${FILE_PATH}" | ${bat} -l markdown \
                          --color=always --paging=never \
                          --style=plain \
                          --terminal-width="''${PREVIEW_WIDTH}" && exit 0
                      exit 1
                      ;;

                      ## XLS
                  *ms-excel)
                      ## Preview as csv conversion
                      ## xls2csv comes with catdoc:
                      ##   http://www.wagner.pp.ru/~vitus/software/catdoc/
                      ${xls2csv} -- "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## Text
                  text/* | */xml)
                      ${bat} --color=always --paging=never \
                          --style=plain \
                          --terminal-width="''${PREVIEW_WIDTH}" \
                          "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## Image
                  image/*)
                      ## Preview as text conversion
                      ${exiftool} "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;

                      ## Video and audio
                  video/* | audio/*)
                      ${mediainfo} "''${FILE_PATH}" && exit 0
                      exit 1
                      ;;
                  esac
              }

              FILE_EXTENSION="''${FILE_PATH##*.}"
              FILE_EXTENSION_LOWER="$(printf "%s" "''${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
              handle_extension
              MIMETYPE="$(${file} --dereference --brief --mime-type -- "''${FILE_PATH}")"
              handle_mime "''${MIMETYPE}"

              exit 1
            ''
        );
    };

    mimetype = {
      class = {
        audio_default = [
          {
            command = lib.getExe config.programs.mpv.package;
            args = [ "--" ];
            fork = true;
          }
        ];
        image_default = [
          {
            command = lib.getExe config.programs.imv.package;
            args = [ "--" ];
            fork = true;
          }
        ];
        video_default = [
          {
            command = lib.getExe config.programs.mpv.package;
            args = [ "--" ];
            fork = true;
          }
        ];
        text_default = [
          {
            command = lib.getExe config.programs.nixvim.build.package;
          }
        ];
        reader_default = [
          {
            command = lib.getExe config.programs.zathura.package;
            fork = true;
            silent = true;
          }
        ];
      };

      extension =
        let
          _7z = lib.getExe pkgs._7zz;
          tar = lib.getExe pkgs.gnutar;
          unrar = lib.getExe pkgs.unrar;
          unzip = lib.getExe pkgs.unzip;
        in
        {
          # image formats
          avif."inherit" = "image_default";
          bmp."inherit" = "image_default";
          gif."inherit" = "image_default";
          heic."inherit" = "image_default";
          jpeg."inherit" = "image_default";
          jpe."inherit" = "image_default";
          jpg."inherit" = "image_default";
          JPG."inherit" = "image_default";
          JPEG."inherit" = "image_default";
          jxl."inherit" = "image_default";
          pgm."inherit" = "image_default";
          png."inherit" = "image_default";
          ppm."inherit" = "image_default";
          webp."inherit" = "image_default";
          tiff."inherit" = "image_default";

          # audio formats
          aac."inherit" = "audio_default";
          ac3."inherit" = "audio_default";
          aiff."inherit" = "audio_default";
          ape."inherit" = "audio_default";
          dts."inherit" = "audio_default";
          flac."inherit" = "audio_default";
          m4a."inherit" = "audio_default";
          mp3."inherit" = "audio_default";
          oga."inherit" = "audio_default";
          ogg."inherit" = "audio_default";
          opus."inherit" = "audio_default";
          wav."inherit" = "audio_default";
          wv."inherit" = "audio_default";

          # video formats
          avi."inherit" = "video_default";
          av1."inherit" = "video_default";
          flv."inherit" = "video_default";
          mkv."inherit" = "video_default";
          m4v."inherit" = "video_default";
          mov."inherit" = "video_default";
          mp4."inherit" = "video_default";
          ts."inherit" = "video_default";
          webm."inherit" = "video_default";
          wmv."inherit" = "video_default";

          # text formats
          build."inherit" = "text_default";
          c."inherit" = "text_default";
          cmake."inherit" = "text_default";
          conf."inherit" = "text_default";
          cpp."inherit" = "text_default";
          css."inherit" = "text_default";
          csv."inherit" = "text_default";
          cu."inherit" = "text_default";
          ebuild."inherit" = "text_default";
          eex."inherit" = "text_default";
          env."inherit" = "text_default";
          ex."inherit" = "text_default";
          exs."inherit" = "text_default";
          go."inherit" = "text_default";
          h."inherit" = "text_default";
          hpp."inherit" = "text_default";
          hs."inherit" = "text_default";
          html."inherit" = "text_default";
          ini."inherit" = "text_default";
          java."inherit" = "text_default";
          js."inherit" = "text_default";
          json."inherit" = "text_default";
          kt."inherit" = "text_default";
          lua."inherit" = "text_default";
          log."inherit" = "text_default";
          md."inherit" = "text_default";
          micro."inherit" = "text_default";
          ninja."inherit" = "text_default";
          norg."inherit" = "text_default";
          org."inherit" = "text_default";
          py."inherit" = "text_default";
          rkt."inherit" = "text_default";
          rs."inherit" = "text_default";
          scss."inherit" = "text_default";
          sh."inherit" = "text_default";
          srt."inherit" = "text_default";
          svelte."inherit" = "text_default";
          tsx."inherit" = "text_default";
          txt."inherit" = "text_default";
          vim."inherit" = "text_default";
          xml."inherit" = "text_default";
          yaml."inherit" = "text_default";
          yml."inherit" = "text_default";

          # archive formats
          "7z".app_list = [
            {
              command = _7z;
              args = [ "x" ];
              confirm_exit = true;
            }
          ];
          bz2.app_list = [
            {
              command = tar;
              args = [ "-xvjf" ];
              confirm_exit = true;
            }
          ];
          gz.app_list = [
            {
              command = tar;
              args = [ "-xvzf" ];
              confirm_exit = true;
            }
          ];
          tar.app_list = [
            {
              command = tar;
              args = [ "-xvf" ];
              confirm_exit = true;
            }
          ];
          tgz.app_list = [
            {
              command = tar;
              args = [ "-xvzf" ];
              confirm_exit = true;
            }
          ];
          rar.app_list = [
            {
              command = unrar;
              args = [ "x" ];
              confirm_exit = true;
            }
          ];
          xz.app_list = [
            {
              command = tar;
              args = [ "-xvJf" ];
              confirm_exit = true;
            }
          ];
          zip.app_list = [
            {
              command = unzip;
              confirm_exit = true;
            }
          ];

          pdf."inherit" = "reader_default";
        };

      mimetype = {
        application.subtype.octet-stream."inherit" = "video_default";
        text."inherit" = "text_default";
        video."inherit" = "text_default";
      };
    };
  };
}
