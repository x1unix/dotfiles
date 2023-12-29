
gocov() {
        go test -coverprofile /tmp/cover.out
        go tool cover -html=/tmp/cover.out
        sleep 2
        rm -rf /tmp/cover*
}

