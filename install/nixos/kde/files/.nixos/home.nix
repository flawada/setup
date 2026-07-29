{ config, pkgs, ... }:

{
  home.username = "flawa";
  home.homeDirectory = "/home/flawa";
  home.stateVersion = "26.11";
  #home.file.".config/hypr".source = ./config/hypr;
}
