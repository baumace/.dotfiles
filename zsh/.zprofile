# Load all SSH private keys into the systemd-managed agent once per boot.
# Any key with a matching .pub file in ~/.ssh/ is added automatically —
# new key pairs are picked up without changing this file.
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
for key in ~/.ssh/*.pub; do
    [[ -f "${key%.pub}" ]] && ssh-add "${key%.pub}" 2>/dev/null
done
