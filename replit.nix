{pkgs}: {
  deps = [
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.awscli2
  ];
}
