command_exist brew || return

LOCATION_RUBY="$(brew --prefix ruby)"
if [[ -d "$LOCATION_RUBY" ]]; then
    PATH="$LOCATION_RUBY/bin:$PATH"
    export PATH
    export LDFLAGS="-L$LOCATION_RUBY/lib${LDFLAGS:+ $LDFLAGS}"
    export CPPFLAGS="-I$LOCATION_RUBY/include${CPPFLAGS:+ $CPPFLAGS}"
    export PKG_CONFIG_PATH="$LOCATION_RUBY/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

LOCATION_SQLITE="$(brew --prefix sqlite)"
if [[ -d "$LOCATION_SQLITE" ]]; then
    PATH="$LOCATION_SQLITE/bin:$PATH"
    export PATH
    export LDFLAGS="-L$LOCATION_SQLITE/lib${LDFLAGS:+ $LDFLAGS}"
    export CPPFLAGS="-I$LOCATION_SQLITE/include${CPPFLAGS:+ $CPPFLAGS}"
    export PKG_CONFIG_PATH="$LOCATION_SQLITE/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
fi

unset LOCATION_RUBY
unset LOCATION_SQLITE
