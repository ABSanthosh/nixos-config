# https://discourse.nixos.org/t/chromium-blank-pages/30281/4
# https://community.brave.com/t/latest-brave-update-fails-to-render-any-webpage-correctly/485593
# https://github.com/electron/electron/issues/40366

# Sometimes when mesa drivers are updated, chromium based browsers will not render any webpages
# and electron apps will not render properly. This script will clear the gpu cache and fix the issue.
find ~/.config -type d -name 'GPUCache' -exec rm -rf {} +