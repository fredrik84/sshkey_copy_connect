function ssh_checkkey() {
  # Handle if no ssh keys found
  if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "No SSH key found, creating a new one for you"
    cat /dev/zero | ssh-keygen -q -t rsa -b 4096 -N "" &> /dev/null
  fi
  # Test login without password to see if we have a authorized_keys on the other side
  ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1
  if [ $? -eq 255 ]; then
    # It didn't work, so lets just fix that by copying the key and login on again
    ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $1
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o HostKeyAlias=$1 $1
  fi
}

# Replace ssh command with function
alias ssh=ssh_checkkey
