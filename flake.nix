{
  description = "Big Data Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };
  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = { };
      };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk17
          python3
          python3Packages.virtualenv
          maven
          docker
          glibcLocales
        ];
        shellHook = ''
          export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
          export LANG="en_US.UTF-8"
          export LC_ALL="en_US.UTF-8"
          export PS1="(big-data) $PS1"
          export HADOOP_LIB_DIR="$(pwd)/hadoop-lib"
          export HADOOP_CLASSPATH="$HADOOP_LIB_DIR/*"
          export MAVEN_OPTS="-Dmaven.repo.local=$(pwd)/.m2/repository"
          source scripts/setup-libs.sh
        '';
      };
    };
}
