# Set Vulkan/MoltenTK variables
set -x VULKAN_SDK "/opt/vulkan-sdk/macOS"
set -x PATH $VULKAN_SDK/bin $PATH
set -x DYLD_LIBRARY_PATH $VULKAN_SDK/lib /usr/local/lib $DYLD_LIBRARY_PATH
set -x VK_ICD_FILENAMES $VULKAN_SDK/share/vulkan/icd.d/MoltenVK_icd.json
set -x VULKAN_FRAMEWORK_PATH $VULKAN_SDK/Frameworks
set -x VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
set -x DYLD_FRAMEWORK_PATH $VULKAN_FRAMEWORK_PATH $DYLD_FRAMEWORK_PATH

# Set Homebrew variables
set -gx HOMEBREW_NO_INSECURE_REDIRECT 1
set -gx HOMEBREW_CASK_OPTS --fontdir=/Library/Fonts --require-sha

# eval (luarocks path --bin)

set -gx PKG_CONFIG_PATH /opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

# Add Android SDK to PATH
set -x PATH $PATH ~/.android-sdk-macosx/platform-tools/

# Add JAVA_HOME
# set -gx JAVA_HOME (/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home)
# set -gx PATH $JAVA_HOME/bin $PATH
set -gx PATH /opt/homebrew/opt/openjdk/bin $PATH
# set -gx CPPFLAGS "-I/opt/homebrew/opt/openjdk/include"

# pyenv init - | source
# set -gx PYENV_VIRTUALENV_DISABLE_PROMPT 1
# set pyenv_version (pyenv version-name | string split ':')

# Set compilation flags
set -x LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -x CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

# Set personal aliases
# alias python3='/opt/homebrew/opt/python@3.10/bin/python3.10'
alias ze="nvim ~/.config/fish/config.fish"
alias zi="source ~/.config/fish/config.fish && echo 'Fish successfully sourced!'"
alias lua="lua5.1"
alias brew="/opt/brew-wrapper.sh"

set -g fish_key_bindings fish_vi_key_bindings

fzf_configure_bindings --directory=\ct --processes=\ck

alias compile="jq -r '.[0].command' compile_commands.json | fish"
alias viewer="/Volumes/Transcend/Developer/projects/pdf-viewer/main"
