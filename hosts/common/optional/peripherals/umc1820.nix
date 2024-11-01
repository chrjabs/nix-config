{
  services.pipewire.extraConfig.pipewire-pulse."99-umc1820" = {
    "pulse.cmd" = [
      {
        cmd = "load-module";
        args = "module-remap-sink sink_name=primary sink_properties=device.description='Primary' remix=no master=alsa_output.usb-BEHRINGER_UMC1820_F2F9C19F-00.multichannel-output channels=2 master_channel_map=front-left,front-right channel_map=front-left,front-right";
      }
      {
        cmd = "load-module";
        args = "module-remap-source sink_name=mic source_properties=device.description='Mic' master=alsa_input.usb-BEHRINGER_UMC1820_F2F9C19F-00.multichannel-input channels=1 master_channel_map=rear-left channel_map=front-left";
      }
    ];
  };
}
