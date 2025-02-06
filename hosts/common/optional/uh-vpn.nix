{config, ...}: {
  services.openvpn.servers.uh-allroute = {
    autoStart = false;
    config = ''
      verb 4


      keepalive 60 720

      dev tun
      client
      script-security 2

      remote hy-vpn.vpn.helsinki.fi

      cipher AES-256-GCM
      auth sha512

      nobind
      remote-cert-tls server
      redirect-gateway def1 bypass-dns
      auth-user-pass ${config.sops.secrets.uh-vpn-user-pass.path}

      #ca HY-vpn-CA.pem


      compress lzo

      <ca>
      -----BEGIN CERTIFICATE-----
      MIIGIzCCBAugAwIBAgIJAMnMR8QZoIOxMA0GCSqGSIb3DQEBBQUAMIGnMQswCQYD
      VQQGEwJGSTEQMA4GA1UECAwHVXVzaW1hYTERMA8GA1UEBwwISGVsc2lua2kxHzAd
      BgNVBAoMFlVuaXZlcnNpdHkgb2YgSGVsc2lua2kxFjAUBgNVBAsMDUlULURlcGFy
      dG1lbnQxEzARBgNVBAMMCmF0ay12ZXJra28xJTAjBgkqhkiG9w0BCQEWFmF0ay12
      ZXJra29AaGVsc2lua2kuZmkwHhcNMTUwODEyMTE1OTExWhcNNDAwODA1MTE1OTEx
      WjCBpzELMAkGA1UEBhMCRkkxEDAOBgNVBAgMB1V1c2ltYWExETAPBgNVBAcMCEhl
      bHNpbmtpMR8wHQYDVQQKDBZVbml2ZXJzaXR5IG9mIEhlbHNpbmtpMRYwFAYDVQQL
      DA1JVC1EZXBhcnRtZW50MRMwEQYDVQQDDAphdGstdmVya2tvMSUwIwYJKoZIhvcN
      AQkBFhZhdGstdmVya2tvQGhlbHNpbmtpLmZpMIICIjANBgkqhkiG9w0BAQEFAAOC
      Ag8AMIICCgKCAgEA0N1iosnnDoqpaCYyp90qVAO95G6iuvjAaT6PVsF+JQ6YcxrD
      GeAJdLBg7X0WJ2Vzhl4LhrAe0/IJ/Rv/hB7j0kfV1Q3rIs8GZc33TVArQIWFUx5s
      M1MyClmYRDVS7R/tMMBy1I7jr9owneOFtsR09R0G+tjTwT22FXDT70d4AdPwLeBq
      SyMlYRgJNd7b9wVRgCIbdnax4dQxnzYA23L1X9b2kTzFumBO2HQw80uGm8ciRnYN
      kNao+IGOHJ+xtB1PNTe0a6UUUJ1sR1KcONl+MHGJ014An0s4Ccn4Jn+3CUN4H3+N
      v+CGhrDX5fiCsMQI12AbJ1FBxV6qkt6Rv2vRWHJrXjrzqn1Aiu/I4ZvVw1hVlESB
      +FpMDB58DfAIbTbA3JrNzxtAKK5yI89pzFHm4VqJKGG3sVkln6albCeL1PK4t0bh
      awCyh4JtAxKDIGUn8ncB5AXdqKIXolBrM+cYbVxnq17IHS7zLWV3lG1FCWUZUaL2
      bChFxIO+n/cmYOPL1Lx0lV8adMQUdx7fz0STnzs55WnwAXhPzLYPqsOoXxeS79m3
      y/+08UgIJtL1Fj8HGpElkB6SRcvE3erZkEgHRf7uvnvEs8ddxo7d7E4f9Jd6RIdk
      DJunGjhKRWWU/y0xKVpHxoFfYw8iJ1rHcZDOEijCzgZWMixJwOUJNzteC7UCAwEA
      AaNQME4wHQYDVR0OBBYEFBPj+IOO7ssnwurpQg6DccKbxg9eMB8GA1UdIwQYMBaA
      FBPj+IOO7ssnwurpQg6DccKbxg9eMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEF
      BQADggIBAHM9/hczIsxBdgOC4639eP2jexJkUUJWIykMriQ/dAY3GzVccfqMzgvq
      ggdlJIyB903ENoBJam3GSlH2a6wdoymA1ycXb0tDNUyyjlyRUUp7p/E66FJ5i4Rw
      +bDeozLlYGHakuzwcXcUlfpboN0kysayXsV7A9w7N4/Y7e14fbS+sqOwkpr2fc8Y
      k54DnlNReDFHR9/00op7gs22N6sZejG2sbdBa4wtWP9APiQalrlbiyVD1AhPfvX5
      O1vSM0h4vdIjMQuwfUXPwjJil1ryAEcmDXAYzb7r4oZ2RPXZLDWDRcVAaFuMHvLG
      I6HENq356bksdZhRlInMwY3IxmGi4U7YzoMw+XHuUTZhVYviw9G1sudXwotljE9r
      +RYg6bJcj3jTri09oQAOsAlvNoi5M7KrgL+sJJve1fkQxCSgc2fxgHerOnXYrhex
      Q52qvux4KIs8hTlo+tTnhc5Yc/OMdBwKmd3xAedVCWpLNL3HEoT9rH1w185aJUdI
      6QeDP9FXOv3jqWwfK+Ds48/DhhCyedp7oJRK+PZe9fw9qGihpsFrC6Ni/NImWdBm
      GgiVKOdVU/RK6rPZczk/D6a8FvRX0cNrIAXQY38PPA3947acwztE1SrdAL39ZTls
      4H/bFlXmxgUhPsW4ndgFNuL8pWJWBd3mCWApEAMtQdahj5qt3l0k
      -----END CERTIFICATE-----
      </ca>
    '';
  };
  sops.secrets.uh-vpn-user-pass.sopsFile = ../secrets.yaml;
}
