with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    openjdk11
    maven
    nodejs
  ];
  shellHook = ''
    echo Welcome to the RxNorm Explorer project.
  '';
}
