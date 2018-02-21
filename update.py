#!/bin/env python

# used to update all local and remote references into this bin folder
import subprocess

GITHUB_SSH_BASE_URL = 'git@github.com:'
GITHUB_HTTPS_BASE_URL = 'https://github.com/'

def intro_msg():
    msg = "For the binder to work..."
    msg += "\nexternal and internal repos need to be linked to.\n"
    msg += "Starting with external sources like github.com\n"
    print(msg)

def clone_repo(repo_user, repo_name, use_ssh=True):
    if use_ssh:
        request_url = GITHUB_SSH_BASE_URL
    else:
        request_url = GITHUB_HTTPS_BASE_URL
    request_url += repo_user + '/' + repo_name
    return subprocess.check_output(['git', 'clone', request_url])


def clone_go_buffer_repo():
    #  print("Cloning the go-buffer (a monolithic go repo) into the binder...")
    clone_repo('marcus-grant', 'go-buffer')


if __name__ == "__main__":
    UPDATE_QUEUE = [
        intro_msg,
        clone_go_buffer_repo,
    ]

    for update_action in UPDATE_QUEUE:
        std_out = update_action()
        print(std_out)
