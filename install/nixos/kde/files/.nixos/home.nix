{ config, pkgs, ... }:

{
  home.username = "USERNAME";
  home.homeDirectory = "/home/USERNAME";
  home.stateVersion = "26.11";
  #home.file.".config/hypr".source = ./config/hypr;
}
