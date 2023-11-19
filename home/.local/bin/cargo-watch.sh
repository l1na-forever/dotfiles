#!/bin/bash
cargo watch --use-shell "/bin/bash" -x test -s "dunstify '✅ Tests Passed' -h string:x-canonical-private-synchronous:cargotests || dunstify '☠️ Tests Failed' -h string:x-canonical-private-synchronous:cargotests"

