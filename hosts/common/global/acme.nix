{
  security.acme = {
    defaults.email = "admin+certs@jabsserver.net";
    acceptTerms = true;
  };

  environment.persistence."/persist".directories = [ "/var/lib/acme" ];
}
