if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set fish variables
set -x VULKAN_SDK "/opt/vulkan-sdk/macOS"
set -x PATH $VULKAN_SDK/bin $PATH
set -x DYLD_LIBRARY_PATH $VULKAN_SDK/lib /usr/local/lib $DYLD_LIBRARY_PATH
#set -x DYLD_LIBRARY_PATH $VULKAN_SDK/lib $DYLD_LIBRARY_PATH # Uncomment if needed
set -x VK_ICD_FILENAMES $VULKAN_SDK/share/vulkan/icd.d/MoltenVK_icd.json
set -x VULKAN_FRAMEWORK_PATH $VULKAN_SDK/Frameworks
set -x VK_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d
set -x DYLD_FRAMEWORK_PATH $VULKAN_FRAMEWORK_PATH $DYLD_FRAMEWORK_PATH

eval (luarocks path --bin)

set -gx PKG_CONFIG_PATH /opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH

# Add Android SDK to PATH
set -x PATH $PATH ~/.android-sdk-macosx/platform-tools/

# Set compilation flags
set -x LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -x CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

# Set personal aliases
alias p@3.12="python3.12"
alias ze="nvim ~/.config/fish/config.fish"
alias zi="source ~/.config/fish/config.fish && echo 'Fish successfully sourced!'"
alias lua="lua5.1"

set -g fish_key_bindings fish_vi_key_bindings

fzf_configure_bindings --directory=\ct --processes=\ck

alias compile="jq -r '.[0].command' compile_commands.json | fish"
alias viewer="/Volumes/Transcend/Developer/projects/pdf-viewer/main"

alias projects="echo /Volumes/Transcend/Developer/projects"
