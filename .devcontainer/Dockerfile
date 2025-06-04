FROM nixos/nix


ARG CURSOR_HASH
# This is so VSCode can tell it's Nix and skip chcking glibc since it doesn't know how to do it
RUN echo 'ID=nixos' > /etc/os-release

RUN nix-channel --update
RUN nix-env --install --attr \
        nixpkgs.nil \
        nixpkgs.nixd \
        nixpkgs.alejandra \
        nixpkgs.nixfmt \
        nixpkgs.gnused \
        nixpkgs.patchelf \
        nixpkgs.nodejs \
        nixpkgs.direnv \
        nixpkgs.coreutils

# Luckily, vscode code-server has support for ELF patching the node binary, we will leverage that to make it work in Nix
# If they ever remove this support, it's easy enough to just run patchelf outselves.  You can see how it works at
# https://github.com/microsoft/vscode/blob/31ec1c528f3352405f329821df31b91e6deba824/resources/server/bin/code-server-linux.sh
# We need an easy to reference location for the binaries and libraries we will need for the binary patch
RUN mkdir -p /root/lib /root/bin && \
    ln -s $(nix-instantiate --eval-only --expr '(import <nixpkgs> {}).glibc.outPath'  | sed -e 's/"//g') /root/lib/glibc && \
    ln -s $(nix-instantiate --eval-only --expr '(import <nixpkgs> {}).libgcc.lib.outPath'  | sed -e 's/"//g') /root/lib/libgcc && \
    ln -s $(which patchelf) /root/bin/patchelf


#RUN mkdir -p /root/.cursor-server/bin

#RUN wget https://cursor.blob.core.windows.net/remote-releases/${CURSOR_HASH}/vscode-reh-linux-x64.tar.gz && \
#    tar -xzf vscode-reh-linux-x64.tar.gz && \
#    rm vscode-reh-linux-x64.tar.gz && \
#    mv vscode-reh-linux-x64 /root/.cursor-server/bin/${CURSOR_HASH}

# Hijack the check-requirements.sh script so we can use our patched node binary
#COPY check-requirements.sh /root/.cursor-server/bin/${CURSOR_HASH}/bin/helpers/check-requirements.sh

#RUN chmod +x /root/.cursor-server/bin/${CURSOR_HASH}/bin/helpers/check-requirements.sh
#RUN ls -alh /root/.cursor-server/bin/${CURSOR_HASH}

# Finally we will set some env vars to tell vscode where to find them so it can patch nodejs
ENV VSCODE_SERVER_CUSTOM_GLIBC_LINKER="/root/lib/glibc/lib/ld-linux-x86-64.so.2"
ENV VSCODE_SERVER_CUSTOM_GLIBC_PATH="/root/lib/glibc/lib:/root/lib/libgcc/lib"
ENV VSCODE_SERVER_PATCHELF_PATH="/root/bin/patchelf"
