## Functions

bundler-installed()
{
    which bundle > /dev/null 2>&1
}

within-bundled-project()
{
    local dir="$(pwd)"
    while [ "$(dirname $dir)" != "/" ]; do
        [ -f "$dir/Gemfile" ] && return
        dir="$(dirname $dir)"
    done
    false
}

run-with-bundler()
{
    if bundler-installed && within-bundled-project; then
        echo $command
        if [ $command == "ruby" ]; then
            ruby -rbundler/setup "$@"
        else
            bundle exec $command "$@"
        fi
    else
        "$@"
    fi
}

## Main program
bundled_commands=(annotate cap capify cucumber foreman guard middleman nanoc rackup rainbows rake ruby shotgun rspec spec spork thin thor unicorn unicorn_rails puma)

for CMD in $bundled_commands; do
    if [[ $CMD != "bundle" && $CMD != "gem" ]]; then
        alias $CMD="run-with-bundler $CMD"
    fi
done