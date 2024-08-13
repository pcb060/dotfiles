#!/usr/bin/env bash

function git_log_diff() {
	target_branch=$1
	local_branch=$(git rev-parse --abbrev-ref HEAD)
	glp $target_branch..$local_branch
}

function git_branch_blame() {
	git for-each-ref --color=always --format='%(color:red)%(committerdate:iso8601)%(color:reset) %(color:green)%(authorname)%(color:reset) %(color:blue)%(refname:short)%(color:reset)' --sort=-committerdate refs/remotes | grep -i ".*$1.*" | bat --file-name="${FUNCNAME[0]}"
}

function git_fast_interactive_rebase() {
	to_rebase=$1
	gri HEAD~$1
}