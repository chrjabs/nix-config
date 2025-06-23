{
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      bind-key h quit
      bind-key j down
      bind-key k up
      bind-key l open
      bind-key H prev-feed
      bind-key L next-feed
      bind-key g home
      bind-key G end
      bind-key ^F pagedown
      bind-key ^B pageup
    '';
    urls = [
      {
        title = "Anna Latour";
        url = "https://latower.github.io/feed.xml";
      }
      {
        title = "PySAT releases";
        url = "https://pypi.org/rss/project/python-sat/releases.xml";
      }
    ];
  };
}
